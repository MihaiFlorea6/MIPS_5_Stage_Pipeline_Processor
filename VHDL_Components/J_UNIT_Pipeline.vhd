----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/22/2025 01:20:21 PM
-- Design Name: 
-- Module Name: JumpUnit - Behavioral
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

entity JumpUnit is
   Port ( 
    instr: in std_logic_vector(25 downto 0);
    pc_next: in std_logic_vector(3 downto 0);
    jumpAddress: inout std_logic_vector(31 downto 0) );
end JumpUnit;

architecture Behavioral of JumpUnit is

begin
  jumpAddress<= pc_next & instr & "00";

end Behavioral;
