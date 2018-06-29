library ieee;
library work;
use ieee.std_logic_1164.all;
use work.pkg.all;


entity timing_control is port(
	IR_input: in std_logic_vector(7 downto 0);
	bM, bT: in std_logic_vector(7 downto 0);
	
	ready, reset: in std_logic;
	
	RST, nextM, nextT, CLR: out std_logic;
	regarr_cs: out std_logic_vector(3 downto 0);
	regarr_load, regarr_put, regarr_inc, regarr_dec: out std_logic;
	addrbuff_load: out std_logic;
	ireg_load: out std_logic;
	databuff_load_bus, databuff_load_inner, databuff_put_inner, databuff_put_bus, databuffclr_pc: out std_logic;
	flag_load_bus, flag_put_bus, flag_load_alu, flag_STC: out std_logic;
	alu_s: out std_logic_vector(3 downto 0);
	alu_put: out std_logic;
	tmp_load, tmp_put: out std_logic;
	acc_load, acc_put: out std_logic
);
end timing_control;

architecture timing_control_arch of timing_control is
signal IR: std_logic_vector(7 downto 0);
begin
IR(7 downto 6) <= IR_input(7 downto 6);
databuffclr_pc <= reset;
CLR <= reset;
process(IR, bM, bT) begin
	case IR_input(7 downto 6) is
		when "01"=>
			if(IR_input(5 downto 3) /= "110") then IR(5 downto 3) <= "000";
			else IR(5 downto 3) <= "110"; end if;
			if(IR_input(2 downto 0) /= "110") then  IR(2 downto 0) <= "000";
			else IR(2 downto 0) <= "110"; end if;
		when "11"=>
			if (IR_input(2 downto 0) = "010" or IR_input(2 downto 0) = "100" or
				 IR_input(2 downto 0) = "000" or IR_input(2 downto 0) = "111" or 
				 IR_input(3 downto 0) = "0101" or IR_input(3 downto 0) = "0001" ) then 
				IR(5 downto 3) <= "000";
			else IR(5 downto 3) <= IR_input(5 downto 3);
			end if;
			IR(2 downto 0) <= IR_input(2 downto 0);
		when "10"=>
			IR(5 downto 3) <= IR_input(5 downto 3);
			if (IR_input(2 downto 0) /= "110") then IR(2 downto 0) <= "000"; 
			else IR(2 downto 0) <= "110"; end if;
		when "00"=>
			if ((IR_input(2 downto 0) = "100" or IR_input(2 downto 0) = "101") 
					and IR_input(5 downto 3) /= "110") then 
						IR(5 downto 3) <= "000";
			elsif (IR_input(3 downto 0) = "0001" or
					 IR_input(3 downto 0) = "1010" or
					 IR_input(3 downto 0) = "0010" or
					 IR_input(3 downto 0) = "0011" or
					 IR_input(3 downto 0) = "1011" or
					 IR_input(3 downto 0) = "1001") then
						IR(5 downto 3) <= "00" & IR_input(3);
			end if;
			IR(2 downto 0) <= IR_input(2 downto 0);
		end case;
	RST<='0'; nextM<='0'; nextT<='0'; regarr_cs<="0000"; regarr_load<='0'; regarr_put<='0';
	regarr_inc<='0'; regarr_dec<='0'; addrbuff_load<='0'; ireg_load<='0'; databuff_load_bus<='0';
	databuff_load_inner<='0'; databuff_put_bus<='0'; databuff_put_bus<='0';
	flag_load_bus<='0'; flag_put_bus<='0'; flag_load_alu<='0'; flag_STC<='0';
	alu_s<="0000"; alu_put<='0'; tmp_load<='0'; tmp_put<='0'; acc_load<='0'; acc_put<='0';
	
	regarr_cs <= onn("1111", bM(0) and (bT(0) or BT(1)));
	regarr_put <= bM(0) and bT(0);
	nextT <= bM(0) and (bT(0) or (bT(1) and ready) or bT(2));
	addrbuff_load <= bM(0) and bT(0);
	regarr_inc <= bM(0) and bT(1);
	databuff_load_bus <= bM(0) and bT(1);
	databuff_put_inner <= bM(0) and bT(2);
	ireg_load <= bM(0) and bT(2);
	
	case IR is
		when "01000000"=> null; -- 1 MOV r, r
		when "01000110"=> null; -- 2 MOV r, M
		when "01110000"=> null; -- 3 MOV M, r
		when "11111001"=> null; -- 4 SPHL;
		when "00000110"=> null; -- 5 MVI r, data
		when "00110110"=> null; -- 6 MVI M, data;
		when "00000001"=> null; -- 7 LXI rp, data
		when "00111010"=> null; -- 8 LDA addr;
		when "00110010"=> null; -- 9 STA addr;
		when "00101010"=> null; -- 10 LHLD addr;
		when "00100010"=> null; -- 11SHLD addr;
		when "00001010"=> null; -- 12 LDAX rp
		when "00000010"=> null; -- 13 STAX rp; 
		when "11101011"=> null; -- 14 XCHG
		when "10000000"=> null; -- 15 ADD r
		when "10000110"=> null; -- 16 ADD M
		when "11000110"=> null; -- 17 ADI data
		when "10001000"=> null; -- 18 ADC r
		when "10001110"=> null; -- 19 ADC M
		when "11001110"=> null; -- 20 ACI data
		when "10010000"=> null; -- 21 SUB r
		when "10010110"=> null; -- 22 SUB M
		when "11010110"=> null; -- 23 SUI data
		when "10011000"=> null; -- 24 SBB r
		when "10011110"=> null; -- 25 SBB M
		when "11011110"=> null; -- 26 SBI data
		when "00000100"=> null; -- 27 INR r
		when "00110100"=> null; -- 28 INR M
		when "00000101"=> null; -- 29 DCR r
		when "00110101"=> null; -- 30 DCR M
		when "00000011"=> null; -- 31 INX rp
		when "00001011"=> null; -- 32 DCX rp
		when "00001001"=> null; -- 33 DAD rp
		when "00100111"=> null; -- 34 DAA
		when "10100000"=> null; -- 35 ANA r
		when "10100110"=> null; -- 36 ANA M
		when "11100110"=> null; -- 37 ANI data
		when "10101000"=> null; -- 38 XRA M
		when "10101110"=> null; -- 39 XRA M
		when "11101110"=> null; -- 40 XRA data
		when "10110000"=> null; -- 41 ORA r
		when "10110110"=> null; -- 42 ORA data
		when "11110110"=> null; -- 43 ORI data
		when "10111000"=> null; -- 44 CMP r
		when "10111110"=> null; -- 45 CMP M
		when "11111110"=> null; -- 46 CPI data
		when "00000111"=> null; -- 47 RLC
		when "00001111"=> null; -- 48 RRC
		when "00010111"=> null; -- 49 RAL
		when "00011111"=> null; -- 50 RAR
		when "00101111"=> null; -- 51 CMA
		when "00111111"=> null; -- 52 CMC
		when "00110111"=> null; -- 53 STC
		when "11000011"=> null; -- 54 JMP addr
		when "11000010"=> null; -- 55 J cond addr
		when "11001101"=> null; -- 56 CALL addr
		when "11000100"=> null; -- 57 C cond addr
		when "11001001"=> null; -- 58 RET
		when "11000000"=> null; -- 59 R cond addr
		when "11000111"=> null; -- 60 RST n
		when "11101001"=> null; -- 61 PCHL
		when "11000101"=> null; -- 62 PUSH rp
		when "11110101"=> null; -- 63 PUSH PSW
		when "11000001"=> null; -- 64 POP rp
		when "11110001"=> null; -- 65 POP PSW
		when "11100011"=> null; -- 66 XTHL
		when "11011011"=> null; -- 67 IN port
		when "11010011"=> null; -- 68 OUT port
		when "11111011"=> null; -- 69 EI
		when "11110011"=> null; -- 70 DI
		when "01110110"=> null; -- 71 HLT
		when "00000000"=> null; -- 72 NOP
		when others=> null;
	end case;
end process;
end timing_control_arch;