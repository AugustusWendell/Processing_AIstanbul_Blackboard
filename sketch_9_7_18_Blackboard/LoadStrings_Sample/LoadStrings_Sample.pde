//String[] lines = loadStrings("http://processing.org/about/index.html");

String[] lines = loadStrings("https://web.njit.edu/~sq42/ProcessingHandler.php?question=Where%20do%20you%20live%3F");
//String[] lines = loadStrings("https://web.njit.edu/~sq42/AIUnityHandler.php?0=new+york&Q0=where%20are%20you%20from%3F");
//String[] lines = loadStrings("https://web.njit.edu/~sq42/AIUnityHandler.php?Q0=where%20are%20you%20from%3F");


println("there are " + lines.length + " lines");
for (int i = 0 ; i < lines.length; i++) {
  println("line " + i + " = " + lines[i]);
}
