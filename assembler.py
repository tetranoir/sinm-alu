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

'''
invalid_op: Generates an error message for invalid operation

input:  opStr: string, the operation in question
        lineNum: the line the operation shows up
output: string, an error message
'''
def invalid_op(op, lineNum):
    return "The operator {0:s} at line {1:d} is invalid".format(op, lineNum)

'''
invalid_oprand: Generates an error message for invalid operand

input:  oprand: string, the operand in question
        lineNum: the line the operand shows up
output: string, an error message
'''
def invalid_oprand(oprand, lineNum):
    return "The operand {0:s} at line {1:d} is invalid".format(oprand, lineNum)

'''
duplicate_label: Generates an error message for duplicate label

input:  label: string, the label in question
        lineNum: the line the dup label shows up
output: string, an error message
'''
def duplicate_label(label, lineNum):
    return "The label {0:s} at line {1:d} is duplicate".format(label, lineNum)

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
    f = open(fileName, "r")

    lineNum = 1 # Line number as in the assembly file
    for line in f:
        tokens = line.split()   # Split line by spaces/tabs
        if len(tokens) > 0:     # If not empty line
            if (tokens[0])[0] != '#' and (tokens[0])[0:2] != '//': # If not comment
                if tokens[0] not in opcode_dict:    # If the first word is not an instruction
                    if (tokens[0])[-1] != ':':      # and not a label
                        errorList.append(invalid_op(tokens[0], lineNum)) # ERROR!!!!
                    else:       # Label
                        label = (tokens[0])[:-1]
                        if label in labelDict:  # Check for duplicate label
                            errorList.append(duplicate_label(label, lineNum))
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
                        opList.append((token[0], token[1])) # Put in the original jump
                    else:                               # General instruction
                        operand = (token[1])
                        if operand[0] == 'r':       # If the operand is a register,
                            operand = operand[1:]   # take out the 'r' before testing.
                        if try_operand_value(operand) is None:  # Error for NaN.
                            errorList.append(invalid_oprand(token[1], lineNum))
                        else:                       # Store the (operator, operand) pair.
                            opList.append((tokens[0], tokens[1]))
        lineNum += 1    # Keep up the line number counter.
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
                ???
'''
def convert_to_mcode(opList, labelDict):
    pass #TODO

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
        print ("=====================================")
        print ("The assembler requires passing the file name of the assembly code " +
               "to be assembled.")
        print ("=====================================")
        return 1

    # Parse the assembly file
    opList, labelDict, errorList = parse_assembly(argv[1])
    # Any error prevents further processing.
    if len(errorList) > 0:
        print ("=====================================")
        for err in errorList:
            print (err)
        print ("=====================================")
        return 2
    # Convert assembly to machine code
    mcodeList, errorList = convert_to_mcode(opList, labelDict)
    # Any error prevents further processing.
    if len(errorList) > 0:
        print ("=====================================")
        for err in errorList:
            print (err)
        print ("=====================================")
        return 3

    # Output machine code
    return 0

if __name__ == "__main__":
    sys.exit(main())

if "kk" not in opcode_dict:
    print ("Waaaaaaa")
