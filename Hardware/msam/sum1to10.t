case address is
    when "0000000000000000"=> data_t <= "00111110";  -- mvi a, 0  0x3e
    when "0000000000000001"=> data_t <= "00000000";  -- mvi a, 0  0x0
    when "0000000000000010"=> data_t <= "00000110";  -- mvi b, 1  0x6
    when "0000000000000011"=> data_t <= "00000001";  -- mvi b, 1  0x1
    when "0000000000000100"=> data_t <= "00100110";  -- mvi h, a  0x26
    when "0000000000000101"=> data_t <= "00001010";  -- mvi h, a  0xa
    when "0000000000000110"=> data_t <= "10000000";  -- add b  0x80
    when "0000000000000111"=> data_t <= "01001111";  -- mov c, a  0x4f
    when "0000000000001000"=> data_t <= "01111000";  -- mov a, b  0x78
    when "0000000000001001"=> data_t <= "10111100";  -- cmp h  0xbc
    when "0000000000001010"=> data_t <= "11010010";  -- jnc OVER  0xd2
    when "0000000000001011"=> data_t <= "00000000";  -- jnc OVER  0x0
    when "0000000000001100"=> data_t <= "00010010";  -- jnc OVER  0x12
    when "0000000000001101"=> data_t <= "01111001";  -- mov a, c  0x79
    when "0000000000001110"=> data_t <= "00000100";  -- inr b  0x4
    when "0000000000001111"=> data_t <= "11000011";  -- jmp LOOP  0xc3
    when "0000000000010000"=> data_t <= "00000000";  -- jmp LOOP  0x0
    when "0000000000010001"=> data_t <= "00000110";  -- jmp LOOP  0x6
    when "0000000000010010"=> data_t <= "01111001";  -- mov a, c  0x79
    when "0000000000010011"=> data_t <= "11010011";  -- out fc  0xd3
    when "0000000000010100"=> data_t <= "11111100";  -- out fc  0xfc
    when "0000000000010101"=> data_t <= "01110110";  -- hlt  0x76
	when others=> data_t <= "01110110";  -- hlt 76
end case;