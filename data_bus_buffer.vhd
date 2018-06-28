library ieee;
library work;
use ieee.std_logic_1164.all;
use work.pkg.all;

entity data_bus_buffer is port(
	CLK: in std_logic;
	data_bus: inout std_logic_vector(7 downto 0);
	inner_bus: inout std_logic_vector(7 downto 0);
	load_data, load_inner, put_data, put_inner: in std_logic
	);
end data_bus_buffer;

architecture data_bus_buffer_arch of data_bus_buffer is
signal data_in, data_out: std_logic_vector(7 downto 0);
begin
R: register8 port map(data_in=>data_in, data_out=>data_out, CLK=>CLK, EN=>load_data or load_inner);
	data_in <= data_bus when load_data='1' else inner_bus;
	data_bus <= data_out when put_data='1' else "ZZZZZZZZ";
	inner_bus <= data_out when put_inner='1' else "ZZZZZZZZ";
end data_bus_buffer_arch;