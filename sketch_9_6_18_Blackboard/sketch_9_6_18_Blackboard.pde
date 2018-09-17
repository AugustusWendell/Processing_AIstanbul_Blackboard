import twitter4j.conf.*;
import twitter4j.*;
import twitter4j.auth.*;
import twitter4j.api.*;

import java.net.HttpURLConnection;    // required for HTML download
import java.net.URL;
import java.net.URLEncoder;
import java.io.InputStreamReader;     // used to get our raw HTML source   

import de.bezier.data.sql.*;

//master Array holding all user data
UserSession[] datalog;

//[AI]stanbul Blackboard application

int x = 0;
int textline = 0;
int AIitineraryCounter = 1;

//these String variables are used to build the itinerary
String location = "Newark";
String madlib = "Placeholder";
String day = "tomorrow";
String activity = "date";
String guest = "susan";
String order = "kebab";

//typeface font holder
PFont mono;

//print text to screen variables
String printtoscreen;
int printtoscreencounter;

States state = States.STATE_1;

int time;
//time between state changes
int wait = 9000;

//map image holder
PImage img;

//DB
MySQL db;

int screenwidth = 1500;
int screenheight = 738;

void setup() {
  //full screen toggle
  //fullScreen();
  size(1500, 738);
  //size(1600, 838);
  background(0);
  noStroke();
  fill(102);
  smooth(1);
  time = millis();//store the current time
  frameRate(10);
  
  //load in the image being used for the map
  img = loadImage("MAP_1500_738.png");
  
  //define typeface for use
  mono = createFont("helvetica", 32);
  
   printtoscreencounter = 0;
  
  datalog = new UserSession[30];
  InitData();
  
  //DB setup
    db = new MySQL( this, "sql3.njit.edu", "aistan_rsrch", "aistan_rsrch", "J8mDan3y" );  // open database file
    db.setDebug(false);
    db.setDebug(true);
    
        if ( db.connect() )
    {
        String[] tableNames = db.getTableNames();
        println(tableNames);
    }
    
    
}


void draw() {

switch (state) {
case STATE_1 :
  println("draw State 1");
  //WriteItinerary(); //State 1 createst the itinerary
  AIitineraryCounter = DrawAIitinerary(AIitineraryCounter);
  //ResetVars();
  break;
case STATE_2:
  println("draw State 2");
  DatabaseViz(); //State 2 creates a database vizualization
  ResetVars();
  break;
case STATE_3:
  println("draw State 3");
  ShowImages(); //State 3 shows an image search
  ResetVars();
  //delay(2000);
  break;
case STATE_4:
  println("draw State 4");
  DrawIDs(); //State 4 shows all ID locations
  ResetVars();
  break;
  case STATE_5:
  println("draw State 5");
  DrawAIdata(1);
  ResetVars();
  break;
  case STATE_6:
  println("draw State 6");
  //do something to dump a lot of data on the screen
  MapAllNodes();
  ResetVars();
  break;
  case STATE_7:
  println("draw State 7");
  DrawAIdata(1);
  ResetVars();
  break;
}

//draw watermark
textFont(mono);
textSize(20);
fill(240,240,240);
text("[AI]stanbul Blackboard Application 0.85", 12, 22);
  

  
  //check the difference between now and the previously stored time is greater than the wait interval
  if(millis() - time >= wait){
    println("tick");//if it is, do something
    //println(getMode());
    time = millis();//also update the stored time
    
    //save the current draw screen
    int s = second();  // Values from 0 - 59
    int m = minute();  // Values from 0 - 59
    int h = hour();    // Values from 0 - 23
    save("ScreenCapture" + h + m + s + ".jpg");
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
      state = States.STATE_5;
    } else
    if(state == States.STATE_5){
      state = States.STATE_6;
    } else
     if(state == States.STATE_6){
      state = States.STATE_7;
    } else
     if(state == States.STATE_7){
      state = States.STATE_1;
    } 
}
}

public int getState() {
    switch (state) {
        case STATE_1: return 1;
        case STATE_2: return 2;
        case STATE_3: return 3;
        case STATE_4: return 4;
        case STATE_5: return 5;
        case STATE_6: return 6;
        case STATE_7: return 7;
    }
    return 0;
}

void ResetVars(){
 printtoscreencounter = 0;
 printtoscreen = "Debug [AI]istanbul data";
 int AIitineraryCounter = 1;
}

