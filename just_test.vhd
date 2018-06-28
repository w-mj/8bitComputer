library ieee;
use ieee.std_logic_1164.all;

entity just_test is port(
	input: in std_logic_vector(3 downto 0);
	output: out std_logic
	);
end just_test;

architecture test_arch of just_test is begin 
process(input) begin
	case input is
		when "01XX"=> output <= '1';
		when "10XX"=> output <= '0';
		when others=> output <= 'Z';
	end case;
end process;
end test_arch;