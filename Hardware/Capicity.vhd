library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Capicity is port(
	sin, clk: in std_logic;
	sout: out std_logic
	);
end Capicity;

architecture Capicity_arch of Capicity is 
signal cnt: unsigned(7 downto 0) := (others=>'0');
signal state: std_logic := '1';
begin
sout <= state;
process(clk) begin
	if (clk'event and clk='0') then
		if (sin = '1' and state = '0') then
			state <= '1';
		elsif (sin = '0' and state = '1') then
			if (cnt = 255) then
				state <= '0';
				cnt <= (others=>'0');
			else
				cnt <= cnt + 1;
			end if;
		end if;
	end if;
end process;
end architecture;