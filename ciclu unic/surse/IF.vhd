library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.numeric_std.ALL;

entity InstrFetch is
    Port ( Jump : in STD_LOGIC;
           PCSrc : in STD_LOGIC;
           BranchAddr : in STD_LOGIC_VECTOR (15 downto 0);
           JumpAddr : in STD_LOGIC_VECTOR (15 downto 0);
           en : in STD_LOGIC;
           rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           PC1 : out STD_LOGIC_VECTOR (15 downto 0);
           Instr : out STD_LOGIC_VECTOR (15 downto 0));
end InstrFetch;

architecture Behavioral of InstrFetch is

type ROM_m is array (0 to 31) of std_logic_vector(15 downto 0);
--programul gaseste minimul si maximul dintr-un sir de 10 numere intregi.
signal ROM: ROM_M:= ( --B"000_000_000_001_0_001",  --X"0011" -> add $1, $0, $0      contor
                      B"001_000_010_0001001",    --X"2109" -> addi $2, $0, 9      nr iteratii
                      B"000_000_000_011_0_001",  --X"0031" ->add $3, $0, $0      index memorie
                      B"111_000_100_0000001",    --X"E201" ->lw $4, 1($0)       primul element = maxim->in memorie pe pozitia 1
                      B"010_000_100_0000000",    --X "4200" ->sw $4, 0($0)       minim->in memorie pe pozitia 0
                     
                      B"011_010_011_0001100",    --X"698C" -> beq $2, $3, 12         cand contorul a ajuns la ultimul element, iesim din bucla
                      B"111_011_101_0000010",    --X"EE82" -> lw $5, 2($3)       al doilea element->$5
                      B"111_000_100_0000000",    --X"E200" -> lw $4, 0($0)       minimul->$4
                      B"000_101_100_100_0_010",  --X"1642" -> sub $4, $5, $4     $4 = element - minim
                      B"100_100_000_0000010",    --X"9002" -> bgez $4, 2         daca diferenta este mai mare de 0 (elementul este mai mare decat minimul), sarim la verificarea maximului
                      B"010_000_101_0000000",    --X"4280" -> sw $5, 0($0)    elementul este mai mic dect minimul curent=>elementul se pune in memorie pe pozitia 0(este noul minim)
                      B"110_0000000010000",      --X"C010" -> j 16             daca elementul are valoarea minima, sarim peste verificarea maximului
                      B"111_000_100_0000001",    --X"E210" ->lw $4, 1($0)       maximul->$4
                      B"000_100_101_100_0_010",  --X"12C2" -> sub $4, $4, $5     $4 = maxim - element
                      B"100_100_000_0000001",    --X"9001" -> bgez $4, 1         daca diferenta >0=> maxim>element=> trecem la urmatorul element
                      B"010_000_101_0000001",    --X"4281" -> sw $5, 1($0)    elementul > maxim => punem elementul in memorie pe pozitia 1
                      B"001_011_011_0000001",    --X"2D81" -> addi $3, $3, 1     index element urmator
                     -- B"001_001_001_0000001",    --X"2481" -> addi $1, $1, 1     i++
                      B"110_0000000000100",      --X"C004" -> j  4               trecem la urmatorul element
                      B"111_000_100_0000000",    --X"E200" -> lw $4, 0($0)           min->$4  
                     others => x"0000");
                     

signal q : STD_LOGIC_VECTOR (15 downto 0) := (others=>'0');
signal d : STD_LOGIC_VECTOR (15 downto 0) := (others=>'0');
signal addrB : STD_LOGIC_VECTOR (15 downto 0) := (others=>'0');


begin

-------------------------------------------------[ PC ]-----------------------------------------------------

process(clk)
begin
   if rising_edge(clk) then
      if rst='1' then
           q<= (others=>'0');
      elsif en='1' then
           q<=d;
      end if;
   end if;
end process;


-------------------------------------------------[ ROM ]-----------------------------------------------------

Instr <= rom(conv_integer(q(4 downto 0)));

-------------------------------------------------[ PC1 ]-----------------------------------------------------

PC1<=q+1;

-------------------------------------------------[ MUX ]-----------------------------------------------------

addrB <= BranchAddr when (PCSrc = '1') else (q+1);
d <= JumpAddr when (Jump = '1') else addrB;

end Behavioral;
