library ieee;
use ieee.std_logic_1164.all;

entity register8 is port (
	data_in: in std_logic_vector(7 downto 0);
	data_out: out std_logic_vector(7 downto 0);
	CLK: in std_logic;
	CLR: in std_logic := '0';
	EN: in std_logic
);
end register8;

architecture register8_arch of register8 is begin
process(CLK, CLR) begin
	if (CLR = '1') then
		data_out <= (others=>'0');
	elsif (EN = '1' and rising_edge(CLK)) then
		data_out <= data_in;
	else
		null;
	end if;
end process;
end register8_arch;