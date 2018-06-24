library IEEE;
use IEEE.STD_LOGIC_1164.All;
entity ALU is port(
	A: in std_logic_vector(7 downto 0);
	B: in std_logic_vector(7 downto 0);
	F: out std_logic_vector(7 downto 0);
	M: in std_logic;
	S: in std_logic_vector(3 downto 0);
	C_in: in std_logic;  -- C_in=0 means a carry bit exists, different from adder.
	C_out: out std_logic
);
end ALU;

architecture ALU_arch of ALU is
component add8 is
	port (
		A, B: in std_logic_vector(7 downto 0);
		S :out std_logic_vector(7 downto 0);
		C_in: in std_logic;
		C_out: out std_logic
	);
end component;
signal adder_A, adder_B, adder_S: std_logic_vector(7 downto 0);
begin
adder: add8 port map(A=>adder_A, B=>adder_B, S=>adder_S, C_in=>(not C_in) or M, C_out=>C_out);
F <= adder_S;
process(A, B, M, S, C_in) begin
	case M is
	when '1' => 
		adder_B <= (others=>'0');
		case S is 
			when "0000"=> adder_A<= not A;
			when "0001"=> adder_A<=not (A or B);
			when "0010"=> adder_A<=(not A) and B;
			when "0011"=> adder_A<="00000000";
			when "0100"=> adder_A<=not (A and B);
			when "0101"=> adder_A<=not B;
			when "0110"=> adder_A<=A xor B;
			when "0111"=> adder_A<=not (A xor B); 
			when "1000"=> adder_A<=(not A) or B; 
			when "1001"=> adder_A<=not (A nor B); 
			when "1010"=> adder_A<=B; 
			when "1011"=> adder_A<=A and B; 
			when "1100"=> adder_A<="11111111"; 
			when "1101"=> adder_A<=A or (not B); 
			when "1110"=> adder_A<=A or B; 
			when "1111"=> adder_A<=A;
		end case;
	when '0' => 
		case S is 
			when "0000"=> adder_A<=A; adder_B<=(others=>'0');
			when "0001"=> adder_A<=A or B; adder_B<=(others=>'0');
			when "0010"=> adder_A<=A or (not B); adder_B<=(others=>'0');
			when "0011"=> adder_A<=(others=>'0'); adder_B<=(others=>'1');
			when "0100"=> adder_A<=A; adder_B<=(A and (not B));
			when "0101"=> adder_A<=A or B; adder_B<=(A and (not B));
			when "0110"=> adder_A<=A; adder_B<=not B;
			when "0111"=> adder_A<=A or (not B); adder_B<=(others=>'1');
			when "1000"=> adder_A<=A; adder_B<=A and B;
			when "1001"=> adder_A<=A; adder_B<=B;
			when "1010"=> adder_A<=(A or (not B)); adder_B<=A and B;
			when "1011"=> adder_A<=A and B; adder_B<=(others=>'1');
			when "1100"=> adder_A<=A; adder_B<=A;
			when "1101"=> adder_A<=A or B; adder_B<=A;
			when "1110"=> adder_A<=A or (not B); adder_B<=A;
			when "1111"=> adder_A<=A; adder_B<=(others=>'1');
		end case;
	end case;
end process;
end ALU_arch;