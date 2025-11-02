----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/21/2025 10:46:30 PM
-- Design Name: 
-- Module Name: UnitControl - Behavioral
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

entity UnitControl is
  Port (
  instr: in std_logic_vector(5 downto 0);
  regDst: inout std_logic;
  extOp: inout std_logic;
  aluSrc: inout std_logic;
  branch: inout std_logic;
  br_not: inout std_logic;
  jump: inout std_logic;
  memWrite: inout std_logic;
  memToReg: inout std_logic;
  regWrite: inout std_logic;
  aluOp: inout std_logic_vector(1 downto 0)
   );
end UnitControl;

architecture Behavioral of UnitControl is

begin
 regDst<='0'; extOp<='0'; aluSrc<='0'; branch<='0'; br_not<='0';
 jump<='0'; memWrite<='0'; memToReg<='0'; regWrite<='0'; aluOp<="00";
 
 process(instr)
  begin
  case instr is
    when "000000" => regDst<='1'; regWrite<='1'; aluOp<="11";
    when "001000" => extOp<='1'; aluSrc<='1'; regWrite<='1'; aluOp<="01";
    when "100011" => extOp<='1'; aluSrc<='1'; memToReg<='1'; regWrite<='1'; aluOp<="01";
    when "101011" => extOp<='1'; aluSrc<='1'; memWrite<='1'; aluOp<="01";
    when "000100" => extOp<='1'; branch<='1'; aluOp<="10";
    when "000101" => extOp<='1'; aluOp<="10"; br_not<='1';
    when "000010" => jump<='1';
    when others =>
 end case;
 end process;
 
end Behavioral;
