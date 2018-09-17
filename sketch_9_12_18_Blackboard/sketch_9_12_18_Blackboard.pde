//import twitter4j.conf.*;
//import twitter4j.*;
//import twitter4j.auth.*;
//import twitter4j.api.*;

import java.net.HttpURLConnection;    // required for HTML download
import java.net.URL;
import java.net.URLEncoder;
import java.io.InputStreamReader;     // used to get our raw HTML source   

import de.bezier.data.sql.*;

//master Array holding all user data
UserSession[] datalog;

Itinerary[] itineraries;

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
int printtoscreencounter = 0;

int usersessioncount = 50;
int itinerariescount = 0;

States state = States.STATE_1;

int time;
//time between state changes
int wait = 15000;

//map image holder
PImage img;
PImage imgCC;

//DB
MySQL db;

int screenwidth = 1920;
int screenheight = 1080;

float leftedge = 28.511;
float rightedge =  29.71;
  
float bottomedge = 40.827;
float topedge = 41.336;

float CCleftedge = 28.9007;
float CCrightedge =  29.16479;
  
float CCbottomedge = 40.95231;
float CCtopedge = 41.06623;

void setup() {
  //full screen toggle
  //fullScreen();
  size(1920, 1080);
  background(0);
  noStroke();
  fill(102);
  smooth(1);
  time = millis();//store the current time
  frameRate(10);
  
  //load in the image being used for the map
  img = loadImage("MAP_1920_1080.png");
  imgCC = loadImage("CITY_1920_1080.png");
  
  //define typeface for use
  mono = createFont("helvetica", 32);
  
   printtoscreencounter = 0;
  
  datalog = new UserSession[300];
  itineraries = new Itinerary[100];
  //InitData(); //deprecated, to fill in dummy data
  DownloadDB(); //goes to the GoDaddy database and pulls all the data down, writes json files locally.
  ImportData(); //imports the json files from the local drive
  FindItineraries();
  ImportItineraries();
    
}

void DownloadDB(){
  
  println("DownloadDB Method Called");
 
    //db = new MySQL( this, "107.180.41.145", "IstanbulQuestions", "aistanbul", "=OFA*qUuAU3Y" );  // open database file
    db = new MySQL( this, "107.180.41.145", "IstanbulQuestions", "augustuswendell", "@Rtist999" );  // open database file

    db.setDebug(true);
    
        if ( db.connect() )
    {
        
        String[] tableNames = db.getTableNames();
        println(tableNames); //only 1 TableName = Answers
        //move into Answers
        db.query( "SELECT * FROM %s", tableNames[0] );
        //select all columns from Answers?       
        String[] columnNames;
        columnNames = db.getColumnNames();
        println(columnNames);
        
        
        //db.query("INSERT INTO Answers (id, qindex, question, Category, Type, FeatureType, FeatureName, Lat, Lon) VALUES (27, 3, 'Where do you live?', 'Biraz kendinizden bahseder misiniz? / Tell me a little bit about yourself.', 'map', 'NULL', 'cafe bambi', '41.015997', '28.973282')");
        println("db insertion called");
        db.query("SELECT * FROM Answers");
        //db.next();
        int r = 0;
        
        while (db.next())
        {
            //columnNames = db.getColumnNames();
            //println(columnNames);
            int y = 0;
            y = db.getInt("id");
            int x = 0;
            x = db.getInt("Qid");
            int z = 0;
            z = db.getInt("Timestamp");
            String b = db.getString("Question");
            String c = db.getString("Category");
            String d = db.getString("Type");
            String e = db.getString("FeatureType");
            String f = db.getString("FeatureName");
            String g = db.getString("Lat");
            String h = db.getString("Lng");
            String i = db.getString("Response");
            println( y + " " + x +  " " + z + " " + b +  " " + c +  " " + d +  " " + e +  " " + f +  " " + g +  " " + h +  " " + i );
            
            //make a new object and put the data into it
            datalog[r] = new UserSession(y, x, z, b, c, d, e, f, g, h, i);
            
            //write datalog[r] to a local JSON file
            //Processing.data.JSONObject
            JSONObject json = new JSONObject();

            //json = new JSONObject();

            json.setInt("id", y);
            json.setInt("qindex", x);
            json.setInt("datetime", z);
            json.setString("question", b);
            json.setString("Category", c);
            json.setString("Type", d);
            json.setString("FeatureType", e);
            json.setString("FeatureName", f);
            json.setString("Lat", g);
            json.setString("Lon", h);
            json.setString("answer", i);
            
            //saveJSONObject(json, "data/AIstanbul_id_"+y+".json");
            saveJSONObject(json, "data/AIstanbul_id_"+r+".json");
            
            usersessioncount = r;
            println("useresessioncount = " + usersessioncount);
            
            //increment counter
            r++;
        }
        
    }
}

