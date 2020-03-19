----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2019/08/29 17:43:48
-- Design Name: 
-- Module Name: watch - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependennumes: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;    --��������ת��
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMERIC_STD.ALL;

use STD.textio.all;                 --�ı��������
use IEEE.std_logic_textio.all;

library UNISIM;                     --������Ҫ
use UNISIM.VComponents.all;

entity watch is
    Port (
	
        Mclk        :      IN std_logic;--������ʱ��Ƶ��  100MHZ
		
        leftBut     :      IN std_logic;--��ť
        rightBut    :      IN std_logic;--�Ұ�ť
        centerBut   :      IN std_logic;--�м䰴ť
        upBut       :      IN std_logic;--�ϰ�ť
        downBut     :      IN std_logic;--�°�ť    

        RGB_LED_1_O	    :      OUT std_logic_vector(2 downto 0);-----���ӽ�����ʾ������   LD16
        RGB_LED_2_O	    :      OUT std_logic_vector(2 downto 0);-----����ʱ������ʾ������   LD17
        Alarmled        :      OUT std_logic;------���Ӵ�����ʾ��   J13
        Countled        :      OUT std_logic_vector(7 downto 0);------����ʱ��ʾ��     K15
        seg7leds        :      OUT std_logic_vector(6 DOWNTO 0);-----������߶�led

		
        AN     :      OUT std_logic_vector(7 downto 0)---------�����ʹ���ź�      
		
      );
end watch;

architecture Behavioral of watch is

signal leftBut_reg : std_logic:='0';   --�����źżĴ�����
signal rightBut_reg : std_logic:='0';
signal centerBut_reg : std_logic:='0';
signal upBut_reg : std_logic:='0';
signal downBut_reg : std_logic:='0';

signal leapyear:std_logic;     --�����־
signal state: std_logic_vector(2 DOWNTO 0):=(others => '0');    --״̬��
signal display_state:std_logic_vector(1 DOWNTO 0):=(others => '0');  --��ʾģʽ״̬��

--����ʱ�䵥Ԫ�ĸߵ�λ�ֿ���
signal dig_hh,dig_hl,dig_mh,dig_ml,dig_sh,dig_sl,dig_dayl,dig_dayh,dig_monl,dig_monh,dig_yearh:integer; 
signal dig_yearl,dig_cml,dig_cmh,dig_csl,dig_csh: integer;
signal dig_alm1_ml,dig_alm1_mh,dig_alm1_hl,dig_alm1_hh:integer;
signal dig_alm2_ml,dig_alm2_mh,dig_alm2_hl,dig_alm2_hh:integer;
signal dig_alm3_ml,dig_alm3_mh,dig_alm3_hl,dig_alm3_hh:integer;
signal dig_smml,dig_ssl,dig_sml,dig_smmh,dig_ssh,dig_smh:integer;

signal data  : integer;--ʱ�䵥Ԫʵֵ
signal scan  : integer range 0 to 3:= 0;  --ɨ��ʱ϶
signal scan1 : integer range 0 to 5:= 0;  --ɨ��ʱ϶���ض�����ʱ����

--������
signal year,year_load:integer := 2019;
signal month,month_load:integer:=  9;
signal day,day_load:integer  := 3;
signal monthsize:integer range 28 to 31;--��������
--ʱ����
signal sec,min,sec_load,min_load:integer range 0 to 59 := 30;
signal hour,hour_load   :integer range 0 to 23 := 9;
--���ӵ�ʱ���
signal alarm1_min : integer range 0 to 59 :=31;
signal alarm1_hour: integer range 0 to 23 :=9;
signal alarm2_min:  integer range 0 to 59 :=33;
signal alarm2_hour: integer range 0 to 23 :=9;
signal alarm3_min:  integer range 0 to 59 :=50;
signal alarm3_hour: integer range 0 to 23 :=9;

--����ʱ
signal ifcount,ifcount1:std_logic:='0';
signal countsec,countsec_load:integer range 0 to 59:=0;
signal countmin,countmin_load:integer range 0 to 59:=1;
signal countdown ,pause :std_logic:='0';--����ʱ/�����Ƿ�ʼ
signal blink_low,blink_high:integer;--�ߵ�ʱ�䵥λ����

--���
signal msec,mmin:integer range 0 to 59 :=0;
signal mmsec:integer range 0 to 99 :=0;
--signal mmsec_load:integer range 0 to 99 :=0;
signal swflag:std_logic:='0';
signal downBut_reg2:std_logic:='0';
--signal resetflag:std_logic:='0';
signal clk_1khz,clk_1hz,clk_5hz,clk_2hz,clk_10hz,clk_100hz:std_logic:='0';--�ɰ���Ӳ�������Ƶ��

signal almled : std_logic:='0';--���ӵ�ʱ��ʾ�ź�
signal timer  : std_logic:='0';--����ʱ��ʱ��ʾ�ź�

-----RGB������
--�������ź�
constant window: std_logic_vector(7 downto 0) := "11111111";
signal windowcount: std_logic_vector(7 downto 0) := (others => '0');
	
