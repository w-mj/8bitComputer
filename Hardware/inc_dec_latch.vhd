library ieee;
use ieee.std_logic_1164.all;

entity inc_dec_latch is port(
	A: in std_logic_vector(15 downto 0);
	inc_decN: in std_logic;
	S: out std_logic_vector(15 downto 0)
	);
end inc_dec_latch;

architecture inc_dec_latch_arch of inc_dec_latch is
signal C, G, P, B: std_logic_vector(15 downto 0);
begin
	B <= (others=>'0') when inc_decN = '1' else (others=>'1');
	process(A, inc_decN) begin
		G <= A and B;
		P <= A or B;
		C(0) <= inc_decN;
		for i in 0 to 14 loop
			C(i + 1) <= G(i) or (P(i) and C(i));
		end loop;
		S <= A xor B xor C;
	end process;
end inc_dec_latch_arch;
		

	