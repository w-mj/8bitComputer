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
	key_clr: out std_logic
);
end timing_control;

architecture timing_control_arch of timing_control is
signal IR: std_logic_vector(7 downto 0);
signal t1, t2, t3, t4, t5, t6, t7: std_logic;
signal m1, m2, m3, m4, m5, m6, m7: std_logic;
signal CF, ZF, AF, PF, SF: std_logic;
signal sss, ddd: std_logic_vector(2 downto 0);
signal rp: std_logic_vector(1 downto 0);
signal success: std_logic;
begin
t1 <= bT(0); t2 <= bT(1); t3 <= bT(2); t4 <= bT(3); t5 <= bT(4); t6 <= bT(5); t7 <= bT(6);
m1 <= bM(0); m2 <= bM(1); m3 <= bM(2); m4 <= bM(3); m5 <= bM(4); m6 <= bM(5); m7 <= bM(6);
CF <= flag_reg(0); AF <= flag_reg(1); PF<=flag_reg(2); ZF<=flag_reg(3); SF<=flag_reg(4);
ddd <= IR_input(5 downto 3);
sss <= IR_input(2 downto 0);
databuffclr_pc <= reset;
CLR <= reset;
process(IR, bM, bT, IR_input) begin
	IR <= IR_input;
	case IR_input(7 downto 6) is
		when "01"=>
			if(ddd /= "110") then IR(5 downto 3) <= "000"; end if;
			if(sss /= "110") then IR(2 downto 0) <= "000"; end if;
		when "11"=>
			if (sss = "111") then 
				IR(5 downto 3) <= "000";
			end if;
		when "10"=>
			if (sss /= "110") then 
				 IR(2 downto 0) <= "000"; end if;
		when "00"=>
			null;
		end case;
	RST<='0'; nextM<='0'; nextT<='0'; regarr_cs<="0000"; regarr_load<='0'; regarr_put<='0';
	regarr_inc<='0'; regarr_dec<='0'; addrbuff_load<='0'; ireg_load<='0'; databuff_load_data<='0';
	databuff_load_inner<='0'; databuff_put_data<='0'; databuff_put_inner<='0';
	flag_load_bus<='0'; flag_put_bus<='0'; flag_load_alu<='0'; flag_STC<='0';
	alu_s<="0000"; alu_put<='0'; tmp_load<='0'; tmp_put<='0'; acc_load<='0'; acc_put<='0';
	success <= '0'; tmp_clr <= '0'; key_clr <= '0';
	
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
		when "01000000" => -- 1 mov r1, r2
			regarr_cs <= onn("0"&sss, m1 and t4) or onn("0"&ddd, m1 and t5);
			regarr_put <= m1 and t4;
			tmp_load <= m1 and t4;
			tmp_put <= m1 and t5;
			nextT <= m1 and t4;
			regarr_load <= m1 and t5;
			RST <= m1 and t5;
		when "01110000" => -- 2 mov M, r
			nextM <= (m1 and t4) or (m2 and t3);
			regarr_cs <= onn("1111", (m2 or m3) and (t1 or t2)) or 
							 onn("1100", m2 and t3) or onn("1101", m3 and t3)or
							 onn("1110", m4 and t1) or 
							 onn("0"&sss, m4 and t2);
			addrbuff_load <= (m2 or m3 or m4) and t1;
			regarr_put <= ((m2 or m3) and t1) or (m4 and (t1 or t2));
			regarr_inc <= (m2 or m3) or t2;
			databuff_load_data <= (m2 or m3) and t2;
			databuff_put_data <= m4 and t3;
			databuff_load_inner <= m4 and t2;
			databuff_put_inner <= (m2 or m3) and t3;
			nextT <= (m2 or m3 or m4) and (t1 or t2);
			RST <= m4 and t3;
		when "01000110" => -- 3 mov r, M
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
		when "01110110" => null; -- 4 hlt
		when "00000110" => -- 5 mvi r, data
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
		when "00110110" => -- 6 mvi m, data
			nextM <= (m1 and t4) or ((m2 or m3) and t3);
			nextT <= (m2 or m3 or m4) and (t1 or t2);
			regarr_cs <= onn("1111", (m2 or m3 or m4) and (t1 or t2)) 
						or onn("1101", m2 and t3) or onn("1100", m3 and t3)
						or onn("1110", m4 and t3);
			regarr_put <= (m2 or m3 or m4) and t1;
			addrbuff_load <= (m2 or m3 or m4) and t1;
			regarr_inc <= (m2 or m3 or m3) and t2;
			databuff_load_data <= (m2 or m3 or m4) and t2;
			databuff_put_inner <= (m2 or m3) and t3;
			regarr_load <= (m2 or m3) and t3;
			databuff_put_data <= m4 and t3;
			RST <= m4 and t3;
		when "00000100" => -- 7 inr r
			nextT <= m1 and t4;
			regarr_cs <= onn("0"&ddd, m1 and (t4 or t5));
			regarr_put <= m1 and t4;
			tmp_load <= m1 and t4;
			alu_s <= onn("0000", m1 and t5);
			alu_put <= m1 and t5;
			flag_load_alu <= m1 and t5;
			regarr_load <= m1 and t5;
			RST <= m1 and t5;
		when "00000101" => -- 8 dcr r
			nextT <= m1 and t4;
			regarr_cs <= onn("0"&ddd, m1 and (t4 or t5));
			regarr_put <= m1 and t4;
			tmp_load <= m1 and t4;
			alu_s <= onn("0001", m1 and t5);
			alu_put <= m1 and t5;
			flag_load_alu <= m1 and t5;
			regarr_load <= m1 and t5;
			RST <= m1 and t5;
		when "00110100" => null; -- 9 inr m
		when "00110101" => null; -- 10 dcr m
		when "10000000" => -- 11 add r
			regarr_cs <= onn("0"&sss, m1 and t4);
			regarr_put <= m1 and t4;
			tmp_load <= m1 and t4;
			alu_s <= onn("0010", m1 and t5);
			alu_put <= m1 and t5;
			flag_load_alu <= m1 and t5;
			acc_load <= m1 and t5;
			nextT <= m1 and t4;
			RST <= m1 and t5;
		when "10001000" => -- 12 adc r
			regarr_cs <= onn("0"&sss, m1 and t4);
			regarr_put <= m1 and t4;
			tmp_load <= m1 and t4;
			alu_s <= onn("0011", m1 and t5);
			alu_put <= m1 and t5;
			flag_load_alu <= m1 and t5;
			acc_load <= m1 and t5;
			nextT <= m1 and t4;
			RST <= m1 and t5;
		when "10010000" => -- 13 sub r
			regarr_cs <= onn("0"&sss, m1 and t4);
			regarr_put <= m1 and t4;
			tmp_load <= m1 and t4;
			alu_s <= onn("0100", m1 and t5);
			alu_put <= m1 and t5;
			flag_load_alu <= m1 and t5;
			acc_load <= m1 and t5;
			nextT <= m1 and t4;
			RST <= m1 and t5;
		when "10011000" => -- 14 sbb r
			regarr_cs <= onn("0"&sss, m1 and t4);
			regarr_put <= m1 and t4;
			tmp_load <= m1 and t4;
			alu_s <= onn("0101", m1 and t5);
			alu_put <= m1 and t5;
			flag_load_alu <= m1 and t5;
			acc_load <= m1 and t5;
			nextT <= m1 and t4;
			RST <= m1 and t5;
		when "10100000" => -- 15 ana r
			nextT <= m1 and t4;
			regarr_cs <= onn("0"&ddd, m1 and (t4 or t5));
			regarr_put <= m1 and t4;
			tmp_load <= m1 and t4;
			alu_s <= onn("0110", m1 and t5);
			alu_put <= m1 and t5;
			flag_load_alu <= m1 and t5;
			regarr_load <= m1 and t5;
			RST <= m1 and t5;
		when "10101000" => -- 16 xra r
			nextT <= m1 and t4;
			regarr_cs <= onn("0"&ddd, m1 and (t4 or t5));
			regarr_put <= m1 and t4;
			tmp_load <= m1 and t4;
			alu_s <= onn("0111", m1 and t5);
			alu_put <= m1 and t5;
			flag_load_alu <= m1 and t5;
			regarr_load <= m1 and t5;
			RST <= m1 and t5;
		when "10110000" => -- 17 ora r
			nextT <= m1 and t4;
			regarr_cs <= onn("0"&ddd, m1 and (t4 or t5));
			regarr_put <= m1 and t4;
			tmp_load <= m1 and t4;
			alu_s <= onn("1000", m1 and t5);
			alu_put <= m1 and t5;
			flag_load_alu <= m1 and t5;
			regarr_load <= m1 and t5;
			RST <= m1 and t5;
		when "10111000" => -- 18 cmp r
			regarr_cs <= onn("0"&sss, m1 and t4);
			regarr_put <= m1 and t4;
			tmp_load <= m1 and t4;
			alu_s <= onn("0100", m1 and t5);
			flag_load_alu <= m1 and t5;
			nextT <= m1 and t4;
			RST <= m1 and t5;
		when "10000110" => -- 19 add m
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
		when "10001110" => -- 20 adc m
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
		when "10010110" => -- 21 sub m
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
		when "10011110" => -- 22 sbb m
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
		when "10100110" => null; -- 23 ana m
		when "10101110" => null; -- 24 xra m
		when "10110110" => null; -- 25 ora m
		when "10111110" => null; -- 26 cmp m
		when "11000110" => -- 27 adi, data
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
		when "11001110" => -- 28 aci, data
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
		when "11010110" => -- 29 sui, data
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
		when "11011110" => -- 30 sbi, data
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
		when "11100110" => -- 31 ani
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
		when "11101110" => -- 32 xri, data
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
		when "11110110" => -- 33 ori
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
		when "11111110" => -- 34 cpi, data
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
		when "00000111" => -- 35 rlc
			alu_s <= onn("1100", m1 and t4);
			alu_put <= m1 and t4;
			acc_load <= m1 and t4;
			RST <= m1 and t4;
		when "00001111" => -- 36 rrc
			alu_s <= onn("1101", m1 and t4);
			alu_put <= m1 and t4;
			acc_load <= m1 and t4;
			flag_load_alu <= m1 and t4;
			RST <= m1 and t4;
		when "00010111" => -- 37 ral
			alu_s <= onn("1010", m1 and t4);
			alu_put <= m1 and t4;
			acc_load <= m1 and t4;
			flag_load_alu <= m1 and t4;
			RST <= m1 and t4;
		when "00011111" => -- 38 rar
			alu_s <= onn("1011", m1 and t4);
			alu_put <= m1 and t4;
			acc_load <= m1 and t4;
			flag_load_alu <= m1 and t4;
			RST <= m1 and t4;
		when "11000011" => -- 39 jmp
			nextM <= (m1 and t4) or (m2 and t3);
			addrbuff_load <= ((m2 or m3) and t1) or (m3 and t4);
			regarr_cs <= onn("1111", (m2 and (t1 or t2)) or (m3 and (t1 or t2))) or onn("1100", m2 and t3) 
								or onn("1101", m3 and t3) or onn("1110", m3 and t4);
			regarr_put <= (m2 or m3) and t1;
			regarr_inc <= (m2 or m3) and t2;
			databuff_load_data <= (m2 or m3) and t2;
			databuff_put_inner <= (m2 or m3) and t3;
			regarr_load <= ((m2 or m3) and t3) or (m3 and t4);
			nextT <= (m2 and (t1 or t2)) or (m3 and (t1 or t2 or t3));
			RST <= (m3 and t4) ;
		when "11011010" => -- 40 jc
			nextM <= (m1 and t4) or (m2 and t3);
			addrbuff_load <= ((m2 or m3) and t1) or (m3 and t4);
			regarr_cs <= onn("1111", (m2 and (t1 or t2)) or (m3 and (t1 or t2))) or onn("1100", m2 and t3) 
								or onn("1101", m3 and t3) or onn("1110", m3 and t4);
			regarr_put <= (m2 or m3) and t1;
			regarr_inc <= (m2 or m3) and t2;
			databuff_load_data <= (m2 or m3) and t2;
			databuff_put_inner <= (m2 or m3) and t3;
			regarr_load <= ((m2 or m3) and t3) or (m3 and t4);
			nextT <= (m2 and (t1 or t2)) or (m3 and (t1 or t2 or (success and t3)));
			RST <= (m3 and t4) or (m3 and t3 and (not CF));
		when "11010010" => -- 41 jnc
			nextM <= (m1 and t4) or (m2 and t3);
			addrbuff_load <= ((m2 or m3) and t1) or (m3 and t4);
			regarr_cs <= onn("1111", (m2 and (t1 or t2)) or (m3 and (t1 or t2))) or onn("1100", m2 and t3) 
								or onn("1101", m3 and t3) or onn("1110", m3 and t4);
			regarr_put <= (m2 or m3) and t1;
			regarr_inc <= (m2 or m3) and t2;
			databuff_load_data <= (m2 or m3) and t2;
			databuff_put_inner <= (m2 or m3) and t3;
			regarr_load <= ((m2 or m3) and t3) or (m3 and t4);
			nextT <= (m2 and (t1 or t2)) or (m3 and (t1 or t2 or (success and t3)));
			RST <= (m3 and t4) or (m3 and t3 and (CF));
		when "11001010" => -- 42 jz
			nextM <= (m1 and t4) or (m2 and t3);
			addrbuff_load <= ((m2 or m3) and t1) or (m3 and t4);
			regarr_cs <= onn("1111", (m2 and (t1 or t2)) or (m3 and (t1 or t2))) or onn("1100", m2 and t3) 
								or onn("1101", m3 and t3) or onn("1110", m3 and t4);
			regarr_put <= (m2 or m3) and t1;
			regarr_inc <= (m2 or m3) and t2;
			databuff_load_data <= (m2 or m3) and t2;
			databuff_put_inner <= (m2 or m3) and t3;
			regarr_load <= ((m2 or m3) and t3) or (m3 and t4);
			nextT <= (m2 and (t1 or t2)) or (m3 and (t1 or t2 or (success and t3)));
			RST <= (m3 and t4) or (m3 and t3 and (not ZF));
		when "11000010" => -- 43 jnz
			nextM <= (m1 and t4) or (m2 and t3);
			addrbuff_load <= ((m2 or m3) and t1) or (m3 and t4);
			regarr_cs <= onn("1111", (m2 and (t1 or t2)) or (m3 and (t1 or t2))) or onn("1100", m2 and t3) 
								or onn("1101", m3 and t3) or onn("1110", m3 and t4);
			regarr_put <= (m2 or m3) and t1;
			regarr_inc <= (m2 or m3) and t2;
			databuff_load_data <= (m2 or m3) and t2;
			databuff_put_inner <= (m2 or m3) and t3;
			regarr_load <= ((m2 or m3) and t3) or (m3 and t4);
			nextT <= (m2 and (t1 or t2)) or (m3 and (t1 or t2 or (success and t3)));
			RST <= (m3 and t4) or (m3 and t3 and (ZF));
		when "11110010" => -- 44 jp
			nextM <= (m1 and t4) or (m2 and t3);
			addrbuff_load <= ((m2 or m3) and t1) or (m3 and t4);
			regarr_cs <= onn("1111", (m2 and (t1 or t2)) or (m3 and (t1 or t2))) or onn("1100", m2 and t3) 
								or onn("1101", m3 and t3) or onn("1110", m3 and t4);
			regarr_put <= (m2 or m3) and t1;
			regarr_inc <= (m2 or m3) and t2;
			databuff_load_data <= (m2 or m3) and t2;
			databuff_put_inner <= (m2 or m3) and t3;
			regarr_load <= ((m2 or m3) and t3) or (m3 and t4);
			nextT <= (m2 and (t1 or t2)) or (m3 and (t1 or t2 or (success and t3)));
			RST <= (m3 and t4) or (m3 and t3 and (SF));
		when "11111010" => -- 45 jm
			nextM <= (m1 and t4) or (m2 and t3);
			addrbuff_load <= ((m2 or m3) and t1) or (m3 and t4);
			regarr_cs <= onn("1111", (m2 and (t1 or t2)) or (m3 and (t1 or t2))) or onn("1100", m2 and t3) 
								or onn("1101", m3 and t3) or onn("1110", m3 and t4);
			regarr_put <= (m2 or m3) and t1;
			regarr_inc <= (m2 or m3) and t2;
			databuff_load_data <= (m2 or m3) and t2;
			databuff_put_inner <= (m2 or m3) and t3;
			regarr_load <= ((m2 or m3) and t3) or (m3 and t4);
			nextT <= (m2 and (t1 or t2)) or (m3 and (t1 or t2 or (success and t3)));
			RST <= (m3 and t4) or (m3 and t3 and (not SF));
		when "11101010" => -- 46 jpe
			nextM <= (m1 and t4) or (m2 and t3);
			addrbuff_load <= ((m2 or m3) and t1) or (m3 and t4);
			regarr_cs <= onn("1111", (m2 and (t1 or t2)) or (m3 and (t1 or t2))) or onn("1100", m2 and t3) 
								or onn("1101", m3 and t3) or onn("1110", m3 and t4);
			regarr_put <= (m2 or m3) and t1;
			regarr_inc <= (m2 or m3) and t2;
			databuff_load_data <= (m2 or m3) and t2;
			databuff_put_inner <= (m2 or m3) and t3;
			regarr_load <= ((m2 or m3) and t3) or (m3 and t4);
			nextT <= (m2 and (t1 or t2)) or (m3 and (t1 or t2 or (success and t3)));
			RST <= (m3 and t4) or (m3 and t3 and (not PF));
		when "11100010" => -- 47 jpo
			nextM <= (m1 and t4) or (m2 and t3);
			addrbuff_load <= ((m2 or m3) and t1) or (m3 and t4);
			regarr_cs <= onn("1111", (m2 and (t1 or t2)) or (m3 and (t1 or t2))) or onn("1100", m2 and t3) 
								or onn("1101", m3 and t3) or onn("1110", m3 and t4);
			regarr_put <= (m2 or m3) and t1;
			regarr_inc <= (m2 or m3) and t2;
			databuff_load_data <= (m2 or m3) and t2;
			databuff_put_inner <= (m2 or m3) and t3;
			regarr_load <= ((m2 or m3) and t3) or (m3 and t4);
			nextT <= (m2 and (t1 or t2)) or (m3 and (t1 or t2 or (success and t3)));
			RST <= (m3 and t4) or (m3 and t3 and (PF));
		when "11001101" => null; -- 48 call
		when "11011100" => null; -- 49 cc
		when "11010100" => null; -- 50 cnc
		when "11001100" => null; -- 51 cz
		when "11000100" => null; -- 52 cnz
		when "11110100" => null; -- 53 cp
		when "11111100" => null; -- 54 cm
		when "11101100" => null; -- 55 cpe
		when "11100100" => null; -- 56 cpo
		when "11001001" => null; -- 57 ret
		when "11011000" => null; -- 58 rc
		when "11010000" => null; -- 59 rnc
		when "11001000" => null; -- 60 rz
		when "11000000" => null; -- 61 rnz
		when "11110000" => null; -- 62 rp
		when "11111000" => null; -- 63 rm
		when "11101000" => null; -- 64 rpe
		when "11100000" => null; -- 65 rpo
		when "11000111" => -- 66 rst
			nextM <= m1 and t4;
			tmp_clr <= m2 and t1;
			tmp_put <= m2 and (t1 or t2);
			regarr_cs <= onn ("1100", m2 and t1) or onn("1101", m2 and t2) or onn("1110", m2 and t3);
			regarr_load <= m2 and (t1 or t2 or t3);
			regarr_put <= m2 and t4;
			addrbuff_load <= m2 and t4;
			nextT <= m2 and (t1 or t2 or t3);
			RST <= m2 and t4;
		when "11011011" => -- 67 in
			nextM <= (m1 and t4) or (m2 and t3);
			nextT <= (m2 and (t1 or t2)) or (m3 and (t1 or t2));
			regarr_cs <= onn("1111", m2 and (t1 or t2)) or onn("1100", m2 and t3) or onn("1110", m3 and t1);
			regarr_put <= (m2 and t1) or (m3 and t1);
			addrbuff_load <= (m2 and t1) or (m3 and t1);
			regarr_inc <= m2 and t2;
			databuff_load_data <= (m2 or m3) and t2;
			databuff_put_inner <= (m2 or m3) and t3;
			regarr_load <= m2 and t3;
			acc_load <= m3 and t3;
			RST <= m3 and t3;
		when "11010011" => -- 68 out
			nextM <= (m1 and t4) or (m2 and t3);
			nextT <= (m2 and (t1 or t2)) or (m3 and (t1 or t2));
			addrbuff_load <= (m2 and t1) or (m3 and t1);
			regarr_cs <= onn("1111", m2 and (t1 or t2)) or onn("1100", m2 and t3) or onn("1110", m3 and t1);
			regarr_inc <= m2 and t2;
			databuff_load_data <= m2 and t2;
			databuff_put_inner <= m2 and t3;
			regarr_load <= m2 and t3;
			regarr_put <= (m3 or m2) and t1;
			databuff_load_inner <= m3 and t2;
			databuff_put_data <= m3 and (t2 or t3);
			acc_put <= m3 and t2;
			RST <= m3 and t3;
		when "00000001" => -- 69 lxi b, data
			nextM <= (m1 and t4) or (m2 and t3);
			regarr_cs <= onn("1111", (m2 or m3) and (t1 or t2))
							 or onn("0001", m2 and t3) or onn("0000", m3 and t3);
			regarr_inc <= (m2 or m3) and t2;
			regarr_put <= (m2 or m3) and t1;
			addrbuff_load <= (m2 or m3) and t1;
			databuff_load_data <= (m2 or m3) and t2;
			databuff_put_inner <= (m2 or m3) and t3;
			regarr_load <= (m2 or m3) and t3;
			nextT <= (m2 or m3) and (t1 or t2);
			RST <= m3 and t3;
		when "00010001" => -- 70 lxi d, data
			nextM <= (m1 and t4) or (m2 and t3);
			regarr_cs <= onn("1111", (m2 or m3) and (t1 or t2))
							 or onn("0011", m2 and t3) or onn("0010", m3 and t3);
			regarr_inc <= (m2 or m3) and t2;
			regarr_put <= (m2 or m3) and t1;
			addrbuff_load <= (m2 or m3) and t1;
			databuff_load_data <= (m2 or m3) and t2;
			databuff_put_inner <= (m2 or m3) and t3;
			regarr_load <= (m2 or m3) and t3;
			nextT <= (m2 or m3) and (t1 or t2);
			RST <= m3 and t3;
		when "00100001" => -- 71 lxi h, data
			nextM <= (m1 and t4) or (m2 and t3);
			regarr_cs <= onn("1111", (m2 or m3) and (t1 or t2))
							 or onn("0101", m2 and t3) or onn("0100", m3 and t3);
			regarr_inc <= (m2 or m3) and t2;
			regarr_put <= (m2 or m3) and t1;
			addrbuff_load <= (m2 or m3) and t1;
			databuff_load_data <= (m2 or m3) and t2;
			databuff_put_inner <= (m2 or m3) and t3;
			regarr_load <= (m2 or m3) and t3;
			nextT <= (m2 or m3) and (t1 or t2);
			RST <= m3 and t3;
		when "00110001" => -- 72 lxi sp, data
			nextM <= (m1 and t4) or (m2 and t3);
			regarr_cs <= onn("1111", (m2 or m3) and (t1 or t2))
							 or onn("1101", m2 and t3) or onn("1100", m3 and t3)
							 or onn("1110", m3 and t4);
			regarr_inc <= (m2 or m3) and t2;
			regarr_put <= (m2 or m3) and t1;
			addrbuff_load <= (m2 or m3) and t1;
			databuff_load_data <= (m2 or m3) and t2;
			databuff_put_inner <= (m2 or m3) and t3;
			regarr_load <= (m2 and t3) or (m3 and (t3 or t4));
			nextT <= (m2 and (t1 or t2)) or (m3 and (t1 or t2 or t3));
			RST <= m3 and t4;
		when "11000101" => null; -- 73 push b
		when "11010101" => null; -- 74 push d
		when "11100101" => null; -- 75 push h
		when "11110101" => null; -- 76 push psw
		when "11000001" => null; -- 77 pop b
		when "11010001" => null; -- 78 pop d
		when "11100001" => null; -- 79 pop h
		when "11110001" => null; -- 80 pop psw
		when "00110010" => null; -- 81 sta
		when "00111010" => null; -- 82 lda
		when "11101011" => null; -- 83 xchg
		when "11100011" => null; -- 84 xthl
		when "11111001" => -- 85 sphl
			regarr_cs <= onn("1011", m1 and t4);
			regarr_load <= m1 and t4;
			RST <= m1 and t4;
		when "11101001" => -- 86 pchl
			regarr_cs <= onn("1111", m1 and t4);
			regarr_load <= m1 and t4;
			RST <= m1 and t4;
		when "00001001" => null; -- 87 dad b
		when "00011001" => null; -- 88 dad d
		when "00101001" => null; -- 89 dad h
		when "00111001" => null; -- 90 dad sp
		when "00000010" => -- 91 stax b
			regarr_cs <= onn("1000", m1 and t4);
			regarr_put <= m1 and t4;
			acc_put <= m1 and t4;
			databuff_load_inner <= m1 and t4;
			databuff_put_data <= m1 and t5;
			addrbuff_load <= m1 and t4;
			nextT <= m1 and t4;
			RST <= m1 and t5;
		when "00010010" => -- 92 stax d
			regarr_cs <= onn("1001", m1 and t4);
			regarr_put <= m1 and t4;
			acc_put <= m1 and t4;
			databuff_load_inner <= m1 and t4;
			databuff_put_data <= m1 and t5;
			addrbuff_load <= m1 and t4;
			nextT <= m1 and t4;
			RST <= m1 and t5;
		when "00001010" => -- 93 ldax b
			regarr_cs <= onn("1000", m1 and t4);
			regarr_put <= m1 and t4;
			addrbuff_load <= m1 and t4;
			acc_load <= m1 and t6;
			databuff_load_data <= m1 and t5;
			databuff_put_inner <= m1 and t6;
			nextT <= m1 and (t4 or t5);
			RST <= m1 and t6;
		when "00011010" => -- 94 ldax d
			regarr_cs <= onn("1001", m1 and t4);
			regarr_put <= m1 and t4;
			addrbuff_load <= m1 and t4;
			acc_load <= m1 and t6;
			databuff_load_data <= m1 and t5;
			databuff_put_inner <= m1 and t6;
			nextT <= m1 and (t4 or t5);
			RST <= m1 and t6;
		when "00000011" => -- 95 inx b
			regarr_cs <= onn("1000", m1 and t4);
			regarr_inc <= m1 and t4;
			RST <= m1 and t4;
		when "00010011" => -- 96 inx d
			regarr_cs <= onn("1001", m1 and t4);
			regarr_inc <= m1 and t4;
			RST <= m1 and t4;
		when "00100011" => -- 97 inx h
			regarr_cs <= onn("1010", m1 and t4);
			regarr_inc <= m1 and t4;
			RST <= m1 and t4;
		when "00110011" => -- 98 inx sp
			regarr_cs <= onn("1011", m1 and t4);
			regarr_inc <= m1 and t4;
			RST <= m1 and t4;
		when "00001011" => -- 99 dcx b
			regarr_cs <= onn("1000", m1 and t4);
			regarr_dec <= m1 and t4;
			RST <= m1 and t4;
		when "00011011" => -- 100 dcx d
			regarr_cs <= onn("1001", m1 and t4);
			regarr_dec <= m1 and t4;
			RST <= m1 and t4;
		when "00101011" => -- 101 dcx h
			regarr_cs <= onn("1010", m1 and t4);
			regarr_dec <= m1 and t4;
			RST <= m1 and t4;
		when "00111011" => -- 102 dcx sp
			regarr_cs <= onn("1011", m1 and t4);
			regarr_dec <= m1 and t4;
			RST <= m1 and t4;
		when "00101111" => null; -- 103 cma
		when "00110111" => -- 104 stc
			flag_stc <= m1 and t4;
			RST <= m1 and t4;
		when "00111111" => null; -- 105 cmc
		when "00100111" => null; -- 106 daa
		when "00100010" => null; -- 107 shld
		when "00101010" => null; -- 108 lhld
		when "11111011" => null; -- 109 ei
		when "11110011" => null; -- 110 di
		when "00000000" => -- 111 nop
			RST <= m1 and t4;
	end case;
	end if;
end process;
end timing_control_arch;