constant deltacountMax: std_logic_vector(19 downto 0) := std_logic_vector(to_unsigned(1000000, 20)); --��1000000ת��Ϊ20λ��
signal deltacount: std_logic_vector(19 downto 0) := (others => '0');
		
constant valcountMax: std_logic_vector(8 downto 0) := "101111111";
signal valcount: std_logic_vector(8 downto 0) := (others => '0');

--��ɫ���Ͷ��ź�
signal incVal: std_logic_vector(7 downto 0);
signal decVal: std_logic_vector(7 downto 0);

signal redVal: std_logic_vector(7 downto 0);
signal greenVal: std_logic_vector(7 downto 0);
signal blueVal: std_logic_vector(7 downto 0);

signal redVal2: std_logic_vector(7 downto 0);
signal greenVal2: std_logic_vector(7 downto 0);
signal blueVal2: std_logic_vector(7 downto 0);
	
--PWM �Ĵ���
signal rgbLedReg1: std_logic_vector(2 downto 0);
signal rgbLedReg2: std_logic_vector(2 downto 0);

begin

--��������ʾ�����ʱ��ʾ��״̬
Alarmled <= almled;
Countled<=timer&timer&timer&timer&timer&timer&timer&timer;

------��Ƶ���źŵĻ��

-----------1kHZ
process(Mclk)
    variable count:integer range 0 to 49999:=0;  --һ���������������干ͬ����
begin
 
  if Mclk'event and Mclk='1' then   --������
         if count =49999 then
             clk_1khz<= not clk_1khz;
             count:=0;
        else
             count := count + 1;
        end if;
    end if;

end process;

-----------100HZ
process(clk_1khz)
    variable count:integer range 0 to 4:=0;
begin

if clk_1khz'event and clk_1khz='1' then
   if count=4 then
   clk_100hz<=not clk_100hz;
   count:=0;
   else count:=count+1;
   end if;
end if;
end process;

-----------10HZ
process(clk_1khz)
    variable count:integer range 0 to 49:=0;
begin

if clk_1khz'event and clk_1khz='1' then
   if count=49 then
   clk_10hz<=not clk_10hz;
   count:=0;
   else count:=count+1;
   end if;
end if;
end process;

-----------1HZ
process(clk_1khz)
    variable count:integer range 0 to 499:=0;
begin

if clk_1khz'event and clk_1khz='1' then
   if count=499 then
   clk_1hz<=not clk_1hz;
   count:=0;
   else count:=count+1;
   end if;
end if;

end process;

----------2HZ
process(clk_1khz)
variable count:integer range 0 to 249:=0;
begin

if clk_1khz'event and clk_1khz='1' then
   if count=249 then
   clk_2hz<=not clk_2hz;
   count:=0;
   else count:=count+1;
   end if;
end if;

end process;

----------5HZ
process(clk_1khz)
variable count:integer range 0 to 99:=0;
begin

if clk_1khz'event and clk_1khz='1' then
    if count=99 then
   clk_5hz<=not clk_5hz;
   count:=0;
   else count:=count+1;
   end if;
end if;

end process;


process(clk_2hz)             --2HZ��ⰴ��
begin
if rising_edge(clk_2hz) then

    if upBut='1' then         -----���ϼ��л���ʾģʽ
     display_state<=display_state+1;
    elsif centerBut='1'  then             ----�м䰴������״̬��ͬʱ����ʾģʽ����
     display_state<="00";
	 state<=state+1;
	 
	if state="111" then
	state<="000";
	
--	if state="010" then redVal<="00000000";end if;  
--    if state="011" then greenVal<="00000000";end if;
--    if state="100" then blueVal<="00000000";end if;
    
--    if state="101" then 
--    redVal2<="00000000";
--    greenVal2<="00000000";
--    blueVal2<="00000000";
--    end if;  
	

	end if;
    end if;
    end if;
	
end process;


process(clk_1hz,clk_5hz,state,display_state,hour,sec,min,day,month,year)

variable countflag:std_logic_vector(3 downto 0):="0110";    ---����ʱ��ʾ��5�������

begin


if rising_edge(clk_1hz) then
 if sec=59 then -------- normal ������ʱ ��̨����
    sec<=0;
    if min=59 then
        min<=0;
        if hour=23 then
            hour<=0;
            if day=monthsize then
                day<=1;
                if month=12 then
                    month<=1;
                    year<=year+1;
                else month<=month+1;
                end if;
            else day<=day+1;
            end if;
        else hour<=hour+1;
        end if;
    else min<=min+1;
    end if;
else sec<=sec + 1;
end if;


