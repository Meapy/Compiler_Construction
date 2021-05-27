import sys
from antlr4 import *
from python3Lexer import python3Lexer
from python3Parser import python3Parser


def main(argv):
    input_stream = FileStream("helloworld.c")
    lexer = python3Lexer(input_stream)
    stream = CommonTokenStream(lexer)
    parser = python3Parser(stream)
    tree = parser.printfStatement()
    print(tree.toStringTree())


if __name__ == '__main__':
    main(sys.argv)