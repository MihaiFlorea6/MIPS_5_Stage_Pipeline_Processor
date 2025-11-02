----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/04/2025 10:40:58 AM
-- Design Name: 
-- Module Name: InstructionDecode - Behavioral
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
--use IEEE.Numeric_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity InstructionDecode is
   Port (
   instr: in std_logic_vector(25 downto 0);
   wd: in std_logic_vector(31 downto 0);
   clk: in std_logic;
   regWrite:in std_logic;
   en:in std_logic;
   extOp:in std_logic;
   wa: in std_logic_vector(4 downto 0);
   rd1: out std_logic_vector(31 downto 0);
   rd2: out std_logic_vector(31 downto 0);
   extImm: out std_logic_vector(31 downto 0);
   funct: out std_logic_vector(5 downto 0);
   sa: out std_logic_vector(4 downto 0);
   rt: out std_logic_vector(4 downto 0);
   rd: out std_logic_vector(4 downto 0));
   
end InstructionDecode;

architecture Behavioral of InstructionDecode is
type reg_file is array(0 to 31) of std_logic_vector(31 downto 0);
signal reg: reg_file :=(others=>x"00000000");


begin

  rd1<=reg(conv_integer( instr(25 downto 21)));
  rd2<=reg(conv_integer(instr(20 downto 16)));
   
   
  process(clk)
  begin
    if clk='0' and clk'event then
      if en='1' and regWrite='1' then
         reg(conv_integer(wa))<=wd;
     end if;
    end if;
  end process;
  
  process(extOp, instr)
  begin
    if extOp='0' then
     extImm<= x"0000" & instr(15 downto 0);
    elsif instr(15) ='1' then
       extImm<= x"FFFF" & instr(15 downto 0);
      
      else
       extImm<=x"0000" & instr(15 downto 0);
      end if; 
  end process;
  
  funct<=instr(5 downto 0);
  sa<= instr(10 downto 6);
  rt<= instr(20 downto 16);
  rd<= instr(15 downto 11);
  
end Behavioral;
