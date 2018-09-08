library ieee;
library work;
use ieee.std_logic_1164.all;
use work.pkg.all;

entity REGISTER_ARRAY is port(
	CLK: in std_logic;
	data: inout std_logic_vector(7 downto 0);
	address: out std_logic_vector(15 downto 0);
	register_select: in std_logic_vector(3 downto 0);
	load, put, inc, dec: in std_logic := '0';
	load_a, put_a: out std_logic;
	clr_pc: in std_logic
	);
end REGISTER_ARRAY;

architecture REGISTER_ARRAY_arch of REGISTER_ARRAY is 
signal W_out, Z_out, B_out, C_out, D_out, E_out, H_out, L_out: std_logic_vector(7 downto 0);
signal SP_out, PC_out: std_logic_vector(15 downto 0);
signal W_EN, Z_EN, B_EN, C_EN, D_EN, E_EN, H_EN, L_EN, SP_EN, PC_EN: std_logic := '0';
signal data_buffer: std_logic_vector(7 downto 0);
signal latch_input, latch_output: std_logic_vector(15 downto 0);
signal reg_in_buff_high, reg_in_buff_low: std_logic_vector(7 downto 0);
signal sign: std_logic_vector(2 downto 0);
begin
REG_W: register8 port map(data_in=>reg_in_buff_high, data_out=>W_out, CLK=>CLK, EN=>W_EN);
REG_Z: register8 port map(data_in=>reg_in_buff_low, data_out=>Z_out, CLK=>CLK, EN=>Z_EN);
REG_B: register8 port map(data_in=>reg_in_buff_high, data_out=>B_out, CLK=>CLK, EN=>B_EN);
REG_C: register8 port map(data_in=>reg_in_buff_low, data_out=>C_out, CLK=>CLK, EN=>C_EN);
REG_D: register8 port map(data_in=>reg_in_buff_high, data_out=>D_out, CLK=>CLK, EN=>D_EN);
REG_E: register8 port map(data_in=>reg_in_buff_low, data_out=>E_out, CLK=>CLK, EN=>E_EN);
REG_H: register8 port map(data_in=>reg_in_buff_high, data_out=>H_out, CLK=>CLK, EN=>H_EN);
REG_L: register8 port map(data_in=>reg_in_buff_low, data_out=>L_out, CLK=>CLK, EN=>L_EN);
REG_SP: register16 port map(data_in=>reg_in_buff_high&reg_in_buff_low, data_out=>SP_out, CLK=>CLK, EN=>SP_EN);
REG_PC: register16 port map(data_in=>reg_in_buff_high&reg_in_buff_low, data_out=>PC_out, CLK=>CLK, EN=>PC_EN, CLR=>clr_pc);

LATCH: inc_dec_latch port map(A=>latch_input, S=>latch_output, inc_decN=>inc);
sign(2) <= put;
sign(1) <= load;
sign(0) <= inc or dec;
process(register_select) begin
	data <= (others=>'Z');
	address <= (others=>'Z');
	W_EN<='0'; Z_EN<='0'; put_a <= '0'; load_a <= '0';
	B_EN<='0'; C_EN<='0'; D_EN<='0'; E_EN<='0'; H_EN<='0'; L_EN<='0'; SP_EN<='0'; PC_EN<='0';
	reg_in_buff_high <= data;
	reg_in_buff_low <= data;
	latch_input <= (others=>'0');
	case sign is
		when "100"=>  -- put data to bus 
			case register_select is
				when "0000"=> data <= B_out;
				when "0001"=> data <= C_out;
				when "0010"=> data <= D_out;
				when "0011"=> data <= E_out;
				when "0100"=> data <= H_out;
				when "0101"=> data <= L_out;
				when "1000"=> address <= B_out & C_out;
				when "1001"=> address <= D_out & E_out;
				when "1010"=> address <= H_out & L_out;
				when "0110"=> data <= PC_out(15 downto 8);
				when "0111"=> data <= PC_out(7 downto 0);
				when "1011"=> address <= SP_out;
				when "1100"=> data <= W_out;
				when "1101"=> data <= Z_out;
				when "1110"=> address <= W_out & Z_out;
				when "1111"=> address <= PC_out;
			end case;
		when "010"=>  -- load data
			case register_select is 
				when "0000"=> B_EN <= '1';
				when "0001"=> C_EN <= '1';
				when "0010"=> D_EN <= '1';
				when "0011"=> E_EN <= '1';
				when "0100"=> H_EN <= '1';
				when "0101"=> L_EN <= '1';
				when "1100"=> W_EN <= '1';
				when "1101"=> Z_EN <= '1';
				when "1011"=> reg_in_buff_high <= H_out; reg_in_buff_low <= L_out; SP_EN <= '1';
				when "1010"=> reg_in_buff_high <= W_out; reg_in_buff_low <= Z_out; SP_EN <= '1';
				when "1111"=> reg_in_buff_high <= H_out; reg_in_buff_low <= L_out; PC_EN <= '1';
				when "1110"=> reg_in_buff_high <= W_out; reg_in_buff_low <= Z_out; PC_EN <= '1';
				when "0111"=> load_a <= '1';
				when "1000"=> reg_in_buff_high <= SP_out(15 downto 8); 
								  reg_in_buff_low <= SP_out(7 downto 0);
								  W_EN <= '1'; Z_EN <= '1';
				when "1001"=> reg_in_buff_high <= PC_out(15 downto 8); 
								  reg_in_buff_low <= PC_out(7 downto 0);
								  W_EN <= '1'; Z_EN <= '1';
				when others=> null;
			end case;
		when "001"=>  -- increse or decrese.
			reg_in_buff_high <= latch_output(15 downto 8);
			reg_in_buff_low <= latch_output(7 downto 0);
			case register_select is
				when "1000"=> latch_input <= B_out & C_out; B_EN <= '1'; C_EN <= '1';
				when "1001"=> latch_input <= D_out & E_out; D_EN <= '1'; E_EN <= '1';
				when "1010"=> latch_input <= H_out & L_out; H_EN <= '1'; L_EN <= '1';
				when "1011"=> latch_input <= SP_out; SP_EN <= '1';
				when "1111"=> latch_input <= PC_out; PC_EN <= '1';
				when others=> null;  -- can't exist
			end case;
		when others=>null;
	end case;
		
end process;
end REGISTER_ARRAY_arch;
