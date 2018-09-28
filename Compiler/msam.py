import sys
reg_list = 'ABCDEHL'
rp_list = 'BDHSP'
reg_code = {
    'A': '111', 'B': '000', 'C': '001', 'D': '010', 'E': '011', 'H': '100', 'L': '101',
}
rp_code = {'B': '00', 'D': '01', 'H': '10', 'SP': '11'}
label_map = dict()


def hex2bin(n):
    return bin(int(n, 16))[2:].zfill(8)

def msam_line(s):
    global label_map
    c = s.split(' ', 1)
    cmd = c[0].upper()
    try:
        arg1 = c[1].split(',')[0].strip().upper()
    except IndexError:
        arg1 = None
    try:
        arg2 = c[1].split(',')[1].strip().upper()
    except IndexError:
        arg2 = None

    if cmd == 'MVI':
        if arg1 in reg_list:
            return '00' + reg_code[arg1] + '110', \
                   hex2bin(arg2)
    elif cmd == 'MOV':
        if arg1 in reg_list and arg2 in reg_list:
            return '01' + reg_code[arg1] + reg_code[arg2],
    elif cmd == 'ADD':
        if arg1 in reg_list:
            return '10000' + reg_code[arg1],
    elif cmd == 'SUB':
        if arg1 in reg_list:
            return '10010' + reg_code[arg1],
    elif cmd == 'OUT':
        return '11010011', \
               hex2bin(arg1)
    elif cmd == 'IN':
        return '11011011', \
               hex2bin(arg1)
    elif cmd == 'HLT':
        return '01110110',
    elif cmd[0] == 'J':
        code = None
        if cmd == 'JMP':
            code = '11000011'
        elif cmd == 'JNZ':
            code = '11000010'
        elif cmd == 'JZ':
            code = '11001010'
        elif cmd == 'JNC':
            code = '11010010'
        elif cmd == 'JC':
            code = '11011010'
        elif cmd == 'JPO' or cmd == 'JNK':
            code = '11100010'
        elif cmd == 'JPE' or cmd == 'JK':
            code = '11101010'
        elif cmd == 'JP':
            code = '11110010'
        elif cmd == 'JM':
            code = '11111010'
        if code is not None:
            return code, \
                   '--JMPH--'+arg1, '--JMPL--'+arg1
    elif cmd == 'CMP':
        if arg1 in reg_list:
            return '10111' + reg_code[arg1],
    elif cmd == 'INR':
        if arg1 in reg_list:
            return '00' + reg_code[arg1] + '100',
    elif cmd == 'ANI':
        return '11100110', hex2bin(arg1)
    elif cmd == 'CMI':
        return '11111110', hex2bin(arg1)
    elif cmd == 'ORI':
        return '11110110', hex2bin(arg1)
    elif cmd == 'RLC':
        return '00000111',
    elif cmd == 'RAL':
        return '00010111',
    elif cmd == 'RRC':
        return '00001111',
    elif cmd == 'RAR':
        return '00011111',
    elif cmd == 'ORA':
        return '10110' + reg_code[arg1],
    elif cmd == 'INX':
        return '00' + rp_code[arg1] + '0011',
    elif cmd == 'DCX':
        return '00' + rp_code[arg1] + '1011',
    elif cmd == 'PCHL':
        return '11101001',
    elif cmd == 'STAX':
        return '00' + rp_code[arg1] + '0010',
    elif cmd == 'LDAX':
        return '00' + rp_code[arg1] + '1010',
    elif cmd == 'NOP':
        return '00000000'



if __name__ == '__main__':
    if len(sys.argv) == 1:
        print('No input file.')
        sys.exit(0)
    addr = 0
    result = []
    with open(sys.argv[1]) as f:
        for i, line in enumerate(f):
            line = line[:-1].split(';')[0]
            if line == '':
                continue
            if ':' in line:
                label_map[line.split(':')[0]] = addr
                continue
            if 'ORG' in line:
                addr = int(line.split(' ')[1], 16)
                continue
            res = msam_line(line)
            if res is None or None in res:
                print('something wrong at line {}'.format(i))
                sys.exit(1)
            for byte in res:
                if '--' not in byte:
                    byte = hex(int(byte, 2))[2:].zfill(2)
                result.append([byte, addr, line])
                addr += 1

    out_f = open('../' + sys.argv[1] + '.mif', 'w')
    out_f.write("WIDTH=8;\nDEPTH=16384;\nADDRESS_RADIX=HEX;\nDATA_RADIX=HEX;\nCONTENT BEGIN\n")
    for byte in result:
        if '--JMPH--' in byte[0]:
            byte[0] = hex(label_map[byte[0][8:]])[2:].zfill(4)[:2]
        elif '--JMPL--' in byte[0]:
            byte[0] = hex(label_map[byte[0][8:]])[2:].zfill(4)[2:]
        out_f.write('    ' + hex(byte[1])[2:].zfill(4) + ':' + byte[0] + ';\n')
    out_f.write('END;')
    out_f.close()
