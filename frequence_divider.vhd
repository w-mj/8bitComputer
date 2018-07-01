library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity frequence_divider is port(
	i: in std_logic;
	o: out std_logic
	);
end frequence_divider;

architecture frequence_divider_arch of frequence_divider is
signal s: unsigned(22 downto 0) := to_unsigned(0, 23);
signal b: std_logic := '0';
begin
o <= b;
process (i) begin
	if (rising_edge(i)) then 
		s <= s + to_unsigned(1, s'length);
		if (s = 6) then
			s <= to_unsigned(0, 23);
			b <= not b;
		end if;
	end if;
end process;
end frequence_divider_arch;
