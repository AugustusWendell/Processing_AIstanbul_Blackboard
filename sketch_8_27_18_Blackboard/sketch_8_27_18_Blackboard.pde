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
int textline = 0;

//these String variables are used to build the itinerary
String location = "Newark";
String madlib = "Placeholder";
String day = "tomorrow";
String activity = "date";
String guest = "susan";
String order = "kebab";

States state = States.STATE_2;

int time;
//time between state changes
int wait = 20000;

PImage img;

//for JSON readIn test
//JSONObject json;

void setup() {
  //full screen toggle
  //fullScreen();
  //size(1500, 738);
  size(1600, 838);
  background(0);
  noStroke();
  fill(102);
  smooth(1);
  time = millis();//store the current time
  //frameRate(.5
  
  //load in the image being used for the map
  img = loadImage("MAP_1500_738.png");
  
/*
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
*/
}


void draw() {
//draw watermark
textSize(10);
fill(200,200,200);
text("AIstanbul Blackboard Application 0.8", 12, 12);
  
  
switch (state) {
case STATE_1 :
  println("draw State 1 - Textual Itinerary");
  WriteItinerary(); //State 1 createst the itinerary
  delay(2000);
  break;
case STATE_2:
  println("draw State 2 - Database Viz");
  DatabaseViz(); //State 2 creates a database vizualization
  delay(2000);
  break;
case STATE_3:
  println("draw State 3 - Show Images");
  ShowImages(); //State 3 shows an image search
  delay(2000);
  break;
case STATE_4:
  println("draw State 4 - Show All IDs");
  DrawIDs(); //State 4 shows all ID locations
  delay(2000);
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
    if(state == States.STATE_1){
      state = States.STATE_2;
    } else
   if(state == States.STATE_2){
      state = States.STATE_3;
    } else
    if(state == States.STATE_3){
      state = States.STATE_4;
    } else
    if(state == States.STATE_4){
      state = States.STATE_1;
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
  //image(img, 0, 0);
  
  textSize(10);
  fill(200,200,200);
  smooth(2);
  text("Draw Mode 1: Itinerary", 12, 24);
  
  
  //create new query to get data from the database to populate the mad lib itinerary
  //String[] lines = loadStrings("https://web.njit.edu/~sq42/ProcessingHandler.php?question=Where%20are%20you%20from%3F");
  String[] lines = loadStrings("https://web.njit.edu/~sq42/ProcessingHandler.php?question=HDis");
  println("there are " + lines.length + " lines");
  for (int i = 0 ; i < lines.length; i++) {
    println("line " + i + " = " + lines[i]);
  }
  int r = int(random(lines.length));
  println("random location value = " + r);
  location = lines[r];

  textSize(25);
  madlib = day +" I will " + activity + " at " + location + " with " + guest;
  text(madlib, 10, textline);
  textline = textline + 40;
}


int[] ConvertCoords() {
 //convert lat and long to pixel values 
 //dummy method not used
 int[] ret = new int[2];
 ret[1] = 30;
 ret[2] = 45;
 return ret;
}

//lat/long  lat/long  lat/long  lat/long  size color(single value)
void DrawItinerary(float[] a, float[] b, float[] c , float[] d, int e, int s) {
  DrawMapPoint(a, e, s, s, s);
  //delay(100);
  DrawMapPoint(b, e, s, s, s);
  //delay(100);
  DrawMapPoint(c, e, s, s, s);
  //delay(100);
  DrawMapPoint(d, e, s, s, s);
  //delay(100);
  DrawMapLine(a, b, e);
  //delay(100);
  DrawMapLine(b, c, e);
  //delay(100);
  DrawMapLine(c, d, e);
}

void DrawMapLine(float[] a, float[] b, int weight) {
  //convert map coordinates to screen coordinates
  //define edge map lat and long
 
  //LAT Y
  //float bottomedge = 40.911613;
  float bottomedge = 40.8;
  //float topedge = 41.196489;
  float topedge = 41.198;
  float bottomtotop = topedge - bottomedge; //.284876       1/ = 3.5102992179
  float inputlat = a[0]; //for instance 41.0    Y VALUE!!!
  
  //LONG X
  float leftedge = 28.43;
  float rightedge =  29.48;
  float lefttoright = rightedge - leftedge; //1.052376      1/ = .950230716
  float inputlong = a[1]; //for instance 28.9   X VALUE!!!
  
  int screenwidth = 1500;
  int screenheight = 738;
  
    //LAT Y
  float inputlat1 = a[0]; //for instance 41.0
  
  float drawlat1 = ((1/bottomtotop) * (topedge - inputlat1)) * screenheight;
    //LONG X
  float inputlong1 = a[1];
  float drawlong1 = ((1/lefttoright) * (rightedge - inputlong1)) * screenwidth;
  
   //LAT Y
   float inputlat2 = b[0]; //for instance 41.0
  float drawlat2 = ((1/bottomtotop) * (topedge - inputlat2)) * screenheight;
  //LONG X
  float inputlong2 = b[1];
  float drawlong2 = ((1/lefttoright) * (rightedge - inputlong2)) * screenwidth;
  
  fill(weight);
  line(drawlong1, drawlat1, drawlong2, drawlat2);
}

void DrawMapPoint(float[] a, int e, int c1, int c2, int c3) {
  
  //convert map coordinates to screen coordinates
  //define edge map lat and long
 
  //LAT Y
  //float bottomedge = 40.911613;
  float bottomedge = 40.8;
  //float topedge = 41.196489;
  float topedge = 41.198;
  float bottomtotop = topedge - bottomedge; //.284876       1/ = 3.5102992179
  float inputlat = a[0]; //for instance 41.0    Y VALUE!!!
  
  //LONG X
  float leftedge = 28.43  ;
  float rightedge =  29.48;
  float lefttoright = rightedge - leftedge; //1.052376      1/ = .950230716
  float inputlong = a[1]; //for instance 28.9   X VALUE!!!
  
  int screenwidth = 1500;
  int screenheight = 738;


  //LAT Y
  float drawlat = ((1/bottomtotop) * (topedge - inputlat)) * screenheight; //Y VALUE FOR DRAWING
  println("draw lat (y coordinate) = " + drawlat);
  
  //LONG X
  float drawlong = ((1/lefttoright) * (rightedge - inputlong)) * screenwidth;  //X VALUE FOR DRAWING
  println("draw long (x coordinate) = " + drawlong);
  
  fill(c1, c2, c3);
  ellipse(drawlong, drawlat, e, e);
}

//when the state is set to show the IDs, the draw method will call this routine to run
void DrawIDs() {
  image(img, 0, 0);
  
  textSize(10);
  fill(200,200,200);
  text("Draw Mode 4: Show All DataPoints", 12, 24);
  
  float[] loc = new float[2];
    loc[1] = random(28.43, 29.48);
    loc[0] = random(40.8, 41.198);
    DrawMapPoint(loc, 12, 12, 12, 12);
  
  
  for(int i = 0; i < 800; i++){
    noStroke();
    float[] loc2 = new float[2];
    loc2[1] = random(28.43, 29.48);
    loc2[0] = random(40.8, 41.198);
    DrawMapPoint(loc2, 10, (int(random(255))), (int(random(255))), (int(random(255))));
  }
  
  
}

//when the state is set to the visualizing the database, the draw method will call this routine to run
void DatabaseViz() {
  image(img, 0, 0);
  
  textSize(10);
  fill(200,200,200);
  text("Draw Mode 2: Database Viz", 12, 24);
  
  String[] lines = loadStrings("https://web.njit.edu/~sq42/ProcessingHandler.php?question=Where%20are%20you%20from%3F");
  //sort into alphabetical order
  String[] s = sort(lines);

  
  for (int i = 0 ; i < lines.length; i++) {
  //do something, obtain the next value
  String t = s[i];

  fill(40,40,40);
  textSize(10);
  stroke(250,250,250);
  ellipse((0 + (i*100)), 100, 45, 45);
  fill(200,200,200);
  text(t, (0 + ((i*100)+12)), 100);
}



float[] senda = new float[2];
senda[0] = 41.19;
senda[1] = 28.43;
float[] sendb = new float[2];
sendb[0] = 41.19;
sendb[1] = 29.48;
float[] sendc = new float[2];
sendc[0] = 40.8;
sendc[1] = 28.43;
float[] sendd = new float[2];
sendd[0] = 40.8;
sendd[1] = 29.48;
DrawItinerary(senda, sendb, sendc, sendd, 40, 5);



float[] senda2 = new float[2];
senda2[0] = 41.0196489;
senda2[1] = 28.968630;
float[] sendb2 = new float[2];
sendb2[0] = 41.017613;
sendb2[1] = 28.98006;
float[] sendc2 = new float[2];
sendc2[0] = 41.002489;
sendc2[1] = 28.978806;
float[] sendd2 = new float[2];
sendd2[0] = 41.002913;
sendd2[1] = 28.961430;

DrawItinerary(senda2, sendb2, sendc2, sendd2, 200, 8);

  /*
  for(int i = 0; i < 4; i++){
    float[] loc1 = new float[2];
    loc1[1] = random(28.43, 29.48);
    loc1[0] = random(40.8, 41.198);
        float[] loc2 = new float[2];
    loc2[1] = random(28.43, 29.48);
    loc2[0] = random(40.8, 41.198);
        float[] loc3 = new float[2];
    loc3[1] = random(28.43, 29.48);
    loc3[0] = random(40.8, 41.198);
        float[] loc4 = new float[2];
    loc4[1] = random(28.43, 29.48);
    loc4[0] = random(40.8, 41.198);
    
    DrawItinerary(loc1, loc2, loc3, loc4, 50, 5);;
  }
  */
  

  
}

//when the state is set to showing the images, the draw method will call this routine to run
void ShowImages() {
  //calls an external function to search for images based on a the "location" variable
  searchforgoogleimages();
}

/*old debug statements here to use a mousepressed input to make something happen
void mousePressed() {
  println("Mouse was pressed");
  //searchforgoogleimages();
  //readIn();
}
*/

//Most all of this method comes from Jeff Thompson github.com/jeffThompson
void searchforgoogleimages() {
//String searchTerm = "istanbul";       // term to search for (use spaces to separate terms)
String searchTerm = location;
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
