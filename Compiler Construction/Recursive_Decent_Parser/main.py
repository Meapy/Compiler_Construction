import Lexer as lx
import Parser as px


##################################################
# RUN
##################################################

def run(fn, text):
    lexer = lx.Lexer(fn, text)
    tokens, error = lexer.make_tokens()

    if error: return None, error
    # generate AST
    parser = px.Parser(tokens)
    ast = parser.parse()
    return ast.node, ast.error


while True:
    text = input('c > ')
    result, error = run('<stdin>', text)

    if error:
        print(error.as_string())
    else:
        print(result)
