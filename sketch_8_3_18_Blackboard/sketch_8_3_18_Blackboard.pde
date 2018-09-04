import twitter4j.conf.*;
import twitter4j.*;
import twitter4j.auth.*;
import twitter4j.api.*;


import java.net.HttpURLConnection;    // required for HTML download
import java.net.URL;
import java.net.URLEncoder;
import java.io.InputStreamReader;     // used to get our raw HTML source        

//[AI]stanbul Blackboard application

int x = 0;
String madlib = "Tomorrow I will";
String day = "tomorrow";
String location = "cafe blah";
String activity = "date";
String guest = "susan";
String order = "kebab";

States state = States.STATE_2;

int time;
//time between state changes, from itinerary to dataviz to image presentation
int wait = 5000;

//for JSON readIn test
//JSONObject json;

void setup() {
 // fullScreen();
 size(1000, 600);
  background(0);
  noStroke();
  fill(102);
  time = millis();//store the current time
  
//test States Enumerator
switch (state) {
case STATE_1 :
  println("STATE 1");
  break;
case STATE_2:
  println("STATE 2");
  break;
case STATE_3:
  println("STATE 3");
  break;
}

//test getState function
println(getState());
}

void draw() {
  
  //test States Enumerator
switch (state) {
case STATE_1 :
  println("draw State 1");
  WriteItinerary();
  break;
case STATE_2:
  println("draw State 2");
  DatabaseViz();
  break;
case STATE_3:
  println("draw State 3");
  ShowImages();
  break;
}
  
  //check the difference between now and the previously stored time is greater than the wait interval
  if(millis() - time >= wait){
    println("tick");//if it is, do something
    //println(getMode());
    time = millis();//also update the stored time
    //clear the screen
    background(0);
    
    
    //changes the state to toggle the behaviour of the blackboard
    if(state == States.STATE_2){
      state = States.STATE_3;
    } else
   if(state == States.STATE_3){
      state = States.STATE_1;
    } else
    if(state == States.STATE_1){
      state = States.STATE_2;
    } 
  }
}

public void setState() {
    
}

public int getState() {
    switch (state) {
        case STATE_1: return 1;
        case STATE_2: return 2;
        case STATE_3: return 3;
    }
    return 0;
}

//when the state is set to writing the itinerary, the draw method will call this routine to run
void WriteItinerary() {
  textSize(100);
  text(madlib, 10, 30);
}

//when the state is set to the visualizing the database, the draw method will call this routine to run
void DatabaseViz() {
  rect(x, height*0.2, 1, height*0.6); 
  x = x + 2;
}

//when the state is set to showing the images, the draw method will call this routine to run
void ShowImages() {
  searchforgoogleimages();
}


void readIn() {

  
/*  
// The following short JSON file called "data.json" is parsed 
// in the code below. It must be in the project's "data" folder.
//
// {
//   "id": 0,
//   "species": "Panthera leo",
//   "name": "Lion"
// }

JSONObject json;

  json = loadJSONObject("data.json");

  int id = json.getInt("id");
  String species = json.getString("species");
  String name = json.getString("name");

  println(id + ", " + species + ", " + name);
}
*/

//old debug statements here to use a mousepressed input to make something happen
void mousePressed() {
  println("Mouse was pressed");
  //searchforgoogleimages();
  //readIn();
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
    //image(webImg, int(random(200)), int(random(200)));
    for (int y=0; y<6; y++) {   
    image(webImg, (i * 100), (y * 100));
    }
  }
}
}
