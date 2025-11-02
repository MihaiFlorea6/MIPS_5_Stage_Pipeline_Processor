----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/22/2025 12:29:54 PM
-- Design Name: 
-- Module Name: MEM_MIPS - Behavioral
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
use Ieee.Std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MEM_MIPS is
   Port (
   memWrite: in std_logic;
   aluResIn: in std_logic_vector(31 downto 0);
   rd2: in std_logic_vector(31 downto 0);
   clk: in std_logic;
   en: in std_logic;
   memData: inout std_logic_vector(31 downto 0);
   aluResOut: inout std_logic_vector(31 downto 0));
end MEM_MIPS;

architecture Behavioral of MEM_MIPS is
type memory is array (0 to 63) of std_logic_Vector(31 downto 0);
signal mem: memory :=(others=>X"00000000");
begin
 process(clk)
 begin
  if clk='1' and clk'event then
    if en='1' and memWrite='1' then
     mem(conv_integer(aluResIn(7 downto 2))) <= rd2;
   end if;
  end if;
 end process;

 memData<= mem(conv_integer(aluResIn(7 downto 2)));
 aluResOut<= aluResIn;
 
end Behavioral;