//find same user lat and lon pairs in the datalog
void FindItineraries(){
  float[] temp = new float[2];
  float[] temp1 = new float[2];
  float[] temp2 = new float[2];
  float[] temp3 = new float[2];
  int r = 0;
  
  for(int i = 1; i < usersessioncount; i++){
    if(datalog[i].qindex == 1000){
      temp[0] = float(datalog[i].Lat);
      temp[1] = float(datalog[i].Lon);
      println("building itinerary point 1");
    }else {
    if(datalog[i].qindex == 1002){
      temp1[0] = float(datalog[i].Lat);
      temp1[1] = float(datalog[i].Lon);
      println("building itinerary point 2");
    } else {
        if(datalog[i].qindex == 1003){
      temp2[0] = float(datalog[i].Lat);
      temp2[1] = float(datalog[i].Lon);
      println("building itinerary point 3");
    } else {
        if(datalog[i].qindex == 1004){
      temp3[0] = float(datalog[i].Lat);
      temp3[1] = float(datalog[i].Lon);
      println("building itinerary point 4");
      
      //write datalog[r] to a local JSON file
            //Processing.data.JSONObject
            JSONObject json = new JSONObject();

            json.setFloat("lat1", temp[0]);
            json.setFloat("lon1", temp[1]);
            json.setFloat("lat2", temp1[0]);
            json.setFloat("lon2", temp1[1]);
            json.setFloat("lat3", temp2[0]);
            json.setFloat("lon3", temp2[1]);
            json.setFloat("lat4", temp3[0]);
            json.setFloat("lon4", temp3[1]);
            
            saveJSONObject(json, "data/AIstanbul_itinerary_"+r+".json");
            println("saved json itinerary");
            itinerariescount = r;
            
      r++;
      println("intinerary counter = "+r);
        }
    }
    }
    }
  }
  for(int i = 0; i < itineraries.length; i++){
    try{
      println("itineraries " + i );
    println(itineraries[i].toString());
    }
    catch (NullPointerException e){}
  }
}
void ImportItineraries(){
 
            JSONObject json = new JSONObject();
            for(int i = 1; i < itinerariescount; i++){
             
            json = loadJSONObject("data/AIstanbul_itinerary_"+i+".json");

  float lat1 = json.getFloat("lat1");
  float lon1 = json.getFloat("lon1");
  float lat2 = json.getFloat("lat2");
  float lon2 = json.getFloat("lon2");
  float lat3 = json.getFloat("lat3");
  float lon3 = json.getFloat("lon3");
  float lat4 = json.getFloat("lat4");
  float lon4 = json.getFloat("lon4");

  float[] temp1 = new float[2];
  temp1[0] = lat1;
  temp1[1] = lon1;
    float[] temp2 = new float[2];
  temp2[0] = lat2;
  temp2[1] = lon2;
    float[] temp3 = new float[2];
  temp3[0] = lat3;
  temp3[1] = lon3;
    float[] temp4 = new float[2];
  temp4[0] = lat4;
  temp4[1] = lon4;
             
  itineraries[i] = new Itinerary(temp1, temp2, temp3, temp4, 1);
            }
} 

