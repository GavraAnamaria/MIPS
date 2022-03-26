
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity mpg is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC;
           ce : out STD_LOGIC);
end mpg;

architecture Behavioral of mpg is
signal nr : STD_LOGIC_VECTOR (16 downto 0) := (others => '0');
signal reg : STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
begin
  process (clk)
  begin
    if clk = '1' and clk'event then
      nr <= nr + 1;
    end if;
  end process;
 
  process (clk)
      begin
          if clk = '1' and  clk'event then
               if nr(16 downto 0) = "11111111111111111" then
                  reg(0) <= btn;
               end if;
                  reg(1) <= reg(0);
                  reg(2) <= reg(1);
          end if;
      end process;
      ce <= reg(1) and (not reg(2));
end Behavioral;