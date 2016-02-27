import java.io.FileReader;
import java.io.FileNotFoundException;

class TestLexer {
    public static void main(String[] args) {
        Lexer lexer;
        try {
            lexer = new Lexer(new FileReader("input_file.txt"));
            System.out.println("Finished lexing");
        } catch (FileNotFoundException e1) {
            e1.printStackTrace();
        }
    }
}
