grammar python3;

@header {
#include "TypeSpecifier.h"
}

/***************************************************
 *                                                 *
 *                   C O M M O N                   *
 *                                                 *
 **************************************************/

compilationUnit
    :   translationUnit? EOF
    ;

translationUnit
    :   externalDeclaration
    |   translationUnit externalDeclaration
    ;

typeSpecifier
    :
    (   Void
    |   Bool
    |   Char
    |   Int
    |   Float
    |   Double
    )
    ;

blockItemList
    :   blockItem
    |   blockItemList blockItem
    ;

blockItem
    :   statement
    |   declaration
    |   functionCall
    ;

/// Im not sure why this doesn't work as a lexer rule, but it does as a parser rule
value
    :   Identifier
    |   IntegerConstant
    |   FloatConstant
    ;

/***************************************************
 *                                                 *
 *             D E C L A R A T I O N S             *
 *                                                 *
 **************************************************/

externalDeclaration
    :   functionDefinition
    |   declaration
    |   Semi
    ;

declaration
    :   typeSpecifier Identifier (Comma Identifier)* Semi
    |   typeSpecifier assignmentExpression (Comma assignmentExpression)* Semi
    ;

/***************************************************
 *                                                 *
 *                  F U N C T I O N                *
 *                                                 *
 **************************************************/

functionParameterList

    :   typeSpecifier Identifier (Comma typeSpecifier Identifier)*
    ;

functionDefinition
    locals [
        string function_header,
        vector <string> args,
        string return_type,
        uint32_t num_local_vars = 0,
        size_t stack_size = 0,
    ]
    :   typeSpecifier Identifier parameterTypeList
    ;

parameterTypeList
    :   LeftParen functionParameterList? RightParen
    ;

functionCall
    :   Identifier LeftParen identifierList? RightParen Semi
    ;

functionReturn
    :   Identifier LeftParen identifierList? RightParen
    ;

/***************************************************
 *                                                 *
 *                S T A T E M E N T S              *
 *                                                 *
 **************************************************/

statement
    :   expressionStatement
    |   iterationStatement
    |   unaryStatement
    |   printfStatement
    ;

printfStatement
    locals [
        string format_string,
        vector <string> args,
    ]
    // printf("Printing : %f", 100.0f);
    :   Printf LeftParen String ( Comma value )* RightParen Semi
    ;


expressionStatement
    :   expression? Semi
    ;

ifStatement
    :   If LeftParen conditionalExpression RightParen statement
    ;

elseIfStatement
    locals [
        uint32_t id = 0
    ]
    :   Else If LeftParen conditionalExpression RightParen statement
    ;

elseStatement
    :   Else statement
    ;

iterationStatement
    :   While LeftParen conditionalExpression RightParen statement
    ;


unaryStatement
    locals [
        backend::TypeSpecifier type,
        char type_letter = '?'
    ]
    :   PlusPlus   Identifier  # unaryIncrementStatement
    |   MinusMinus Identifier  # unaryDecrementStatement
    |   Identifier PlusPlus    # unaryIncrementStatement
    |   Identifier MinusMinus  # unaryDecrementStatement
    |   Identifier Power       # unarySquareStatement
    ;

/***************************************************
 *                                                 *
 *               E X P R E S S I O N S             *
 *                                                 *
 **************************************************/

identifierList
    :   expression (Comma expression)*
    ;

expression
    locals [
        backend::TypeSpecifier type,
        string expr_operator,
        char type_letter = '?'
    ]
    :   expression opr=( '*' | '/' | '%' ) expression                       # mulDivExpr
    |   expression opr=( '+' | '-' ) expression                             # addminExpr
    |   expression opr=( '<<' | '>>' | '&' | '|' | '~' | '^' ) expression   # bitExpr
    |   primaryExpression                                                   # primExpr
    ;

primaryExpression
    locals [
        char type_letter = '?',
        uint32_t current_nesting_level = 0
    ]
    :   Identifier
    |   IntegerConstant
    |   FloatConstant
    |   LeftParen expression RightParen
    ;