if state="110" then
    if display_state ="11" then
        if downBut='1' then
            if downBut_reg='0' then
                downBut_reg<='1';
                ifcount<='1';    -----���Ƶ���˸���
                countdown<=not countdown;
                pause<='1';------------------���õ���ʱ
            end if;
        else downBut_reg<='0';
        end if;
        
        if countdown='1' then      ------------����ʱ��ʼ
            if(pause='1')then
                countsec<=countsec_load;
                countmin<=countmin_load;
                pause<='0';
            end if;
            
            
            if countsec=0 and countmin=0 and pause='0' then
                countdown<='0';
                elsif countsec=0 and pause='0' then
                countsec<=59;
                countmin<=countmin-1;
                elsif   pause='0'  then
                countsec<=countsec-1;
            end if;
            
        end if;
        
        
        if countsec=0 and countmin=0   and ifcount='1' and countflag>"0000"  then
            countflag:=countflag-1;
            if (countflag(0)='1') --��λ����
                then timer<='1';
            else  timer<='0';
            end if;
                elsif countflag="0000" then--����ʱ��ʾ����ȫ����
                timer<='0';
                countflag:="0110";
                ifcount<='0';
            end if;
        end if;
    end if;
    
end if;  
           year_load<=year;
           month_load<=month;
           day_load<=day;
           min_load<=min;
           sec_load<=sec;
           hour_load<=hour;
     if state="110" and display_state ="11" and countdown='0'  then
           countsec_load<=countsec;
           countmin_load<=countmin;
     end if;
                    
     
------------------����ʱ��------------------

if rising_edge(clk_5hz) then
if state="000" then 
case display_state is
when "00"=>null;        
when "01"=>if rightBut='1' then 
	                  if rightBut_reg='0' then              ----hour +
						    rightBut_reg<='1';
						    if hour_load=23 then
                         hour_load<=0;
							 else hour_load<=hour_load+1;
							 end if;
						  end if;
					else rightBut_reg<='0';
					end if;
            if leftBut='1' then  
                      if leftBut_reg='0' then              ----hour -
                            leftBut_reg<='1';
                            if hour_load=0 then
                         hour_load<=23;
                             else hour_load<=hour_load-1;
                             end if;
                          end if;
                    else leftBut_reg<='0';
                    end if;
when "10"=>if rightBut='1' then  
	                if rightBut_reg='0' then               ----min +
	                        rightBut_reg<='1';
						      if min_load=59 then
								    min_load<=0;
							   else min_load<=min_load+1;
								end if;
						 end if;
				  else rightBut_reg<='0';
				  end if;
            if leftBut='1' then  
                      if leftBut_reg='0' then             ----min -
                             leftBut_reg<='1';
                                if min_load=0 then
                                      min_load<=59;
                                 else min_load<=min_load-1;
                                  end if;
                           end if;
                    else leftBut_reg<='0';
                    end if;
when "11"=>null;
when others=>null;
end case;
-----------------------ʱ�����ý���--------------------------------
---������---
elsif state="001" then
 case display_state is
      when "00"=>null;
      when "10"=>if rightBut='1' then     ------year+
                    if rightBut_reg='0' then rightBut_reg<='1';
                              if year_load=2030 then
                                    year_load<=2010;
                                else year_load<=year_load+1;
                                end if;
                         end if;
                     else rightBut_reg<='0';
                     end if;
                 if leftBut='1' then      ------year-
                   if leftBut_reg='0' then leftBut_reg<='1';
                              if year_load=0 then
                                    year_load<=9999;
                                else year_load<=year_load-1;
                                end if;
                       end if;
                       else leftBut_reg<='0';
                      end if;
                      when others=>null;
  end case;
--������--
elsif state="010" then
case display_state is
	 when "00"=>null;
	 when "01"=>if rightBut='1' then-------- month +
                        if rightBut_reg='0' then rightBut_reg<='1';
                                  if month_load=12 then
                                        month_load<=1;
                                    else month_load<=month_load+1;
                                    end if;
                             end if;
                      else rightBut_reg<='0';
                      end if;
                 if leftBut='1' then-------- month -
                      if leftBut_reg='0' then leftBut_reg<='1';
                                if month_load=1 then
                                      month_load<=12;
                                  else month_load<=month_load-1;
                                  end if;
                           end if;
                    else leftBut_reg<='0';
                    end if;
	 when "10"=>if rightBut='1' then-------- day  +    
	                if rightBut_reg='0' then rightBut_reg<='1';
						      if day_load=monthsize then
								    day_load<=1;
								else day_load<=day_load+1;
								end if;
						 end if;
				  else rightBut_reg<='0';
				  end if;
			   if leftBut = '1' then-------- day  - 
			      if leftBut_reg = '0' then leftBut_reg <= '1';
			             if day_load= 1 then 
			                 day_load <=monthsize;
			             else day_load <= day_load - 1;
			             end if;
			      end if;
			   else leftBut_reg <='0';
			   end if; 
			   
    when "11"=>null;
	 when others=>null;
	 end case;


------------------��������------------------
elsif state="011" then 

