import sys 
def main(c):
    with open('ASC16', 'rb') as f:
        asc_data = f.read()
    font_width = 8
    font_height = 16
    c = c * 16
    mask = [128, 64, 32, 16, 8, 4, 2, 1]

    for i in range(font_height):
        for j in range(font_width):
            flag = asc_data[c + i] & mask[j]
            print('*' if flag > 0 else ' ', end='')
        print('')

if __name__ == '__main__':
    main(int(sys.argv[1], 10))
