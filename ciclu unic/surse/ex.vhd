
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE ieee.numeric_std.ALL;


entity ex is
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
end ex;

architecture Behavioral of ex is

signal ALUCtrl : STD_LOGIC_VECTOR(2 downto 0) := "000";
signal B : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
signal C : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
signal Z : STD_LOGIC := '0';

begin


----------------------------------------------------------[ ALU Control ]-------------------------------------------

process(ALUOp, func)
begin
   case ALUOp is
     when "00" =>
          case func is
            when "001"  => ALUCtrl <= "001";
            when "010"  => ALUCtrl <= "010";
            when "011"  => ALUCtrl <= "011";
            when "111"  => ALUCtrl <= "111";
            when "100"  => ALUCtrl <= "100";
            when "101"  => ALUCtrl <= "101";
            when "110"  => ALUCtrl <= "110";
            when "000"  => ALUCtrl <= "000";
             when others =>ALUCtrl <= (others => 'X');
          end case;
     when "01" => ALUCtrl <= "001"; 
     when "10" => ALUCtrl <= "010"; 
     when others =>ALUCtrl <= (others => 'X');
   end case;
end process;


----------------------------------------------------------[ MUX ]-------------------------------------------

B <= RD2 when (ALUSrc = '0') else ext_imm;


----------------------------------------------------------[ ALU ]-------------------------------------------

process(ALUCtrl, RD1, B, C, Z, RD2, sa)
begin
   case ALUCtrl is
     when "001" => C <= RD1 + B;
     when "010" => C <= RD1 - B;
                                
     when "011" => if sa='0' then
                          C <= B;
                   else
                          C <= B(14 downto 0)& '0';
                   end if; 
                         
     when "111" => if sa = '0' then
                        C <= B;
                   else
                       C <= '0' & B(15 downto 1);
                   end if;             
              
     when "100" => C <= RD1 and B;
     when "101" => C <= RD1 or B;
     when "110" =>  if sa = '0' then
                                C <= B;
                             else
                                 C <= B(15) & B(15 downto 1);
                             end if;  
     when others => C <= RD1 xor B;
   end case;
   end process;
   ALURes <= C; 
   
   process(C)
   begin
   if C = x"0000" then 
       Z <= '1';
   else
       Z <= '0';
   end if;
   end process;
   Zero <= Z;
   NE <= not (Z);
   GE <= not(C(15));
    

----------------------------------------------------------[ Branch Addresss ]-------------------------------------------

BranchAddr <= ext_imm +pc1;

end Behavioral;
