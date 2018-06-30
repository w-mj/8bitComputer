library ieee;
use ieee.std_logic_1164.all;

entity beats is port(
	output: out std_logic_vector(7 downto 0);
	CLK: in std_logic;
	EN: in std_logic;
	RST: in std_logic
	);
end beats;

architecture beats_arch of beats is
signal data: std_logic_vector(7 downto 0) := "00000000";
signal c: std_logic;
begin
output <= data;
process(CLK, RST) begin
	c <= 'X';
	if (falling_edge(CLK)) then
		if (data = "00000000") then
			data <= "00000001";
		elsif (EN = '1' and RST='0') then 
			c <= data(7);
			data(7 downto 1) <= data(6 downto 0);
			data(0) <= c;
		elsif (RST = '1') then
			data <= "00000000";
		end if; 
	end if;
end process;
end beats_arch;