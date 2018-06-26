library ieee;
use ieee.std_logic_1164.all;
package pkg is 
COMPONENT alu_chip
	PORT
	(
		M		:	 IN STD_LOGIC;
		CN		:	 IN STD_LOGIC;
		A		:	 IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		B		:	 IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		s		:	 IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		CN8		:	 OUT STD_LOGIC;
		AEBQ		:	 OUT STD_LOGIC;
		F		:	 OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

component register8 is port (
	data_in: in std_logic_vector(7 downto 0);
	data_out: out std_logic_vector(7 downto 0);
	CLK: in std_logic;
	CLR: in std_logic := '0';
	EN: in std_logic
);
end component;

component register16 is port(
	data_in: in std_logic_vector(15 downto 0);
	data_out: out std_logic_vector(15 downto 0);
	CLK: in std_logic;
	CLR: in std_logic:='0';
	EN: in std_logic
	);
end component;

component add8 is
port (
	A, B: in std_logic_vector(7 downto 0);
	S :out std_logic_vector(7 downto 0);
	C_in: in std_logic;
	C_out: out std_logic;
	P_out, G_out: out std_logic
);
end component;

component add16 is
port (
	A, B: in std_logic_vector(15 downto 0);
	S :out std_logic_vector(15 downto 0);
	C_in: in std_logic;
	C_out: out std_logic;
	P_out, G_out: out std_logic
);
end component;
COMPONENT inc_dec_latch
	PORT
	(
		LDN		:	 IN STD_LOGIC;
		GN		:	 IN STD_LOGIC;
		DNUP		:	 IN STD_LOGIC;
		CLK		:	 IN STD_LOGIC;
		input		:	 IN STD_LOGIC_VECTOR(0 TO 15);
		output		:	 OUT STD_LOGIC_VECTOR(0 TO 15)
	);
END COMPONENT;

end pkg;
