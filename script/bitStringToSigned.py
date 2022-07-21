def twos_comp(val, bits):
    if (val & (1 << (bits - 1))) != 0:  # if sign bit is set e.g., 8bit: 128-255
        val = val - (1 << bits)        # compute negative value
    return val


def twos(val_str, bytes):
    import sys
    val = int(val_str, 2)
    b = val.to_bytes(bytes, byteorder=sys.byteorder, signed=False)
    return int.from_bytes(b, byteorder=sys.byteorder, signed=True)


f = open(r"C:\FTN\edge_detection\spec\python\bitValKernelVHDL.txt", "r")
for x in f:
    print(x)
    # out = twos_comp(int(str(x), 2), len(x))
    out = twos(x, 2)
    g = open(r"C:\FTN\edge_detection\spec\python\signed_kernel.txt", "a")
    g.write(str(out)+",\n")
    g.close()

    print(out)

print(twos_comp(int("1110100001111001", 2), len("1110100001111001")))
