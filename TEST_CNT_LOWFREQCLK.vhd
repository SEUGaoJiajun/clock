----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2017/08/31 23:28:04
-- Design Name: 
-- Module Name: TEST_CNT_LOWFREQCLK - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TEST_CNT2 is
 Port (
clk:in std_logic:='0';
reset:in std_logic:='0';
input:in std_logic_vector(9 downto 0):="0000000000";
begin_input:in std_logic:='0';
enter:in std_logic:='0';
manage:in std_logic:='0';
delete:in std_logic:='0';
back:in std_logic:='0';
led:buffer std_logic_vector(15 downto 0):="0000000000000000";
reset_all:in std_logic:='0';
disp_place:buffer std_logic_vector(7 downto 0):="11111111";
disp_number:out std_logic_vector(6 downto 0):="1110111"
 );
end TEST_CNT2;

architecture Behavioral of TEST_CNT2 is
signal clk_10s:std_logic:='0';
signal clk_20s:std_logic:='0';
signal clk_125ms:std_logic:='0';
signal clk_10ms:std_logic:='0';
signal clk_1ms:std_logic:='0';
signal cnt_10s:std_logic_vector(29 downto 0):="000000000000000000000000000000";
signal cnt_20s:std_logic_vector(30 downto 0):="0000000000000000000000000000000";
signal cnt_125ms:std_logic_vector(24 downto 0):="0000000000000000000000000";
signal cnt_10ms:std_logic_vector(19 downto 0):="00000000000000000000";
signal cnt_1ms:std_logic_vector(16 downto 0):="00000000000000000";
signal true_code_0:std_logic_vector(9 downto 0):="0000000001";
signal true_code_1:std_logic_vector(9 downto 0):="0000000001";
signal true_code_2:std_logic_vector(9 downto 0):="0000000001";
signal true_code_3:std_logic_vector(9 downto 0):="0000000001";
signal input_code_0:std_logic_vector(9 downto 0):="0000000000";
signal input_code_1:std_logic_vector(9 downto 0):="0000000000";
signal input_code_2:std_logic_vector(9 downto 0):="0000000000";
signal input_code_3:std_logic_vector(9 downto 0):="0000000000";
signal reset_state:std_logic:='0';
signal input_state:std_logic:='0';
signal warning_state:std_logic:='0';
signal unreset_state:std_logic:='0';
signal waiting_state:std_logic:='1';
signal lock_state:std_logic:='1';
signal already_input:std_logic:='0';
signal already_reset_all:std_logic:='0';
signal already_manage:std_logic:='0';
signal already_reset:std_logic:='0';
signal already_enter:std_logic:='0';
signal already_back:std_logic:='0';
signal already_delete:std_logic:='0';
signal already_begin_input:std_logic:='0';
signal reset_button:std_logic:='0';
signal enter_button:std_logic:='0';
signal back_button:std_logic:='0';
signal delete_button:std_logic:='0';
signal begin_input_button:std_logic:='0';
signal input_button:std_logic_vector(9 downto 0):="0000000000";
signal manage_button:std_logic:='0';
signal reset_all_button:std_logic:='0';
signal reset_1:std_logic:='0';
signal enter_1:std_logic:='0';
signal back_1:std_logic:='0';
signal delete_1:std_logic:='0';
signal begin_input_1:std_logic:='0';
signal input_1:std_logic_vector(9 downto 0):="0000000000";
signal manage_1:std_logic:='0';
signal reset_all_1:std_logic:='0';
signal reset_2:std_logic:='0';
signal enter_2:std_logic:='0';
signal back_2:std_logic:='0';
signal delete_2:std_logic:='0';
signal begin_input_2:std_logic:='0';
signal input_2:std_logic_vector(9 downto 0):="0000000000";
signal manage_2:std_logic:='0';
signal reset_all_2:std_logic:='0';
signal reset_3:std_logic:='0';
signal enter_3:std_logic:='0';
signal back_3:std_logic:='0';
signal delete_3:std_logic:='0';
signal begin_input_3:std_logic:='0';
signal input_3:std_logic_vector(9 downto 0):="0000000000";
signal manage_3:std_logic:='0';
signal reset_all_3:std_logic:='0';
signal input_place:std_logic_vector(1 downto 0):="11";
signal input_times:std_logic_vector(2 downto 0):="000";
signal led_place:std_logic_vector(3 downto 0):="1000";
signal led_show:std_logic:='0';
signal once_wrong:std_logic_vector(1 downto 0):="00";
constant lock_0:std_logic_vector(6 downto 0):="1110000";
constant lock_1:std_logic_vector(6 downto 0):="0110001";
constant lock_2:std_logic_vector(6 downto 0):="0000001";
constant lock_3:std_logic_vector(6 downto 0):="1110001";
constant open_0:std_logic_vector(6 downto 0):="0001001";
constant open_1:std_logic_vector(6 downto 0):="0110000";
constant open_2:std_logic_vector(6 downto 0):="0011000";
constant open_3:std_logic_vector(6 downto 0):="0000001";
constant disp_0:std_logic_vector(6 downto 0):="0000001";
constant disp_1:std_logic_vector(6 downto 0):="1001111";
constant disp_2:std_logic_vector(6 downto 0):="0010010";
constant disp_3:std_logic_vector(6 downto 0):="0000110";
constant disp_4:std_logic_vector(6 downto 0):="1001100";
constant disp_5:std_logic_vector(6 downto 0):="0100100";
constant disp_6:std_logic_vector(6 downto 0):="0100000";
constant disp_7:std_logic_vector(6 downto 0):="0001111";
constant disp_8:std_logic_vector(6 downto 0):="0000000";
constant disp_9:std_logic_vector(6 downto 0):="0000100";
constant disp_void:std_logic_vector(6 downto 0):="1110111";

