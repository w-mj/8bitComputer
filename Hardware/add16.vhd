library ieee;
library work;
use ieee.std_logic_1164.all;
use work.pkg.all;
entity add16 is port(
	A, B: in std_logic_vector(15 downto 0);
	S :out std_logic_vector(15 downto 0);
	C_in: in std_logic;
	C_out: out std_logic;
	P_out, G_out: out std_logic
);
end add16;

architecture add16_arch of add16 is 
signal P, G, C: std_logic;
begin 
C1: add8 port map(A=>A(7 downto 0), B=>B(7 downto 0), S=>S(7 downto 0), 
						C_in=>C_in, C_out=>C, P_out=>P, G_out=>G);
C2: add8 port map(A=>A(15 downto 8), B=>B(15 downto 8), S=>S(15 downto 8),
						C_in=> G or (P and C), C_out=>C_out, P_out=>P_out, G_out=>G_out);
end add16_arch;
