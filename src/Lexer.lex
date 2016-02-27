/* JFlex example: partial Java language lexer specification */
import java_cup.runtime.*;

%%

%class Lexer
%unicode
%cup
%line
%column

%{
  private boolean debug_mode;
  public  boolean debug()            { return debug_mode; }
  public  void    debug(boolean mode){ debug_mode = mode; }

  StringBuffer string = new StringBuffer();

  private void print_lexeme(int type, Object value){
      if(!debug()){ return; }

      System.out.print("<");
      switch(type){
        case sym.INTEGER:
            System.out.print("int"); break;
        case sym.BOOLEAN:
            System.out.print("bool"); break;
        case sym.CHARACTER:
            System.out.print("char"); break;
        case sym.STRING:
            System.out.print("string"); break;
        case sym.RATIONAL:
            System.out.print("rat"); break;
        case sym.FLOAT:
            System.out.print("float"); break;
        case sym.DICTIONARY:
            System.out.print("dict"); break;
        case sym.SEQUENCE:
            System.out.print("seq"); break;
        case sym.VOID:
            System.out.print("void"); break;

        case sym.TOP:
            System.out.print("top"); break;
        case sym.TRUE:
            System.out.print("T"); break;
        case sym.FALSE:
            System.out.print("F"); break;
        case sym.IN:
            System.out.print("in"); break;
        case sym.ALIAS:
            System.out.print("alias"); break;
        case sym.TYPEDEF:
            System.out.print("tdef"); break;
        case sym.WHILE:
            System.out.print("while"); break;
        case sym.IF:
            System.out.print("if"); break;
        case sym.THEN:
            System.out.print("then"); break;
        case sym.ELSE:
            System.out.print("else"); break;
        case sym.ELSE_IF:
            System.out.print("elif"); break;
        case sym.FINISH:
            System.out.print("fi"); break;
        case sym.DO:
            System.out.print("do"); break;
        case sym.PRINT:
            System.out.print("print"); break;
        case sym.READ:
            System.out.print("read"); break;
        case sym.FORALL:
            System.out.print("forall"); break;
        case sym.FUNCTION_DEFINITION:
            System.out.print("fdef"); break;
        case sym.OD:
            System.out.print("od"); break;
        case sym.RETURN:
            System.out.print("return"); break;
        case sym.EQ:
            System.out.print("="); break;
        case sym.EQEQ:
            System.out.print("=="); break;
        case sym.PLUS:
            System.out.print("+"); break;
        case sym.MINUS:
            System.out.print("-"); break;
        case sym.MULT:
            System.out.print("*"); break;
        case sym.SLASH:
            System.out.print("/"); break;
        case sym.CARET:
            System.out.print("^"); break;
        case sym.UNDERSCORE:
            System.out.print("_"); break;
        case sym.IDENTIFIER:
            System.out.printf("IDENT %s", value); break;
        case sym.L_BRACKET:
            System.out.print("<"); break;
        case sym.R_BRACKET:
            System.out.print(">"); break;
        case sym.L_SQUARE_BRACKET:
            System.out.print("["); break;
        case sym.R_SQUARE_BRACKET:
            System.out.print("]"); break;
        case sym.COMMA:
            System.out.print(","); break;
        case sym.COLON:
            System.out.print(":"); break;
        case sym.SEMI_COLON:
            System.out.print(";"); break;
        case sym.L_CURLY_BRACKET:
            System.out.print("{"); break;
        case sym.R_CURLY_BRACKET:
            System.out.print("}"); break;
        case sym.L_PAREN:
            System.out.print("("); break;
        case sym.R_PAREN:
            System.out.print(")"); break;
        case sym.NUMBER_LITERAL:
            System.out.printf("Number %d", value); break;
        case sym.NEGATION:
            System.out.print("!"); break;
        case sym.AND:
            System.out.print("&&"); break;
        case sym.OR:
            System.out.print("||"); break;
      }
      System.out.print(">  ");
    }

  private Symbol symbol(int type) {
    return new Symbol(type, yyline, yycolumn);
  }
  private Symbol symbol(int type, Object value) {
    return new Symbol(type, yyline, yycolumn, value);
  }
%}

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
    "*"                             { return symbol(sym.MULT); }
    "/"                             { return symbol(sym.SLASH); }
    "^"                             { return symbol(sym.CARET); }
    "_"                             { return symbol(sym.UNDERSCORE); }

    /* identifiers */
    {Identifier}                    { return symbol(sym.IDENTIFIER); }

    "<"                             { return symbol(sym.L_BRACKET); }
    ">"                             { return symbol(sym.R_BRACKET); }
    "["                             { return symbol(sym.L_SQUARE_BRACKET); }
    "]"                             { return symbol(sym.R_SQUARE_BRACKET); }
    ","                             { return symbol(sym.COMMA); }
    ":"                             { return symbol(sym.COLON); }
    ";"                             { return symbol(sym.SEMI_COLON); }
    "{"                             { return symbol(sym.L_CURLY_BRACKET); }
    "}"                             { return symbol(sym.R_CURLY_BRACKET); }
    "("                             { return symbol(sym.L_PAREN); }
    ")"                             { return symbol(sym.R_PAREN); }

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
                                   return symbol(sym.STRING_LITERAL, string.toString()); }
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