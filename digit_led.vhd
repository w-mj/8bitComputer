library ieee;
use ieee.std_logic_1164.all;


entity digit_led is port(
	digit_cs: in std_logic_vector(1 downto 0);
	digit_data: in std_logic_vector(4 downto 0);
	digit_data_out: out std_logic_vector(7 downto 0);
	digit_cs_out: out std_logic_vector(3 downto 0);
	CLK, load: in std_logic
	);
end digit_led;

architecture digit_led_arch of digit_led is
signal cs_scan: std_logic_vector(3 downto 0);
signal dig1, dig2, dig3, dig4, A: std_logic_vector(4 downto 0);
begin
digit_cs_out <= cs_scan;
process (CLK) begin
	case cs_scan is
		when "1110" => cs_scan<="1101"; A <= dig2;
		when "1101" => cs_scan<="1011"; A <= dig3;
		when "1011" => cs_scan<="0111"; A <= dig4;
		when "0111" => cs_scan<="1110"; A <= dig1;
		when others => cs_scan<="1110"; A <= dig1;
	end case;
	if (load = '1') then
		case digit_cs is
			when "00"=> dig1 <= digit_data;
			when "01"=> dig2 <= digit_data;
			when "10"=> dig3 <= digit_data;
			when "11"=> dig4 <= digit_data;
		end case;
	end if;
end process;

process (A)
BEGIN
    case A(3 downto 0) is
        when "0000"=> digit_data_out <= A(4) & "1111110";  -- '0'
        when "0001"=> digit_data_out <= A(4) & "0110000";  -- '1'
        when "0010"=> digit_data_out <= A(4) & "1101101";  -- '2'
        when "0011"=> digit_data_out <= A(4) & "1111001";  -- '3'
        when "0100"=> digit_data_out <= A(4) & "0110011";  -- '4' 
        when "0101"=> digit_data_out <= A(4) & "1011011";  -- '5'
        when "0110"=> digit_data_out <= A(4) & "1011111";  -- '6'
        when "0111"=> digit_data_out <= A(4) & "1110000";  -- '7'
        when "1000"=> digit_data_out <= A(4) & "1111111";  -- '8'
        when "1001"=> digit_data_out <= A(4) & "1111011";  -- '9'
        when "1010"=> digit_data_out <= A(4) & "1110111";  -- 'A'
        when "1011"=> digit_data_out <= A(4) & "0011111";  -- 'b'
        when "1100"=> digit_data_out <= A(4) & "1001110";  -- 'C'
        when "1101"=> digit_data_out <= A(4) & "0111101";  -- 'd'
        when "1110"=> digit_data_out <= A(4) & "1001111";  -- 'E'
        when "1111"=> digit_data_out <= A(4) & "1000111";  -- 'F'
        when others =>  NULL;
    end case;
end process;

end digit_led_arch;