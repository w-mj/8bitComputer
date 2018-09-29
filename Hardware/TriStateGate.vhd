library ieee;
use ieee.std_logic_1164.all;

entity TriStateGate is port(
	data_in : in std_logic_vector(7 downto 0);
	data_out: out std_logic_vector(7 downto 0);
	data: inout std_logic_vector(7 downto 0);
	wen: in std_logic
	);
end TriStateGate;

architecture TriStateGate_arch of TriStateGate is begin
data_out <= data when wen = '0' else (others=>'Z');
data <= data_in when wen = '1' else (others=>'Z');
end architecture;