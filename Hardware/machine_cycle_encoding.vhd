library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.pkg.all;


entity machine_cycle_encoding is port (
	M_out: out std_logic_vector(7 downto 0);
	T_out: out std_logic_vector(7 downto 0);
	CLK: in std_logic;
	RST, next_M, next_T: in std_logic
	);
end machine_cycle_encoding;

architecture machine_cycle_encoding_arch of machine_cycle_encoding is 
signal half_CLK: std_logic;
begin
MC: beats port map(output=>M_out, CLK=>CLK, EN=>next_M, RST=>RST);
TC: beats port map(output=>T_out, CLK=>CLK, EN=>next_T, RST=>RST or next_M);
end machine_cycle_encoding_arch;
