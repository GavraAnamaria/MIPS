
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MEM is
    Port ( MemWrite : in STD_LOGIC;
           en : in STD_LOGIC;
           clk : in STD_LOGIC;
           ALURes : in STD_LOGIC_VECTOR (15 downto 0);
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           MemData : out STD_LOGIC_VECTOR (15 downto 0);
           ALU_Res : out STD_LOGIC_VECTOR (15 downto 0));
end MEM;

architecture Behavioral of MEM is
type mem_type is array (0 to 31) of std_logic_vector(15 downto 0);
signal mem : mem_type := (x"0000", x"0011", x"1102", x"0013", x"0104", x"0015", x"1006", x"0117", x"1128", x"0190", x"0001",others => x"0000");


begin

process (clk)
begin
   if rising_edge(clk) then
       if en = '1' and MemWrite='1' then
          mem(conv_integer(ALURes(4 downto 0))) <= RD2;
      end if;
   end if;
end process;
MemData <= mem(conv_integer(ALURes(4 downto 0)));
ALU_Res <= ALURes;

end Behavioral;
