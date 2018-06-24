library ieee;
library work;
use ieee.std_logic_1164.all;
use work.pkg.all;

entity REGISTER_ARRAY is port(
	data: inout std_logic_vector(7 downto 0);
	address: out std_logic_vector(15 downto 0);
	register_select: in std_logic_vector(3 downto 0);
	load, put: in std_logic
	);
end REGISTER_ARRAY;

architecture REGISTER_ARRAY_arch of REGISTER_ARRAY is 
signal W_in, W_out, Z_in, Z_out: std_logic_vector(7 downto 0);
signal B_in, B_out, C_in, C_out: std_logic_vector(7 downto 0);
signal D_in, D_out, E_in, E_out: std_logic_vector(7 downto 0);
signal H_in, H_out, L_in, L_out: std_logic_vector(7 downto 0);
signal SP_in, SP_out, PC_in, PC_out: std_logic_vector(15 downto 0);
signal W_CLK, Z_CLK, B_CLK, C_CLK, D_CLK, E_CLK, H_CLK, L_CLK, SP_CLK, PC_CLK: std_logic := '0';
signal data_buffer: std_logic_vector(7 downto 0);
signal selected: std_logic_vector(15 downto 0);
begin
REG_W: register8 port map(data_in=>data, data_out=>W_out, CLK=>W_CLK);
REG_Z: register8 port map(data_in=>data, data_out=>Z_out, CLK=>Z_CLK);
REG_B: register8 port map(data_in=>data, data_out=>B_out, CLK=>B_CLK);
REG_C: register8 port map(data_in=>data, data_out=>C_out, CLK=>C_CLK);
REG_D: register8 port map(data_in=>data, data_out=>D_out, CLK=>D_CLK);
REG_E: register8 port map(data_in=>data, data_out=>E_out, CLK=>E_CLK);
REG_H: register8 port map(data_in=>data, data_out=>H_out, CLK=>H_CLK);
REG_L: register8 port map(data_in=>data, data_out=>L_out, CLK=>L_CLK);
REG_SP: register16 port map(data_in=>H_out&L_out, data_out=>SP_out, CLK=>SP_CLK);
REG_PC: register16 port map(data_in=>H_out&L_out, data_out=>PC_out, CLK=>PC_CLK);

data <= data_buffer;

with put & register_select select
data_buffer <= 
	B_out when "10000",
	C_out when "10001",
	D_out when "10010",
	E_out when "10011",
	H_out when "10100",
	L_out when "10101",
	"ZZZZZZZZ" when others;

B_CLK <= load and equ("0000", register_select);
C_CLK <= load and equ("0001", register_select);
D_CLK <= load and equ("0010", register_select);
E_CLK <= load and equ("0011", register_select);
H_CLK <= load and equ("0100", register_select);
L_CLK <= load and equ("0101", register_select);

end REGISTER_ARRAY_arch;
