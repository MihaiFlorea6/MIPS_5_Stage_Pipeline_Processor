----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/11/2025 10:34:25 AM
-- Design Name: 
-- Module Name: AluCtrl - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity AluCtrl is
Port (
  rd1: in std_logic_vector(31 downto 0);
  rd2: in std_logic_vector(31 downto 0);
  extImm: in std_logic_vector(31 downto 0);
  aluSrc: in std_logic;
  sa: in std_logic_Vector(4 downto 0);
  func: in std_logic_vector(5 downto 0);
  aluOp:in std_logic_vector(1 downto 0);
  pc_next: in std_logic_Vector(31 downto 0);
  RegDst: in std_logic;
  rt: in std_logic_vector(4 downto 0);
  rd: in std_logic_vector(4 downto 0);
  aluRes: out std_logic_vector(31 downto 0);
  branch_addr: inout std_logic_vector(31 downto 0);
  zero_beq: inout std_logic:= '0';
  rWa: out std_logic_vector(4 downto 0));
  
end AluCtrl;

architecture Behavioral of AluCtrl is
signal aluCtrl: std_logic_vector(2 downto 0);
signal aluRes1: std_logic_vector(31 downto 0);

begin
  process(aluOp, func)
  begin
    case aluOp is
     when "11" =>
      case func is
        when "100000" => aluCtrl<= "000";
        when "100010" => aluCtrl<= "001";
        when "100101" => aluCtrl<= "010";
        when "100100" => aluCtrl<= "100";
        when "000010" => aluCtrl<= "011";
        when others=> aluCtrl<= (others=>'X');
   end case;
   
     when "01" => aluCtrl<= "000";
     when "10" => aluCtrl<= "001";
     when others => aluCtrl<= (others=> 'X');
  end case;
  end process;
  
  process(aluCtrl,aluSrc, rd1, sa)
  begin
   if aluSrc='0' then
    case aluCtrl is
     when "000" => aluRes1 <= rd1 + rd2;
     when "001" => aluRes1 <= rd1 - rd2;
     when "010" => aluRes1 <= rd1 or rd2;
     when "100" => aluRes1 <= rd1 and rd2;
     when "011" => aluRes1 <= to_stdlogicvector(to_bitvector(rd2) srl conv_integer(sa));
     when others=> 
     
    end case;
    
   else
     case aluCtrl is
      when "000" => aluRes1 <= rd1 + extImm;
      when "001" => aluRes1 <= rd1 - extImm;
      when others=> 
     end case;
     
   end if;
  end process; 
  
  aluRes<= aluRes1;
  
  zero_beq<='1' when aluRes1=x"00000000";
  
  
  branch_addr<= (extImm(29 downto 0) & "00" ) + pc_next;
   
  rWa<= rd when RegDst='1' else rt; 
   
end Behavioral;
