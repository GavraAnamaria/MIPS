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
           extOp : in STD_LOGIC;
           wa : in STD_LOGIC_VECTOR(2 downto 0);
           instr : in STD_LOGIC_VECTOR (12 downto 0);
           wd : in STD_LOGIC_VECTOR (15 downto 0);
           rd1 : out STD_LOGIC_VECTOR (15 downto 0);
           rd2 : out STD_LOGIC_VECTOR (15 downto 0);
           ext_Imm : out STD_LOGIC_VECTOR (15 downto 0);
           func : out STD_LOGIC_VECTOR (2 downto 0);
           rt : out STD_LOGIC_VECTOR (2 downto 0);
           rd : out STD_LOGIC_VECTOR (2 downto 0);
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


component ex is
    Port (  ALUSrc : in STD_LOGIC;
          RegDst : in STD_LOGIC;
          rt : in STD_LOGIC_VECTOR (2 downto 0);
          rd : in STD_LOGIC_VECTOR (2 downto 0);
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
          wa : out STD_LOGIC_VECTOR (2 downto 0);
          ALURes : out STD_LOGIC_VECTOR (15 downto 0);
          BranchAddr : out STD_LOGIC_VECTOR (15 downto 0));
end component;


component MEM is
    Port ( MemWrite : in STD_LOGIC;
           en : in STD_LOGIC;
           clk : in STD_LOGIC;
           ALURes : in STD_LOGIC_VECTOR (15 downto 0);
           RD2 : in STD_LOGIC_VECTOR (15 downto 0);
           MemData : out STD_LOGIC_VECTOR (15 downto 0);
           ALU_Res : out STD_LOGIC_VECTOR (15 downto 0));
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


signal en : STD_LOGIC := '0';
signal GEZ : STD_LOGIC := '0';
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
signal rt : STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
signal rd : STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
signal wa : STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
signal wd : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal rd1 : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal rd2 : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal ext_imm : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal rd1Out : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal ext_immOut : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal rd2Out : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal MemOut : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal func : STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
signal do : STD_LOGIC_VECTOR (15 downto 0) := (others => '0');
signal if_id : STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
signal id_ex : STD_LOGIC_VECTOR (83 downto 0) := (others => '0');
signal ex_mem : STD_LOGIC_VECTOR (59 downto 0) := (others => '0');
signal mem_wb : STD_LOGIC_VECTOR (36 downto 0) := (others => '0');
begin

-----------------------------------------------------[ MPG ]--------------------------------------------------------------
 MPG1: mpg port map (clk, btn(0), en);
 MPG2: mpg port map (clk, btn(1), rst);

-----------------------------------------------------[ IF ]--------------------------------------------------------------

InstrF: InstrFetch port map(jmp, PCSrc, ex_mem(50 downto 35), JmpAddr, en, rst, clk, PC1, Instr);
                                           --branchAddr
   process(clk)   --IF/ID
       begin
          if rising_edge(clk) then
             if en = '1' then
                if_id(31 downto 16) <= instr;
                if_id(15 downto 0) <= PC1;
             end if;
          end if;
       end process;
       
JmpAddr(15 downto 13) <= if_id (15 downto 13); --PC1(15 - 13)
JmpAddr(12 downto 0) <= if_id(28 downto 16);   --Instr(12 - 0)

-----------------------------------------------------[ UC ]--------------------------------------------------------------

UCt: UC port map(if_id(31 downto 29), ALUSrc, branch, jmp, MemtoReg, MemWrite, RegWrite, br_gez, br_ne, regDst, extOp, ALUOp);
                  -- instr(15 - 13) 
-----------------------------------------------------[ ID ]--------------------------------------------------------------

IDe: ID port map(clk, en, MEM_WB(35), extOp, MEM_WB(2 downto 0), if_id(28 downto 16), wd, rd1, rd2, ext_Imm, func, rt, rd, sa);

 process(clk)   --ID/EX
       begin
          if rising_edge(clk) then
             if en = '1' then 
                id_ex(83) <= RegDst;
                id_ex(82) <= AluSrc;
                id_ex(81 downto 80) <= AluOp;
                id_ex(79) <= MemWrite;
                id_ex(78) <= Branch;
                id_ex(77) <= Br_gez;
                id_ex(76) <= Br_ne;
                id_ex(75) <= MemToReg;
                id_ex(74) <= RegWrite;
                id_ex(73 downto 58) <= RD1;
                id_ex(57 downto 42) <= RD2;
                id_ex(41 downto 26) <= Ext_Imm;
                id_ex(25 downto 23) <= func;
                id_ex(22) <= sa;
                id_ex(21 downto 19) <= rd;
                id_ex(18 downto 16) <= rt;
                id_ex(15 downto 0) <= If_id(15 downto 0);   --PC1
                rd1Out <= rd1;
                rd2Out <= rd2;
                ext_immOut <= ext_imm;
             end if;
          end if;
       end process;
           
       


