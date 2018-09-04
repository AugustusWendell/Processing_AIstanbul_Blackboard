   DbaseNode[] data_Array;
   
   void setup() 
{
  size(1200, 700);
  frameRate(10);
  callLoader();
}

void draw() { 
  background(204);
  for (int i = 1 ; i < data_Array.length; i++) {
  data_Array[i].update();
} 
}

class DbaseNode { 
  int id, x, y, rad; 


  DbaseNode(int i, int xloc, int yloc, int r) {  
    id = i;
    x = xloc;
    y = yloc;
    rad = r;
  } 
  
  void update() { 
    //do something
    ellipse(x, y, rad, rad);
  } 
} 

void callLoader()
{
//String[] lines = loadStrings("http://processing.org/about/index.html");
//String[] lines = loadStrings("https://web.njit.edu/~sq42/ProcessingHandler.php?question=Where%20do%20you%20live%3F");
String[] lines = loadStrings("https://web.njit.edu/~sq42/ProcessingHandler.php?question=Where%20are%20you%20from%3F");

data_Array = new DbaseNode[lines.length];

println("there are " + lines.length + " lines");
for (int i = 1 ; i < lines.length; i++) {
  //println("line " + i + " = " + lines[i]);
  println(lines[i]);
  //DbaseNode h1 = new DbaseNode(i, (i+5), (i+5), 3);
  //data_Array[i] = h1; 
  data_Array[i] = new DbaseNode(i, (i*5), (i*5), 3);
} 
}
