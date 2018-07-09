library ieee;
library work;
use ieee.std_logic_1164.all;
use work.pkg.all;

entity ALU is
port(
	A: in std_logic_vector(7 downto 0);
	T: in std_logic_vector(7 downto 0);
	output: out std_logic_vector(7 downto 0);
	S: in std_logic_vector(3 downto 0);
	put: in std_logic;
	F_in: in std_logic_vector(7 downto 0);  -- 0:C, A, P, Z, 4:S
	F_out: out std_logic_vector(7 downto 0) := "00000000"
	);
end ALU;

architecture ALU_arch of ALU is
signal adder_A_in, adder_B_in, adder_S: std_logic_vector(7 downto 0);
signal adder_C_in, adder_C_out, adder_A_out: std_logic;
begin
C: add8 port map(A=>adder_A_in, B=>adder_B_in, S=>adder_S, C_in=>adder_C_in, C_out=>adder_C_out, A_out=>adder_A_out);
output <= adder_s when put='1' else "ZZZZZZZZ";
process (S) begin
	adder_A_in <= (others=>'0');
	adder_b_in <= (others=>'0');
	adder_C_in <= '0';
	F_out(0) <= adder_C_out;
	F_out(1) <= adder_A_out;
	F_out(2) <= not (adder_S(7) xor adder_S(6) xor adder_S(5) xor adder_S(4) xor adder_S(3) xor adder_S(2) xor adder_S(1) xor adder_S(0));
	F_out(3) <= not (adder_S(7) or adder_S(6) or adder_S(5) or adder_S(4) or adder_S(3) or adder_S(2) or adder_S(1) or adder_S(0));
	F_out(4) <= adder_S(7);
	case S is 
		when "0000"=> adder_A_in <= T; adder_C_in <= '1';  -- T + 1
		when "0001"=> adder_A_in <= T; adder_B_in <= (others=>'1'); 
						  F_out(0) <= not adder_C_out; F_out(1) <= not adder_A_out;  -- T - 1
		when "0010"=> adder_A_in <= A; adder_B_in <= T;  -- A + T
		when "0011"=> adder_A_in <= A; adder_B_in <= T; adder_C_in <= F_in(0); -- A + T + CF
		when "0100"=> adder_A_in <= A; adder_B_in <= not T; adder_C_in <= '1'; 
						  F_out(0) <= not adder_C_out; F_out(1) <= not adder_A_out;  -- A - T
		when "0101"=> adder_A_in <= A; adder_B_in <= not T; adder_C_in <= not F_in(0);
						  F_out(0) <= not adder_C_out; F_out(1) <= not adder_A_out;  -- A - T - CF
		when "0110"=> adder_A_in <= A and T;  -- A and T
		when "0111"=> adder_A_in <= A xor T;  -- A xor T
		when "1000"=> adder_A_in <= A or T;
		when "1001"=> null;  -- used to be cmp.
		when "1010"=> F_out(0) <= A(7); adder_A_in <= A(6 downto 0) & A(7);  -- ROL
		when "1011"=> F_out(0) <= A(0); adder_A_in <= A(0) & A(7 downto 1);  -- ROR
		when "1100"=> F_out(0) <= A(7); adder_A_in <= A(6 downto 0) & F_in(0);  -- RCL
		when "1101"=> F_out(0) <= A(0); adder_A_in <= F_in(0) & A(6 downto 0);  -- RCR
		when "1110"=> null;
		when "1111"=> null;
	end case;
end process;
end ALU_arch;