import java.io.FileReader;
import java.io.FileNotFoundException;

import java_cup.runtime.*;

class SC {
    public static void main(String[] args) {
    	Lexer lexer;
		try {
			lexer = new Lexer(new FileReader(args[0]));
			lexer.debug(true);

			try {
				Parser parser = new Parser(lexer);
				parser.debug(true);

				System.out.println("digraph G {");
				Symbol result = parser.parse();
				System.out.println("}");
			} catch (Exception e) {
				// Commented out because this output is uniformative.  ETB
				//e.printStackTrace();
			}
		} catch (FileNotFoundException e1) {
			e1.printStackTrace();
		}
    }
}
