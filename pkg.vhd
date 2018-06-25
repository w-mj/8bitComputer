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

function equ(
	a: std_logic_vector;
	b: std_logic_vector
) return std_logic;
end pkg;

package body pkg is 
	function equ(
		a: std_logic_vector;
		b: std_logic_vector
	) return std_logic is 
	begin
		if (a = b) then
			return '1';
		else
			return '0';
		end if;
	end equ;
end pkg;