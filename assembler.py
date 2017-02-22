from numpy import binary_repr

import sys

# The opcode of the operations
opcode_dict = { "setdr" : "00000",
                "add"   : "00001",
                "addc"  : "00010",
                "sub"   : "00011",
                "incr"  : "00100",
                "decr"  : "00101",
                "load"  : "0011",
                # load has two versions, 00110 for imm4 and 00111 for reg
                "store" : "0100",
                # store has two versions, 01000 for imm4 and 01001 for reg
                "mov"   : "0101",
                # mov has two versions, 01010 for imm4 and 01011 for reg
                "clr"   : "01100",
                "shl"   : "01101",
                "shr"   : "01110",
                "sar"   : "01111",

                "rcr"   : "10000",
                "rcl"   : "10001",
                "and"   : "10010",
                "xor"   : "10011",
                "cmp"   : "1010",
                # cmp has two versions, 10100 for imm4 and 10101 for reg
                "jmp"   : "10110",
                "jz"    : "10111",
                "jfnz"  : "11000",
                "jnz"   : "11001",
                "clfb"  : "11010",
                "max"   : "11011",
                "ckfr"  : "111111110",
                "halt"  : "111111111"
              }

# The following ops don't have operand
no_oprand_op_list = ["ckfr", "halt"]
# The following ops have two versions
two_ver_op_list = ["load", "store", "mov", "cmp"]
# The following ops are jump ops that needs to be expanded during parse,
# and have jump value dynamically generated during conversion.
jump_op_list = ["jmp", "jz", "jfnz", "jnz"]

open_file_error_template = "The file {0:s} cannot be opened"
invalid_op_template = "The operator {0:s} at line {1:d} is invalid"
invalid_oprand_template = "The operand {0:s} at line {1:d} is invalid"
duplicate_label_template = "The label {0:s} at line {1:d} is duplicate"
undefined_label_template = "Label {0:s} is undefined"

'''
try_operand_value:  Try to interpret an operand's number part. Returns None if
                    the operand representation is not valid decimal number.

input:  operand: string, the operand to be interpreted.
output: int, equal to the value represented by the string in decimal,
    OR  None, if the operand is invalid.
'''
def try_operand_value(operand):
    try:
        return int(operand)
    except ValueError:
        return None

'''
parse_assembly: Parse the assembly file. For each line of the code, this subroutine
                separates the operator from operand, and do necessary checks. Labels
                will be stored to a dict: label -> memory location. Any error will be
                stored in a list.

input:  fileName: string, the file name of the assembly file.
output: ([(string, string)], {string: int}, [string]), a tuple:
        The first entry of the tuple is a list of tuples where each tuple contains
            the string for operation and the string for operand. For example,
            instruction "mov r15" will become ("mov", "r15")
        The second entry of the tuple is a dictionary from string to int, where each
            entry maps a label to the memory location it points to.
        The third entry of the tuple is a list of errors messages. If no error was
            encountered, the list will be empty. The following are possible errors:
                1. Invalid operator. Quite obvious
                2. Invalid operand. Same
                3. Duplicate label. Meh
'''
def parse_assembly(fileName):
    errorList = []
    opList = []
    labelDict = {}
    try:
        f = open(fileName, "r")
    except IOError:
        f.close()
        return [],[],[open_file_error_template.format(fileName)]

    lineNum = 1 # Line number as in the assembly file
    for line in f:
        tokens = line.split()   # Split line by spaces/tabs
        if len(tokens) > 0:     # If not empty line
            if (tokens[0])[0] != '#' and (tokens[0])[0:2] != '//': # If not comment
                if tokens[0] not in opcode_dict:    # If the first word is not an instruction
                    if (tokens[0])[-1] != ':':      # and not a label
                        errorList.append(invalid_op_template.format(tokens[0], lineNum)) # Add error
                    else:       # Label
                        label = (tokens[0])[:-1]
                        if label in labelDict:  # Check for duplicate label
                            errorList.append(duplicate_label_template.format(label, lineNum))
                        else:
                            # Add the label to the dictionary
                            labelDict[label] = len(opList) # length of opList = the mem loc of next instr
                else:   # Found valid operator
                    if tokens[0] in no_oprand_op_list:  # If the operator should have no operand,
                        opList.append((tokens[0], ""))  # use empty string in place of operand. Store the pair
                    elif tokens[0] in jump_op_list:     # If the operator is a jump op
                        # We need to expand the code to populate the r_jump_base
                        opList.append(("setdr", "r14")) # Set r_dr to point to r_jump_base
                        opList.append(("mov", "ph"))    # Mov a val to r_jump_base. The val will be determined
                                                        # during conversion.
                        opList.append((tokens[0], tokens[1])) # Put in the original jump
                    else:                               # General instruction
                        operand = (tokens[1])
                        if operand[0] == 'r':       # If the operand is a register,
                            operand = operand[1:]   # take out the 'r' before testing.
                        val = try_operand_value(operand)
                        if val is None or (val < 0 or val > 15): # Error for NaN or out of range number.
                            errorList.append(invalid_oprand_template.format(tokens[1], lineNum))
                        else:                       # Store the (operator, operand) pair.
                            opList.append((tokens[0], tokens[1]))
        lineNum += 1    # Keep up the line number counter.

    f.close()
    return opList, labelDict, errorList

