library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity matrix is
port(clk: in std_logic;
	row:  in std_logic_vector(3 downto 0);
	col: out std_logic_vector(3 downto 0);
	keyout: out std_logic_vector(3 downto 0);
	flag: out std_logic;
	flag_clr: in std_logic
	);
end matrix;


architecture behave of matrix is
signal colreg: std_logic_vector(3 downto 0);
signal con: std_logic_vector(7 downto 0);
signal cnt: std_logic_vector(31 downto 0);
constant cnt50ms: integer:= 100000;
signal clkreg, scanning: std_logic;
begin
col<=colreg;
con<= colreg & row;
process(clk)
begin
	if(rising_edge(clk)) then
		if (scanning = '1') then
			case colreg is
				when "1110" => colreg<="1101";
				when "1101" => colreg<="1011";
				when "1011" => colreg<="0111";
				when "0111" => colreg<="1110";
				when others => colreg<="1110";
			end case;
		end if;
	end if;
	
	if ((row(0) and row(1) and row(2) and row(3)) = '0') then
		scanning <= '0';
		if (cnt >= cnt50ms) then
			clkreg <= '1';
			flag <= '1';
		else 
			cnt <= cnt + '1';
		end if;
	else 
		scanning <= '1';
		cnt <= (others=>'0');
		clkreg <= '0';
		flag <= '0';
	end if;
end process;

process(clkreg)
begin
if clkreg'event and clkreg = '1' then
	case con is
	when "11101110" => keyout<="0000";
	when "11011110" => keyout<="0001";
	when "10111110" => keyout<="0010";
	when "01111110" => keyout<="0011";
	when "11101101" => keyout<="0100";
	when "11011101" => keyout<="0101";
	when "10111101" => keyout<="0110";
	when "01111101" => keyout<="0111";
	when "11101011" => keyout<="1000";
	when "11011011" => keyout<="1001";
	when "10111011" => keyout<="1010";
	when "01111011" => keyout<="1011";
	when "11100111" => keyout<="1100";
	when "11010111" => keyout<="1101";
	when "10110111" => keyout<="1110";
	when "01110111" => keyout<="1111";
	when others => keyout<="1111";
	end case;
end if;
end process;
end behave;