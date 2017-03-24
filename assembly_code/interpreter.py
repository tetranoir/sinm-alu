"""sinm interpreter written in python"""
from assembler import parse_assembly
import sys


def parse_line(line):
    """Turn line into integer to be stored into mem"""
    if line[:2] == '0x':        # hex line
        return int(line[2:], 16)
    elif line[:2] == '0b':      # binary line
        return int(line[2:], 2)
    else:                       # integer line
        return int(line)


def load_memory(filename='data_memory'):
    """
    Return (memory object with the file loaded in, errors)

    Memory obj can be accessed with [] indexing
    Each line in the file is a byte address
    eg.  Addr    File example
        0x0000 | 0
        0x0001 | 12312      # base 10 integer
        0x0002 | 0xFFFF     # 0x means hex
        0x0003 | 0b001011   # 0b means binary
        ------ | *124       # sets the next line to be memory addr 124
        0x007C | 10
        ..
    """
    errs = []
    mem = []

    try:
        f = open(filename, 'rw+')
    except IOError:
        f.close()
        return (mem, errs.append('Couldnt open file %s' % filename))

    for line in f:                              # line ex: 0xFF  # comment
        data = line.split('#', 1)[0].strip()
        if data[0] == '*':        # memory line
            mem += [0] * (int(data[1:]) - len(mem))
        else:
            mem.append(parse_line(data))


def main():
    """Main funnfnf"""
    if len(sys.argv) != 2:
        print('GIB a fileanem')
        return

    opList, labelDict, errorList = parse_assembly(sys.argv[1])
    if len(errorList) > 0:
        for err in errorList:
            print(err)
        return


if __name__ == "__main__":
    main()
