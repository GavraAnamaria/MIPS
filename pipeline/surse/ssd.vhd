library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ssd is
    Port ( clk : in STD_LOGIC;
           nr : in STD_LOGIC_VECTOR (15 downto 0);
           an : out STD_LOGIC_VECTOR (3 downto 0);
           cat : out STD_LOGIC_VECTOR (6 downto 0));
end ssd;

architecture Behavioral of ssd is

signal sel :STD_LOGIC_VECTOR(1 downto 0) := (others=>'0');
signal cifra :std_logic_vector(3 downto 0) := (others=>'0');

begin

--numarator
process (clk, nr)
variable nr2: std_logic_vector(15 downto 0) := (others=>'0');
  begin
    if clk = '1' and clk'event then
      nr2 := nr2 + 1;
    end if;
    sel <= nr(15 downto 14);
end process;

--mux
process(sel, nr)  
begin											  
    case sel is
    when "00" =>
	  an <= "0111";
	  cifra <= nr(15 downto 12);
    when "01" =>
	  an <= "1011";
	  cifra <= nr(11 downto 8);
    when "10" =>
	  an <= "1101";
	  cifra <= nr(7 downto 4);
    when others =>
	  an <= "1110"; 
	  cifra <= nr(3 downto 0);
    end case;	
end process;  

--dcd
process (cifra)				  
	begin
		case cifra is
			when "0000" => cat<="1111110";
			when "0001" => cat<="0110000";
			when "0010" => cat<="1101101";           
			when "0011" => cat<="1111001";
			when "0100" => cat<="0110011";
			when "0101" => cat<="1011011";
			when "0110" => cat<="0011111";
			when "0111" => cat<="1110000";
			when "1000" => cat<="1111111";
			when "1001" => cat<="1111011";
			when "1010" => cat<="1110111"; 
			when "1011" => cat<="0011111";
			when "1100" => cat<="1001110";
			when "1101" => cat<="0111101";
			when "1110" => cat<="1001111";
			when "1111" => cat<="1000111";
		    when others => cat<="1111111";
		end case;
	end process;

end Behavioral;
