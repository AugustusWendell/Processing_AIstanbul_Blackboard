import java.net.HttpURLConnection;    // required for HTML download
import java.net.URL;
import java.net.URLEncoder;
import java.io.InputStreamReader;     // used to get our raw HTML source        


int x = 0;
String madlib = "Tomorrow I will";
String time = "tomorrow";
String location = "cafe blah";
String activity = "date";
String guest = "susan";
String order = "kebab";

void setup() {
 // fullScreen();
 size(400, 400);
  background(0);
  noStroke();
  fill(102);
}

void draw() {
  rect(x, height*0.2, 1, height*0.6); 
  x = x + 2;
  text(madlib, 10, 30);
}

void mousePressed() {
  println("Mouse was pressed");
  searchforgoogleimages();
}

//Most all of this method comes from Jeff Thompson github.com/jeffThompson
void searchforgoogleimages() {
String searchTerm = "istanbul";       // term to search for (use spaces to separate terms)
int offset = 20;                      // we can only 20 results at a time - use this to offset and get more!
String fileSize = "10mp";             // specify file size in mexapixels (S/M/L not figured out yet)
String source = null;                 // string to save raw HTML source code

// format spaces in URL to avoid problems
searchTerm = searchTerm.replaceAll(" ", "%20");

// get Google image search HTML source code; mostly built from PhyloWidget example:
// http://code.google.com/p/phylowidget/source/browse/trunk/PhyloWidget/src/org/phylowidget/render/images/ImageSearcher.java
try {
  URL query = new URL("http://images.google.com/images?gbv=1&start=" + offset + "&q=" + searchTerm + "&tbs=isz:lt,islt:" + fileSize);
  HttpURLConnection urlc = (HttpURLConnection) query.openConnection();                                // start connection...
  urlc.setInstanceFollowRedirects(true);
  urlc.setRequestProperty("User-Agent", "");
  urlc.connect();
  BufferedReader in = new BufferedReader(new InputStreamReader(urlc.getInputStream()));               // stream in HTTP source to file
  StringBuffer response = new StringBuffer();
  char[] buffer = new char[1024];
  while (true) {
    int charsRead = in.read(buffer);
    if (charsRead == -1) {
      break;
    }
    response.append(buffer, 0, charsRead);
  }
  in.close();                                                                                          // close input stream (also closes network connection)
  source = response.toString();
}

// any problems connecting? let us know
catch (Exception e) {
  e.printStackTrace();
}

// extract image URLs only, starting with 'imgurl'
if (source != null) {
  String[][] m = matchAll(source, "img height=\"\\d+\" src=\"([^\"]+)\"");
  
  for (int i=0; i<m.length; i++) {                                                          // iterate all results of the match
    println(i + ":\t" + m[i][1]);        // print (or store them)**
    //try to load each image into the current image pane
    
    PImage webImg;
    String url = m[i][1];
    webImg = loadImage(url, "png");
    image(webImg, int(random(200)), int(random(200)));
  }
}
}
