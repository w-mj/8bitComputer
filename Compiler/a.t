case address is
    when "0000000000000000"=> data_t <= "11011011"; -- in f0
    when "0000000000000001"=> data_t <= "11110000"; -- in f0
    when "0000000000000010"=> data_t <= "11010011"; -- out fc
    when "0000000000000011"=> data_t <= "11111100"; -- out fc
    when "0000000000000100"=> data_t <= "11000011"; -- jmp LOOP
    when "0000000000000101"=> data_t <= "00000000"; -- jmp LOOP
    when "0000000000000110"=> data_t <= "00000000"; -- jmp LOOP
	when others=> data_t <= "01110110";  -- hlt
end case;