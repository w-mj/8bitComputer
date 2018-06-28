library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity machine_cycle_encoding is port (
	beats_out: out std_logic_vector(5 downto 0);
	CLK: in std_logic;
	RST, next_M, next_T: in std_logic
	);
end machine_cycle_encoding;

architecture machine_cycle_encoding_arch of machine_cycle_encoding is 
signal M, T: std_logic_vector(2 downto 0) := "000";
begin
beats_out <= M & T;
process(CLK) begin
	if (falling_edge(CLK)) then
		if (next_M = '1') then
			M <= std_logic_vector(unsigned(M) + 1);
			T <= "000";
		elsif (next_T = '1') then 
			T <= std_logic_vector(unsigned(T) + 1);
		else null;
		end if;
	else null;
	end if;
	if (RST = '1') then
		M <= "000";
		T <= "000";
	end if;
end process;
end machine_cycle_encoding_arch;
