# TOKENS
import string

TT_INT = 'INT'
TT_FLOAT = 'FLOAT'
TT_CHAR = 'CHAR'
TT_DOUBLE = 'DOUBLE'
TT_LONG = 'LONG'
TT_KEYWORD = 'KEYWORD'
TT_IDENTIFIER = 'IDENTIFIER'
TT_PLUS = 'PLUS'
TT_MINUS = 'MINUS'
TT_MUL = 'MUL'
TT_DIV = 'DIV'
TT_POW = 'POW'
TT_EQ = 'EQ'
TT_LPAR = 'LPAR'
TT_RPAR = 'RPAR'
TT_EE = 'EE'
TT_NE = 'NE'
TT_LT = 'LT'
TT_GT = 'GT'
TT_LTE = 'LTE'
TT_GTE = 'GTE'
TT_EOF = 'EOF'

DIGITS = '0123456789'

KEYWORDS = [
    'AND',
    'OR',
    'NOT',
]
VAIRABLE_TYPES = [
    'int',
    'var',
    'float',
    'char',

]
LETTERS = string.ascii_letters
LETTERS_DIGITS = LETTERS + DIGITS


class Token:
    def __init__(self, type_, value=None, pos_start=None, pos_end=None):
        self.type = type_
        self.value = value

        if pos_start:
            self.pos_start = pos_start.copy()
            self.pos_end = pos_start.copy()
            self.pos_end.advance()

        if pos_end:
            self.pos_end = pos_end

    def matches(self, type_, value):
        return self.type == type_ and self.value == value

    def __repr__(self):
        if self.value: return f'{self.type}:{self.value}'
        return f'{self.type}'
