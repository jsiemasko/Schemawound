(
/*
*  MORSE by Jonathan Siemasko
*  http://www.schemawound.com/
*
*  Function to take a string and convert it to morse code.
*  Handles a-z, A-Z and 0-9
*  Parameters allow you to adjust the space between letters and words
*  These parameters default to international morse code as shown on http://en.wikipedia.org/wiki/Morse_code
*
*  NOTE: wordSpace must be equal to or greater than letterSpace.
*
*  Created to assist my work on DISQUIET JUNTO PROJECT 0050: -…….–.-..-…-
*  More Info: http://disquiet.com/2012/12/13/disquiet0050-morsebeat/
*/
var morse = {|inString, spaceBetweenLetters = 3, spaceBetweenWords = 7|
	var outString = ""; //String that will be output
	var letterSpace = ""; //String representing space between letters
	var wordSpace = ""; //String representing space between words
	var charToMorse;

	//Fill letterSpace per number specified in spaceBetweenLetters
	(spaceBetweenLetters - 1).do{letterSpace = letterSpace ++ " "};

	//Fill wordSpace per number specified in spaceBetweenWords.
	//wordSpace reduced by the size of letterSpace to account for that will occur before it.
	(spaceBetweenWords - spaceBetweenLetters).do{wordSpace = wordSpace ++ " "};

	//Function to convert a single character to morse code
	charToMorse = {|inChar|
		switch(inChar,
			//Alpha
			$A, {".-"},     $B, {"-..."},   $C, {"-.-."},   $D, {"-.."},    $E, {"."},      $F, {"..-."},
			$G, {"--."},    $H, {"...."},   $I, {".."},     $J, {".---"},   $K, {"-.-"},    $L, {".-.."},
			$M, {"--"},     $N, {"-."},     $O, {"---"},    $P, {".--."},   $Q, {"--.-"},   $R, {".-."},
			$S, {"..."},    $T, {"-"},      $U, {"..-"},    $V, {"...-"},   $W, {".--"},    $X, {"-..-"},
			$Y, {"-.--"},   $Z, {"--.."},
			//Numeric
			$1, {".----"},  $2, {"..---"},  $3, {"...--"},  $4, {"....-"},  $5, {"....."},  $6, {"-...."},
			$7, {"--..."},  $8, {"---.."},  $9, {"----."},  $0, {"-----"},
			//Special Handling
			$ , {wordSpace}
		);
	};

	//Take the input string, convert to uppercase and convert one letter at a time.  Add letterSpace between letters
	inString.toUpper.do{|char, i|
		var isFinalChar = (i != (inString.size - 1));
		var isWordSpace = (char != $ );
		outString = outString ++ charToMorse.(char);
		//Include letterSpace after each character except wordSpaces and the final letter.
		if(isFinalChar && isWordSpace, {outString = outString + letterSpace});
	};
	outString;
};

//Test it out
morse.("Hello World");
)
