library ieee;
use ieee.std_logic_1164.all;

entity Flipflop is port (
	clk, set1, set0: in std_logic;
	res: out std_logic
	);
end Flipflop;

architecture Flipflop_arch of Flipflop is 
signal state: std_logic_vector(1 downto 0) := "00";
begin
process(clk) begin
	if (clk'event and clk = '0') then
		case state is 
			when "00"=>
				if (set1 = '1' and set0 = '0') then 
					state <= "01";
					res <= '1';
				else
					state <= "00";
					res <= '0';
				end if;
			when "01"=>
				if (set1 = '0' and set0 = '1') then
					state <= "00";
					res <= '0';
				elsif (set1 = '1' and set0 = '1') then
					state <= "10";
					res <= '0';
				else
					state <= "01";
					res <= '1';
				end if;
			when "10"=>
				if (set1 = '0') then
					state <= "00";
					res <= '0';
				else
					state <= "10";
					res <= '0';
				end if;
			when "11"=>
				state <= "00";
				res <= '0';
			end case;
	end if;
end process;
end;