//fill an array with test user data as if from database
void InitData() {
  println("run init data");
  for(int i = 0; i < 30; i++){
    datalog[i] = new UserSession(i, "Where do you live?", "Home", str(random(40.8, 41.198)), str(random(28.43, 29.48)));
    println(datalog[i].toString());
  }
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

//lat/long,  lat/long,  lat/long,  lat/long,  size, color(single value)
void DrawItinerary(float[] a, float[] b, float[] c , float[] d, int e, int s) {
  DrawMapPoint(a, e, s, s, s, "test1");
  //delay(100);
  DrawMapPoint(b, e, s, s, s, "test2");
  //delay(100);
  DrawMapPoint(c, e, s, s, s, "test3");
  //delay(100);
  DrawMapPoint(d, e, s, s, s, "test4");
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
  //println("DrawMapLine() called");
 
  //LAT Y
  //float bottomedge = 40.911613;
  float bottomedge = 40.8;
  //float topedge = 41.196489;
  float topedge = 41.198;
  float bottomtotop = topedge - bottomedge; //.284876       1/ = 3.5102992179
  float inputlat = a[0]; //for instance 41.0    Y VALUE!!!
  
  //40.8,28.43
  //41.198,29.48
  
  //LONG X
  float leftedge = 28.43;
  float rightedge =  29.48;
  float lefttoright = rightedge - leftedge; //1.052376      1/ = .950230716
  float inputlong = a[1]; //for instance 28.9   X VALUE!!!
  
  int screenwidth = 1500;
  int screenheight = 738;
  
    //LAT Y
  float inputlat1 = a[0]; //for instance 41.0
  
  //float drawlat1 = ((1/bottomtotop) * (topedge - inputlat1)) * screenheight;
  float drawlat1 = ((topedge - inputlat1)/bottomtotop) * screenheight;
    //LONG X
  float inputlong1 = a[1];
  //float drawlong1 = ((1/lefttoright) * (rightedge - inputlong1)) * screenwidth;
  float drawlong1 = ((rightedge - inputlong1)/lefttoright) * screenwidth;
    drawlong1 = screenwidth - drawlong1;
  
   //LAT Y
   float inputlat2 = b[0]; //for instance 41.0
  //float drawlat2 = ((1/bottomtotop) * (topedge - inputlat2)) * screenheight;
  float drawlat2 = ((topedge - inputlat2)/bottomtotop) * screenheight;
  //LONG X
  float inputlong2 = b[1];
  //float drawlong2 = ((1/lefttoright) * (rightedge - inputlong2)) * screenwidth;
  float drawlong2 = ((rightedge - inputlong2)/lefttoright) * screenwidth;
    drawlong2 = screenwidth - drawlong2;
  
  //fill(weight);
  strokeWeight(weight);
  line(drawlong1, drawlat1, drawlong2, drawlat2);
}


//float[lat, long], image to be displayed, String info
void PlaceImage(float[] a, PImage b, String c) {
  
  //LAT Y
  float bottomedge = 40.8;
  float topedge = 41.198;
  float bottomtotop = topedge - bottomedge; //.398
  float inputlat = a[0]; //for instance 41.0    Y VALUE!!!
  
  //LONG X
  float leftedge = 28.43  ;
  float rightedge =  29.48;
  float lefttoright = rightedge - leftedge; //1.052376      1/ = .950230716
  float inputlong = a[1]; //for instance 28.9   X VALUE!!!
  
  int screenwidth = 1500;
  int screenheight = 738;


  //LAT Y
  float drawlat = ((topedge - inputlat)/bottomtotop) * screenheight; //Y VALUE FOR DRAWING 8/29/18 fix
  
  //LONG X
  float drawlong = ((rightedge - inputlong)/lefttoright) * screenwidth;  //X VALUE FOR DRAWING 8/29/18 fix
  drawlong = screenwidth - drawlong;

  ellipse(drawlong, drawlat, 5, 5);

  //draw the image
  image(b, drawlong, drawlat);

  textSize(10);
  fill(200,200,200);
  text(c, (drawlong + 20), (drawlat + 20));
}

float ConvertLat(float a){
  //convert map coordinates to screen coordinates
 
  float bottomedge = 40.8;
  float topedge = 41.198;
  float bottomtotop = topedge - bottomedge; //.398
  float inputlat = a; //for instance 41.0    Y VALUE!!!
  
  int screenwidth = 1500;
  int screenheight = 738;

  float drawlat = ((topedge - inputlat)/bottomtotop) * screenheight; //Y VALUE FOR DRAWING 8/29/18 fix

  return(drawlat);
  
}

void TestDBConnectivity(){
  
}

float ConvertLong(float a){
  //convert map coordinates to screen coordinates

  float leftedge = 28.43  ;
  float rightedge =  29.48;
  float lefttoright = rightedge - leftedge; 
  float inputlong = a; 
  
  int screenwidth = 1500;
  int screenheight = 738;

  float drawlong = ((rightedge - inputlong)/lefttoright) * screenwidth;  //X VALUE FOR DRAWING 8/29/18 fix
  drawlong = screenwidth - drawlong;
  
  return(drawlong);
  
}


//lat/long, weight, color, color, color, description
void DrawMapPoint(float[] a, int e, int c1, int c2, int c3, String description) {
  
  //convert map coordinates to screen coordinates
  //define edge map lat and long
 
  //LAT Y
  //float bottomedge = 40.911613;
  float bottomedge = 40.8;
  //float topedge = 41.196489;
  float topedge = 41.198;
  float bottomtotop = topedge - bottomedge; //.398
  float inputlat = a[0]; //for instance 41.0    Y VALUE!!!
  
  //LONG X
  float leftedge = 28.43  ;
  float rightedge =  29.48;
  float lefttoright = rightedge - leftedge; //1.052376      1/ = .950230716
  float inputlong = a[1]; //for instance 28.9   X VALUE!!!
  
  int screenwidth = 1500;
  int screenheight = 738;


  //LAT Y
  //float drawlat = ((1/bottomtotop) * (topedge - inputlat)) * screenheight; //Y VALUE FOR DRAWING
  float drawlat = ((topedge - inputlat)/bottomtotop) * screenheight; //Y VALUE FOR DRAWING 8/29/18 fix
  //println("draw lat (y coordinate) = " + drawlat);
  
  //LONG X
  //float drawlong = ((1/lefttoright) * (rightedge - inputlong)) * screenwidth;  //X VALUE FOR DRAWING
  float drawlong = ((rightedge - inputlong)/lefttoright) * screenwidth;  //X VALUE FOR DRAWING 8/29/18 fix
  drawlong = screenwidth - drawlong;
  //println("draw long (x coordinate) = " + drawlong);
  
  fill(c1, c2, c3);
  ellipse(drawlong, drawlat, e, e);
  textSize(10);
  fill(200,200,200);
  text(description, (drawlong + e), (drawlat + e));
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
    DrawMapPoint(loc, 12, 12, 12, 12, "test");
  
  
  for(int i = 0; i < 800; i++){
    noStroke();
    float[] loc2 = new float[2];
    loc2[1] = random(28.43, 29.48);
    loc2[0] = random(40.8, 41.198);
    DrawMapPoint(loc2, 10, (int(random(255))), (int(random(255))), (int(random(255))), "ID#");
  }
}


//draw all nodes in a graphical way
void MapAllNodes(){
    image(img, 0, 0);
  textFont(mono);
  textSize(20);
  fill(240,240,240);
  text("Draw Mode: Map All Nodes", 12, 44);
  
  int h = datalog.length;
  
    for(int i = 0; i < h; i++){
    fill(random(100, 200),random(100, 200),random(100, 200)); 
    //make a rectangle with a random color x, y , width, height
    strokeWeight(.1);
    rect(((screenwidth/h)*i), (screenheight/2), ((screenwidth/h)-4), 20);
    //write the node id number underneath the rectangle

    textSize(10);
    fill(222,222,222);
    //rotate(PI/2);
    text(i, ((screenwidth/h)*i), ((screenheight/2) - 5));
    //rotate(PI/2);
    //rotate(PI/2);
    //rotate(PI/2);
    //draw arc from each node to another random node
    noFill();
    strokeWeight(.5);
    stroke(255);
    arc(((screenwidth/h)*i), ((screenheight/2)+25), ((screenwidth/h)*random(3,33)), ((screenwidth/h)*random(3,33)), 0, PI);
  }
}


//when the state is set to 5 to draw an autonomous itinerary
int DrawAIdata(int a) {
 int pointcounter = 0;
  pointcounter = a;
  image(img, 0, 0);
  
  textFont(mono);
  textSize(20);
  fill(240,240,240);
  text("Draw Mode 7: Show AI Data", 12, 44);
  
  for(int i = 0; i < (datalog.length - 1); i++){
    //text("User Data Session" + str(datalog[i].id), 12, (100 + (15*i)));
    text("User Data Session Information " + i + " " + datalog[i].toString(), 12, (100 + (15*i)));

  }
  
  
  if(pointcounter > 0){
    //
  } 
  if(pointcounter > 1){
    //
  } 
  if(pointcounter > 2){
    //
  } 
  if(pointcounter > 3){
    //
  } 
  if(pointcounter > 4){
    //
  } 
  if(pointcounter > 5){
      //
  }
  if(pointcounter > 6){
      //
  } 
  pointcounter++;
  println("pointcounter = " + pointcounter);
  return(pointcounter);
}

//when the state is set to 5 to draw an autonomous itinerary
void PrintToScreen(String s) {
  image(img, 0, 0);
  
  textFont(mono);
  textSize(20);
  fill(240,240,240);
  text("Print Text To Screen", 12, 44);
  
  textSize(50);
  text(s.substring(0, printtoscreencounter), 12, 100);
  if(printtoscreencounter < s.length()){
    printtoscreencounter++;
  }
  println("printtoscreenscounter = " + printtoscreencounter);
}

//when the state is set to 5 to draw an autonomous itinerary
int DrawAIitinerary(int a) {
  int pointcounter = 0;
  pointcounter = a;
  image(img, 0, 0);
  
  textFont(mono);
  textSize(20);
  fill(240,240,240);
  text("Draw Mode 5: Show All DataPoints", 12, 44);
  
  float[] senda = new float[2];
  //40.979,28.754
  senda[0] = 40.979;
  senda[1] = 28.754;
  float[] sendb = new float[2];
  //40.955,28.837
  sendb[0] = 40.955;
  sendb[1] = 28.837;
  float[] sendc = new float[2];
  //41.001,28.979
  sendc[0] = 41.001;
  sendc[1] = 28.979;
  float[] sendd = new float[2];
  //40.9667,29.032
  sendd[0] = 40.9667;
  sendd[1] = 29.032;
  
  int e = 5;
  int s = 255;
  
  PrintToScreen("AI DATASET ITINERARY - MARKOV MODEL .90");
  
  if(pointcounter > 0){
    DrawMapPoint(senda, e, s, s, s, "test1");
    //Draw AI Itinerary1 Text
  } 
  if(pointcounter > 10){
    DrawMapPoint(sendb, e, s, s, s, "test2");
    //Draw AI Itinerary2 Text
  } 
  if(pointcounter > 20){
    DrawMapPoint(sendc, e, s, s, s, "test3");
    //Draw AI Itinerary3 Text
  } 
  if(pointcounter > 30){
    DrawMapPoint(sendd, e, s, s, s, "test4");
    //Draw AI Itinerary4 Text
  } 
  if(pointcounter > 40){
    strokeWeight(5);
    stroke(222, 222, 222);
    //line(10, 10, 40, 100);
      DrawMapLine(senda, sendb, 5);
  } 
  if(pointcounter > 50){
      DrawMapLine(sendb, sendc, 5);
  }
  if(pointcounter > 60){
      DrawMapLine(sendc, sendd, 5);
  } 
  pointcounter++;
  println("pointcounter = " + pointcounter);
  return(pointcounter);
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

/*
//draw bounds of map - this seems to validate the map, right? 
  //40.8,28.43
  //41.198,29.48
float[] senda = new float[2];
senda[0] = 41.198;
senda[1] = 28.43;
float[] sendb = new float[2];
sendb[0] = 41.198;
sendb[1] = 29.48;
float[] sendc = new float[2];
sendc[0] = 40.8;
sendc[1] = 28.43;
float[] sendd = new float[2];
sendd[0] = 40.8;
sendd[1] = 29.48;
DrawItinerary(senda, sendb, sendc, sendd, 5, 200);
*/


//test hard coded test itinerary in old istanbul
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
DrawItinerary(senda2, sendb2, sendc2, sendd2, 4, 1);

//test hard coded test itinerary to define coastline
float[] senda3 = new float[2];
//40.979,28.754
senda3[0] = 40.979;
senda3[1] = 28.754;
float[] sendb3 = new float[2];
//40.955,28.837
sendb3[0] = 40.955;
sendb3[1] = 28.837;
float[] sendc3 = new float[2];
//41.001,28.979
sendc3[0] = 41.001;
sendc3[1] = 28.979;
float[] sendd3 = new float[2];
//40.9667,29.032
sendd3[0] = 40.9667;
sendd3[1] = 29.032;
DrawItinerary(senda3, sendb3, sendc3, sendd3, 15, 255);




//define a series of base itineraries
float[] historicitinerary1 = {41.05,         28.815,         41.04,       28.947,    41.08,     29.14,     41,       29.18};
float[] historicitinerary2 = {41.09,         28.82,          41.03,       28.95,     41.09,     29.13,     41.07,    29.18};
float[] historicitinerary3 = {41.01,         28.82,          41.01,       28.942,    41.091,    29.15,     41.07,    29.19};
float[] historicitinerary4 = {41.05,         28.815,         41.035,      28.941,    41.085,    29.14,     41,       29.19};
float[] historicitinerary5 = {40.979,        28.754,         40.955,      28.837,    41.001,    28.979,    40.9667,  29.032};
float[][] stock = new float[5][8];
stock[0] = historicitinerary1;
stock[1] = historicitinerary2;
stock[2] = historicitinerary3;
stock[3] = historicitinerary4;
stock[4] = historicitinerary5;

  for(int i = 0; i < 4; i++){
    float[] temp1 = new float[2];
    temp1[0] = stock[i][0];
    temp1[1] = stock[i][1];
    float[] temp2 = new float[2];
    temp2[0] = stock[i][2];
    temp2[1] = stock[i][3];
    float[] temp3 = new float[2];
    temp3[0] = stock[i][4];
    temp3[1] = stock[i][5];
    float[] temp4 = new float[2];
    temp4[0] = stock[i][6];
    temp4[1] = stock[i][7];
    DrawItinerary(temp1, temp2, temp3, temp4, (i*3), (i*63));
  }



  
  for(int i = 0; i < 4; i++){
    float[] loc1 = new float[2];
    loc1[1] = random(28.7, 29.1);
    loc1[0] = random(41, 41.198);
        float[] loc2 = new float[2];
    loc2[1] = random(28.7, 29.1);
    loc2[0] = random(41, 41.198);
        float[] loc3 = new float[2];
    loc3[1] = random(28.7, 29.1);
    loc3[0] = random(41, 41.198);
        float[] loc4 = new float[2];
    loc4[1] = random(28.7, 29.1);
    loc4[0] = random(41, 41.198);
    
    DrawItinerary(loc1, loc2, loc3, loc4, 5, 128);;
  }
}

//when the state is set to showing the images, the draw method will call this routine to run
void ShowImages() {
//load in our master map image
  image(img, 0, 0);
  
  //calls an external function to search for images based on a the "location" variable
  searchforgoogleimages(random(41, 41.1), random(28.7, 28.95), "cafe");
  searchforgoogleimages(random(41, 41.1), random(28.7, 28.95), "istanbul");
  searchforgoogleimages(random(41, 41.1), random(28.7, 28.95), "orient");
  searchforgoogleimages(random(41, 41.1), random(28.7, 29.2), "kebab");
  searchforgoogleimages(random(41, 41.1), random(28.7, 29.2), "lost");
}

//Most all of this method comes from Jeff Thompson github.com/jeffThompson
void searchforgoogleimages(float x, float y, String s) {
  
String searchTerm = s;       // term to search for (use spaces to separate terms)

int offset = 2;                      // we can only 20 results at a time - use this to offset and get more!
//String fileSize = "10mp";
String fileSize = "1mp";             // specify file size in mexapixels (S/M/L not figured out yet)
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
    //println(i + ":\t" + m[i][1]);        // print (or store them)**
    PImage webImg;
    String url = m[i][1];
    webImg = loadImage(url, "png");
    
    float[] loc = new float[2];
    loc[1] = y;
    loc[0] = x;
    //loc[1] = random(28.43, 29.48);
    //loc[0] = random(40.8, 41.198);
    
     PlaceImage(loc, webImg, "Image Information");
    //image(webImg, int(random(200)), int(random(200)));

  }
}


}

//Object to store each user session. These can be loaded into some container and then queried offline in case database connection is lost.
class UserSession
{
    public int id;
    public int qindex;
    public int datetime;
    public String question;
    public String Category;
    public String Type;
    public String FeatureType;
    public String FeatureName;
    public String Lat;
    public String Long;
    public String answer;
    
    //id, question, answer, lat, long
    UserSession(int a, String b, String c, String d, String e) {
      id = a;
      question = b;
      answer = c;
      Lat = d;
      Long = e;
    }
   
   public String toString ()
    {
        //return String.format("id: %i, question: %s answer: %s", id, question, answer);
        String r = "id: " + str(id) + ", question: " + question + " answer: " + answer;
        return r;
    }
}

//Object to store an itinerary
class Itinerary
{
    public float[] point1;
    public float[] point2;
    public float[] point3;
    public float[] point4;
    public int id;
    
    Itinerary(float[] a, float[] b, float[] c, float[] d, int e) {
      point1 = a;
      point2 = b;
      point3 = c;
      point4 = d;
      id = e;
    }
}
