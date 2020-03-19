----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2017/09/16 09:58:23
-- Design Name: 
-- Module Name: simu - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity simu is
--  Port ( );
end simu;

architecture Behavioral of simu is

begin
    -- Component Declaration for the Unit Under Test (UUT)

COMPONENT TEST_CNT2
PORT(
clk:in std_logic:='0';
reset:in std_logic:='0';
input:in std_logic_vector(9 downto 0);
begin_input:in std_logic:='0';
enter:in std_logic:='0';
manage:in std_logic:='0';
delete:in std_logic:='0';
back:in std_logic:='0';
led:buffer std_logic_vector(15 downto 0);
reset_all:in std_logic:='0';
disp_place:buffer std_logic_vector(7 downto 0):="11111111";
disp_number:out std_logic_vector(6 downto 0):="1110111"
    );
END COMPONENT;


signal clk_10s:std_logic:='0';
signal clk_20s:std_logic:='0';
signal clk_500ms:std_logic:='0';
signal clk_5ms:std_logic:='0';
signal clk_1ms:std_logic:='0';
signal cnt_10s:std_logic_vector(26 downto 0):="000000000000000000000000000";
signal cnt_20s:std_logic_vector(26 downto 0):="000000000000000000000000000";
signal cnt_500ms:std_logic_vector(26 downto 0):="000000000000000000000000000";
signal cnt_5ms:std_logic_vector(18 downto 0):="0000000000000000000";
signal cnt_1ms:std_logic_vector(16 downto 0):="00000000000000000";
signal true_code_0:std_logic_vector(9 downto 0):="0000000000";
signal true_code_1:std_logic_vector(9 downto 0):="0000000000";
signal true_code_2:std_logic_vector(9 downto 0):="0000000000";
signal true_code_3:std_logic_vector(9 downto 0):="0000000000";
signal input_code_0:std_logic_vector(9 downto 0):="0000000000";
signal input_code_1:std_logic_vector(9 downto 0):="0000000000";
signal input_code_2:std_logic_vector(9 downto 0):="0000000000";
signal input_code_3:std_logic_vector(9 downto 0):="0000000000";
signal reset_state:std_logic:='0';
signal input_state:std_logic:='0';
signal warning_state:std_logic:='0';
signal unreset_state:std_logic:='0';
signal waiting_state:std_logic:='0';
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
signal reset_button_once:std_logic:='0';
signal enter_button_once:std_logic:='0';
signal back_button_once:std_logic:='0';
signal delete_button_once:std_logic:='0';
signal begin_input_button_once:std_logic:='0';
signal reset_unbutton_once:std_logic:='0';
signal enter_unbutton_once:std_logic:='0';
signal back_unbutton_once:std_logic:='0';
signal delete_unbutton_once:std_logic:='0';
signal begin_input_unbutton_once:std_logic:='0';
signal input_place:std_logic_vector(1 downto 0):="11";
signal led_place:std_logic_vector(3 downto 0):="1000";
signal once_wrong:std_logic_vector(1 downto 0):="00";
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

-- Clock period definitions
constant clk_period : time := 10 ns;

BEGIN

-- Instantiate the Unit Under Test (UUT)
uut: TEST_CNT2 PORT MAP (

      clk => clk,
      reset => reset,
      input => input,
      begin_input => begin_input,
      enter => enter,
      manage => manage,
      delete => delete,
      back => back,
      led => led,
      reset_all => reset_all,
      disp_place => disp_place,
      disp_number => disp_number,
      clk_10s => clk_10s,
      clk_20s => clk_20s,
      clk_500ms => clk_500ms,
      clk_5ms => clk_5ms,
      clk_1ms => clk_1ms,
      cnt_10s => cnt_10s,
      cnt_20s => cnt_20s,
      cnt_500ms => cnt_500ms,
      cnt_5ms => cnt_5ms,
      cnt_1ms => cnt_1ms,
      true_code_0 => true_code_0,
      true_code_1 => true_code_1,
      true_code_2 => true_code_2,
      true_code_3 => true_code_3, 
      input_code_0 => input_code_0,
      input_code_1 => input_code_1,
      input_code_2 => input_code_2,
      input_code_3 => input_code_3,
      reset_state => reset_state,
      input_state => input_state,
      warning_state => warning_state,
      unreset_state => unreset_state,
      waiting_state => waiting_state,
      lock_state => lock_state,
      already_input => already_input,
      already_reset_all => already_reset_all,
      already_manage => already_manage,
      already_reset => already_reset,
      already_enter => already_enter
      already_back => already_back,
      already_delete => already_delete,
      already_begin_input => already_begin_input,
      reset_button => reset_button,,
      enter_button => enter_button,
      back_button => back_button,
      delete_button => delete_button,
      begin_input_button => begin_input_button,
      reset_button_once => reset_button_once,
      enter_button_once => enter_button_once,
      back_button_once => back_button_once,
      delete_button_once => delete_button_once,
      begin_input_button_once => begin_input_button_once,
      reset_unbutton_once => reset_unbutton_once,
      enter_unbutton_once => enter_unbutton_once,
      back_unbutton_once => back_unbutton_once,
      delete_unbutton_once => delete_unbutton_once,
      begin_input_unbutton_once => begin_input_unbutton_once,
      input_place => input_place,
      led_place => led_place,
      once_wrong => once_wrong
      
    );

-- Clock process definitions
clk_process :process
begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
end process;


-- Stimulus process
stim_proc: process
begin        
  -- hold reset state for 100 ns.
  wait for 100 ns;    
  reset<='1';
    wait for 200 ns;
    reset<='0';
    
  wait for clk_period*10;

  -- insert stimulus here 

  wait;
end process;


end Behavioral;
