----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/28/2025 10:29:27 AM
-- Design Name: 
-- Module Name: InstructionFetch - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity InstructionFetch is
 Port ( 
 jump_address: in std_logic_vector(31 downto 0);
 branch_address: in std_logic_vector(31 downto 0);
 jump:in std_logic;
 clk: in std_logic;
 pcsrc: in std_logic;
 rst: in std_logic;
 en: in std_logic;
 pc_next: inout std_logic_vector(31 downto 0);
 instruction: inout std_logic_vector(31 downto 0));
end InstructionFetch;

architecture Behavioral of InstructionFetch is
signal pc: std_logic_vector(31 downto 0):=x"00000000";
signal cnt: std_logic_vector(31 downto 0):=x"00000000";
signal next_address: stD_logic_vector(31 downto 0);
signal mux1: std_logic_vector(31 downto 0);
type ROM is array (0 to 63) of std_logic_vector(31 downto 0);
signal memROM1: ROM:= (
   b"000000_00000_00000_00001_00000_100000",--00000820/0/ADD $1, $0, $0/  initializeaza R1 cu 0
   b"001000_00000_00100_0000000000000100",--20040004/1/ADDI $4, $0, 4/  initializeaza R4 cu 4
   b"000000_00000_00000_00010_00000_100000",--00001020/2/ADD $2, $0, $0/  initializeaza R2 cu 0
   b"000000_00000_00000_01000_00000_100000",--00004020/3/ADD $8, $0, $0/ intiliazeaza R8 cu 0
   b"001000_00000_01010_0000000000000001",--200A0001/4/ADDI $10, $0, 1/ intializeaza R10 cu 1
   b"000100_00001_00100_0000000000011001",--10240019/5/BEQ $1, $4, 25/ Face salt peste 25 instructiuni
   b"000000_00000_00000_00000_00000_000000", --NOOP/6/
   b"000000_00000_00000_00000_00000_000000", --NOOP/7/
   b"000000_00000_00000_00000_00000_000000", --NOOP/8
   b"100011_00010_00101_0000000000000000",--8C450000/9/LW $5, 0($2)/ In R5 se aduce elementul din sir de la adresa 0
   b"000010_00000000000000000000010001",--8000011/10/J 17/ jump la instructiunea 17(verifica daca nr din sir e putere a lui2)
   b"000000_00000_00000_00000_00000_000000", --NOOP/11/
   b"000000_01000_00101_01000_00000_100000",--01054020/12/ADD $8, $8, $5/ aduna la R8 valoarea din R5(face suma elementelor)
   b"001000_00010_00010_0000000000000100",--20420004/13/ADDI $2, $2, 4/ aduna la R2 valoarea 4(merge la urmatoarea locatie de memorie)
   b"001000_00001_00001_0000000000000001",--20210001/14/ADDI $1, $1, 1/  aduna la R1 valoarea 1(incrementam iteratia)
   b"000010_00000000000000000000000101",--08000005/15/J 5/ jump la instructiunea 5(se revine in bucla)
   b"000000_00000_00000_00000_00000_000000", --NOOP/16
   b"000000_00101_00000_00111_00000_100101",--00A03825/17/ OR $7, $5, $0/ or intre R5 si R0 => se salv in R7(copiem valoarea din R5 in R7)
   b"000000_00101_00000_01001_00000_100101",--00A04825/18/ OR $9, $5, $0/ or intre R5 si R0 => se salv in R9(copiem valoarea din R5 in R9)
   b"000000_00000_00000_00000_00000_000000", --NOOP/19
   b"000000_00000_00000_00000_00000_000000", --NOOP/20
   b"000000_01001_01010_01001_00000_100010",--012A4822/21/ SUB $9, $9, $10/ scadem din R9 valoarea din R10( adica 1)
   b"000000_00000_00000_00000_00000_000000", --NOOP/22
   b"000000_00000_00000_00000_00000_000000", --NOOP/23
   b"000000_00111_01001_00111_00000_100100",--00E93824/24/ AND $7, $7, $9/ and intre R7 si R9
   b"000100_00111_00000_1111111111110100",--10E0FFF4/25/ BEQ $7, $0, -12/ daca rezultatul de la and=0, sare 12 instructiuni in spate(nr e putere a lui2)
   b"000000_00000_00000_00000_00000_000000", --NOOP/26
   b"000000_00000_00000_00000_00000_000000", --NOOP/27
   b"000000_00000_00000_00000_00000_000000", --NOOP/28
   b"000010_00000000000000000000111110",--800003E/29/ J 46/ sare la instructiunea 46(adica la end)
   b"000000_00000_00000_00000_00000_000000", --NOOP/30
   b"000000_00000_01000_01000_00010_000010",--00084082/31/ SRL $8, $8, 2/ shifteaza valoarea din R8 cu 2 pozitii( imparte suma la 4 = calculeaza media)
   b"000000_00000_00000_00000_00000_000000", --NOOP/32
   b"000000_00000_00000_00000_00000_000000", --NOOP/33
   b"000000_01000_00000_01100_00000_100101",--01006025/34/ OR $12, $8, $0/ or intre R8 si R0=>salv in R12(copiem val din R8 in R12)
   b"000000_00000_00000_00000_00000_000000", --NOOP/35
   b"000000_00000_00000_00000_00000_000000", --NOOP/36
   b"000000_01100_01010_01100_00000_100010",--018A6022/37/ SUB $12, $12, $10/ scadem din R12 valoarea din R10( adica 1)
   b"000000_00000_00000_00000_00000_000000", --NOOP/38
   b"000000_00000_00000_00000_00000_000000", --NOOP/39
   b"000000_01100_01000_01100_00000_100100",--01886024/40/ AND $12, $12, $8/ and intre R12 si R8
   b"000101_01100_00000_0000000000000100",--15800004/41/ BNE $12, $0, 4/ daca rezultatul de la and nu este 0, media nu e putere a lui 2 si sare 4 instructiuni la final
   b"000000_00000_00000_00000_00000_000000", --NOOP/42
   b"000000_00000_00000_00000_00000_000000", --NOOP/43
   b"000000_00000_00000_00000_00000_000000", --NOOP/44
   b"101011_00000_01000_0000000000010000",--AC080010/45/ SW $8, 16($0)/  se salveaza media la adresa 16
   b"101011_00000_00000_0000000000010000",--AC000010/46/ SW $0, 16($0)/  se salveaza 0 la adresa 16
   
   others=>x"00000000");
begin

   process(clk,rst)
    begin
      if rst='1' then 
        pc<= (others => '0');
      elsif clk='1' and clk'event then
        if en='1' then
          pc<= next_address;
        end if;
      
      end if;
   end process;
   
   instruction<= memROM1(conv_integer(pc(6 downto 2)));
   
   cnt<= pc+4;
   pc_next<= cnt;
   
   mux1<= branch_address when pcsrc='1' else cnt;
   
   next_address<= jump_address when jump='1' else mux1;
   
end Behavioral;
