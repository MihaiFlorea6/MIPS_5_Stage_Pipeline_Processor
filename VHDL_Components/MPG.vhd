----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/28/2025 10:58:19 AM
-- Design Name: 
-- Module Name: MPG - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MPG is
  Port ( 
  btn: in std_logic;
  clk: in std_logic;
  enable: inout std_logic);
end MPG;

architecture Behavioral of MPG is
signal count: std_logic_vector(17 downto 0):= (others=> '0');
signal q1: std_logic;
signal q2: std_logic;
signal q3: std_logic;
begin

enable<= q2 and (not(q3));

 process(clk)
 begin
   if clk='1' and clk'event then
    count<= count +1;
  
 end if;
 end process;

 process(clk)
 begin
   if clk='1' and clk'event then
    if count(17 downto 0) = "111111111111111111" then
     q1<= btn;
     end if;
   end if;
 end process;
  
  process(clk)
  begin
    if clk='1' and clk'event then
     q2<=q1;
     q3<=q2;
  end if;
  end process;
  
end Behavioral;
