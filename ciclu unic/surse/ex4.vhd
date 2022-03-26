
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.numeric_std.ALL;

entity ex4 is
    Port ( clk : in STD_LOGIC;
           btn : in STD_LOGIC_vector(1 downto 0);
           sw : in STD_LOGIC_vector(2 downto 0);
           led : out STD_LOGIC_vector(11 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end ex4;

architecture Behavioral of ex4 is

component MEM is
    Port ( MemWrite : in STD_LOGIC;
           en : in STD_LOGIC;
           clk : in STD_LOGIC;
           ALURes : in STD_LOGIC_VECTOR (15 downto 0);
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           MemData : out STD_LOGIC_VECTOR (15 downto 0);
           ALU_Res : out STD_LOGIC_VECTOR (15 downto 0));
end component;


component ex is
    Port ( ALUSrc : in STD_LOGIC;
           RD1 : in STD_LOGIC_VECTOR (15 downto 0);
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           ext_imm : in STD_LOGIC_VECTOR (15 downto 0);
           sa : in STD_LOGIC;
           func : in STD_LOGIC_VECTOR (2 downto 0);
           ALUOp : in STD_LOGIC_VECTOR (1 downto 0);
           PC1 : in STD_LOGIC_VECTOR (15 downto 0);
           GE : out STD_LOGIC;
           Zero : out STD_LOGIC;
           NE : out STD_LOGIC;
           ALURes : out STD_LOGIC_VECTOR (15 downto 0);
           BranchAddr : out STD_LOGIC_VECTOR (15 downto 0));
end component;


component InstrFetch is
    Port ( Jump : in STD_LOGIC;
           PCSrc : in STD_LOGIC;
           BranchAddr : in STD_LOGIC_VECTOR (15 downto 0);
           JumpAddr : in STD_LOGIC_VECTOR (15 downto 0);
           en : in STD_LOGIC;
           rst : in STD_LOGIC;
           clk : in STD_LOGIC;
           PC1 : out STD_LOGIC_VECTOR (15 downto 0);
           Instr : out STD_LOGIC_VECTOR (15 downto 0));
end component;

component ID is
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
end component;

component UC is
    Port ( opcode : in STD_LOGIC_VECTOR (2 downto 0);
           ALUSrc : out STD_LOGIC;
           branch : out STD_LOGIC;
              jump : out STD_LOGIC;
              MemtoReg : out STD_LOGIC;
              MemWrite : out STD_LOGIC;
              RegWrite : out STD_LOGIC;
              Br_gez : out STD_LOGIC;
              Br_ne : out STD_LOGIC;
              regDst : out STD_LOGIC;
              extOp : out STD_LOGIC;
              ALUOp : out STD_LOGIC_VECTOR(1 downto 0));
end component;

COMPONENT mpg is
    Port ( clk : in STD_LOGIC;
       btn : in STD_LOGIC;
       ce : out STD_LOGIC);
end COMPONENT;

component ssd is
    Port ( clk : in STD_LOGIC;
           nr : in STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end component;


signal ce : STD_LOGIC := '0';
signal GE : STD_LOGIC := '0';
signal NE : STD_LOGIC := '0';
signal Zero : STD_LOGIC := '0';
signal rst : STD_LOGIC := '0';
signal jmp : STD_LOGIC := '0';
signal Branch : STD_LOGIC := '0';
signal br_ne : STD_LOGIC := '0';
signal br_gez : STD_LOGIC := '0';
signal RegWrite : STD_LOGIC := '0';
signal MemWrite : STD_LOGIC := '0';
signal MemtoReg : STD_LOGIC := '0';
signal RegDst : STD_LOGIC := '0';
signal ExtOp : STD_LOGIC := '0';
signal sa : STD_LOGIC :='0';
signal PCSrc : STD_LOGIC:='0';
signal ALUSrc : STD_LOGIC:='0';
signal MemData : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal ALU_Res : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal ALUOp : STD_LOGIC_VECTOR (1 downto 0) := (others => '0');
signal JmpAddr : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal BranchAddr : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal ALURes : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal PC1 : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal Instr : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal wd : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal rd1 : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal rd2 : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal ext_imm : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal func : STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
signal do : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
begin

-----------------------------------------------------[ MPG ]--------------------------------------------------------------
 MPG1: mpg port map (clk, btn(0), ce);
 MPG2: mpg port map (clk, btn(1), rst);

-----------------------------------------------------[ IF ]--------------------------------------------------------------

InstrF: InstrFetch port map(jmp, PCSrc, BranchAddr, JmpAddr, ce, rst, clk, PC1, Instr);
JmpAddr(15 downto 13) <= PC1 (15 downto 13); 
JmpAddr(12 downto 0) <= Instr(12 downto 0); 
-----------------------------------------------------[ UC ]--------------------------------------------------------------

UCt: UC port map(instr(15 downto 13), ALUSrc, branch, jmp, MemtoReg, MemWrite, RegWrite, br_gez, br_ne, regDst, extOp, ALUOp);
led(10) <= br_ne;
led(11) <= br_gez;
led(9 downto 8) <= ALUOp;
led(6) <= ExtOp;
led(5) <= ALUSrc;
led(7) <= regDst;
led(4) <= Branch;
led(3) <= jmp;
led(2) <= memWrite;
led(1) <= memToReg;
led(0) <= regWrite;
-----------------------------------------------------[ ID ]--------------------------------------------------------------

IDe: ID port map(clk, ce, RegWrite, regDst, extOp, Instr, wd, rd1, rd2, ext_Imm, func, sa);



-----------------------------------------------------[ EX ]--------------------------------------------------------------
EXe: ex port map(ALUSrc, rd1, rd2, ext_imm, sa, func, ALUOp, PC1 , GE, Zero, NE, ALURes, BranchAddr );


-----------------------------------------------------[ MEM ]--------------------------------------------------------------
MEMory: mem port map(MemWrite, ce, clk, ALURes, RD2, MemData, ALU_Res);

-----------------------------------------------------[ wb ]--------------------------------------------------------------
WB:WD <= ALU_Res when (MemtoReg = '0') else MemData; 


--------------------------------------------------[ Branch ]-------------------------------------------------------------
BR:PCSrc <=  (Branch and Zero) or (NE and br_ne) or (GE and Br_gez);

--------------------------------------------------[ MUX ]-------------------------------------------------------------

MUX:process (sw, instr, pc1, wd, ext_imm, func, sa, rd1, rd2)  
begin											  
    case sw is
    when "000" =>
	  do <= Instr;
    when "001" =>
      do <= PC1;
    when "010" =>
      do <= rd1;
    when "011" =>
      do <= rd2;
    when "100" =>
      do <= wd;
    when "101" =>
      do <= ext_imm;
    when "110" =>
      do <= "0000000000000" & func;
    when "111" =>
      do <= "000000000000000" & sa;
    when others =>
        do <= (others => '0');            
    end case;	
end process; 
--------------------------------------------------[ SSD ]-------------------------------------------------------------

SSDec: ssd port map (clk, do, an, cat); --afisare continut memorie
 



end Behavioral;