case display_state is
when "01"=>if rightBut='1' then        -------- alarm1 hour +
	                if rightBut_reg='0' then rightBut_reg<='1';
						      if alarm1_hour=23 then
								    alarm1_hour<=0;
								else alarm1_hour<=alarm1_hour+1;
								end if;
						 end if;
				  else rightBut_reg<='0';
				  end if;
          if leftBut='1' then         -------- alarm1 hour -
                  if leftBut_reg='0' then leftBut_reg<='1';
                            if alarm1_hour=0 then
                                  alarm1_hour<=23;
                              else alarm1_hour<=alarm1_hour-1;
                              end if;
                       end if;
                else leftBut_reg<='0';
                end if;
                
                
	when "10"=>if rightBut='1' then   -------- alarm1 min +
	                if rightBut_reg='0' then 
	                          rightBut_reg<='1';
						      if alarm1_min=59 then
								    alarm1_min<=0;
								else alarm1_min<=alarm1_min+1;
								end if;
						 end if;
				  else rightBut_reg<='0';
				  end if;
               if leftBut='1' then     ------- alarm1 min-
                  if leftBut_reg='0' then 
                            leftBut_reg<='1';
                            if alarm1_min=0 then
                                  alarm1_min<=59;
                              else alarm1_min<=alarm1_min - 1;
                              end if;
                       end if;
                else leftBut_reg<='0';
                end if;				  
	 when others=>null; 
	 end case;

elsif state="100" then 

case display_state is
when "01"=>if rightBut='1' then           ------alarm2 hour +
	                if rightBut_reg='0' then rightBut_reg<='1';
						      if alarm2_hour=23 then
								    alarm2_hour<=0;
								else alarm2_hour<=alarm2_hour+1;
								end if;
						 end if;
				  else rightBut_reg<='0';
				  end if;
	        if leftBut='1' then           ------alarm2 hour -
                    if leftBut_reg='0' then leftBut_reg<='1';
                              if alarm2_hour=0 then
                                    alarm2_hour<=23;
                                else alarm2_hour<=alarm2_hour-1;
                                end if;
                         end if;
                  else leftBut_reg<='0';
                  end if;
                            
	when "10"=>if rightBut='1' then      ------alarm2 min +
	                if rightBut_reg='0' then rightBut_reg<='1';
						      if alarm2_min=59 then
								    alarm2_min<=0;
								else alarm2_min<=alarm2_min+1;
								end if;
						 end if;
				  else rightBut_reg<='0';
				  end if;
			      if leftBut='1' then    ------alarm2 min -
                         if leftBut_reg='0' then leftBut_reg<='1';
                                   if alarm2_min=0 then
                                         alarm2_min<=59;
                                     else alarm2_min<=alarm2_min - 1;
                                     end if;
                              end if;
                       else leftBut_reg<='0';
                       end if;                  
	 when others=>null; 
	 end case;	 
 elsif state="101" then 
 case display_state is
 when "01"=>if rightBut='1' then         ------alarm3 hour +
                     if rightBut_reg='0' then rightBut_reg<='1';
                               if alarm3_hour=23 then
                                     alarm3_hour<=0;
                                 else alarm3_hour<=alarm3_hour+1;
                                 end if;
                          end if;
                   else rightBut_reg<='0';
                   end if;
           if leftBut='1' then            ------alarm3 hour -
                    if leftBut_reg='0' then leftBut_reg<='1';
                              if alarm3_hour=0 then
                                    alarm3_hour<=23;
                                else alarm3_hour<=alarm3_hour-1;
                                end if;
                         end if;
                  else leftBut_reg<='0';
                  end if;       
     when "10"=>if rightBut='1' then     ------alarm3 min +
                     if rightBut_reg='0' then rightBut_reg<='1';
                               if alarm3_min=59 then
                                     alarm3_min<=0;
                                 else alarm3_min<=alarm3_min+1;
                                 end if;
                          end if;
                   else rightBut_reg<='0';
                   end if;
                if leftBut='1' then       ------alarm3 min -
                      if leftBut_reg='0' then leftBut_reg<='1';
                                if alarm3_min=0 then
                                      alarm3_min<=59;
                                  else alarm3_min<=alarm3_min - 1;
                                  end if;
                           end if;
                    else leftBut_reg<='0';
                    end if;                  
      when others=>null; 
      end case;   
-----------------------�������ý���--------------------------------
------------------���õ���ʱ------------------   
elsif state="110" then
case display_state is
when "01"=>
	
	if rightBut='1' then    -----countdown min +
               if rightBut_reg='0' then   
                 rightBut_reg<='1';
                  if countmin_load=59 then
                     countmin_load<=0;
                  else countmin_load<=countmin_load+1;
                  end if;
                end if;
              else rightBut_reg<='0';
              end if;
				
	if leftBut='1' then     -----countdown min -
             if leftBut_reg='0' then   
               leftBut_reg<='1';
                if countmin_load=0 then
                   countmin_load<=59;
                else countmin_load<=countmin_load - 1;
                end if;
              end if;
            else leftBut_reg<='0';
            end if;
    
 
   when "10"=>	if rightBut='1' then   -----countdown sec +
              if rightBut_reg='0' then 
                 rightBut_reg<='1';
                  if countsec_load=59 then
                      countsec_load<=0;
                  else countsec_load<=countsec_load+1;
			
                  end if;
              end if;
            else rightBut_reg<='0';
            end if;
                if leftBut='1' then     -----countdown sec -
              if leftBut_reg='0' then 
                 leftBut_reg<='1';
                  if countsec_load=0 then
                      countsec_load<=59;
                  else countsec_load<=countsec_load -  1;
                 
                  end if;
              end if;
            else leftBut_reg<='0';
            end if;
 
     when others=>null;	
	end case;	
					
 end if;
