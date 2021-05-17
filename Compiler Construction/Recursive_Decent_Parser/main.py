import Lexer as lx
import Parser as px
import Interpreter as ix


##################################################
# RUN
##################################################
global_symbol_table = ix.SymbolTable()
global_symbol_table.set("null", ix.Number(0))



def run(fn, text):
    lexer = lx.Lexer(fn, text)
    tokens, error = lexer.make_tokens()
    if error: return None, error

    # generate AST
    parser = px.Parser(tokens)
    ast = parser.parse()
    if ast.error: return None, ast.error

    # Run program
    interpreter = ix.Interpreter()
    context = ix.Context('<program>')
    context.symbol_table = global_symbol_table
    result = interpreter.visit(ast.node, context)

    return result.value, result.error


while True:
    text = input('c > ')
    result, error = run('<stdin>', text)

    if error:
        print(error.as_string())
    else:
        print(result)

