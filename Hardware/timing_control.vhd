library ieee;
library work;
use ieee.std_logic_1164.all;
use work.pkg.all;


entity timing_control is port(
	IR_input: in std_logic_vector(7 downto 0);
	bM, bT: in std_logic_vector(7 downto 0);
	
	ready, reset: in std_logic;
	flag_reg: in std_logic_vector(7 downto 0);
	
	RST, nextM, nextT, CLR: out std_logic;
	regarr_cs: out std_logic_vector(3 downto 0);
	regarr_load, regarr_put, regarr_inc, regarr_dec: out std_logic;
	addrbuff_load: out std_logic;
	ireg_load: out std_logic;
	databuff_load_data, databuff_load_inner, databuff_put_inner, databuff_put_data, databuffclr_pc: out std_logic;
	flag_load_bus, flag_put_bus, flag_load_alu, flag_STC: out std_logic;
	alu_s: out std_logic_vector(3 downto 0);
	alu_put: out std_logic;
	tmp_load, tmp_put: out std_logic;
	acc_load, acc_put: out std_logic;
	tmp_clr: out std_logic;
	key_flag: in std_logic;
	key_clr, EI, DI: out std_logic;
	nnn: out std_logic_vector(15 downto 0)
);
end timing_control;

architecture timing_control_arch of timing_control is
signal IR: std_logic_vector(7 downto 0);
signal t1, t2, t3, t4, t5, t6, t7: std_logic;
signal m1, m2, m3, m4, m5, m6, m7: std_logic;
signal CF, ZF, AF, PF, SF, EF: std_logic;
signal sss, ddd: std_logic_vector(2 downto 0);
signal rp: std_logic_vector(1 downto 0);
signal success, in_interrupt: std_logic := '0';
begin
t1 <= bT(0); t2 <= bT(1); t3 <= bT(2); t4 <= bT(3); t5 <= bT(4); t6 <= bT(5); t7 <= bT(6);
m1 <= bM(0); m2 <= bM(1); m3 <= bM(2); m4 <= bM(3); m5 <= bM(4); m6 <= bM(5); m7 <= bM(6);
CF <= flag_reg(0); AF <= flag_reg(1); PF<=flag_reg(2); ZF<=flag_reg(3); SF<=flag_reg(4); EF<=flag_reg(7);
ddd <= IR_input(5 downto 3);
sss <= IR_input(2 downto 0);
rp <= IR_input(5 downto 4);
databuffclr_pc <= reset;
CLR <= reset;
process(IR, bM, bT, IR_input) begin
	IR <= IR_input;
	case IR_input(7 downto 6) is
		when "01"=>
			if(ddd /= "110") then IR(5 downto 3) <= "000"; end if;
			if(sss /= "110") then IR(2 downto 0) <= "000"; end if;
		when "10"=>
			if(sss /= "110") then IR(2 downto 0) <= "000"; end if;
		when "11"=>
			if(sss = "111" or sss = "000" or sss = "100" or sss="010") then
				IR(5 downto 3) <= "000"; 
			end if;
		when "00"=>
			if (ddd /= "110" and (sss = "110" or sss = "100" or sss = "101")) then
				IR(5 downto 3) <= "000";
			end if;
		end case;
	RST<='0'; nextM<='0'; nextT<='0'; regarr_cs<="0000"; regarr_load<='0'; regarr_put<='0';
	regarr_inc<='0'; regarr_dec<='0'; addrbuff_load<='0'; ireg_load<='0'; databuff_load_data<='0';
	databuff_load_inner<='0'; databuff_put_data<='0'; databuff_put_inner<='0';
	flag_load_bus<='0'; flag_put_bus<='0'; flag_load_alu<='0'; flag_STC<='0';
	alu_s<="0000"; alu_put<='0'; tmp_load<='0'; tmp_put<='0'; acc_load<='0'; acc_put<='0';
	success <= '0'; tmp_clr <= '0'; key_clr <= '0'; EI <='0'; DI<='0';
	nnn <= "0000000000"&ddd&"000";
	
	if ((m1 and t1 and key_flag) = '1' or in_interrupt = '1') then
		key_clr <= '1';
		nnn <= "0000000100000000";
		nextM <= (m1 and t1) or (m2 and t6);
		regarr_cs <= onn("1001", m1 and t1) or
						 onn("1100", m2 and t1) or onn("1101", m2 and t4) or 
						 onn("1011", m2 and (t2 or t3 or t5 or t6)) or
						 onn("0110", m3 and t1);
		regarr_load <= (m1 and t1) or (m3 and t1);
		regarr_put <= m2 and (t1 or t2 or t4 or t5);
		databuff_load_inner <= m2 and (t1 or t4);
		addrbuff_load <= m2 and (t2 or t5);
		regarr_dec <= m2 and (t3 or t6);
		databuff_put_data <= m2 and (t3 or t6);
		nextT <= m2 and (t1 or t2 or t3 or t4 or t5);
		RST <= m3 and t1;
		in_interrupt <= not (m3 and t1);
	else
	if ((m1 and (t1 or t2 or t3)) = '1') then 
		regarr_cs <= onn("1111", m1 and (t1 or t2));
		regarr_put <= m1 and t1;
		addrbuff_load <= m1 and t1;
		regarr_inc <= m1 and t2;
		databuff_load_data <= m1 and t2;
		databuff_put_inner <= m1 and t3;
		ireg_load <= m1 and t3;
		nextT <= m1 and (t1 or t2 or t3);
	else
	case IR is
		when "01000000"=>  -- 1 MOV r, r
			regarr_cs <= onn("0"&sss, m1 and t4) or onn("0"&ddd, m1 and t5);
			regarr_put <= m1 and t4;
			tmp_load <= m1 and t4;
			tmp_put <= m1 and t5;
			nextT <= m1 and t4;
			regarr_load <= m1 and t5;
			RST <= m1 and t5;
		when "01000110"=> -- 2 MOV r, M
			nextM <= (m1 and t4) or (m2 and t3);
			regarr_cs <= onn("1111", (m2 or m3) and (t1 or t2)) or 
							 onn("1100", m2 and t3) or onn("1101", m3 and t3)or
							 onn("1110", m4 and t1) or 
							 onn("0"&ddd, m4 and t3);
			addrbuff_load <= (m2 or m3 or m4) and t1;
			regarr_put <= (m2 or m3 or m4) and t1;
			regarr_inc <= (m2 or m3) or t2;
			databuff_load_data <= (m2 or m3 or m4) and t2;
			databuff_put_inner <= (m2 or m3 or m4) and t3;
			regarr_load <= m4 and t3;
			nextT <= (m2 or m3 or m4) and (t1 or t2);
			RST <= m4 and t3;
		when "01110000"=> -- 3 MOV M, r
			nextM <= (m1 and t4) or ((m2 or m3) and t3);
			nextT <= ((m2 or m3 or m4) and (t1 or t2));
			regarr_cs <= onn("1111", (m2 or m3) and (t1 or t2)) or onn("0"&sss, m4 and t1)
						or onn("1101", m2 and t3) or onn("1100", m3 and t3)
						or onn("1110", m4 and t2);
			regarr_put <= (m2 or m3 or m4) and t1;
			addrbuff_load <= ((m2 or m3) and t1) or (m4 and t2);
			regarr_inc <= (m2 or m3) and t2;
			databuff_load_data <= (m2 or m3) and t2;
			databuff_load_inner <= m4 and t1;
			databuff_put_inner <= (m2 or m3) and t3;
			regarr_load <= (m2 or m3) and t3;
			databuff_put_data <= m4 and t3;
			RST <= m4 and t3;
		when "11111001"=> -- 4 SPHL;
			regarr_cs <= onn("1011", m1 and t4);
			regarr_load <= m1 and t4;
			RST <= m1 and t4;
		when "00000110"=> -- 5 MVI r, data
			nextM <= m1 and t4;
			regarr_cs <= onn("1111", m2 and (t1 or t2)) or onn("0"&ddd, m2 and t3);
			regarr_put <= m2 and t1;
			addrbuff_load <= m2 and t1;
			regarr_load <= m2 and t3;
			regarr_inc <= m2 and t2;
			databuff_load_data <= m2 and t2;
			databuff_put_inner <= m2 and (t2 or t3);
			nextT <= m2 and (t1 or t2 or t3);
			RST <= m2 and t3;
		when "00110110"=> -- 6 MVI M, data;
			nextM <= (m1 and t4) or ((m2 or m3) and t3);
			nextT <= ((m2 or m3 or m4) and (t1 or t2)) or (m4 and t3);
			regarr_cs <= onn("1111", (m2 or m3 or m4) and (t1 or t2)) 
						or onn("1101", m2 and t3) or onn("1100", m3 and t3)
						or onn("1110", m4 and t3);
			regarr_put <= (m2 or m3 or m4) and t1;
			addrbuff_load <= ((m2 or m3 or m4) and t1) or (m4 and t3);
			regarr_inc <= (m2 or m3 or m4) and t2;
			databuff_load_data <= (m2 or m3 or m4) and t2;
			databuff_put_inner <= (m2 or m3) and t3;
			regarr_load <= (m2 or m3) and t3;
			databuff_put_data <= m4 and t4;
			RST <= m4 and t4;
		when "00000001"=> null; -- 7 LXI rp, data
		when "00111010"=> null; -- 8 LDA addr;
		when "00110010"=> null; -- 9 STA addr;
		when "00101010"=> null; -- 10 LHLD addr;
		when "00100010"=> null; -- 11 SHLD addr;
		when "00001010"=> -- 12 LDAX B
			regarr_cs <= onn("1000", m1 and t4);
			regarr_put <= m1 and t4;
			addrbuff_load <= m1 and t4;
			acc_load <= m1 and t6;
			databuff_load_data <= m1 and t5;
			databuff_put_inner <= m1 and t6;
			nextT <= m1 and (t4 or t5);
			RST <= m1 and t6;
		when "00011010"=> -- 12 LDAX D
			regarr_cs <= onn("1001", m1 and t4);
			regarr_put <= m1 and t4;
			addrbuff_load <= m1 and t4;
			acc_load <= m1 and t6;
			databuff_load_data <= m1 and t5;
			databuff_put_inner <= m1 and t6;
			nextT <= m1 and (t4 or t5);
			RST <= m1 and t6;
		when "00000010"=> -- 13 STAX B; 
			regarr_cs <= onn("1000", m1 and t4);
			regarr_put <= m1 and t4;
			acc_put <= m1 and t4;
			databuff_load_inner <= m1 and t4;
			databuff_put_data <= m1 and t5;
			addrbuff_load <= m1 and t4;
			nextT <= m1 and t4;
			RST <= m1 and t5;
		when "00010010"=> -- 13 STAX D; 
			regarr_cs <= onn("1001", m1 and t4);
			regarr_put <= m1 and t4;
			acc_put <= m1 and t4;
			databuff_load_inner <= m1 and t4;
			databuff_put_data <= m1 and t5;
			addrbuff_load <= m1 and t4;
			nextT <= m1 and t4;
			RST <= m1 and t5;
		when "11101011"=> null; -- 14 XCHG
		when "10000000"=>  -- 15 ADD r
			regarr_cs <= onn("0"&sss, m1 and t4);
			regarr_put <= m1 and t4;
			tmp_load <= m1 and t4;
			alu_s <= onn("0010", m1 and t5);
			alu_put <= m1 and t5;
			flag_load_alu <= m1 and t5;
			acc_load <= m1 and t5;
			nextT <= m1 and t4;
			RST <= m1 and t5;
		when "10000110"=> -- 16 ADD M
			nextM <= (m1 and t4) or (m2 and t3);
			regarr_cs <= onn("1111", (m2 or m3) and (t1 or t2)) or 
							 onn("1100", m2 and t3) or onn("1101", m3 and t3)or
							 onn("1110", m4 and t1); 
			addrbuff_load <= (m2 or m3 or m4) and t1;
			regarr_put <= (m2 or m3 or m4) and t1;
			regarr_inc <= (m2 or m3) or t2;
			databuff_load_data <= (m2 or m3 or m4) and t2;
			databuff_put_inner <= (m2 or m3 or m4) and t3;
			tmp_load <= m4 and t3;
			alu_s <= onn("0010", m4 and t4);
			flag_load_alu <= m4 and t4;
			alu_put <= m4 and t4;
			acc_load <= m4 and t4;
			nextT <= ((m2 or m3 or m4) and (t1 or t2)) or (m4 and t4);
			RST <= m4 and t4;
		when "11000110"=> -- 17 ADI data
			nextM <= m1 and t4;
			regarr_cs <= onn("1111", m2 and (t1 or t2));
			addrbuff_load <= m2 and t1;
			regarr_put <= m2 and t1;
			databuff_load_data <= m2 and t2;
			regarr_inc <= m2 and t2;
			databuff_put_inner <= m2 and t3;
			tmp_load <= m2 and t3;
			alu_s <= onn("0010", m2 and t4);
			flag_load_alu <= m2 and t4;
			alu_put <= m2 and t4;
			acc_load <= m2 and t4;
			RST <= m2 and t4;
			nextT <= m2 and (t1 or t2 or t3);
		when "10001000"=> -- 18 ADC r
			regarr_cs <= onn("0"&sss, m1 and t4);
			regarr_put <= m1 and t4;
			tmp_load <= m1 and t4;
			alu_s <= onn("0011", m1 and t5);
			alu_put <= m1 and t5;
			flag_load_alu <= m1 and t5;
			acc_load <= m1 and t5;
			nextT <= m1 and t4;
			RST <= m1 and t5;
		when "10001110"=> -- 19 ADC M
			nextM <= (m1 and t4) or (m2 and t3);
			regarr_cs <= onn("1111", (m2 or m3) and (t1 or t2)) or 
							 onn("1100", m2 and t3) or onn("1101", m3 and t3)or
							 onn("1110", m4 and t1); 
			addrbuff_load <= (m2 or m3 or m4) and t1;
			regarr_put <= (m2 or m3 or m4) and t1;
			regarr_inc <= (m2 or m3) or t2;
			databuff_load_data <= (m2 or m3 or m4) and t2;
			databuff_put_inner <= (m2 or m3 or m4) and t3;
			tmp_load <= m4 and t3;
			alu_s <= onn("0011", m4 and t4);
			flag_load_alu <= m4 and t4;
			alu_put <= m4 and t4;
			acc_load <= m4 and t4;
			nextT <= ((m2 or m3 or m4) and (t1 or t2)) or (m4 and t4);
			RST <= m4 and t4;
		when "11001110"=> -- 20 ACI data
			nextM <= m1 and t4;
			regarr_cs <= onn("1111", m2 and (t1 or t2));
			addrbuff_load <= m2 and t1;
			regarr_put <= m2 and t1;
			databuff_load_data <= m2 and t2;
			regarr_inc <= m2 and t2;
			databuff_put_inner <= m2 and t3;
			tmp_load <= m2 and t3;
			alu_s <= onn("0011", m2 and t4);
			flag_load_alu <= m2 and t4;
			alu_put <= m2 and t4;
			acc_load <= m2 and t4;
			RST <= m2 and t4;
			nextT <= m2 and (t1 or t2 or t3);
		when "10010000"=>  -- 21 SUB r
			regarr_cs <= onn("0"&sss, m1 and t4);
			regarr_put <= m1 and t4;
			tmp_load <= m1 and t4;
			alu_s <= onn("0100", m1 and t5);
			alu_put <= m1 and t5;
			flag_load_alu <= m1 and t5;
			acc_load <= m1 and t5;
			nextT <= m1 and t4;
			RST <= m1 and t5;
		when "10010110"=> -- 22 SUB M
			nextM <= (m1 and t4) or (m2 and t3);
			regarr_cs <= onn("1111", (m2 or m3) and (t1 or t2)) or 
							 onn("1100", m2 and t3) or onn("1101", m3 and t3)or
							 onn("1110", m4 and t1); 
			addrbuff_load <= (m2 or m3 or m4) and t1;
			regarr_put <= (m2 or m3 or m4) and t1;
			regarr_inc <= (m2 or m3) or t2;
			databuff_load_data <= (m2 or m3 or m4) and t2;
			databuff_put_inner <= (m2 or m3 or m4) and t3;
			tmp_load <= m4 and t3;
			alu_s <= onn("0100", m4 and t4);
			flag_load_alu <= m4 and t4;
			alu_put <= m4 and t4;
			acc_load <= m4 and t4;
			nextT <= ((m2 or m3 or m4) and (t1 or t2)) or (m4 and t4);
			RST <= m4 and t4;
		when "11010110"=> -- 23 SUI data
			nextM <= m1 and t4;
			regarr_cs <= onn("1111", m2 and (t1 or t2));
			addrbuff_load <= m2 and t1;
			regarr_put <= m2 and t1;
			databuff_load_data <= m2 and t2;
			regarr_inc <= m2 and t2;
			databuff_put_inner <= m2 and t3;
			tmp_load <= m2 and t3;
			alu_s <= onn("0100", m2 and t4);
			flag_load_alu <= m2 and t4;
			alu_put <= m2 and t4;
			acc_load <= m2 and t4;
			RST <= m2 and t4;
			nextT <= m2 and (t1 or t2 or t3);
		when "10011000"=> -- 24 SBB r
			regarr_cs <= onn("0"&sss, m1 and t4);
			regarr_put <= m1 and t4;
			tmp_load <= m1 and t4;
			alu_s <= onn("0101", m1 and t5);
			alu_put <= m1 and t5;
			flag_load_alu <= m1 and t5;
			acc_load <= m1 and t5;
			nextT <= m1 and t4;
			RST <= m1 and t5;
		when "10011110"=> -- 25 SBB M
			nextM <= (m1 and t4) or (m2 and t3);
			regarr_cs <= onn("1111", (m2 or m3) and (t1 or t2)) or 
							 onn("1100", m2 and t3) or onn("1101", m3 and t3)or
							 onn("1110", m4 and t1); 
			addrbuff_load <= (m2 or m3 or m4) and t1;
			regarr_put <= (m2 or m3 or m4) and t1;
			regarr_inc <= (m2 or m3) or t2;
			databuff_load_data <= (m2 or m3 or m4) and t2;
			databuff_put_inner <= (m2 or m3 or m4) and t3;
			tmp_load <= m4 and t3;
			alu_s <= onn("0101", m4 and t4);
			flag_load_alu <= m4 and t4;
			alu_put <= m4 and t4;
			acc_load <= m4 and t4;
			nextT <= ((m2 or m3 or m4) and (t1 or t2)) or (m4 and t4);
			RST <= m4 and t4;
		when "11011110"=> -- 26 SBI data
			nextM <= m1 and t4;
			regarr_cs <= onn("1111", m2 and (t1 or t2));
			addrbuff_load <= m2 and t1;
			regarr_put <= m2 and t1;
			databuff_load_data <= m2 and t2;
			regarr_inc <= m2 and t2;
			databuff_put_inner <= m2 and t3;
			tmp_load <= m2 and t3;
			alu_s <= onn("0101", m2 and t4);
			flag_load_alu <= m2 and t4;
			alu_put <= m2 and t4;
			acc_load <= m2 and t4;
			RST <= m2 and t4;
		when "00000100"=> -- 27 INR r
			nextT <= m1 and t4;
			regarr_cs <= onn("0"&ddd, m1 and (t4 or t5));
			regarr_put <= m1 and t4;
			tmp_load <= m1 and t4;
			alu_s <= onn("0000", m1 and t5);
			alu_put <= m1 and t5;
			flag_load_alu <= m1 and t5;
			regarr_load <= m1 and t5;
			RST <= m1 and t5;
		when "00110100"=> null; -- 28 INR M
		when "00000101"=> -- 29 DCR r
			nextT <= m1 and t4;
			regarr_cs <= onn("0"&ddd, m1 and (t4 or t5));
			regarr_put <= m1 and t4;
			tmp_load <= m1 and t4;
			alu_s <= onn("0001", m1 and t5);
			alu_put <= m1 and t5;
			flag_load_alu <= m1 and t5;
			regarr_load <= m1 and t5;
			RST <= m1 and t5;
		when "00110101"=> null; -- 30 DCR M
		when "00000011"=> -- 31 INX B
			regarr_cs <= onn("1000", m1 and t4);
			regarr_inc <= m1 and t4;
			RST <= m1 and t4;
		when "00010011"=> -- 31 INX D
			regarr_cs <= onn("1001", m1 and t4);
			regarr_inc <= m1 and t4;
			RST <= m1 and t4;
		when "00100011"=> -- 31 INX H
			regarr_cs <= onn("1010", m1 and t4);
			regarr_inc <= m1 and t4;
			RST <= m1 and t4;
		when "00110011"=> -- 31 INX SP
			regarr_cs <= onn("1011", m1 and t4);
			regarr_inc <= m1 and t4;
			RST <= m1 and t4;
		when "00001011"=> -- 32 DCX B
			regarr_cs <= onn("1000", m1 and t4);
			regarr_dec <= m1 and t4;
			RST <= m1 and t4;
		when "00011011"=> -- 32 DCX D
			regarr_cs <= onn("1001", m1 and t4);
			regarr_dec <= m1 and t4;
			RST <= m1 and t4;
		when "00101011"=> -- 32 DCX H
			regarr_cs <= onn("1010", m1 and t4);
			regarr_dec <= m1 and t4;
			RST <= m1 and t4;
		when "00111011"=> -- 32 DCX SP
			regarr_cs <= onn("1011", m1 and t4);
			regarr_dec <= m1 and t4;
			RST <= m1 and t4;
		when "00001001"=> null; -- 33 DAD B
		when "00011001"=> null; -- 33 DAD D
		when "00101001"=> null; -- 33 DAD H
		when "00111001"=> null; -- 33 DAD SP
		when "00100111"=> null; -- 34 DAA
		when "10100000"=> -- 35 ANA r
			nextT <= m1 and t4;
			regarr_cs <= onn("0"&ddd, m1 and (t4 or t5));
			regarr_put <= m1 and t4;
			tmp_load <= m1 and t4;
			alu_s <= onn("0110", m1 and t5);
			alu_put <= m1 and t5;
			flag_load_alu <= m1 and t5;
			regarr_load <= m1 and t5;
			RST <= m1 and t5;
		when "10100110"=> null;-- 36 ANA M
		when "11100110"=> -- 37 ANI data
			nextM <= m1 and t4;
			nextT <= m2 and (t1 or t2 or t3);
			regarr_cs <= onn("1111", m2 and (t1 or t2));
			addrbuff_load <= m2 and t1;
			regarr_put <= m2 and t1;
			databuff_load_data <= m2 and t2;
			regarr_inc <= m2 and t2;
			databuff_put_inner <= m2 and t3;
			tmp_load <= m2 and t3;
			alu_s <= onn("0110", m2 and t4);
			flag_load_alu <= m2 and t4;
			alu_put <= m2 and t4;
			acc_load <= m2 and t4;
			RST <= m2 and t4;
		when "10101000"=> -- 38 XRA r
			nextT <= m1 and t4;
			regarr_cs <= onn("0"&ddd, m1 and (t4 or t5));
			regarr_put <= m1 and t4;
			tmp_load <= m1 and t4;
			alu_s <= onn("0111", m1 and t5);
			alu_put <= m1 and t5;
			flag_load_alu <= m1 and t5;
			regarr_load <= m1 and t5;
			RST <= m1 and t5;
		when "10101110"=> null; -- 39 XRA M
		when "11101110"=> -- 40 XRI data
			nextM <= m1 and t4;
			nextT <= m2 and (t1 or t2 or t3);
			regarr_cs <= onn("1111", m2 and (t1 or t2));
			addrbuff_load <= m2 and t1;
			regarr_put <= m2 and t1;
			databuff_load_data <= m2 and t2;
			regarr_inc <= m2 and t2;
			databuff_put_inner <= m2 and t3;
			tmp_load <= m2 and t3;
			alu_s <= onn("0111", m2 and t4);
			flag_load_alu <= m2 and t4;
			alu_put <= m2 and t4;
			acc_load <= m2 and t4;
			RST <= m2 and t4;
		when "10110000"=> -- 41 ORA r
			nextT <= m1 and t4;
			regarr_cs <= onn("0"&ddd, m1 and (t4 or t5));
			regarr_put <= m1 and t4;
			tmp_load <= m1 and t4;
			alu_s <= onn("1000", m1 and t5);
			alu_put <= m1 and t5;
			flag_load_alu <= m1 and t5;
			regarr_load <= m1 and t5;
			RST <= m1 and t5;
		when "10110110"=> null; -- 42 ORA M
		when "11110110"=> -- 43 ORI data
			nextM <= m1 and t4;
			nextT <= m2 and (t1 or t2 or t3);
			regarr_cs <= onn("1111", m2 and (t1 or t2));
			addrbuff_load <= m2 and t1;
			regarr_put <= m2 and t1;
			databuff_load_data <= m2 and t2;
			regarr_inc <= m2 and t2;
			databuff_put_inner <= m2 and t3;
			tmp_load <= m2 and t3;
			alu_s <= onn("1000", m2 and t4);
			flag_load_alu <= m2 and t4;
			alu_put <= m2 and t4;
			acc_load <= m2 and t4;
			RST <= m2 and t4;
		when "10111000"=>  -- 44 CMP r
			regarr_cs <= onn("0"&sss, m1 and t4);
			regarr_put <= m1 and t4;
			tmp_load <= m1 and t4;
			alu_s <= onn("0100", m1 and t5);
			flag_load_alu <= m1 and t5;
			nextT <= m1 and t4;
			RST <= m1 and t5;
		when "10111110"=> null; -- 45 CMP M
		when "11111110"=> -- 46 CPI data
			nextM <= m1 and t4;
			nextT <= m2 and (t1 or t2 or t3);
			regarr_cs <= onn("1111", m2 and (t1 or t2));
			addrbuff_load <= m2 and t1;
			regarr_put <= m2 and t1;
			databuff_load_data <= m2 and t2;
			regarr_inc <= m2 and t2;
			databuff_put_inner <= m2 and t3;
			tmp_load <= m2 and t3;
			alu_s <= onn("0100", m2 and t4);
			flag_load_alu <= m2 and t4;
			RST <= m2 and t4;
		when "00000111"=> -- 47 RLC
			alu_s <= onn("1100", m1 and t4);
			alu_put <= m1 and t4;
			acc_load <= m1 and t4;
			RST <= m1 and t4;
		when "00001111"=>  -- 48 RRC
			alu_s <= onn("1101", m1 and t4);
			alu_put <= m1 and t4;
			acc_load <= m1 and t4;
			flag_load_alu <= m1 and t4;
			RST <= m1 and t4;
		when "00010111"=> -- 49 RAL
			alu_s <= onn("1010", m1 and t4);
			alu_put <= m1 and t4;
			acc_load <= m1 and t4;
			flag_load_alu <= m1 and t4;
			RST <= m1 and t4;
		when "00011111"=> -- 50 RAR
			alu_s <= onn("1011", m1 and t4);
			alu_put <= m1 and t4;
			acc_load <= m1 and t4;
			flag_load_alu <= m1 and t4;
			RST <= m1 and t4;
		when "00101111"=> null; -- 51 CMA
		when "00111111"=> null; -- 52 CMC
		when "00110111"=> -- 53 STC
			flag_stc <= m1 and t4;
			RST <= m1 and t4;
		when "11000011"=>  -- 54 JMP addr
			nextM <= (m1 and t4) or (m2 and t3);
			addrbuff_load <= ((m2 or m3) and t1) or (m3 and t4);
			regarr_cs <= onn("1111", (m2 and (t1 or t2)) or (m3 and (t1 or t2))) or onn("1101", m2 and t3) 
								or onn("1100", m3 and t3) or onn("1110", m3 and t4);
			regarr_put <= (m2 or m3) and t1;
			regarr_inc <= (m2 or m3) and t2;
			databuff_load_data <= (m2 or m3) and t2;
			databuff_put_inner <= (m2 or m3) and t3;
			regarr_load <= ((m2 or m3) and t3) or (m3 and t4);
			nextT <= (m2 and (t1 or t2)) or (m3 and (t1 or t2 or t3));
			RST <= (m3 and t4) ;
		when "11000010"=>  -- 55 J cond addr
			if	((ddd="000" and ZF='0') or (ddd="001" and ZF='1') or (ddd="010" and CF='0') or
					 (ddd="011" and CF='1') or (ddd="100" and key_flag='0') or (ddd="101" and key_flag='1') or
					 (ddd="110" and SF='0') or (ddd="111" and SF='1')) then
					 success <= '1'; key_clr <= '1'; end if;
			nextM <= (m1 and t4) or (m2 and t3);
			addrbuff_load <= ((m2 or m3) and t1) or (m3 and t4);
			regarr_cs <= onn("1111", (m2 and (t1 or t2)) or (m3 and (t1 or t2))) or onn("1101", m2 and t3) 
								or onn("1100", m3 and t3) or onn("1110", m3 and t4);
			regarr_put <= (m2 or m3) and t1;
			regarr_inc <= (m2 or m3) and t2;
			databuff_load_data <= (m2 or m3) and t2;
			databuff_put_inner <= (m2 or m3) and t3;
			regarr_load <= ((m2 or m3) and t3) or (m3 and t4);
			nextT <= (m2 and (t1 or t2)) or (m3 and (t1 or t2 or (success and t3)));
			RST <= (m3 and t4) or (m3 and t3 and (not success));
		when "11001101"=> null; -- 56 CALL addr
		when "11000100"=> null; -- 57 C cond addr
		when "11001001"=> -- 58 RET
			nextM <= (m1 or m2) and t4;
			regarr_cs <= onn("1011", m2 and (t1 or t2)) or 
							 onn("1101", m2 and t4) or onn("1100", m3 and t4) or
							 onn("1110", m3 and t5);
			regarr_inc <= (m2 or m3) and t1;
			regarr_put <= (m2 or m3) and t2;
			addrbuff_load <= (m2 or m3) and t2;
			databuff_load_data <= (m2 or m3) and t3;
			databuff_put_inner <= (m2 or m3) and t4;
			regarr_load <= (m2 and t4) or (m3 and (t4 or t5));
			nextT <= ((m2 or m3) and (t1 or t2 or t3)) or (m3 and t5);
			RST <= m3 and t5;
		when "11000000"=> null; -- 59 R cond addr
		when "11000111"=>  -- 60 RST n
			nextM <= (m1 and t4) or (m2 and t6);
			regarr_cs <= onn("1001", m1 and t4) or
							 onn("1100", m2 and t1) or onn("1101", m2 and t4) or 
							 onn("1011", m2 and (t2 or t3 or t5 or t6)) or
							 onn("0110", m3 and t1);
			regarr_load <= (m1 and t4) or (m3 and t1);
			regarr_put <= m2 and (t1 or t2 or t4 or t5);
			databuff_load_inner <= m2 and (t1 or t4);
			addrbuff_load <= m2 and (t2 or t5);
			regarr_dec <= m2 and (t3 or t6);
			databuff_put_data <= m2 and (t3 or t6);
			nextT <= m2 and (t1 or t2 or t3 or t4 or t5);
			RST <= m3 and t1;
		when "11101001"=> -- 61 PCHL
			regarr_cs <= onn("1111", m1 and t4);
			regarr_load <= m1 and t4;
			RST <= m1 and t4;
		when "11000101"=> -- 62 PUSH B
			nextM <= m1 and t4;
			regarr_cs <= onn("0000", m2 and t1) or onn("0001", m2 and t4) or onn("1011", m2 and (t2 or t3 or t5 or t6));
			regarr_put <= m2 and (t1 or t2 or t4 or t5);
			databuff_load_inner <= m2 and (t1 or t4);
			addrbuff_load <= m2 and (t2 or t5);
			regarr_dec <= m2 and (t3 or t6);
			databuff_put_data <= m2 and (t3 or t6);
			nextT <= m2 and (t1 or t2 or t3 or t4 or t5);
			RST <= m2 and t6;
		when "11010101"=> -- 62 PUSH D
			nextM <= m1 and t4;
			regarr_cs <= onn("0010", m2 and t1) or onn("0011", m2 and t4) or onn("1011", m2 and (t2 or t3 or t5 or t6));
			regarr_put <= m2 and (t1 or t2 or t4 or t5);
			databuff_load_inner <= m2 and (t1 or t4);
			addrbuff_load <= m2 and (t2 or t5);
			regarr_dec <= m2 and (t3 or t6);
			databuff_put_data <= m2 and (t3 or t6);
			nextT <= m2 and (t1 or t2 or t3 or t4 or t5);
			RST <= m2 and t6;
		when "11100101"=> -- 62 PUSH H
			nextM <= m1 and t4;
			regarr_cs <= onn("0100", m2 and t1) or onn("0101", m2 and t4) or onn("1011", m2 and (t2 or t3 or t5 or t6));
			regarr_put <= m2 and (t1 or t2 or t4 or t5);
			databuff_load_inner <= m2 and (t1 or t4);
			addrbuff_load <= m2 and (t2 or t5);
			regarr_dec <= m2 and (t3 or t6);
			databuff_put_data <= m2 and (t3 or t6);
			nextT <= m2 and (t1 or t2 or t3 or t4 or t5);
			RST <= m2 and t6;
		when "11110101"=> -- 63 PUSH PSW
			nextM <= m1 and t4;
			regarr_cs <= onn("1011", m2 and (t2 or t3 or t5 or t6));
			regarr_put <= m2 and (t2 or t5);
			acc_put <= m2 and t1;
			flag_put_bus <= m2 and t4;
			databuff_load_inner <= m2 and (t1 or t4);
			addrbuff_load <= m2 and (t2 or t5);
			regarr_dec <= m2 and (t3 or t6);
			databuff_put_data <= m2 and (t3 or t6);
			nextT <= m2 and (t1 or t2 or t3 or t4 or t5);
			RST <= m2 and t6;
		when "11000001"=> -- 64 POP B
			nextM <= (m1 or m2) and t4;
			regarr_cs <= onn("1011", m2 and (t1 or t2)) or onn("0001", m2 and t4) or onn("0000", m3 and t4);
			regarr_inc <= (m2 or m3) and t1;
			regarr_put <= (m2 or m3) and t2;
			addrbuff_load <= (m2 or m3) and t2;
			databuff_load_data <= (m2 or m3) and t3;
			databuff_put_inner <= (m2 or m3) and t4;
			regarr_load <= (m2 or m3) and t4;
			nextT <= (m2 or m3) and (t1 or t2 or t3);
			RST <= m3 and t4;
		when "11010001"=> -- 64 POP D
			nextM <= (m1 or m2) and t4;
			regarr_cs <= onn("1011", m2 and (t1 or t2)) or onn("0011", m2 and t4) or onn("0010", m3 and t4);
			regarr_inc <= (m2 or m3) and t1;
			regarr_put <= (m2 or m3) and t2;
			addrbuff_load <= (m2 or m3) and t2;
			databuff_load_data <= (m2 or m3) and t3;
			databuff_put_inner <= (m2 or m3) and t4;
			regarr_load <= (m2 or m3) and t4;
			nextT <= (m2 or m3) and (t1 or t2 or t3);
			RST <= m3 and t4;
		when "11100001"=> -- 64 POP H
			nextM <= (m1 or m2) and t4;
			regarr_cs <= onn("1011", m2 and (t1 or t2)) or onn("0101", m2 and t4) or onn("0100", m3 and t4);
			regarr_inc <= (m2 or m3) and t1;
			regarr_put <= (m2 or m3) and t2;
			addrbuff_load <= (m2 or m3) and t2;
			databuff_load_data <= (m2 or m3) and t3;
			databuff_put_inner <= (m2 or m3) and t4;
			regarr_load <= (m2 or m3) and t4;
			nextT <= (m2 or m3) and (t1 or t2 or t3);
			RST <= m3 and t4;
		when "11110001"=> -- 65 POP PSW
			nextM <= (m1 or m2) and t4;
			regarr_cs <= onn("1011", m2 and (t1 or t2));
			regarr_inc <= (m2 or m3) and t1;
			regarr_put <= (m2 or m3) and t2;
			addrbuff_load <= (m2 or m3) and t2;
			databuff_load_data <= (m2 or m3) and t3;
			databuff_put_inner <= (m2 or m3) and t4;
			flag_load_bus <= m2 and t4;
			acc_load <= m3 and t4;
			nextT <= (m2 or m3) and (t1 or t2 or t3);
			RST <= m3 and t4;
		when "11100011"=> null; -- 66 XTHL
		when "11011011"=> -- 67 IN port
			nextM <= (m1 or m2) and t4;
			nextT <= (m2 and (t1 or t2 or t3)) or (m3 and (t1 or t2));
			regarr_cs <= onn("1111", m2 and (t1 or t2)) or onn("1101", m2 and t3) or onn("1100", m2 and t4) or onn("1110", m3 and t1);
			regarr_put <= (m2 and (t1 or t4)) or (m3 and t1);
			addrbuff_load <= (m2 and t1) or (m3 and t1);
			regarr_inc <= m2 and (t2 or t4);
			databuff_load_data <= (m2 or m3) and t2;
			databuff_put_inner <= (m2 or m3) and t3;
			regarr_load <= m2 and (t3 or t4);
			acc_load <= m3 and t3;
			RST <= m3 and t3;
		when "11010011"=> -- 68 OUT port
			-- both argarr put and load equals 1 at m2 and t4, means set all 1 on selected register.
			nextM <= (m1 or m2) and t4;
			nextT <= (m2 and (t1 or t2 or t3)) or (m3 and (t1 or t2));
			addrbuff_load <= (m2 and t1) or (m3 and t1);
			regarr_cs <= onn("1111", m2 and (t1 or t2)) or onn("1101", m2 and t3) or onn("1100", m2 and t4) or onn("1110", m3 and t1);
			regarr_inc <= m2 and (t2 or t4);
			databuff_load_data <= m2 and t2;
			databuff_put_inner <= m2 and t3;
			regarr_load <= m2 and (t3 or t4);
			regarr_put <= ((m3 or m2) and t1) or (m2 and t4);
			databuff_load_inner <= m3 and t2;
			databuff_put_data <= m3 and (t2 or t3);
			acc_put <= m3 and t2;
			RST <= m3 and t3;
		when "11111011"=> -- 69 EI
			EI <= '1';
			RST <= m1 and t4;
		when "11110011"=> -- 70 DI
			DI <= '1';
			RST <= m1 and t4;
		when "01110110"=> null; -- 71 HLT
		when "00000000"=> -- 72 NOP
			RST <= m1 and t4;
		when others=> null;
	end case;
	end if;
	end if;
end process;
end timing_control_arch;