end if;


--����ֵ����ʱ��
if  state="001" and display_state="10" then  --�����ã�����ʵ��ֻ����λ
	year<=year_load;
end if;

if  state="000" and display_state="01" then  --ʱ�����������ʱ���
    hour<=hour_load;
end if;
if  state="000" and display_state="10" then 
    min<=min_load;
end if;


 if state="010" and display_state="01" then  --�������������������
    month<=month_load;
end if;   
 if state="010" and display_state="10" then  
    day<=day_load;
end if;      

if state="110" and  display_state="01" then  --����ʱ����ķ�����
    countmin<=countmin_load;
end if;       
if state="110" and  display_state="10" then
    countsec<=countsec_load; 
end if;   

--if state="010" then redVal<="00000000";end if;  
--if state="011" then greenVal<="00000000";end if;
--if state="100" then blueVal<="00000000";end if;

--if state="101" then 
--redVal2<="00000000";
--greenVal2<="00000000";
--blueVal2<="00000000";
--end if;  

     
end process;


process(clk_2hz,display_state,blink_low,blink_high,scan,scan1)                --------���������

begin
   case display_state is 
	    when "00"=>blink_low<=1;blink_high<=1;--�˶������������
        when "11"=>blink_low<=1;blink_high<=1;
		
        when "10"=>  --���Ʒֵ���˸
        if clk_2hz='1' then
           blink_low<=1;
        else
           blink_low<=0;
        end if;
		
        when "01"=>  --����ʱ����˸
        if clk_2hz='1' then
           blink_high<=1;
        else
           blink_high<=0;
        end if;
        when others=>null;
   end case;
   
end process;




-----------alarm--����״̬��ʹ��
process(clk_1hz,downBut,hour,min,sec)
variable alarmcount:std_logic_vector(3 downto 0):="0110";------��˸5s
variable alarmcount2:std_logic_vector(3 downto 0):="1000";--ʮ�������һ��
variable alarmflag:std_logic:='0';-------10s������һ��
variable num:std_logic_vector(1 downto 0):="00";-------�ڼ���������
variable alm_signal:std_logic:='0';--------���ӵ���ı�־
begin

if rising_edge(clk_1hz) then
if( hour=alarm1_hour and min=alarm1_min and sec=0 ) or (hour=alarm2_hour and min=alarm2_min and sec=0) or (hour=alarm3_hour and min=alarm3_min and sec=0)
then-----������������һ��
       alm_signal:='1';
       alarmflag:='0';
	   num:="01";--------��һ����������
end if;

if  state/="111" then
      if alm_signal='1' and downBut='1'  then-------�¼� Ϊ��ͣ��    --״̬����Ŷ
      almled<='0';
	  alm_signal:='0';                 
      alarmflag:='0';
      alarmcount:="0110";
      alarmcount2:="1000";     
      end if;
end if;
if alm_signal='1'  and alarmcount>"0000" then
     alarmcount:=alarmcount-1;
	  if (alarmcount(0)='1') then                              ------����˸
	     almled<='1';
		else almled<='0';
 end if;
elsif alm_signal='1' and alarmcount="0000" then
     almled<='0';
	 alm_signal:='0';
     alarmcount:="0110";
     alarmflag:='1';
end if;
if alarmflag='1' and num="01" then
if  alarmcount2>"0000" then
  alarmcount2:=alarmcount2-1;
elsif  alarmcount2="0000"  then
  alarmflag:='0';
  alarmcount2:="1000";
  alm_signal:='1';
  num:=num+1;--------�ڶ�������
  end if;
end if;
end if;
end process;

--���
process(state,clk_10hz,clk_2hz,clk_100hz,clk_5hz)
begin 

if rising_edge(clk_100hz) and state="111" then
if   downBut='1' then  
    if downBut_reg2='0' then downBut_reg2<='1';
    swflag<=not swflag;
    end if;
else downBut_reg2<='0';
end if;

--if   rightBut='1' then  
--    if rightBut_reg='0' then rightBut_reg<='1';
--    resetflag<='1';
--    end if;
--else rightBut_reg<='0';
--end if;
--if   rightBut='1' then
--     resetflag<='1';  
--end if;

end if;

if  rising_edge(clk_100hz) and state="111" then
 if swflag='1' then
  if mmsec=99 then 
           mmsec<=0;
           if msec=59 then
               msec<=0;
               if mmin=59 then
                   mmin<=0;
               else mmin<=mmin+1;
               end if;
           else msec<=msec+1;
           end if;
       else mmsec<=mmsec + 1;
       end if;
   elsif  swflag='0' and rightBut='1' then 
