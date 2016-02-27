/* JFlex example: partial Java language lexer specification */
import java_cup.runtime.*;

%%

%class Lexer
%unicode
%cup
%line
%column

%{
  StringBuffer string = new StringBuffer();

  private Symbol symbol(int type) {
    return new Symbol(type, yyline, yycolumn);
  }
  private Symbol symbol(int type, Object value) {
    return new Symbol(type, yyline, yycolumn, value);
  }
%}

/* TODO Must have a main function */

LineTerminator = \r|\n|\r\n
InputCharacter = [^\r\n]
WhiteSpace     = {LineTerminator} | [ \t\f]

/* comments */
Comment = {TraditionalComment} | {EndOfLineComment}

TraditionalComment   = "/#" [^#] ~"#/" | "/#" "#" + "/"
// Comment can be the last line of the file, without line terminator.
EndOfLineComment     = "#" {InputCharacter}* {LineTerminator}?

/* Union jletterdigit character class with underscore */
alphanumericUnderscore = [[:jletterdigit:]||"_"]
Identifier = [:jletter:] [:alphanumericUnderscore:]*

/*
A character is a single letter, punctuation symbol, or digit wrapped in ’’ and has type char. The allowed
punctuation symbols are space (See http://en.wikipedia.org/wiki/Punctuation) and the ASCII
symbols, other than digits, on this page http://www.kerryr.net/pioneers/ascii3.htm.
*/
SingleCharacter = [[:jletterdigit:]|| \p{Punctuation}]

DecIntegerLiteral = 0 | [1-9][0-9]*

%state STRING, CHAR

%%

<YYINITIAL> {
    "int"                           { return symbol(sym.INTEGER); }
    "bool"                          { return symbol(sym.BOOLEAN); }
    "char"                          { return symbol(sym.CHARACTER); }
    "string"                        { return symbol(sym.STRING); }
    "rat"                           { return symbol(sym.RATIONAL); }
    "float"                         { return symbol(sym.FLOAT); }
    "dict"                          { return symbol(sym.DICTIONARY); }
    "seq"                           { return symbol(sym.SEQUENCE); }
    "void"                          { return symbol(sym.VOID); }

    "top"                           { return symbol(sym.TOP); }

    "T"                             { return symbol(sym.TRUE); }
    "F"                             { return symbol(sym.FALSE); }

    "in"                            { return symbol(sym.IN); }

    "alias"                         { return symbol(sym.ALIAS); }
    "tdef"                          { return symbol(sym.TYPEDEF); }
    "while"                         { return symbol(sym.WHILE); }
    "if"                            { return symbol(sym.IF); }
    "then"                          { return symbol(sym.THEN); }
    "else"                          { return symbol(sym.ELSE); }
    "elif"                          { return symbol(sym.ELSE_IF); }
    "fi"                            { return symbol(sym.FINISH); }
    "do"                            { return symbol(sym.DO); }
    "print"                         { return symbol(sym.PRINT); }
    "read"                          { return symbol(sym.READ); }
    "forall"                        { return symbol(sym.FORALL); }
    "fdef"                          { return symbol(sym.FUNCTION_DEFINITION); }
    "od"                            { return symbol(sym.OD); }
    "return"                        { return symbol(sym.RETURN); }

    /* operators */
    "="                             { return symbol(sym.EQ); }
    "=="                            { return symbol(sym.EQEQ); }
    "+"                             { return symbol(sym.PLUS); }
    "-"                             { return symbol(sym.MINUS); }
    "*"                             { return symbol(sym.STAR); }
    "/"                             { return symbol(sym.SLASH); }
    "^"                             { return symbol(sym.CARET); }
    "_"                             { return symbol(sym.UNDERSCORE); }

    /* identifiers */
    {Identifier}                    { return symbol(sym.IDENTIFIER); }

    "<"                             { return symbol(sym.LEFT_BRACKET); }
    ">"                             { return symbol(sym.RIGHT_BRACKET); }
    "["                             { return symbol(sym.LEFT_SQUARE_BRACKET); }
    "]"                             { return symbol(sym.RIGHT_SQUARE_BRACKET); }
    ","                             { return symbol(sym.COMMA); }
    ":"                             { return symbol(sym.COLON); }
    ";"                             { return symbol(sym.SEMI_COLON); }
    "{"                             { return symbol(sym.LEFT_CURLY_BRACKET); }
    "}"                             { return symbol(sym.RIGHT_CURLY_BRACKET); }
    "("                             { return symbol(sym.LEFT_PARENTHESES); }
    ")"                             { return symbol(sym.RIGHT_PARENTHESES); }

    /* literals */
    {DecIntegerLiteral}             { return symbol(sym.NUMBER_LITERAL); }
    \"                              { string.setLength(0); yybegin(STRING); }
    \'                              { string.setLength(0); yybegin(CHARACTER); }


    /* Boolean operators */
    "!"                             { return symbol(sym.NEGATION); }
    "&&"                            { return symbol(sym.AND); }
    "||"                            { return symbol(sym.OR); }

    /* comments */
    {Comment}                       { /* ignore */ }

    /* whitespace */
    {WhiteSpace}                    { /* ignore */ }
}

<STRING> {
  \"                             { yybegin(YYINITIAL);
                                   return symbol(sym.STRING_LITERAL,
                                   string.toString()); }
  [^\n\r\"\\]+                   { string.append( yytext() ); }
  \\t                            { string.append('\t'); }
  \\n                            { string.append('\n'); }

  \\r                            { string.append('\r'); }
  \\\"                           { string.append('\"'); }
  \\                             { string.append('\\'); }
}

<CHAR> {
    \'                      { yybegin(YYINITIAL); return symbol(sym.CHAR_LITERAL, string.toString())}
    {SingleCharacter}       { string.append( yytext() ); }
    [^]                     { throw new Error("Illegal character, character has to be surrounded in '' <" + yytext() + ">"); }

}

/* error fallback */
[^]                              { throw new Error("Illegal character <" + yytext() + ">"); }