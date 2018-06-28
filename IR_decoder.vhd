library ieee;
library work;
use ieee.std_logic_1164.all;
use work.pkg.all;

entity IR_decoder is port(
	IR: in std_logic_vector(7 downto 0);
	IR_decoded: out std_logic_vector(6 downto 0);
	operand: out std_logic_vector(5 downto 0)
	);
end IR_decoder;

architecture IR_decoder_arch of IR_decoder is 
variable num: unsigned(6 downto 0);
begin
IR_decoded <= std_logic_vector(num);
process (IR) begin
	operand <= IR(5 downto 0);
	case IR is
		when "11111001"=> num := 4; -- SPHL;
		when "00110110"=> num := 6; -- MVI r, data;
		when "00111010"=> num := 8; -- LDA addr;
		when "00110010"=> num := 9; -- STA addr;
		when "00101010"=> num := 10; -- LHLD addr;
		when "00100010"=> num := 11; -- SHLD addr;
		when "11101011"=> num := 14; -- XCHG
		when "10000110"=> num := 16; -- ADD M
		when "11000110"=> num := 17; -- ADI data
		when "10001110"=> num := 19; -- ADC M
		when "11001110"=> num := 20; -- ACI data
		when "10010110"=> num := 22; -- SUB M
		when "11010110"=> num := 23; -- SUI data
		when "10011110"=> num := 25; -- SBB M
		when "11011110"=> num := 26; -- SBI data
		when "00110100"=> num := 28; -- INR M
		when "00110101"=> num := 30; -- DCR M
		when "00100111"=> num := 34; -- DAA
		when "10100110"=> num := 36; -- ANA M
		when "11100110"=> num := 37; -- ANI data
		when "10101110"=> num := 39; -- XRA M
		when "11101110"=> num := 40; -- XRA data
		when "10110110"=> num := 42; -- ORA data
		when "11110110"=> num := 43; -- ORI data
		when "10111110"=> num := 45; -- CMP M
		when "11111110"=> num := 46; -- CPI data
		when "00000111"=> num := 47; -- RLC
		when "00001111"=> num := 48; -- RRC
		when "00010111"=> num := 49; -- RAL
		when "00011111"=> num := 50; -- RAR
		when "00101111"=> num := 51; -- CMA
		when "00111111"=> num := 52; -- CMC
		when "00110111"=> num := 53; -- STC
		when "11000011"=> num := 54; -- JMP addr
		when "11001101"=> num := 56; -- CALL addr
		when "11001001"=> num := 58; -- RET
		when "11101001"=> num := 61; -- PCHL
		when "11110101"=> num := 63; -- PUSH PSW
		when "11110001"=> num := 65; -- POP PSW
		when "11100011"=> num := 66; -- XTHL
		when "11011011"=> num := 67; -- IN port
		when "11010011"=> num := 68; -- OUT port
		when "11111011"=> num := 69; -- EI
		when "11110011"=> num := 70; -- DI
		when "01110110"=> num := 71; -- HLT
		when "00000000"=> num := 73; -- NOP
	if (IR(7 downto 6) = "01") then
		if ((IR(5 downto 0) = "110110") then num := 71; -- HLT;
		elsif ((IR(5 downto 3) = "110") then num := 3; operand <= IR(2 downto 0) & "XXX"; -- mov m, r;
		elsif ((IR(2 downto 0) = "110") then num := 2; operand <= IR(5 downto 3) & "XXX"; -- mov r, m;
		else num := 1; operand <= IR(5 downto 0); -- mov r, r;
		end if;
	elsif (IR(7 downto 6) = "11") then

	end if;
end process;
end IR_decoder_arch;