--   elsif  swflag='0' and resetflag='1' then 
       mmsec<=0;
       msec<=0;
       mmin<=0;
--       resetflag<='0';
       end if;      
       end if;
       
-- if  rising_edge(clk_10hz) and state="111" then
-- mmsec_load<=Integer(mmsec/10);
-- end if;
       
end process;
--

-------- ��������ת��Ϊ������������껶��Ż��������ˣ�ʵ����ֵ��Ӧ���������ʾ
process(sec,dig_sl,dig_sh,
min,dig_ml,dig_mh,
alarm1_min,dig_alm1_ml,dig_alm1_mh,alarm2_min,
dig_alm2_ml,dig_alm2_mh,alarm3_min,
dig_alm3_mh,dig_alm3_ml,
hour,dig_hl,dig_hh,
alarm1_hour,dig_alm1_hl,dig_alm1_hh,
alarm2_hour,dig_alm2_hl,dig_alm2_hh
,alarm3_hour,dig_alm3_hl,dig_alm3_hh,
day,dig_dayl,dig_dayh,
month,dig_monl,dig_monh,
year,dig_yearl,dig_yearh,
countsec,dig_csl,dig_csh,
countmin,dig_cml,dig_cmh)
                    
begin
--��
dig_sl<=sec rem 10;
dig_sh<=Integer(sec/10);
--��
dig_ml<=min  rem 10;
dig_mh<=Integer(min/10);
--����1��
dig_alm1_ml<=alarm1_min rem 10;
dig_alm1_mh<=Integer(alarm1_min/10);
--����2��
dig_alm2_ml<=alarm2_min rem 10 ;

dig_alm2_mh<=Integer(alarm2_min/ 10);

--����3��
dig_alm3_ml<=alarm3_min rem 10;

dig_alm3_mh<=Integer(alarm3_min/10) ;
--ʱ
dig_hl<= hour rem 10;

dig_hh<=Integer(hour/ 10) ;
--����1ʱ
dig_alm1_hl<=alarm1_hour rem 10;

dig_alm1_hh<=Integer(alarm1_hour/10);
--����2ʱ
dig_alm2_hl<= alarm2_hour rem 10;

dig_alm2_hh<= Integer(alarm2_hour/10);
--����3ʱ
dig_alm3_hl<=alarm3_hour rem 10 ;

dig_alm3_hh<=Integer(alarm3_hour/10) ;
--��
dig_dayl<=day rem 10;

dig_dayh<=Integer(day/10) ;
--��
dig_monl<=month rem 10;

dig_monh<=Integer(month/10) ;
--��
dig_yearl<=(year-2000) rem 10;

dig_yearh<=integer(year-2000)/10;
--����ʱ��
dig_csl<=countsec rem 10;

dig_csh<=Integer(countsec/10) ;
---����ʱ��
dig_cml<=countmin rem 10 ;

dig_cmh<=Integer(countmin/10);

--���
dig_smml<= mmsec rem 10 ;

dig_smmh<=Integer(mmsec/10);

dig_ssl<= msec rem 10 ;

dig_ssh<=Integer(msec/10);

dig_sml<= mmin rem 10 ;

dig_smh<=Integer(mmin/10);
end process;

-----------------���� ��
process(year,dig_yearl,dig_yearh)
begin
----�ж����겢�ñ�־λ

if((year rem 4 =0 and year rem 100/=0)or(year rem 400=0))
then leapyear<='1';
else leapyear<='0';
end if;

end process;

----------------------�����Ӧ�µ�����
process(leapyear,month)
begin 
if leapyear='1' then
  case month is
      when 1|3|5|7|8|10|12=> monthsize<=31;
		when 4|6|9|11=> monthsize<=30;
		when 2=>monthsize<=29;
		when others=>null;
	end case;
elsif  leapyear='0' then
   case month is 
      when 1|3|5|7|8|10|12=> monthsize<=31;
		when 4|6|9|11=> monthsize<=30;
		when 2=>monthsize<=28;
		when others=>null;
	end case;
end if;
end process;

--�����ɨ��
process(clk_1khz)
begin
if rising_edge(clk_1khz) then

           if scan=3 then--����
                scan<=0;
           else scan<=scan+1;
		   
           if scan1=5 then--רΪ��ʾʱ����ʱ������
             scan1<=0;
           else  scan1<=scan1+1;
           end if;
           end if;
end if;
end process;

process(state,dig_hh,dig_hl,dig_mh,dig_ml,dig_sh,dig_sl,dig_dayl,dig_dayh,dig_monl,dig_monh,dig_yearh,dig_yearl,dig_cml,dig_cmh,dig_csl,dig_csh,
       dig_alm1_ml,dig_alm1_mh,dig_alm1_hl,dig_alm1_hh,dig_alm2_ml,dig_alm2_mh,dig_alm2_hl,dig_alm2_hh,dig_alm3_ml,dig_alm3_mh,dig_alm3_hl,dig_alm3_hh)
