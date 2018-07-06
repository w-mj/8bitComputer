case address is
    when "0000000000000000"=> data_t <= "11011011"; -- in f8
    when "0000000000000001"=> data_t <= "11111000"; -- in f8
    when "0000000000000010"=> data_t <= "11010011"; -- out fc
    when "0000000000000011"=> data_t <= "11111100"; -- out fc
    when "0000000000000100"=> data_t <= "11000011"; -- jmp L
    when "0000000000000101"=> data_t <= "00000000"; -- jmp L
    when "0000000000000110"=> data_t <= "00000000"; -- jmp L
	when others=> data_t <= "01110110";  -- hlt
end case;