void ImportData(){
  
    datalog = new UserSession[usersessioncount];
    println("updated size of datalog to " + usersessioncount);
    
            //write datalog[r] to a local JSON file
            //Processing.data.JSONObject
            JSONObject json = new JSONObject();
            for(int i = 1; i < usersessioncount; i++){
             
            json = loadJSONObject("data/AIstanbul_id_"+i+".json");

  int id = json.getInt("id");
  int qindex = json.getInt("qindex");
  int datetime = json.getInt("datetime");
  String question = json.getString("question");
  String Category = json.getString("Category");
  String Type = json.getString("Type");
  String FeatureType = json.getString("FeatureType");
  String FeatureName = json.getString("FeatureName");
  String Lat = json.getString("Lat");
  String Lon = json.getString("Lon");
  String answer = json.getString("answer");
  
  datalog[i] = new UserSession(id, qindex, datetime, question, Category, Type, FeatureType, FeatureName, Lat, Lon, answer);
            }
} 

void draw() {
  
switch (state) {
case STATE_1 : //  1 Boot Mode
  //println("draw State 1");
  DrawInitialize();
  break;
case STATE_2: // 2 List of all or recent data points - makes clear that there are users, Last few at the top of the screen. 1 per user
  //println("draw State 2");
  ListRecentDataPoints();
  delay(500);
  break;
case STATE_3: //3 Same Data as Points on the screen: Color Coded, could be a few modes in here…….Home, Food, Activities, Work
  //println("draw State 3");
  DrawIDs(); //State 4 shows all ID location
  //delay(2000);
  break;
case STATE_4: //4 Draw connections between them, to visually build itineraries - colored by user
  //println("draw State 4");
  DrawCCIDs(); //State 4 shows all ID locations
  delay(500);
  //ResetVars();
  break;
  case STATE_5: //5 Isolate one itinerary and place images along it
  //println("draw State 5");
  DrawItineraries();
  //ShowImages(); //State 3 shows an image search
  //ResetVars();
  break;
  case STATE_6: //6 AI Boot Screen?
  //println("draw State 6");
   DrawCCItineraries();
  //DrawAIInitialize();
  //delay(500);
  //ResetVars();
  break;
  case STATE_7: //7 AI writes out data points as text

  println("draw State 7");
  AIitineraryCounter = DrawAIitinerary(AIitineraryCounter);
  //ResetVars();
  break;
  case STATE_8: //8 AI draws as dots
  //println("draw State 8");
  DatabaseViz();
  //ResetVars();
  break;
  case STATE_9: //9 AI Connects with lines to build itinerary

  println("draw State 9");

  DrawAIdata(1);
  //ResetVars();
  break;
    case STATE_10: //10 AI reports textually on the itinerary and what it has learned
  println("draw State 10");
AI_Text_Itinerary();
//ResetVars();
  break;
  case STATE_11:
  println("draw State 9");
  MapAllNodes();
  //ResetVars();
  break;
  case STATE_12:
  println("draw State 9");
  GridData();
  //ResetVars();
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
    time = millis();//also update the stored time
    
    //save the current draw screen
    int d = day();    // Values from 1 - 31
    int m = month();  // Values from 1 - 12
    int y = year();
    int s = second();  // Values from 0 - 59
    int min = minute();  // Values from 0 - 59
    int h = hour();    // Values from 0 - 23
    save("screencaptures/AIstanbul"+"_"+y+m+d+"/ScreenCapture" +y+m+d+"_"+h+min+s+ ".jpg");

    //clear the screen
    background(0);
    
    ResetVars();
    
    textSize(30);
    fill(120,120,120);
    text("[AI]istanbul Refresh - Changing Modes", 12, 120);
    text("Computer Learning Drawing Mode = " + state, 12, 160);
    
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
      state = States.STATE_8;
    }  else
     if(state == States.STATE_8){
      state = States.STATE_9;
    }  else
     if(state == States.STATE_9){
      state = States.STATE_10;
    }  else
     if(state == States.STATE_10){
      state = States.STATE_11;
    }  else
     if(state == States.STATE_11){
      state = States.STATE_12;
    }  else
     if(state == States.STATE_12){
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
        case STATE_8: return 8;
        case STATE_9: return 9;
        case STATE_10: return 10;
        case STATE_11: return 11;
        case STATE_12: return 12;
        case STATE_13: return 13;
    }
    return 0;
}
void AI_Text_Itinerary(){
  image(imgCC, 0, 0);
  
  textSize(10);
  fill(200,200,200);
  stroke(200,200,200);
  strokeWeight(1);
  text("Draw Mode: Report AI itinerary", 12, 24);
 }


