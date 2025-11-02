----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/22/2025 02:50:29 PM
-- Design Name: 
-- Module Name: MIPS_SingleCycle - Behavioral
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

entity MIPS_PIPELINE is
  Port (
  btn0: in std_logic;
  btn1: in std_logic;
  clk: in std_logic;
  switch: in std_logic_vector(2 downto 0);
  led: out std_logic_vector(15 downto 0);
  an: out std_logic_vector(7 downto 0);
  cat: out std_logic_vector(6 downto 0)
   );
end MIPS_PIPELINE;

architecture Behavioral of MIPS_PIPELINE is
component MPG is
  Port ( 
  btn: in std_logic;
  clk: in std_logic;
  enable: inout std_logic);
end component;

component InstructionFetch is
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
end component;

component UnitControl is
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
  aluOp: inout std_logic_vector(1 downto 0));
end component;

component InstructionDecode is
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
end component;

component AluCtrl is
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
end component;

component MEM_MIPS is
   Port (
   memWrite: in std_logic;
   aluResIn: in std_logic_vector(31 downto 0);
   rd2: in std_logic_vector(31 downto 0);
   clk: in std_logic;
   en: in std_logic;
   memData: inout std_logic_vector(31 downto 0);
   aluResOut: inout std_logic_vector(31 downto 0));
end component;

component WriteBack is
  Port (
  memToReg: in std_logic;
  aluResOut: in std_logic_vector(31 downto 0);
  memData: in std_logic_vector(31 downto 0);
  writeBack: inout std_logic_vector(31 downto 0) );
end component;

component JumpUnit is
   Port ( 
    instr: in std_logic_vector(25 downto 0);
    pc_next: in std_logic_vector(3 downto 0);
    jumpAddress: inout std_logic_vector(31 downto 0) );
end component;

component BranchUnit is
   Port (
    branch: in std_logic;
    br_not: in std_logic;
    zero: in std_logic;
    pcSrc: inout std_logic
    );
end component;

component SSD is
 Port ( 
 clk: in std_logic;
 an: out std_logic_vector(7 downto 0);
 digits: in std_logic_vector(31 downto 0):=x"00000000";
 cat: out std_logic_vector(6 downto 0));
end component;

signal en: std_logic;
signal instr: std_logic_vector(31 downto 0);
signal instrP: std_logic_vector(31 downto 0);
signal pc_next: std_logic_vector(31 downto 0);
signal pc_nextP: std_logic_vector(31 downto 0);
signal regDst: std_logic;
signal regDstP: std_logic;
signal extOp: std_logic;
signal aluSrc: std_logic;
signal aluSrcP: std_logic;
signal branch: std_logic;
signal branchP: std_logic;
signal br_not: std_logic;
signal br_notP: std_logic;
signal jump: std_logic;
signal aluOp: std_logic_vector(1 downto 0);
signal aluOpP: std_logic_vector(1 downto 0);
signal memWrite: std_logic;
signal memWriteP: std_logic;
signal memToReg: std_logic;
signal memToRegP: std_logic;
signal regWrite: std_logic;
signal regWriteP: std_logic;
signal write_back: std_logic_Vector(31 downto 0);
signal rd1: std_logic_vector(31 downto 0);
signal rd1P: std_logic_vector(31 downto 0);
signal rd2: std_logic_vector(31 downto 0);
signal rd2P: std_logic_vector(31 downto 0);
signal rt: std_logic_vector(4 downto 0);
signal rtP: std_logic_vector(4 downto 0);
signal rd: std_logic_vector(4 downto 0);
signal rdP: std_logic_vector(4 downto 0);
signal extImm: std_logic_vector(31 downto 0);
signal extImmP: std_logic_vector(31 downto 0);
signal func: std_logic_vector(5 downto 0);
signal funcP: std_logic_vector(5 downto 0);
signal sa: std_logic_Vector(4 downto 0);
signal saP: std_logic_Vector(4 downto 0);
signal zero: std_logic;
signal zeroP: std_logic;
signal branchAddress: std_logic_vector(31 downto 0);
signal branchAddressP: std_logic_vector(31 downto 0);
signal aluRes: std_logic_vector(31 downto 0);
signal aluResP: std_logic_vector(31 downto 0);
signal aluResOut: std_logic_Vector(31 downto 0);
signal aluResOutP: std_logic_Vector(31 downto 0);
signal rWa: std_logic_vector(4 downto 0);
signal rWaP: std_logic_vector(4 downto 0);
signal memData: std_logic_vector(31 downto 0);
signal memDataP: std_logic_vector(31 downto 0);
signal jumpAddr: std_logic_vector(31 downto 0);
signal pcSrc: std_logic;
signal digits: std_logic_Vector(31 downto 0);