begin
  
  process(clk)
   begin
   if(clk'event and clk='1')then
    if(reset_all='1') then
     reset_state<='0';
     input_state<='0';
     warning_state<='0';
     unreset_state<='0';
     waiting_state<='1';
     lock_state<='1';
     input_place<="11";
     input_times<="000";
     already_input<='0';
     true_code_0<="0000000001";
     true_code_1<="0000000001";
     true_code_2<="0000000001";
     true_code_3<="0000000001";
     input_code_0<="0000000000";
     input_code_1<="0000000000";
     input_code_2<="0000000000";
     input_code_3<="0000000000";
     once_wrong<="00";
     cnt_10s<="000000000000000000000000000000";
     cnt_20s<="0000000000000000000000000000000";
     cnt_125ms<="0000000000000000000000000";
     cnt_10ms<="00000000000000000000";
     cnt_1ms<="00000000000000000";
     clk_125ms<='0';
     clk_10s<='0';
     clk_20s<='0';
     clk_10ms<='0';
     clk_1ms<='0';
     led_show<='0';
    end if;
    
    if(input_button="0000000000" and input_state='1' and enter_button='0' and begin_input_button='0' and delete_button='0') then
      if(cnt_10s<="11101110011010110010100000000") then
       cnt_10s<=cnt_10s+1;
       clk_10s<='1';
      elsif(cnt_10s="111011100110101100100111111111") then
       cnt_10s<="000000000000000000000000000000";
       clk_10s<='0';
       input_state<='0';
       waiting_state<='1';
       input_place<="11";
       input_times<="000";    
       input_code_0<="0000000000";
       input_code_1<="0000000000";
       input_code_2<="0000000000";
       input_code_3<="0000000000";
      else
       cnt_10s<=cnt_10s+1;
       clk_10s<='0';
      end if;

    elsif(input_button="0000000000" and lock_state='0' and enter_button='0' and reset_button='0' and delete_button='0') then
      if(cnt_20s<="111011100110101100101000000000") then
       cnt_20s<=cnt_20s+1;
       clk_20s<='1';
      elsif(cnt_20s="1110111001101011001001111111111") then
       cnt_20s<="0000000000000000000000000000000";
       clk_20s<='0';
       reset_state<='0';
       unreset_state<='0';
       lock_state<='1';
       led_show<='1';
       waiting_state<='1';
       input_code_0<="0000000000";
       input_code_1<="0000000000";
       input_code_2<="0000000000";
       input_code_3<="0000000000";
      else
       cnt_20s<=cnt_20s+1;
       clk_20s<='0';
      end if;

     else
      cnt_20s<="0000000000000000000000000000000";
      cnt_10s<="000000000000000000000000000000";
     end if;
     
    if(delete_button='0')then
     already_delete<='0';
    end if;
     
    if(input_button="0000000000") then
     already_input<='0';
    end if;
     
    if(reset_state='1' or input_state='1') then

     if(delete_button='1' and input_times>"000") then
      if(already_delete='0') then
       already_delete<='1';
       case input_place is
       when "10" => input_code_3<="0000000000";input_place<=input_place+1;input_times<=input_times-1;
       when "01" => input_code_2<="0000000000";input_place<=input_place+1;input_times<=input_times-1;
       when "00" => input_code_1<="0000000000";input_place<=input_place+1;input_times<=input_times-1;
       when others => input_code_0<="0000000000";input_place<=input_place+1;input_times<=input_times-1;
       end case;
      end if;
      
     elsif(input_place="11" and input_times<"100") then
      if(already_input='0') then
        case input_button is
        when "0000000001" => input_code_3<="0000000001";already_input<='1';input_place<=input_place-1;input_times<=input_times+1;
        when "0000000010" => input_code_3<="0000000010";already_input<='1';input_place<=input_place-1;input_times<=input_times+1;
        when "0000000100" => input_code_3<="0000000100";already_input<='1';input_place<=input_place-1;input_times<=input_times+1;
        when "0000001000" => input_code_3<="0000001000";already_input<='1';input_place<=input_place-1;input_times<=input_times+1;
        when "0000010000" => input_code_3<="0000010000";already_input<='1';input_place<=input_place-1;input_times<=input_times+1;
        when "0000100000" => input_code_3<="0000100000";already_input<='1';input_place<=input_place-1;input_times<=input_times+1;
        when "0001000000" => input_code_3<="0001000000";already_input<='1';input_place<=input_place-1;input_times<=input_times+1;
        when "0010000000" => input_code_3<="0010000000";already_input<='1';input_place<=input_place-1;input_times<=input_times+1;
        when "0100000000" => input_code_3<="0100000000";already_input<='1';input_place<=input_place-1;input_times<=input_times+1;
        when "1000000000" => input_code_3<="1000000000";already_input<='1';input_place<=input_place-1;input_times<=input_times+1;
        when others         => input_code_3<="0000000000";
        end case;
      end if;
      
     elsif(input_place="10" and input_times<"100") then
      if(already_input='0') then
        case input_button is
        when "0000000001" => input_code_2<="0000000001";already_input<='1';input_place<=input_place-1;input_times<=input_times+1;
        when "0000000010" => input_code_2<="0000000010";already_input<='1';input_place<=input_place-1;input_times<=input_times+1;
        when "0000000100" => input_code_2<="0000000100";already_input<='1';input_place<=input_place-1;input_times<=input_times+1;
        when "0000001000" => input_code_2<="0000001000";already_input<='1';input_place<=input_place-1;input_times<=input_times+1;
        when "0000010000" => input_code_2<="0000010000";already_input<='1';input_place<=input_place-1;input_times<=input_times+1;
        when "0000100000" => input_code_2<="0000100000";already_input<='1';input_place<=input_place-1;input_times<=input_times+1;
        when "0001000000" => input_code_2<="0001000000";already_input<='1';input_place<=input_place-1;input_times<=input_times+1;
        when "0010000000" => input_code_2<="0010000000";already_input<='1';input_place<=input_place-1;input_times<=input_times+1;
        when "0100000000" => input_code_2<="0100000000";already_input<='1';input_place<=input_place-1;input_times<=input_times+1;
        when "1000000000" => input_code_2<="1000000000";already_input<='1';input_place<=input_place-1;input_times<=input_times+1;
        when others         => input_code_2<="0000000000";
        end case;
      end if;
      
     elsif(input_place="01" and input_times<"100") then
      if(already_input='0') then
        case input_button is
        when "0000000001" => input_code_1<="0000000001";already_input<='1';input_place<=input_place-1;input_times<=input_times+1;
        when "0000000010" => input_code_1<="0000000010";already_input<='1';input_place<=input_place-1;input_times<=input_times+1;
        when "0000000100" => input_code_1<="0000000100";already_input<='1';input_place<=input_place-1;input_times<=input_times+1;
        when "0000001000" => input_code_1<="0000001000";already_input<='1';input_place<=input_place-1;input_times<=input_times+1;
        when "0000010000" => input_code_1<="0000010000";already_input<='1';input_place<=input_place-1;input_times<=input_times+1;
        when "0000100000" => input_code_1<="0000100000";already_input<='1';input_place<=input_place-1;input_times<=input_times+1;
        when "0001000000" => input_code_1<="0001000000";already_input<='1';input_place<=input_place-1;input_times<=input_times+1;
        when "0010000000" => input_code_1<="0010000000";already_input<='1';input_place<=input_place-1;input_times<=input_times+1;
        when "0100000000" => input_code_1<="0100000000";already_input<='1';input_place<=input_place-1;input_times<=input_times+1;
        when "1000000000" => input_code_1<="1000000000";already_input<='1';input_place<=input_place-1;input_times<=input_times+1;
        when others         => input_code_1<="0000000000";
        end case;
      end if;
      
     elsif(input_place="00" and input_times<"100") then
      if(already_input='0') then
        case input_button is
        when "0000000001" => input_code_0<="0000000001";already_input<='1';input_place<=input_place-1;input_times<=input_times+1;
        when "0000000010" => input_code_0<="0000000010";already_input<='1';input_place<=input_place-1;input_times<=input_times+1;
        when "0000000100" => input_code_0<="0000000100";already_input<='1';input_place<=input_place-1;input_times<=input_times+1;
        when "0000001000" => input_code_0<="0000001000";already_input<='1';input_place<=input_place-1;input_times<=input_times+1;
        when "0000010000" => input_code_0<="0000010000";already_input<='1';input_place<=input_place-1;input_times<=input_times+1;
        when "0000100000" => input_code_0<="0000100000";already_input<='1';input_place<=input_place-1;input_times<=input_times+1;
        when "0001000000" => input_code_0<="0001000000";already_input<='1';input_place<=input_place-1;input_times<=input_times+1;
        when "0010000000" => input_code_0<="0010000000";already_input<='1';input_place<=input_place-1;input_times<=input_times+1;
        when "0100000000" => input_code_0<="0100000000";already_input<='1';input_place<=input_place-1;input_times<=input_times+1;
        when "1000000000" => input_code_0<="1000000000";already_input<='1';input_place<=input_place-1;input_times<=input_times+1;
        when others         => input_code_0<="0000000000";
        end case;
      end if;
     end if; 
    end if;

    if(cnt_125ms<="10111110101111000010000") then
     cnt_125ms<=cnt_125ms+1;
     clk_125ms<='1';
    elsif(cnt_125ms="101111101011110000011111") then
     cnt_125ms<="0000000000000000000000000";
     clk_125ms<='0';
    else
     cnt_125ms<=cnt_125ms+1;
     clk_125ms<='0';
    end if;

    if(reset_button='0')then
     already_reset<='0';
    end if;   
    
    if(reset_button='1' and lock_state='0') then
    
     if(unreset_state='1' and reset_state='0') then
      if(already_reset='0') then
       already_reset<='1';
       reset_state<='1';
       unreset_state<='0';
      end if;
    
     elsif(unreset_state='0' and reset_state='1') then
      if(already_reset='0') then
       already_reset<='1';
       reset_state<='0';
       unreset_state<='1';
       input_times<="000";
       input_place<="11";
       input_code_0<="0000000000";
       input_code_1<="0000000000";
       input_code_2<="0000000000";
       input_code_3<="0000000000";
      end if;
     end if;
     
    end if;
    
    if(begin_input_button='0')then
     already_begin_input<='0';
    end if;
    
    if(begin_input_button='1' and waiting_state='1' and lock_state='1' and input_state='0') then
     if(already_begin_input='0') then
     already_begin_input<='1';
     input_state<='1';
     waiting_state<='0';
     end if;
    end if;
    
    if(begin_input_button='1' and input_state='1') then
     if(already_begin_input='0') then
      already_begin_input<='1';
      input_state<='0';
      waiting_state<='1';
      input_place<="11";
      input_times<="000";    
      input_code_0<="0000000000";
      input_code_1<="0000000000";
      input_code_2<="0000000000";
      input_code_3<="0000000000";
     end if;    
    end if;
    
    if(led_place="1000" and led_show='1') then
     led_show<='0';
    end if;
    
    if(enter_button='0')then
     already_enter<='0';
    end if;
    
    if(input_state='1' and lock_state='1') then
     if(enter_button='1') then
      if(already_enter='0') then
       already_enter<='1';
       input_times<="000";
       input_place<="11";
       input_code_0<="0000000000";
       input_code_1<="0000000000";
       input_code_2<="0000000000";
       input_code_3<="0000000000";
       if(input_code_0=true_code_0 and input_code_1=true_code_1 and input_code_2=true_code_2 and input_code_3=true_code_3) then
        lock_state<='0';
        input_state<='0';
        unreset_state<='1';
        led_show<='1';
        once_wrong<="00";
       elsif(once_wrong="10") then
        warning_state<='1';
        input_state<='0';
        once_wrong<="00";
       else
        once_wrong<=once_wrong+1;
       end if;
      end if;
     end if;
    elsif(reset_state='1' and lock_state='0') then
     if(enter_button='1') then
      if(already_enter='0') then
       already_enter<='1';
       input_times<="000";
       input_place<="11";
       true_code_0<=input_code_0;
       true_code_1<=input_code_1;
       true_code_2<=input_code_2;
       true_code_3<=input_code_3;
       reset_state<='0';
       unreset_state<='1';
       input_code_0<="0000000000";
       input_code_1<="0000000000";
       input_code_2<="0000000000";
       input_code_3<="0000000000";
      end if;
     end if;
    end if;
    
    if(manage_button='0')then
     already_manage<='0';
    end if;
    
    if(manage_button='1' and lock_state='1' and warning_state='1') then
     if(already_manage='0') then
      already_manage<='1';
      warning_state<='0';
      waiting_state<='1';
     end if;
    end if;
    
    if(back_button='0')then
     already_back<='0';
    end if;
    
    if(back_button='1' and lock_state='0' and unreset_state='1' and reset_state='0') then
     if(already_back='0') then
      already_back<='1';
      lock_state<='1';
      unreset_state<='0';
      waiting_state<='1';
      led_show<='1';
     end if;
    end if;
    
    if(cnt_10ms<="1111010000100100000") then
     cnt_10ms<=cnt_10ms+1;
     clk_10ms<='1';
    elsif(cnt_10ms="11110100001000111111") then
     cnt_10ms<="00000000000000000000";
     clk_10ms<='0';
    else
     cnt_10ms<=cnt_10ms+1;
     clk_10ms<='0';
    end if;

    if(cnt_1ms<="1100001101010000") then
     cnt_1ms<=cnt_1ms+1;
     clk_1ms<='1';
    elsif(cnt_1ms="11000011010011111") then
     cnt_1ms<="00000000000000000";
     clk_1ms<='0';
    else
     cnt_1ms<=cnt_1ms+1;
     clk_1ms<='0';
    end if;
    
    enter_button<=enter_1 or enter_2 or enter_3;
    begin_input_button<=begin_input_1 or begin_input_2 or begin_input_3;
    delete_button<=delete_1 or delete_2 or delete_3;
    reset_button<=reset_1 or reset_2 or reset_3;
    back_button<=back_1 or back_2 or back_3;
    input_button<=input_1 or input_2 or input_3;
    manage_button<=manage_1 or manage_2 or manage_3;
    reset_all_button<=reset_all_1 or reset_all_2 or reset_all_3;    
    
   end if;
   
  end process;
  
  process(clk_10ms)
  begin
   if(clk_10ms'event and clk_10ms='1') then
    enter_1<=enter;
    enter_2<=enter_1;
    enter_3<=enter_2;
    begin_input_1<=begin_input;
    begin_input_2<=begin_input_1;
    begin_input_3<=begin_input_2;
    delete_1<=delete;
    delete_2<=delete_1;
    delete_3<=delete_2;
    back_1<=back;
    back_2<=back_1;
    back_3<=back_2;
    reset_1<=reset;
    reset_2<=reset_1;
    reset_3<=reset_2;
    input_1<=input;
    input_2<=input_1;
    input_3<=input_2;
    manage_1<=manage;
    manage_2<=manage_1;
    manage_3<=manage_2;
    reset_all_1<=reset_all;
    reset_all_2<=reset_all_1;
    reset_all_3<=reset_all_2;
   end if;
  end process;
  
  process(clk_125ms)
  begin
  
   if(clk_125ms'event and clk_125ms='1') then
    if(warning_state='1') then
     if(led="000000000") then
      led<="1111111111111111";
     else
      led<="0000000000000000";
     end if;
    end if;
    
    if(led_place="1001" and led_show='0') then
     if(lock_state='0') then
      led<="0000000000000000";
     elsif(lock_state='1' and warning_state='0') then
      led<="1111111111111111";
     end if;
    end if;
    
    if(led_show='0') then
     led_place<="1001";
    end if;
    
    if(led_show='1' and led_place="1001") then
     led_place<="0000";
    end if;
    
    if(led_place<"1001" and led_show='1') then
      if(lock_state='1') then
       case led_place is
       when "0000" => led<="0000000110000000";led_place<=led_place+1;
       when "0001" => led<="0000001111000000";led_place<=led_place+1;
       when "0010" => led<="0000011111100000";led_place<=led_place+1;
       when "0011" => led<="0000111111110000";led_place<=led_place+1;
       when "0100" => led<="0001111111111000";led_place<=led_place+1;
       when "0101" => led<="0011111111111100";led_place<=led_place+1;
       when "0110" => led<="0111111111111110";led_place<=led_place+1;
       when others => led<="1111111111111111";led_place<=led_place+1;
       end case;
      elsif(lock_state='0') then
       case led_place is
       when "0000" => led<="1111111001111111";led_place<=led_place+1;
       when "0001" => led<="1111110000111111";led_place<=led_place+1;
       when "0010" => led<="1111100000011111";led_place<=led_place+1;
       when "0011" => led<="1111000000001111";led_place<=led_place+1;
       when "0100" => led<="1110000000000111";led_place<=led_place+1;
       when "0101" => led<="1100000000000011";led_place<=led_place+1;
       when "0110" => led<="1000000000000001";led_place<=led_place+1;
       when others => led<="0000000000000000";led_place<=led_place+1;
       end case;   
      end if;
     end if;
     
   end if;
  end process;
  
  process(clk_1ms)
  variable storage:std_logic_vector(9 downto 0);
  begin
   if(clk_1ms'event and clk_1ms='1') then
    
     case disp_place is
     when "11111110" => disp_place<="11111101"; if(input_state='1' or reset_state='1') then storage:=input_code_1; else storage:="1111111111"; end if;
     when "11111101" => disp_place<="11111011"; if(input_state='1' or reset_state='1') then storage:=input_code_2; else storage:="1111111111"; end if;
     when "11111011" => disp_place<="11110111"; if(input_state='1' or reset_state='1') then storage:=input_code_3; else storage:="1111111111"; end if;
     when "11110111" => disp_place<="11101111"; if(lock_state='1') then storage:="1000000001"; else storage:="0100000001"; end if;
     when "11101111" => disp_place<="11011111"; if(lock_state='1') then storage:="1000000010"; else storage:="0100000010"; end if;
     when "11011111" => disp_place<="10111111"; if(lock_state='1') then storage:="1000000100"; else storage:="0100000100"; end if;
     when "10111111" => disp_place<="01111111"; if(lock_state='1') then storage:="1000001000"; else storage:="0100001000"; end if;
     when others       => disp_place<="11111110"; if(input_state='1' or reset_state='1') then storage:=input_code_0; else storage:="1111111111"; end if;
     end case;
     case storage is
     when "0000000001" => disp_number<=disp_0;
     when "0000000010" => disp_number<=disp_1;
     when "0000000100" => disp_number<=disp_2;
     when "0000001000" => disp_number<=disp_3;
     when "0000010000" => disp_number<=disp_4;
     when "0000100000" => disp_number<=disp_5;
     when "0001000000" => disp_number<=disp_6;
     when "0010000000" => disp_number<=disp_7;
     when "0100000000" => disp_number<=disp_8;
     when "1000000000" => disp_number<=disp_9;
     when "1111111111" => disp_number<="1111111";
     when "1000000010" => disp_number<=lock_1;
     when "1000000100" => disp_number<=lock_2;
     when "1000001000" => disp_number<=lock_3;
     when "1000000001" => disp_number<=lock_0;
     when "0100000010" => disp_number<=open_1;
     when "0100000100" => disp_number<=open_2;
     when "0100001000" => disp_number<=open_3;
     when "0100000001" => disp_number<=open_0;     
     when others         => disp_number<=disp_void;
     end case;
   end if;
  end process;
  
end Behavioral;
