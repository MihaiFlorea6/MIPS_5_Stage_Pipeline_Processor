----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/02/2025 07:07:37 PM
-- Design Name: 
-- Module Name: SSD - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SSD is
 Port ( 
 clk: in std_logic;
 an: out std_logic_vector(7 downto 0);
 digits: in std_logic_vector(31 downto 0);
 cat: out std_logic_vector(6 downto 0));
end SSD;

architecture Behavioral of SSD is
signal sel: std_logic_vector(2 downto 0);
signal count: std_logic_vector(16 downto 0):= (others=> '0');
signal hex: std_logic_vector(3 downto 0);

begin
   process(clk)
   begin
    if clk='1' and clk'event then
      count<= count+1;
    end if;
   end process;
   
 sel<= count(16 downto 14);
 
 process(digits, sel)
 begin
    case sel is
      when "000" => hex<= digits(3 downto 0);
      when "001" => hex<= digits(7 downto 4);
      when "010" => hex<= digits(11 downto 8);
      when "011" => hex<= digits(15 downto 12);
      when "100" => hex<= digits(19 downto 16);
      when "101" => hex<= digits(23 downto 20);
      when "110" => hex<= digits(27 downto 24);
      when "111" => hex<= digits(31 downto 28);
      when others=> hex<= (others => 'X');
 
 end case;
 end process;
 
 process(hex)
 begin
   case hex is
   when "0000" => cat<="1000000";
   when "0001" => cat<="1111001";
   when "0010" => cat<="0100100";
   when "0011" => cat<="0110000";
   when "0100" => cat<="0011001";
   when "0101" => cat<="0010010";
   when "0110" => cat<="0000010";
   when "0111" => cat<="1111000";
   when "1000" => cat<="0000000";
   when "1001" => cat<="0010000";
   when "1010" => cat<="0001000";
   when "1011" => cat<="0000011";
   when "1100" => cat<="1000110";
   when "1101" => cat<="0100001";
   when "1110" => cat<="0000110";
   when "1111" => cat<="0001110";
   when others => cat<= (others => 'X');
 
 end case;
 end process;
 
 
 process(sel)
 begin
    case sel is 
      when "000" => an <= "11111110";
      when "001" => an <= "11111101";
      when "010" => an <= "11111011";
      when "011" => an <= "11110111";
      when "100" => an <= "11101111";
      when "101" => an <= "11011111";
      when "110" => an <= "10111111";
      when "111" => an <= "01111111";
      when others=> an <= (others => 'X');
    end case;
 end process;
 
end Behavioral;
