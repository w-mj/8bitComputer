library ieee;
library work;
use ieee.std_logic_1164.all;
use work.pkg.all;

entity flag_ff is port(
	from_alu: in std_logic_vector(7 downto 0);
	to_alu: out std_logic_vector(7 downto 0);
	to_bus: inout std_logic_vector(7 downto 0);
	load_bus, load_alu, CLK, put: in std_logic;
	STC: in std_logic
	);
end flag_ff;

architecture flag_ff_arch of flag_ff is
signal data: std_logic_Vector(7 downto 0):="00000000";
begin
to_bus <= data when put='1' else "ZZZZZZZZ";
to_alu <= data;
process (load_bus, load_alu, CLK, STC) begin
	if (load_bus = '1' and rising_edge(CLK)) then
		data <= to_bus;
	elsif (load_alu = '1' and rising_edge(CLK)) then
		data <= from_alu;
	end if;
	if (STC = '1') then
		data(0) <= '1';
	end if;
end process;
end flag_ff_arch;