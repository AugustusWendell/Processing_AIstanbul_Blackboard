//String[] lines = loadStrings("http://processing.org/about/index.html");

//String[] lines = loadStrings("https://web.njit.edu/~sq42/ProcessingHandler.php?question=Where%20do%20you%20live%3F");
String[] lines = loadStrings("https://web.njit.edu/~sq42/ProcessingHandler.php?question=HDis%3F");



println("there are " + lines.length + " lines");
for (int i = 0 ; i < lines.length; i++) {
  println("line " + i + " = " + lines[i]);
}