begin
case state is
   when "000"=>case scan1 is -------------����ʱ������
              when 0=>if blink_low=1 or blink_high=1 then data<=dig_sl; else data<=10; end if;AN<="11111110";
              when 1=>if blink_low=1 or blink_high=1 then data<=dig_sh; else data<=10; end if;AN<="11111101";
	          when 2=>if blink_low=1 then data<=dig_ml; else data<=10; end if;AN<="11111011";
	          when 3=>if blink_low=1 then data<=dig_mh; else data<=10; end if;AN<="11110111"; 
              when 4=>if blink_high=1 then data<=dig_hl; else data<=10; end if;AN<="11101111";
              when 5=>if blink_high=1 then data<=dig_hh; else data<=10; end if;AN<="11011111";	
              when others=>null;
              end case;
  
    when "001"=>case scan is --------------����������
                         when 0=>if blink_low=1 then data<=dig_yearl; else data<=10; end if;AN<="11101111";
                         when 1=>if blink_low=1 then data<=dig_yearh; else data<=10; end if;AN<="11011111";
                         when 2=>if blink_high=1 then data<=0; else data<=10; end if;AN<="10111111";-----Ĭ��21���͵�һ������
                         when 3=>if blink_high=1 then data<=2; else data<=10; end if;AN<="01111111";
                         when others=>null;
                         end case;
  
    when "010"=>case scan is --------------������������
                                     when 0=>if blink_low=1 then data<=dig_dayl; else data<=10; end if;AN<="11111110";
                                     when 1=>if blink_low=1 then data<=dig_dayh; else data<=10; end if;AN<="11111101";
                                     when 2=>if blink_high=1 then data<=dig_monl; else data<=10; end if;AN<="11111011";
                                     when 3=>if blink_high=1 then data<=dig_monh; else data<=10; end if;AN<="11110111";
                                     when others=>null;
                                     end case;
  
   when "011"=>case scan is --------------��������1����
              when 0=>if blink_low=1 then data<=dig_alm1_ml; else data<=10; end if;AN<="11111110";
		      when 1=>if blink_low=1 then data<=dig_alm1_mh; else data<=10; end if;AN<="11111101";
		      when 2=>if blink_high=1 then data<=dig_alm1_hl; else data<=10; end if;AN<="11111011";
		      when 3=>if blink_high=1 then data<=dig_alm1_hh; else data<=10; end if;AN<="11110111";
		      when others=>null;
		      end case;
		 
   when "100"=>case scan is --------------��������2����
			when 0=>if blink_low=1 then data<=dig_alm2_ml; else data<=10; end if;AN<="11111110";
			when 1=>if blink_low=1 then data<=dig_alm2_mh; else data<=10; end if;AN<="11111101";
			when 2=>if blink_high=1 then data<=dig_alm2_hl; else data<=10; end if;AN<="11111011";
			when 3=>if blink_high=1 then data<=dig_alm2_hh; else data<=10; end if;AN<="11110111";
			when others=>null;
		    end case;	
			
   when "101"=>case scan is --------------��������3����
			when 0=>if blink_low=1 then data<=dig_alm3_ml; else data<=10; end if;AN<="11111110";
			when 1=>if blink_low=1 then data<=dig_alm3_mh; else data<=10; end if;AN<="11111101";
			when 2=>if blink_high=1 then data<=dig_alm3_hl; else data<=10; end if;AN<="11111011";
			when 3=>if blink_high=1 then data<=dig_alm3_hh; else data<=10; end if;AN<="11110111";
			when others=>null;
		    end case;
				 
   when "110"=>case scan is --------------���õ���ʱ����
		    when 0=>if blink_low=1 then data<=dig_csl; else data<=10; end if;AN<="11111110";
            when 1=>if blink_low=1 then data<=dig_csh; else data<=10; end if;AN<="11111101";
            when 2=>if blink_high=1 then data<=dig_cml; else data<=10; end if;AN<="11111011";
            when 3=>if blink_high=1 then data<=dig_cmh; else data<=10; end if;AN<="11110111";
            when others=>null;
			end case;	

   when"111"=>case scan1 is	--------------�����������
            when 0=> data<=dig_smml;AN<="11111110";		
            when 1=> data<=dig_smmh;AN<="11111101";	
            when 2=> data<=dig_ssl;AN<="11111011";	
            when 3=> data<=dig_ssh;AN<="11110111";	
            when 4=> data<=dig_sml;AN<="11101111";	
            when 5=> data<=dig_smh;AN<="11011111";	
            when others=>null;
            end case;
   when others=>null;
 end case;
 end process;
 
