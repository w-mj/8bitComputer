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
signal data: std_logic_vector(7 downto 0) := "00000001";
begin
output <= data;
process(CLK, RST) begin
	if (falling_edge(CLK)) then
		if (EN = '1' or data(7) = '1') then 
			if (data(7) = '1') then 
				data(7 downto 1) <= data(6 downto 0);
				data(0) <= '1';
			else
				data(7 downto 1) <= data(6 downto 0);
				data(0) <= '0';
			end if;
		end if; 
	end if;
	if (RST = '1') then
		data <= "10000000";
	end if;
end process;
end beats_arch;