-----------------------------------------------------[ EX ]--------------------------------------------------------------
EXe: ex port map(id_ex(82), id_ex(83), id_ex(18 downto 16), id_ex(21 downto 19), id_ex(73 downto 58), id_ex(57 downto 42), id_ex(41 downto 26), id_ex(22), id_ex(25 downto 23), id_ex(81 downto 80), id_ex(15 downto 0) , GEZ, Zero, NE, wa, ALURes, BranchAddr );
                 --aluSrc,  RegDst,     rt,                     rd,                Rd1                       RD2                  ext_imm          sa          func                     AluOp             PC1 


 process(clk)   --EX/MEM
       begin
          if rising_edge(clk) then
             if en = '1' then
                ex_mem(59) <=id_ex(79); --MemWrite;
                ex_mem(58) <= id_ex(78);  --Branch
                ex_mem(57) <= id_ex(77);  --Br_gez
                ex_mem(56) <= id_ex(76);  --Br_ne
                ex_mem(55) <= id_ex(75);   --MemToReg
                ex_mem(54) <= id_ex(74);   --RegWrite
                ex_mem(53) <= zero;
                ex_mem(52) <= ne;
                ex_mem(51) <= gez;
                ex_mem(50 downto 35) <= BranchAddr;
                ex_mem(34 downto 19) <= AluRes;
                ex_mem(18 downto 16) <= wa;
                ex_mem(15 downto 0) <= id_ex(57 downto 42); --RD2
             end if;
          end if;
       end process;

--------------------------------------------------[ Branch ]-------------------------------------------------------------
 BR:PCSrc <=  (ex_mem(58) and ex_mem(53)) or (ex_mem(52) and ex_mem(56)) or (ex_mem(51) and ex_mem(57));
               --branch        zero             ne             br_ne           gez            br_gez


-----------------------------------------------------[ MEM ]--------------------------------------------------------------
MEMory: mem port map(ex_mem(59), en, clk, ex_mem(34 downto 19), ex_mem(15 downto 0), MemData, ALU_Res);
                     --MemWrite              AluRes              --RD2


 process(clk)   --MEM/wb
       begin
          if rising_edge(clk) then
             if en = '1' then
                mem_wb(36) <= ex_mem(55);  --MemToReg
                mem_wb(35) <= ex_mem(54);  --RegWrite
                mem_wb(34 downto 19) <= Alu_Res;
                mem_wb(18 downto 3) <= MemData;
                mem_wb(2 downto 0) <= ex_mem(18 downto 16);  --wa
                memOut <= MemData;
             end if;
          end if;
       end process;
       


-----------------------------------------------------[ wb ]--------------------------------------------------------------
WB:WD <= MEM_WB(34 downto 19) when (MEM_WB(36) = '0') else MEM_WB(18 downto 3); 
               --AluRes               MemToReg               MemData 


--------------------------------------------------[ MUX ]-------------------------------------------------------------

MUX:process (sw, instr, pc1, id_ex(73 downto 26), wd,AluRes, mem_wb(18 downto 3))  
begin											  
    case sw is
    when "000" =>
	  do <= Instr;
    when "001" =>
      do <= PC1;
    when "010" =>
      do <= id_ex(73 downto 58);  --rd1
    when "011" =>
      do <= id_ex(57 downto 42);   -- RD2;
    when "100" =>
      do <= id_ex(41 downto 26);    -- ext_imm;
    when "101" =>
      do <= wd;
    when "110" =>
      do <= AluRes;
    when "111" =>
      do <= mem_wb(18 downto 3); -- MemData;
    when others =>
        do <= (others => '0');            
    end case;	
end process; 



--------------------------------------------------[ SSD ]-------------------------------------------------------------

SSDec: ssd port map (clk, do, an, cat);
 

led(10) <= ex_mem(56);  --br ne
led(11) <= ex_mem(57);  --br gez
led(9 downto 8) <= id_ex(81 downto 80); --alu op
led(6) <= ExtOp;
led(5) <= id_ex(82); --alu src
led(7) <= id_ex(83); --reg dst
led(4) <= ex_mem(58);--branch
led(3) <= jmp;  
led(2) <= ex_mem(59); --mem write
led(1) <= mem_wb(36); --mem to reg
led(0) <= mem_wb(35);  --reg wr

end Behavioral;
