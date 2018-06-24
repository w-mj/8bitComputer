library IEEE;
use IEEE.STD_LOGIC_1164.all;
entity add8 is
	port (
		A, B: in std_logic_vector(7 downto 0);
		S :out std_logic_vector(7 downto 0);
		C_in: in std_logic;
		C_out: out std_logic
	);
end add8;

architecture add8_arch of add8 is 
	signal G, P, CO: std_logic_vector(7 downto 0);
begin
	process(A, B, G, P, CO, C_in) begin
		G <= A and B;
		P <= A or B;
		CO(0) <= C_in;
		CO(1) <= G(0) or (P(0) and CO(0));
		CO(2) <= G(1) or (P(1) and CO(1));
		CO(3) <= G(2) or (P(2) and CO(2));
		CO(4) <= G(3) or (P(3) and CO(3));
		CO(5) <= G(4) or (P(4) and CO(4));
		CO(6) <= G(5) or (P(5) and CO(5));
		CO(7) <= G(6) or (P(6) and CO(6));
		C_out <= G(7) or (P(7) and CO(7));
		S <= A xor B xor CO;
	end process;
end add8_arch;