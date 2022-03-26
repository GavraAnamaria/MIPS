library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ID is
    Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           RegWrite : in STD_LOGIC;
           regDst : in STD_LOGIC;
           extOp : in STD_LOGIC;
           instr : in STD_LOGIC_VECTOR (15 downto 0);
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : out STD_LOGIC_VECTOR (15 downto 0);
           ext_Imm : out STD_LOGIC_VECTOR (15 downto 0);
           func : out STD_LOGIC_VECTOR (2 downto 0);
           sa : out STD_LOGIC);
end ID;

architecture Behavioral of ID is

type reg_array is array (0 to 6) of std_logic_vector(15 downto 0);
signal reg_file : reg_array:= (others => x"0000");

signal ra1 : STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
signal ra2 : STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
signal wa : STD_LOGIC_VECTOR (2 downto 0) := (others => '0');

begin

ra1 <= instr(12 downto 10);
ra2 <= instr(9 downto 7);
func <= instr(2 downto 0);
sa <= instr(3);

--------------------------------------------------------[ RF ]-------------------------------------------------------
process(clk)
begin
  if rising_edge(clk) then
    if RegWrite = '1' and en = '1' then
      reg_file(conv_integer(wa)) <= wd;
    end if;
  end if;
end process;
rd1 <= reg_file(conv_integer(ra1));
rd2 <= reg_file(conv_integer(ra2));

--------------------------------------------------------[ MUX ]-------------------------------------------------------

wa <=  instr(9 downto 7) when (regDst = '0') else  instr(6 downto 4);

--------------------------------------------------------[ EXT UNIT ]-------------------------------------------------------

ext_Imm <= ("111111111" & instr(6 downto 0)) when (instr(6) = '1' and extOp = '1') else ("000000000" & instr(6 downto 0));


end Behavioral;