conditionalExpression
    locals [
        string iteration_name,  /// Stores the name of the parent statement (while_N | if_N)
        string opr,             /// Stores the operator chars
        string opcode           /// Stores the instruction opcode used in Pass 2
    ]
    :   expression ConditionalOperator expression                               # basicConditionalExpr
    |   conditionalExpression ConditionalConnectOperator conditionalExpression  # connectedConditionalExpr
    |   LeftParen conditionalExpression RightParen                              # parenthesizedConditionalExpr
    |   Not LeftParen conditionalExpression RightParen                          # negatedConditionalExpr
    ;

assignmentExpression
    locals [
        backend::TypeSpecifier type,
        char type_letter = 0,
        uint32_t current_nesting_level = 0
    ]
    :   Identifier Assign expression
    |   Identifier Assign functionReturn
    ;

/***************************************************
 *                                                 *
 *                   Fragments                     *
 *                                                 *
 **************************************************/

fragment
IdentifierNondigit
    :   Nondigit
    ;

fragment
Nondigit
    :   [a-zA-Z_]
    ;

fragment
DigitSequence
    :   Digit+
    ;

fragment
Digit
    :   [0-9]
    ;

fragment
NonzeroDigit
    :   [1-9]
    ;

fragment
Constant
    :   IntegerConstant
    |   FloatConstant
    ;

ConditionalConnectOperator
    :   OrOr
    |   AndAnd
    ;

ConditionalOperator
    :   Less
    |   LessEqual
    |   Greater
    |   GreaterEqual
    |   Equal
    |   NotEqual
    ;


/***************************************************
 *                                                 *
 *                      Lexer                      *
 *                                                 *
 **************************************************/



///Tokens
Printf           : 'printf';
Break            : 'break';
DoubleQuote      : '"';
Case             : 'case';
Char             : 'char';
Const            : 'const';
Bool             : 'bool';
Default          : 'default';
Double           : 'double';
Else             : 'else';
Float            : 'float';
For              : 'for';
If               : 'if';
Int              : 'int';
Uint32           : 'uint32_t';
Int32            : 'int32_t';
Long             : 'long';
Return           : 'return';
Short            : 'short';
Signed           : 'signed';
Sizeof           : 'sizeof';
Static           : 'static';
Switch           : 'switch';
Typedef          : 'typedef';
Unsigned         : 'unsigned';
Void             : 'void';
While            : 'while';
LeftParen        : '(';
RightParen       : ')';
LeftBracket      : '[';
RightBracket     : ']';
LeftBrace        : '{';
RightBrace       : '}';
Less             : '<';
LessEqual        : '<=';
Greater          : '>';
GreaterEqual     : '>=';
LeftShift        : '<<';
RightShift       : '>>';
Plus             : '+';
PlusPlus         : '++';
Minus            : '-';
MinusMinus       : '--';
Star             : '*';
Power            : '^';
Div              : '/';
Mod              : '%';
And              : '&';
Or               : '|';
Negate           : '~';
Question         : '?';
Colon            : ':';
Semi             : ';';
Comma            : ',';
Assign           : '=';
StarAssign       : '*=';
DivAssign        : '/=';
ModAssign        : '%=';
PlusAssign       : '+=';
MinusAssign      : '-=';



IntegerConstant
    :   '-'? NonzeroDigit Digit*
    |   '0'
    ;

FloatConstant
    :   '-'? DigitSequence? '.' DigitSequence
    |   DigitSequence '.'
    ;

AndAnd
    :   '&&'
    |   'and'
    ;

OrOr
    :   '||'
    |   'or'
    ;
Not
    :   '!'
    |   'not'
    ;

Equal
    :   '=='
    |   'is'
    ;

NotEqual
    :   '!='
    |   'is not'
    ;

Identifier
    :   IdentifierNondigit
        (   IdentifierNondigit
        |   Digit
        )*
    ;

String
    :   DoubleQuote .*? DoubleQuote // Regex : /"([^"\\]*(\\.[^"\\]*)*)"/
    ;


Whitespace
    :   [ \t]+
        -> skip
    ;

Newline
    :   (   '\r' '\n'?
        |   '\n'
        )
        -> skip
    ;

BlockComment
    :   '/*' .*? '*/'
        -> skip
    ;

LineComment
    :   '//' ~[\r\n]*
        -> skip
    ;