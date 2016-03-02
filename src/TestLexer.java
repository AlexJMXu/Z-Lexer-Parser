import java_cup.runtime.Symbol;

import java.io.FileReader;
import java.io.FileNotFoundException;

class TestLexer {
    public static void main(String[] args) {
        Lexer lexer;
        try {
            lexer = new Lexer(new FileReader("input/input_file.txt"));
            lexer.debug(true);

            try {
                Parser parser = new Parser(lexer);
                //parser.debug(true);

                Symbol result = parser.parse();
                if(!parser.syntaxErrors){
                    System.out.println("parsing successful");
                }
            } catch (Exception e) {
                // Commented out because this output is uniformative.  ETB
                //e.printStackTrace();
            }

            System.out.println("Finished lexing");
        } catch (FileNotFoundException e1) {
            e1.printStackTrace();
        }
    }
}