begin
monopulse10: MPG port map (btn0, clk,en);

instructionFetch1: InstructionFetch port map (jumpAddr, branchAddressP, jump, clk, pcSrc, btn1, en, pc_next, instr);
   process(clk)--IF/ID
   begin
    if clk='1' and clk'event then
      if en='1' then 
         instrP<=instr;
         pc_nextP<=pc_next;
         
      end if;
     end if;
   end process;


unitateSmnControl: UnitControl port map(instrP(31 downto 26), regDst, extOp, aluSrc, branch, br_not, jump, memWrite, memToReg, regWrite, aluOp);
instructionDecoder1: InstructionDecode port map(instrP(25 downto 0), write_back, clk, regWriteP, en, extOp, rWaP, rd1, rd2, extImm, func, sa, rt, rd );

  process(clk)--ID/EX
  begin
   if clk='1' and clk'event then
     if en='1' then
     regDstP<=regDst;
     aluSrcP<=aluSrc;
     branchP<=branch;
     br_notP<=br_not;
     memWriteP<=memWrite;
     memToRegP<= memToReg;
     regWriteP<=regWrite;
     aluOpP<=aluOp;
     rd1P<= rd1;
     rd2P<= rd2;
     extImmP<=extImm;
     funcP<= func;
     saP<= sa;
     rtP<= rt;
     rdP<= rd;
     
    end if;
   end if;
  end process;

excution1: AluCtrl port map(rd1P, rd2P, extImmP, aluSrcP, saP, funcP, aluOpP, pc_nextP, regDstP , rtP, rdP,  aluRes, branchAddress, zero, rWa);
   
   process(clk)--EX/MEM
     begin
    if clk='1' and clk'event then   
       if en='1' then
       
      aluResP<=aluRes;
      branchAddressP<= branchAddress;
      zeroP<=zero;
      rWaP<=rWa;
      
    end if;    
   end if;
 end process;
   
   
   
memory1: MEM_MIPS port map(memWriteP, aluResP, rd2P, clk, en, memData, aluResOut);

   process(clk)--MEM/WB
   begin
     if clk='1' and clk'event then
        if en='1' then
        
     memDataP<= memData;
     aluResOutP<=aluResOut;
   
   end if;
   end if;
   end process;


writeBackUnit: WriteBack port map(memToRegP, aluResOutP, memDataP, write_back);
jumpUnit1: JumpUnit port map(instrP(25 downto 0), pc_nextP(31 downto 28), jumpAddr);
branchUnit1: BranchUnit port map(branchP, br_notP, zeroP, pcSrc);

  

 process(switch)
 begin
   case switch(2 downto 0) is
    when "000" => digits<= instrP;
    when "001" => digits<= pc_nextP;
    when "010" => digits<= rd1P;
    when "011" => digits<= rd2P;
    when "100" => digits<= extImmP;
    when "101" => digits<= aluResP;
    when "110" => digits<= memDataP;
    when "111" => digits<= write_back;
    when others=> 

 end case;
 end process;
 
sevensegment1: SSD port map (clk, an, digits, cat);
led(10 downto 0) <= aluOp & regDst & extOp & aluSrc & branch & br_not & jump & memWrite & memToReg & regWrite;

end Behavioral;
