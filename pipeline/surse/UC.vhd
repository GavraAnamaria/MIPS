library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity UC is
    Port ( opcode : in STD_LOGIC_VECTOR (2 downto 0);
           ALUSrc : out STD_LOGIC;
           branch : out STD_LOGIC;
              jump : out STD_LOGIC;
              MemtoReg : out STD_LOGIC;
              MemWrite : out STD_LOGIC;
              RegWrite : out STD_LOGIC;
              Br_gez : out STD_LOGIC;
              Br_ne : out STD_LOGIC;
              ALUOp : out STD_LOGIC_VECTOR(1 downto 0);
              regDst : out STD_LOGIC;
              extOp : out STD_LOGIC);
             
end UC;

architecture Behavioral of UC is

begin

process(opcode)
begin
   RegDst <= '0';
   extOp <= '0';
   ALUSrc <= '0';
   branch <= '0';
   jump <= '0';
   MemWrite <= '0';
   MemtoReg <= '0'; 
   RegWrite <= '0';
   ALUOp <= "00";
   Br_gez <= '0';
   Br_ne <= '0';
   case(opcode) is
      when "000" => --R
            RegDst <= '1';
            RegWrite <= '1';
            ALUOp <= "00";
      
      when "001" => --ADDI
            extOp <= '1';
            ALUSrc <= '1';
            RegWrite <= '1';
            ALUOp <= "01";
            
      when "010" => --sw
            extOp <= '1';
            ALUSrc <= '1';
            MemWrite <= '1';
            ALUOp <= "01";
            
      when "011" => --beq
            extOp <= '1';
            branch <= '1';
            ALUOp <= "10";
            
      when "100" => --bgez
            extOp <= '1';
            branch <= '1';
            Br_gez <= '1';
            ALUOp <= "10";
                        
     when "101" => --bne
           extOp <= '1';
           branch <= '1';
           Br_ne <= '1';
           ALUOp <= "10";
                               
     when "110" => --j
           jump <= '1';
           
     when others => --lw
           extOp <= '1';
           ALUSrc <= '1';
           MemtoReg <= '1';
           RegWrite <= '1';
           ALUOp <= "01";                        
end case;
end process;


end Behavioral;
