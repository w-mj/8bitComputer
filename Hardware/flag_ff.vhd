library ieee;
library work;
use ieee.std_logic_1164.all;
use work.pkg.all;

entity flag_ff is port(
	from_alu: in std_logic_vector(7 downto 0);
	to_alu: out std_logic_vector(7 downto 0);
	to_bus: inout std_logic_vector(7 downto 0);
	load_bus, load_alu, CLK, put: in std_logic;
	STC, EI, DI: in std_logic
	);
end flag_ff;

architecture flag_ff_arch of flag_ff is
signal data: std_logic_Vector(7 downto 0):="00000000";
begin
to_bus <= data when put='1' else "ZZZZZZZZ";
to_alu <= data;
process (load_bus, load_alu, CLK, STC) begin
	if (rising_edge(CLK)) then 
		if (load_bus = '1') then
			data <= to_bus;
		elsif (load_alu = '1') then
			data <= from_alu;
		end if;
	end if;
	if (STC = '1') then
		data(0) <= '1';
	end if;
	if (EI = '1') then
		data(7) <= '1';
	elsif (DI = '1') then
		data(7) <= '0';
	end if;
end process;
end flag_ff_arch;