void DrawCityCenter(){
  image(imgCC, 0, 0);
  
  textSize(10);
  fill(200,200,200);
  stroke(200,200,200);
  strokeWeight(1);
  text("Draw Mode: City Center", 12, 24);
  
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
DrawCCItinerary(senda2, sendb2, sendc2, sendd2, 2, 200);
}

void DrawItineraries(){
  //println("DrawItineraries");
  image(img, 0, 0);
  
  textSize(10);
  fill(200,200,200);
  stroke(200,200,200);
  strokeWeight(1);
  text("Draw Mode: User Itineraries", 12, 24);
  
  for(int i = 0; i < printtoscreencounter; i++){
  //for(int i = 0; i < itineraries.length; i++){
    try{
      DrawItinerary(itineraries[i]);
      println("draw itinerary " + i);
    }catch (NullPointerException e) {}
  }
  //println(printtoscreencounter);
  printtoscreencounter++;
  delay(500);
}

void DrawCCItineraries(){
  //println("DrawCCItineraries");
  image(imgCC, 0, 0);
  
  textSize(10);
  fill(200,200,200);
  stroke(200,200,200);
  strokeWeight(1);
  text("Draw Mode: User Itineraries, City Center", 12, 24);
  
  for(int i = 0; i < printtoscreencounter; i++){
  //for(int i = 0; i < itineraries.length; i++){
    try{
      DrawCCItinerary(itineraries[i]);
      println("draw itinerary " + i);
    }catch (NullPointerException e) {}
  }
  //println(printtoscreencounter);
  printtoscreencounter++;
  delay(500);
}

void DrawInitialize(){
  //image(img, 0, 0);
  /*
  println("DrawInitialize Method called");
  
  textSize(30);
  fill(200,200,200);
  text("BOOT MODE", 12, 24);
    
  text("[AI]stanbul Initialize Blackboard", 12, 48);
    
  text("Initialize Drawing Engine", 12, 72);
  
  text("Loading Base Map", 12, 96);
  */
  
   String a = "Initializing [AI]stanbul Blackboard Machine Learning Application";
   PrintToScreen(a);
}

void DrawAIInitialize(){
  image(img, 0, 0);
  /*
  println("DrawInitialize Method called");
  
  textSize(30);
  fill(200,200,200);
  text("BOOT MODE", 12, 24);
    
  text("[AI]stanbul Initialize Blackboard", 12, 48);
    
  text("Initialize Drawing Engine", 12, 72);
  
  text("Loading Base Map", 12, 96);
  */
  
   String a = "Initializing [AI]stanbul Artifical Intelligence Engine";
   PrintToScreen(a);
}

//called during each MODE transition to reset all variables needed
void ResetVars(){
 printtoscreencounter = 0;
 printtoscreen = "Debug [AI]istanbul data";
 int AIitineraryCounter = 1;
 println("ResetVars");
}

//fill an array with test user data as if from database
void InitData() {
  println("run init data");
  for(int i = 0; i < usersessioncount; i++){
    datalog[i] = new UserSession(i, "Where do you live?", "Home", str(random(40.8, 41.198)), str(random(28.43, 29.48)));
    //println(datalog[i].toString());
  }
  datalog[(usersessioncount-1)] = new UserSession(99, "Where do you live?", "Home", str(41.016144), str(28.973294));
  datalog[(usersessioncount-1)].FeatureName = "Cafe Bambi";
  //41.016144, 28.973294 cafe bambi
}