'''
convert_to_mcode:   Convert assembly to machine code with comments. For each
                    line of instruction, translate the operator to corresponding
                    opcode, translate operand to 4-bit operand value.

input:  opList: [(string, string)], the list of (operator, operand) tuples.
        labelDict: {string: int}, a mapping from label to the memory location
                    it points to.
output: ([string], [string]), a tuple:
        The first entry of the tuple is a list of tuples where each tuple contains
            the machine code of an instruction and its comment. The comment is the
            asm code.
        The second entry of the tuple is a list of errors messages. If no error was
            encountered, the list will be empty. The following are possible errors:
                1. Undefined label. You could be more careful dude.
'''
def convert_to_mcode(opList, labelDict):
    mcodeList = []
    errorList = []
    codeIndex = 0
    for (operator, operand) in opList:
        opcode = opcode_dict[operator]
        oprval = "0000"
        # For a two version operation, the 5th bit determines whether it takes imm4
        # or reg, thus this bit will be set as part of operand.
        if operator in two_ver_op_list:
            if operand[0] == 'r':   # reg operand
                oprval = "1" + binary_repr(int(operand[1:]), 4)
            # Translate "ph" for place holder value in expanded jump to 00000.
            # To be changed when the next line jump statement is processed
            elif operand == 'ph':
                oprval = "00000"
            else:                   # imm4 operand
                oprval = "0" + binary_repr(int(operand), 4)
        # For jump, we need to rewrite the placeholder imm4 for prev line of mov.
        elif operator in jump_op_list:
            # Check for undefined label.
            if operand not in labelDict:
                errorList.append(undefined_label_template.format(operand))
            else:
                # Calculate the jump distance as 8-bit binary
                jumpDist = binary_repr(labelDict[operand] - codeIndex, 8)

                # Change the operand for the mov on prev line. It should be
                # an imm4. Rewrite the generated comment, too
                mcodeList[-1] = "{0:s}{1:s}{2:s}{1:s}_bin\n".format(
                    mcodeList[-1][:5], jumpDist[:4], mcodeList[-1][9:-3])

                oprval = jumpDist[4:8]
        # For no operand instruction, use "" for oprval to conform with the line
        # component combining logic
        elif operator in no_oprand_op_list:
            oprval = ""
        # Generate either imm4 or 4 bit register code. Notice we don't append a "0"
        # or an "1" because this is not a two-version op
        else:
            if operand[0] == 'r':
                oprval = binary_repr(int(operand[1:]), 4)
            else:
                oprval = binary_repr(int(operand), 4)

        # Generate comment
        comment = "// {0:s} {1:s}\n".format(operator, operand)

        if len(errorList) == 0:
            # Add current line to mcodeList
            mcodeList.append("{0:s}{1:s} {2:s}".format(opcode, oprval, comment))
        codeIndex += 1

    return mcodeList, errorList

'''
main: Well, main.

return code:
    0: Normal exit
    1: No input filename provided
    2: Error when parsing
    3: Error when converting
    4: Error during output
'''
def main(argv=None):
    if argv is None:
        argv = sys.argv
    if len(argv) != 2:          # Execution command is strictly 'python assembler.py filename'
        print ("================ERROR================")
        print ("The assembler requires passing the file name of the assembly code " +
               "to be assembled.")
        print ("=====================================")
        return 1

    # Parse the assembly file
    opList, labelDict, errorList = parse_assembly(argv[1])
    '''
    for op in opList:
        print(op)
    for l in labelDict:
        print(l, labelDict[l])
    '''
    # Any error prevents further processing.
    if len(errorList) > 0:
        print ("================ERROR================")
        for err in errorList:
            print (err)
        print ("=====================================")
        return 2
    # Convert assembly to machine code
    mcodeList, errorList = convert_to_mcode(opList, labelDict)
    # Any error prevents further processing.
    if len(errorList) > 0:
        print ("================ERROR================")
        for err in errorList:
            print (err)
        print ("=====================================")
        return 3
    '''
    for mcode in mcodeList:
        print(mcode)
    '''
    dotpos = argv[1].find('.')
    filename = argv[1]
    if dotpos != -1:
        filename = filename[:dotpos]
    try:
        outf = open(filename + "_mcode.txt", "w")
    except IOError:
        print ("================ERROR================")
        print (open_file_error_template.format(filename))
        print ("=====================================")
        return 4

    for line in mcodeList:
        try:
            outf.write(line)
        except IOError:
            print ("================ERROR================")
            print (open_file_error_template.format(filename))
            print ("=====================================")
            return 4
    outf.close()
    return 0

if __name__ == "__main__":
    sys.exit(main())

if "kk" not in opcode_dict:
    print ("Waaaaaaa")