-------�γ���ת���� 
process(data)
 begin
 case data is
     when 0=>seg7leds<="1000000";    
     when 1=>seg7leds<="1111001";     
     when 2=>seg7leds<="0100100"; 
     when 3=>seg7leds<="0110000"; 
     when 4=>seg7leds<="0011001"; 
     when 5=>seg7leds<="0010010"; 
     when 6=>seg7leds<="0000010"; 
     when 7=>seg7leds<="1111000"; 
     when 8=>seg7leds<="0000000"; 
     when 9=>seg7leds<="0010000"; 
     when others=>seg7leds<="1111111"; 
 end case;
 
 
 end process;
 
 ----RGB������
 window_counter:process(Mclk)
 begin
     if(rising_edge(Mclk)) then
         if windowcount < (window) then
             windowcount <= windowcount + 1;
         else
             windowcount <= (others => '0');
         end if;
     end if;
 end process;
 
 color_change_counter:process(Mclk)
 begin
     if(rising_edge(Mclk)) then
         if(deltacount < deltacountMax) then
             deltacount <= deltacount + 1;
         else
             deltacount <= (others => '0');
         end if;
     end if;
 end process;
 
 color_intensity_counter:process(Mclk)
 begin
     if(rising_edge(Mclk)) then
     if(deltacount = 0) then
         if(valcount < valcountMax) then
             valcount <= valcount + 1;
         else
             valcount <= (others => '0');
         end if;
     end if;
     end if;
 end process;
 
 incVal <= "0" & valcount(6 downto 0);  --ǰ��0
 
 --The folowing code sets decVal to (128 - incVal)
 decVal(7) <= '0';
 decVal(6) <= not(valcount(6));
 decVal(5) <= not(valcount(5));
 decVal(4) <= not(valcount(4));
 decVal(3) <= not(valcount(3));
 decVal(2) <= not(valcount(2));
 decVal(1) <= not(valcount(1));
 decVal(0) <= not(valcount(0)); 
 

 redVal <= incVal when (valcount(8 downto 7) = "00") else
           decVal when (valcount(8 downto 7) = "01") else
           (others => '0');       
 greenVal <= decVal when (valcount(8 downto 7) = "00") else
           (others => '0') when (valcount(8 downto 7) = "01") else
           incVal;
 blueVal <= (others => '0') when (valcount(8 downto 7) = "00") else
            incVal when (valcount(8 downto 7) = "01") else
            decVal;
 
redVal2 <= incVal when (valcount(8 downto 7) = "00") else
            decVal when (valcount(8 downto 7) = "01") else
            (others => '0');       
greenVal2 <= decVal when (valcount(8 downto 7) = "00") else
           (others => '0') when (valcount(8 downto 7) = "01") else
             incVal;
blueVal2 <= (others => '0') when (valcount(8 downto 7) = "00") else
            incVal when (valcount(8 downto 7) = "01") else
            decVal;


 
 --red processes
 red_comp:process(Mclk)
 begin
     if(rising_edge(Mclk))and state="011" then   --��������̬�ֱ�������������
         if((redVal) > windowcount) then
             rgbLedReg1(2) <= '1';
         else
             rgbLedReg1(2) <= '0';
         end if;
     end if;
     if state="100" then rgbLedReg1(2) <= '0';end if;
 end process;
 
 
 --green processes
 green_comp:process(Mclk)
 begin
     if(rising_edge(Mclk))and state="100" then
         if((greenVal) > windowcount) then
             rgbLedReg1(1) <= '1';
         else
             rgbLedReg1(1) <= '0';
         end if;
     end if;
     if state="101" then rgbLedReg1(1) <= '0';end if; 
 end process;
 
             
 --blue processes
 blue_comp:process(Mclk)
 begin
     if(rising_edge(Mclk))and state="101" then
         if((blueVal) > windowcount) then
             rgbLedReg1(0) <= '1';
         else
             rgbLedReg1(0) <= '0';
         end if;
     end if;
     if state="110" then rgbLedReg1(0) <= '0';end if;
 end process;
 
--red2 processes
 red2_comp:process(Mclk)
 begin
     if(rising_edge(Mclk))and state="110" and display_state="00" then
         if((redVal2) > windowcount) then
             rgbLedReg2(2) <= '1';
         else
             rgbLedReg2(2) <= '0';
         end if;
     end if;
     if state="111" then rgbLedReg2(2) <= '0';end if;
 end process;
 
 
 --green2 processes
 green2_comp:process(Mclk)
 begin
     if(rising_edge(Mclk))and state="110" and display_state="00" then
         if((greenVal2) > windowcount) then
             rgbLedReg2(1) <= '1';
         else
             rgbLedReg2(1) <= '0';
         end if;
     end if;
     if state="111" then rgbLedReg2(1) <= '0';end if; 
 end process;
 
             
 --blue2 processes
 blue2_comp:process(Mclk)
 begin
     if(rising_edge(Mclk))and state="110" and display_state="00" then
         if((blueVal2) > windowcount) then
             rgbLedReg2(0) <= '1';
         else
             rgbLedReg2(0) <= '0';
         end if;
     end if;
     if state="111" then rgbLedReg2(0) <= '0';end if; 
 end process;
 
RGB_LED_1_O <= rgbLedReg1;
RGB_LED_2_O <= rgbLedReg2;	

end Behavioral;

