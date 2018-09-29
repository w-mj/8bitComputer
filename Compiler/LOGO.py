
def main():
    with open('../LOGO.mif', 'w') as f:
        f.write("WIDTH=8;\nDEPTH=4800;\nADDRESS_RADIX=UNS;\nDATA_RADIX=UNS;\nCONTENT BEGIN\n")
        addr = 0
        data = 0
        for i in range(80 * 60):
            f.write("{}:{};\n".format(addr, data))
            addr += 1
            data += 1
            if data == 256:
                data = 0
        f.write("END")

if __name__ == "__main__":
    main()