library ieee;
library work;
use ieee.std_logic_1164.all;
use work.pkg.all;

entity REGISTER_ARRAY is port(
	CLK: in std_logic;
	data: inout std_logic_vector(7 downto 0);
	address: out std_logic_vector(15 downto 0);
	register_select: in std_logic_vector(5 downto 0) := "000000" -- 4 for cs and 2 for function, 01: load, 10: put
	);
end REGISTER_ARRAY;

architecture REGISTER_ARRAY_arch of REGISTER_ARRAY is 
signal W_out, Z_out, B_out, C_out, D_out, E_out, H_out, L_out: std_logic_vector(7 downto 0);
signal SP_out, PC_out: std_logic_vector(15 downto 0);
signal W_EN, Z_EN, B_EN, C_EN, D_EN, E_EN, H_EN, L_EN, SP_EN, PC_EN: std_logic := '0';
signal data_buffer: std_logic_vector(7 downto 0);
begin
REG_W: register8 port map(data_in=>data, data_out=>W_out, CLK=>CLK, EN=>W_EN);
REG_Z: register8 port map(data_in=>data, data_out=>Z_out, CLK=>CLK, EN=>Z_EN);
REG_B: register8 port map(data_in=>data, data_out=>B_out, CLK=>CLK, EN=>B_EN);
REG_C: register8 port map(data_in=>data, data_out=>C_out, CLK=>CLK, EN=>C_EN);
REG_D: register8 port map(data_in=>data, data_out=>D_out, CLK=>CLK, EN=>D_EN);
REG_E: register8 port map(data_in=>data, data_out=>E_out, CLK=>CLK, EN=>E_EN);
REG_H: register8 port map(data_in=>data, data_out=>H_out, CLK=>CLK, EN=>H_EN);
REG_L: register8 port map(data_in=>data, data_out=>L_out, CLK=>CLK, EN=>L_EN);
REG_SP: register16 port map(data_in=>H_out&L_out, data_out=>SP_out, CLK=>CLK, EN=>SP_EN);
REG_PC: register16 port map(data_in=>H_out&L_out, data_out=>PC_out, CLK=>CLK, EN=>PC_EN);

process(register_select) begin
	data <= (others=>'Z');
	B_EN<='0'; C_EN<='0'; D_EN<='0'; E_EN<='0'; H_EN<='0'; L_EN<='0';
	case register_select is
		when "000010"=> data <= B_out;
		when "000110"=> data <= C_out;
		when "001010"=> data <= D_out;
		when "001110"=> data <= E_out;
		when "010010"=> data <= H_out;
		when "010110"=> data <= L_out;
		when "000001"=> B_EN <= '1';
		when "000101"=> C_EN <= '1';
		when "001001"=> D_EN <= '1';
		when "001101"=> E_EN <= '1';
		when "010001"=> H_EN <= '1';
		when "010101"=> L_EN <= '1';
		when others=>null;
	end case;
end process;
end REGISTER_ARRAY_arch;
