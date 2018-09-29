
def main():
    with open('ASC16', 'rb') as f:
        asc_data = f.read()

    with open('ASC16.mif', 'w') as f:
        f.write("ASC16 8*16 ASCII character file.\n")
        f.write("DEPTH = 4096;\nWIDTH = 8;\nADDRESS_RADIX = HEX;\nDATA_RADIX = HEX;\n")
        f.write("CONTENT BEGIN\n")
        for addr, byte in enumerate(asc_data):
            f.write("{}:{};\n".format(str(hex(addr))[2:], str(hex(byte))[2:]))
        f.write("END")

if __name__ == "__main__":
    main()