//when the state is set to writing the itinerary, the draw method will call this routine to run
void WriteItinerary() {
  image(img, 0, 0);
  
  fill(200,200,200);
  stroke(200,200,200);
  strokeWeight(1);
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

void DrawItinerary(Itinerary i) {
  DrawMapPoint(i.point1, 5, 255, 255, 255, "test1");
  println("itinerary MapPoint " + i.point1[0] + " " + i.point1[1]);
  //delay(100);
  DrawMapPoint(i.point2, 5, 255, 255, 255, "test2");
  //delay(100);
  DrawMapPoint(i.point3, 5, 255, 255, 255, "test3");
  //delay(100);
  DrawMapPoint(i.point4, 5, 255, 255, 255, "test4");
  //delay(100);
  DrawMapLine(i.point1, i.point2, 5);
  //delay(100);
  DrawMapLine(i.point2, i.point3, 5);
  //delay(100);
  DrawMapLine(i.point3, i.point4, 5);
}

void DrawCCItinerary(Itinerary i) {
  DrawCCMapPoint(i.point1, 5, 255, 255, 255, "test1");
  //println("itinerary MapPoint " + i.point1[0] + " " + i.point1[1]);
  //delay(100);
  DrawCCMapPoint(i.point2, 5, 255, 255, 255, "test2");
  //delay(100);
  DrawCCMapPoint(i.point3, 5, 255, 255, 255, "test3");
  //delay(100);
  DrawCCMapPoint(i.point4, 5, 255, 255, 255, "test4");
  //delay(100);
  DrawCCMapLine(i.point1, i.point2, 5);
  //delay(100);
  DrawCCMapLine(i.point2, i.point3, 5);
  //delay(100);
  DrawCCMapLine(i.point3, i.point4, 5);
}

//lat/long,  lat/long,  lat/long,  lat/long,  size, color(single value)
void DrawCCItinerary(float[] a, float[] b, float[] c , float[] d, int e, int s) {
  DrawCCMapPoint(a, e, s, s, s, "test1");
  //delay(100);
  DrawCCMapPoint(b, e, s, s, s, "test2");
  //delay(100);
  DrawCCMapPoint(c, e, s, s, s, "test3");
  //delay(100);
  DrawCCMapPoint(d, e, s, s, s, "test4");
  //delay(100);
  DrawCCMapLine(a, b, e);
  //delay(100);
  DrawCCMapLine(b, c, e);
  //delay(100);
  DrawCCMapLine(c, d, e);
}

void DrawMapLine(float[] a, float[] b, int weight) {
  //using convert methods to simplify the code
  float drawlat1 = ConvertLat(a[0]);
  float drawlong1 = ConvertLong(a[1]);
  
  //using convert methods to simplify the code
  float drawlat2 = ConvertLat(b[0]);
  float drawlong2 = ConvertLong(b[1]);
  
  fill(200,200,200);
  stroke(200,200,200);
  strokeWeight(2);
  line(drawlong1, drawlat1, drawlong2, drawlat2);
}

void DrawCCMapLine(float[] a, float[] b, int weight) {
  //using convert methods to simplify the code
  float drawlat1 = ConvertCCLat(a[0]);
  float drawlong1 = ConvertCCLong(a[1]);
  
  //using convert methods to simplify the code
  float drawlat2 = ConvertCCLat(b[0]);
  float drawlong2 = ConvertCCLong(b[1]);
  
  fill(200,200,200);
  stroke(200,200,200);
  strokeWeight(2);
  line(drawlong1, drawlat1, drawlong2, drawlat2);
}


//float[lat, long], image to be displayed, String info
void PlaceImage(float[] a, PImage b, String c) {
  fill(200,200,200);
  stroke(200,200,200);
  strokeWeight(1);
//using convert methods to simplify the code
  float drawlat = ConvertLat(a[0]);
  float drawlong = ConvertLong(a[1]);
  
  ellipse(drawlong, drawlat, 5, 5);

  //draw the image
  image(b, drawlong, drawlat);

  textSize(10);
  fill(200,200,200);
  text(c, (drawlong + 20), (drawlat + 20));
}

float ConvertLat(float a){
  //convert map coordinates to screen coordinates
 
  float bottomtotop = topedge - bottomedge; //.398
  float inputlat = a; //for instance 41.0    Y VALUE!!!

  float drawlat = ((topedge - inputlat)/bottomtotop) * screenheight; //Y VALUE FOR DRAWING 8/29/18 fix

  return(drawlat);
}

float ConvertCCLat(float a){
  //convert map coordinates to screen coordinates
 
  float bottomtotop = CCtopedge - CCbottomedge;  //.11392
  float inputlat = a;                            
  println("inputlat = " + inputlat); 

  float drawlat = ((CCtopedge - inputlat)/bottomtotop) * screenheight; //Y VALUE FOR DRAWING 8/29/18 fix   41.06623- 
  println("drawlat = " + drawlat);
  
  return(drawlat);

}

float ConvertLong(float a){
  //convert map coordinates to screen coordinates

  float lefttoright = rightedge - leftedge; 
  float inputlong = a; 

  float drawlong = ((rightedge - inputlong)/lefttoright) * screenwidth;  //X VALUE FOR DRAWING 8/29/18 fix
  drawlong = screenwidth - drawlong;
  
  return(drawlong);
  
}

float ConvertCCLong(float a){
  //convert map coordinates to screen coordinates

  float lefttoright = CCrightedge - CCleftedge; 
  float inputlong = a; 
  println("inputlong = " + inputlong);

  float drawlong = ((CCrightedge - inputlong)/lefttoright) * screenwidth;
  drawlong = screenwidth - drawlong;
  println("drawlong = " + drawlong);
  
  return(drawlong);  
}


//lat/long, weight, color, color, color, description
void DrawMapPoint(float[] a, int e, int c1, int c2, int c3, String description) {
    fill(200,200,200);
  stroke(200,200,200);
  strokeWeight(1);
  //using convert methods to simplify the code
  float drawlat = ConvertLat(a[0]);
  println("Draw Lat = " + drawlat);
  float drawlong = ConvertLong(a[1]);
  println("Draw Long = " + drawlong);
  
  fill(c1, c2, c3);
  ellipse(drawlong, drawlat, e, e);
  textSize(10);
  fill(200,200,200);
  text(description, (drawlong + e), (drawlat + e));
}

//lat/long, weight, color, color, color, description
void DrawCCMapPoint(float[] a, int e, int c1, int c2, int c3, String description) {
  fill(200,200,200);
  stroke(200,200,200);
  strokeWeight(1);
  float drawlat = ConvertCCLat(a[0]);
  println("CC Draw Lat = " + drawlat);
  float drawlong = ConvertCCLong(a[1]);
  println("CC Draw Long = " + drawlong);
  
  fill(c1, c2, c3);
  ellipse(drawlat, drawlong, e, e);
  textSize(10);
  fill(200,200,200);
  //text(description + drawlong + drawlat, (drawlong + e), (drawlat + e));
  text(description, (drawlong + e), (drawlat + e));
}

void  ListRecentDataPoints(){
  image(img, 0, 0);

  stroke(200,200,200);
  strokeWeight(1);
  textFont(mono);
  textSize(20);
  fill(240,240,240);
  text("Draw Mode: List Recent Data", 12, 44);
  
  textSize(30);
  fill(155,155,155);
  text("DRAWING RECENT DATABASE ENTRIES", 12, 100);
  textSize(15);
  
  int r = datalog.length;
 
  for(int i = 0; i < r; i++){
    //for(int i = printtoscreencounter; i < r; i++){
    try{
    if(datalog[i].FeatureName != null){ 
        textSize(10);
  fill(220 ,220,220);
      //text("User Data Session Information " + i + " " + datalog[i].FeatureName, 12, (100 + (15 * i)));
      text("User Data Session Information " + i + " ", 12, (10 + (10 * i)));
      fill(255,100,100);
      text(datalog[i].FeatureName, 350, (10 + (10 * i)));
    println("writing out user session data for FeatureName "+ i + " " + datalog[i].FeatureName);
    }else
    println("not writing out user session data");
    }
    catch (NullPointerException e) {}
  }
  printtoscreencounter++;
  delay(100);
}

//when the state is set to show the IDs, the draw method will call this routine to run
void DrawIDs() {
  image(img, 0, 0);
  fill(200,200,200);
  stroke(200,200,200);
  strokeWeight(1);
  textSize(10);
  text("Draw Mode 4: Show All DataPoints", 12, 24);
  
  //for(int i = 0; i < datalog.length; i++){
    for(int i = 0; i < printtoscreencounter; i++){
    try{
      float[] temp = new float[2];
      //println("calling entry " + i);
      //println(datalog[i].Lat);
      //println(datalog[i].Lon);
      if(datalog[i].Lat != null){
        temp[0] = float(datalog[i].Lat);
        if(datalog[i].Lon != null){
          temp[1] = float(datalog[i].Lon);
          if(datalog[i].qindex == 1000){
            DrawMapPoint(temp, 10, 255,0,0, (str(datalog[i].id) + " " + datalog[i].FeatureName));
          }else
          if(datalog[i].qindex == 1001){
            DrawMapPoint(temp, 10, 0, 255, 0, (str(datalog[i].id) + " " + datalog[i].FeatureName));
          }else
          if(datalog[i].qindex == 1002){
            DrawMapPoint(temp, 10, 0,0,255, (str(datalog[i].id) + " " + datalog[i].FeatureName));
          }else
                    if(datalog[i].qindex == 2001){
            DrawMapPoint(temp, 10, 0,0,128, (str(datalog[i].id) + " " + datalog[i].FeatureName));
          }else
                    if(datalog[i].qindex == 2007){
            DrawMapPoint(temp, 10, 0,128,0, (str(datalog[i].id) + " " + datalog[i].FeatureName));
          }else
          DrawMapPoint(temp, 10, (int(i*(255/datalog.length))),(int(i*(255/datalog.length))),(int(i*(255/datalog.length))), (str(datalog[i].id) + " " + datalog[i].FeatureName));
        }
      }
    } catch (NullPointerException e){
      println("exception called during ID drawing routine");
    }
  } 
  println(printtoscreencounter);
  println(datalog.length);
  printtoscreencounter++;
  if(printtoscreencounter > datalog.length){printtoscreencounter = datalog.length;}
}

//when the state is set to show the IDs, the draw method will call this routine to run
void DrawCCIDs() {
  image(imgCC, 0, 0);
  fill(200,200,200);
  stroke(200,200,200);
  strokeWeight(1);
  textSize(10);
  text("Draw Mode 4: Show All DataPoints, CityCenter", 12, 24);
  
  for(int i = 0; i < datalog.length; i++){
    try{
      float[] temp = new float[2];
      println("calling entry " + i);
      println(datalog[i].Lat);
      println(datalog[i].Lon);
      if(datalog[i].Lat != null){
        temp[0] = float(datalog[i].Lat);
        if(datalog[i].Lon != null){
          temp[1] = float(datalog[i].Lon);
          DrawCCMapPoint(temp, 10, (int(i*(255/datalog.length))),(int(i*(255/datalog.length))),(int(i*(255/datalog.length))), (str(datalog[i].id) + " " + datalog[i].FeatureName));
        }
      }
    } catch (NullPointerException e){
      println("exception called during ID drawing routine");
    }
  } 
}

//when the state is set to show the IDs, the draw method will call this routine to run
void PlaceImageFeatureName() {
  image(img, 0, 0);
  fill(200,200,200);
  stroke(200,200,200);
  strokeWeight(1);
  textSize(10);
  text("Draw Mode: Place Image based on Feature Name", 12, 24);
  
  for(int i = 0; i < datalog.length; i++){
    //if( datalog[i].FeatureName 
  } 
}

void GridData(){
  image(img, 0, 0);
  stroke(200,200,200);
  strokeWeight(1);
  textFont(mono);
  textSize(20);
  fill(240,240,240);
  text("Draw Mode: User Session Grid Data", 12, 44);
  
  textSize(30);
  fill(120,120,120);
  text("GRIDDING DATABASE ENTRIES", 12, 700);
  textSize(20);
  
    int h = datalog.length;
    int count = 0;
    //number of entries before line break
    int linebreak = 10;
  
    for(int i = 0; i < (h/linebreak); i++){
      for(int y = 0; y < linebreak; y++){
        try{
        if(datalog[count].qindex == 1000){
                fill(255, 0, 0);
          }
        } catch (NullPointerException e){}
                  try{
        if(datalog[count].qindex == 1002){
                fill(255, 0, 255);
          } 
                  }catch (NullPointerException e){}
                  try{
        if(datalog[count].qindex == 1003){
                fill(255, 255, 0);
          } 
                  }catch (NullPointerException e){}
                  try{
        if(datalog[count].qindex == 1004){
                fill(128, 0, 0);
          } 
                  }catch (NullPointerException e){}

    strokeWeight(.1);
    rect(((screenwidth/(h/linebreak))*i), ((screenheight/2)+(y*60)), ((screenwidth/(h/linebreak))-10), 20);
    //write the node id number underneath the rectangle
    textSize(10);
    fill(222,222,222);
    //rotate(PI/2);
    text(count, ((screenwidth/(h/linebreak))*i), (((screenheight/2)+(y*60))-5));
    count++;
      }
  }
  
}

//draw all nodes in a graphical way
void MapAllNodes(){
    image(img, 0, 0);
      fill(200,200,200);
  stroke(200,200,200);
  strokeWeight(1);
  textFont(mono);
  textSize(20);
  fill(240,240,240);
  text("Draw Mode: Map All Nodes", 12, 44);
  
  textSize(30);
  fill(120,120,120);
  text("MAPPING DATABASE NODES CONNECTIONS + NULL", 12, 700);
  textSize(20);
  
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
  
  textSize(30);
  fill(55,55,55);
  text("DRAWING ARTIFICIAL INTELLIGENCE DATASET", 12, 650);
  textSize(15);
  
  for(int i = 0; i < (datalog.length - 1); i++){
    try{
    text("User Data Session Information " + i + " " + datalog[i].toString(), 12, (100 + (15*i)));
    }
    catch (NullPointerException e) {}
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

void PrintToScreen(String s) {
  image(img, 0, 0);
    fill(200,200,200);
  stroke(200,200,200);
  strokeWeight(1);
  
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
  
  textSize(30);
  fill(120,120,120);
  text("DRAWING MARKOV MODEL ITINERARIES", 12, 700);
  textSize(20);
  
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
  
    /*
  //String[] lines = loadStrings("https://web.njit.edu/~sq42/ProcessingHandler.php?question=Where%20are%20you%20from%3F");
  //sort into alphabetical order
  String[] lines = null;
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
DrawItinerary(senda2, sendb2, sendc2, sendd2, 2, 200);

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
DrawItinerary(senda3, sendb3, sendc3, sendd3, 5, 255);




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
    DrawItinerary(temp1, temp2, temp3, temp4, (i*2), (i*63));
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
    
    DrawItinerary(loc1, loc2, loc3, loc4, 3, 128);;
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
  
  //for (int i=0; i<m.length; i++) {                                                          // iterate all results of the match
    for (int i=0; i<1; i++) {
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
    public String Lon;
    public String answer;
    
    //id, question, answer, lat, long
    UserSession(int a, String b, String c, String d, String e) {
      id = a;
      question = b;
      answer = c;
      Lat = d;
      Lon = e;
    }
    
      UserSession(int a, int b, int c, String d, String e, String f, String g, String h, String i, String j, String k) {
      id = a;
      qindex = b;
      datetime = c;
      question = d;
      Category = e;
      Type = f;
      FeatureType = g;
      FeatureName = h;
      Lat = i;
      Lon = j;
      answer = k;
      println("UserSession Constructor Called. ID # = "+id);
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
      println("itinerary object created");
      println("point1 = "+ point1[0] + " " + point1[1]);
      println("point2 = "+ point2[0] + " " + point2[1]);
      println("point3 = "+ point3[0] + " " + point3[1]);
      println("point4 = "+ point4[0] + " " + point4[1]);
    }
    
       public String toString ()
    {
        //return String.format("id: %i, question: %s answer: %s", id, question, answer);
        String r = "point1 lat: " + str(point1[0]) + " " + "point1 lon: " + str(point1[1]);
        return r;
    }
}
