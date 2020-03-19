----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2019/08/27 22:30:03
-- Design Name: 
-- Module Name: test_bench - Behavioral
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

entity test_bench is
end test_bench;

architecture Behavioral of test_bench is
component test port(
    led: out std_logic;
    switch: in std_logic);
end component;
signal led: std_logic:='0';
signal switch: std_logic:='0';    
begin
dut:test port map(
    led=>led,switch=>switch
    );
process
begin
    switch<='1';
    wait for 10ms;
    switch<='0';
    wait for 10ms;
end process;
end Behavioral;
