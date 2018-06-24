library ieee;
use ieee.std_logic_1164.all;

entity CPU is port (
	input: in std_logic_vector(3 downto 0);
	output: out std_logic_vector(3 downto 0)
	);
end CPU;

architecture CPU_arch of CPU is begin
output <= input;

end CPU_arch;