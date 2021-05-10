grammar python3;

expr    : term ((PLUS | MINUS)  term)*;

term    : factor ((MUL | DIV)  factor)*;

factor  : (PLUS|MINUS) factor;
        : power;

power   : factor(POW factor)*;

atom    : INT| FLOAT;
        : LPAREN expr RPAREN;


