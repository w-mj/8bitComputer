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
    elif cmd == 'HLT':
        return '01110110',
    elif cmd == 'JMP':
        return '11000011', \
               bin(label_map[arg1])[2:].zfill(16)[0:8], \
               bin(label_map[arg1])[2:].zfill(16)[8:]


if __name__ == '__main__':
    if len(sys.argv) == 1:
        print('No input file.')
        sys.exit(0)
    addr = 0
    out_f = open(sys.argv[1] + '.t', 'w')
    out_f.write("with address select data_t <=\n")
    with open(sys.argv[1]) as f:
        for i, line in enumerate(f):
            line = line[:-1].split(';')[0]
            if line == '':
                continue
            if ':' in line:
                label_map[line.split(':')[0]] = addr
                continue
            res = msam_line(line)
            if res is None or None in res:
                print('something wrong at line {}'.format(i))
                sys.exit(1)
            for byte in res:
                out_f.write('    "' + byte + '" when "' + bin(addr)[2:].zfill(16) + '", -- ' + line + '\n')
                addr += 1
    out_f.write('	"01110110" when others;  -- hlt')
    out_f.close()
