import java_cup.runtime.Symbol;

public class Parser {
    private Lexer lexer;

    public boolean syntaxErrors;

    public Parser(Lexer lexer) {
        this.lexer = lexer;
    }

    public Symbol parse() {
        return null;
    }

    public void syntax_error(Symbol current_token) {
        System.out.println("Syntax error at line " + (current_token.left + 1) + ", column " + current_token.right);
    }
}
