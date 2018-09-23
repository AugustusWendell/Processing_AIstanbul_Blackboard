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

AISession[] ailog;

Itinerary[] itineraries;
Itinerary[] AIitineraries;
Feature[] features;

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
PFont bold;

//print text to screen variables
String printtoscreen;
int printtoscreencounter = 0;
int printtoscreencounter2 = 0;

int usersessioncount = 500;
int AIsessioncount = 500;
int itinerariescount = 0;
int AIitinerariescount = 0;
int featurecount = 0;

States state = States.STATE_1;

int time;
//time between state changes
int wait = 15000;

//map image holder
PImage img;
PImage imgCC;

//colors
color colorHome = color(200, 200, 200);
color colorWork = color(50, 50, 50);
color colorFood = color(0, 152, 97);
color colorActivities = color(0, 86, 152);
color colorNostalgia = color(255, 204, 0);
color colorAI = color(255, 50, 0);


//DB
MySQL db;
MySQL db2;


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
  smooth(4);
  time = millis();//store the current time
  frameRate(40);

  //load in the image being used for the map
  img = loadImage("MAP_1920_1080.png");
  imgCC = loadImage("CITY_1920_1080.png");

  //define typeface for use
  //mono = createFont("helvetica.ttf", 32);
  //mono = createFont("af_drs.ttf", 20);
  mono = createFont("Arial-Unicode-Regular.ttf", 20);

  //bold = createFont("Helvetica Black Cyrillic Bold.ttf", 32);
  bold = createFont("HELR65W.ttf", 20);


  printtoscreencounter = 0;

  datalog = new UserSession[20000];
  ailog = new AISession[5000];
  itineraries = new Itinerary[5000];
  AIitineraries = new Itinerary[5000];
  features = new Feature[5000];
  DownloadDB(); //goes to the GoDaddy database and pulls all the data down, writes json files locally.
  DownloadAIDB();
  ImportData(); //imports the json files from the local drive
  FindItineraries();
  ImportItineraries();
  ImportAIItineraries();
  FindFeatureNames();
  //PrintFeaturesDebug();
}

void DownloadDB() {

  //println("DownloadDB Method Called");

  //db = new MySQL( this, "107.180.41.145", "IstanbulQuestions", "aistanbul", "=OFA*qUuAU3Y" );  // open database file
  db = new MySQL( this, "107.180.41.145", "IstanbulQuestions", "augustuswendell", "@Rtist999" );  // open database file

  db.setDebug(true);

  if ( db.connect() )
  {

    String[] tableNames = db.getTableNames();
    //println(tableNames); //only 1 TableName = Answers
    //move into Answers
    db.query( "SELECT * FROM %s", tableNames[0] );
    //select all columns from Answers?       
    String[] columnNames;
    columnNames = db.getColumnNames();
    //println(columnNames);

    //println("db insertion called");
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
      //println( y + " " + x +  " " + z + " " + b +  " " + c +  " " + d +  " " + e +  " " + f +  " " + g +  " " + h +  " " + i );

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
      //println("useresessioncount = " + usersessioncount);

      //increment counter
      r++;
    }
  }
}


void DownloadAIDB() {

  db2 = new MySQL( this, "107.180.41.145", "IstanbulAIOutput", "augustuswendell", "@Rtist999" );  // open database file
  AIitinerariescount = 0;

  db2.setDebug(true);

  if ( db2.connect() )
  {

    String[] tableNames = db2.getTableNames();
    db2.query( "SELECT * FROM %s", tableNames[0] );      
    String[] columnNames;
    columnNames = db2.getColumnNames();
    //println(columnNames);

    db2.query("SELECT * FROM Output");
    int r = 0;


    while (db2.next())
    {
      //columnNames = db.getColumnNames();
      //println(columnNames);
      int id = db2.getInt("id");
      float lat1 = db2.getFloat("lat1");
      float lon1 = db2.getFloat("lon1");
      float lat2 = db2.getFloat("lat2");
      float lon2 = db2.getFloat("lon2");
      float lat3 = db2.getFloat("lat3");
      float lon3 = db2.getFloat("lon3");
      float lat4 = db2.getFloat("lat4");
      float lon4 = db2.getFloat("lon4");

      //make a new object and put the data into it
      ailog[r] = new AISession(id, lat1, lon1, lat2, lon2, lat3, lon3, lat4, lon4);

      //write datalog[r] to a local JSON file
      //Processing.data.JSONObject
      JSONObject json = new JSONObject();

      json.setInt("id", id);
      json.setFloat("lat1", lat1);
      json.setFloat("lon1", lon1);
      json.setFloat("lat2", lat2);
      json.setFloat("lon2", lon2);
      json.setFloat("lat3", lat3);
      json.setFloat("lon3", lon3);
      json.setFloat("lat4", lat4);
      json.setFloat("lon4", lon4);


      saveJSONObject(json, "data/AIstanbul_AI_id_"+r+".json");


      //write datalog[r] to a local JSON file
      //Processing.data.JSONObject
      JSONObject json2 = new JSONObject();

      json2.setFloat("lat1", lat1);
      json2.setFloat("lon1", lon1);
      json2.setFloat("lat2", lat2);
      json2.setFloat("lon2", lon2);
      json2.setFloat("lat3", lat3);
      json2.setFloat("lon3", lon3);
      json2.setFloat("lat4", lat4);
      json2.setFloat("lon4", lon4);

      saveJSONObject(json2, "data/AIstanbul_AI_itinerary_"+r+".json");
      //println("saved json itinerary");
      AIitinerariescount = r;

      AIsessioncount = r;

      //increment counter
      r++;
    }
  }
}

//find same user lat and lon pairs in the datalog
void FindItineraries() {
  float[] temp = new float[2];
  float[] temp1 = new float[2];
  float[] temp2 = new float[2];
  float[] temp3 = new float[2];
  int r = 0;

  for (int i = 1; i < usersessioncount; i++) {
    if (datalog[i].qindex == 1000) {
      temp[0] = float(datalog[i].Lat);
      temp[1] = float(datalog[i].Lon);
      //println("building itinerary point 1");
    } else {
      if (datalog[i].qindex == 1002) {
        temp1[0] = float(datalog[i].Lat);
        temp1[1] = float(datalog[i].Lon);
        //println("building itinerary point 2");
      } else {
        if (datalog[i].qindex == 2001) {
          temp2[0] = float(datalog[i].Lat);
          temp2[1] = float(datalog[i].Lon);
          //println("building itinerary point 3");
        } else {
          if (datalog[i].qindex == 2007) {
            temp3[0] = float(datalog[i].Lat);
            temp3[1] = float(datalog[i].Lon);
            //println("building itinerary point 4");

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
            //println("saved json itinerary");
            itinerariescount = r;

            r++;
            //println("intinerary counter = "+r);
          }
        }
      }
    }
  }
  for (int i = 0; i < itineraries.length; i++) {
    try {
      //println("itineraries " + i );
      //println(itineraries[i].toString());
    }
    catch (NullPointerException e) {
    }
  }
}

void ImportItineraries() {

  JSONObject json = new JSONObject();
  for (int i = 1; i < itinerariescount; i++) {

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


void ImportAIItineraries() {

  JSONObject json = new JSONObject();
  for (int i = 1; i < AIitinerariescount; i++) {

    json = loadJSONObject("data/AIstanbul_AI_itinerary_"+i+".json");

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

    AIitineraries[i] = new Itinerary(temp1, temp2, temp3, temp4, 1);
  }
}

void ImportData() {

  datalog = new UserSession[usersessioncount];
  //println("updated size of datalog to " + usersessioncount);

  //write datalog[r] to a local JSON file
  //Processing.data.JSONObject
  JSONObject json = new JSONObject();
  for (int i = 1; i < usersessioncount; i++) {

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
    ScreenInitialize();
    //ListRecentDataPoints();
    break;
  case STATE_2: // 2 List of all or recent data points - makes clear that there are users, Last few at the top of the screen. 1 per user
    //ListFeatures();
    DrawInitialize();
    break;
  case STATE_3: //3 Same Data as Points on the screen: Color Coded, could be a few modes in here…….Home, Food, Activities, Work
    ListRecentDataPoints();
    break;
  case STATE_4: //4 Draw connections between them, to visually build itineraries - colored by user
    DrawIDs(); //State 4 shows all ID location
    break;
  case STATE_5: //5 Isolate one itinerary and place images along it
    DrawCCIDs(); //State 4 shows all ID locations
    break;
  case STATE_6: //6 AI Boot Screen?
    DrawNostalgiaIDs();
    //DrawWishbox();
    break;
  case STATE_7: //7 AI writes out data points as text
    DrawItineraries();
    //AIitineraryCounter = DrawAIitinerary(AIitineraryCounter);
    break;
  case STATE_8: //8 AI draws as dots  
    DrawCCItineraries();
    //DatabaseViz();
    break;
  case STATE_9: //9 AI Connects with lines to build itinerary
    PlaceImageFeatureName(3);
    break;
  case STATE_10: //10 AI reports textually on the itinerary and what it has learned
    PlaceCCImageFeatureName(5);
    break;
  case STATE_11:
    DrawAIInitialize();
    break;
  case STATE_12:
    DrawAIdata(1);
    break;
  case STATE_13:
    //AI_Text_Itinerary();
    DrawAIitinerary(2000);
    break;
  case STATE_14:

    DrawAIItineraries();
    break;
  case STATE_15:
    DrawAICCItineraries();
    break;
  case STATE_16:
    GridData();
    break;
    //case STATE_17: 
    //MapAllNodes();
    //break;
  }


  int d = day();    // Values from 1 - 31
  int m = month();  // Values from 1 - 12
  int y = year();
  int s = second();  // Values from 0 - 59
  int min = minute();  // Values from 0 - 59
  int h = hour();    // Values from 0 - 23

  //draw watermark
  textFont(mono);
  textSize(20);
  fill(188, 188, 188);
  text("[AI]stanbul Blackboard Application 0.95      "+state+"          " +m+ "_" +d+ "  "+h+"hours "+min+"minutes "+s+"seconds", 12, 22);
  text("Draw timing: " + millis() + " milliseconds", 1500, 22);

  //check the difference between now and the previously stored time is greater than the wait interval
  if (millis() - time >= wait) {
    //println("tick");//if it is, do something
    time = millis();//also update the stored time

    //save the current draw screen
    save("screencaptures/"+state+"/ScreenCapture"+y+m+d+"_"+h+min+".jpg");

    //clear the screen
    background(0);

    ResetVars();

    textSize(30);
    fill(120, 120, 120);
    text("[AI]istanbul Refresh - Loading New Drawing Mode", 12, 120);
    text("[AI]istanbul Refresh - Yeni Çizim Modu Yükleniyor", 12, 160);
    text("Computer Learning Drawing Mode = " + state, 12, 200);
    delay(3000);
    //changes the state to toggle the behaviour of the blackboard
    if (state == States.STATE_1) {
      state = States.STATE_2;
    } else
      if (state == States.STATE_2) {
        state = States.STATE_3;
      } else
        if (state == States.STATE_3) {
          state = States.STATE_4;
        } else
          if (state == States.STATE_4) {
            state = States.STATE_5;
          } else
            if (state == States.STATE_5) {
              state = States.STATE_6;
            } else
              if (state == States.STATE_6) {
                state = States.STATE_7;
              } else
                if (state == States.STATE_7) {
                  state = States.STATE_8;
                } else
                  if (state == States.STATE_8) {
                    state = States.STATE_9;
                  } else
                    if (state == States.STATE_9) {
                      state = States.STATE_10;
                    } else
                      if (state == States.STATE_10) {
                        state = States.STATE_11;
                      } else
                        if (state == States.STATE_11) {
                          state = States.STATE_12;
                        } else
                          if (state == States.STATE_12) {
                            state = States.STATE_13;
                          } else
                            if (state == States.STATE_13) {
                              state = States.STATE_14;
                            } else
                              if (state == States.STATE_14) {
                                state = States.STATE_15;
                              } else
                                if (state == States.STATE_15) {
                                  state = States.STATE_16;
                                } else
                                  if (state == States.STATE_16) {
                                    state = States.STATE_1;
                                  }
  }
}

public int getState() {
  switch (state) {
  case STATE_1: 
    return 1;
  case STATE_2: 
    return 2;
  case STATE_3: 
    return 3;
  case STATE_4: 
    return 4;
  case STATE_5: 
    return 5;
  case STATE_6: 
    return 6;
  case STATE_7: 
    return 7;
  case STATE_8: 
    return 8;
  case STATE_9: 
    return 9;
  case STATE_10: 
    return 10;
  case STATE_11: 
    return 11;
  case STATE_12: 
    return 12;
  case STATE_13: 
    return 13;
  }
  return 0;
}
void AI_Text_Itinerary() {
  image(imgCC, 0, 0);

  stroke(200, 200, 200);
  strokeWeight(1);
  textFont(mono);
  textSize(20);
  fill(240, 240, 240);
  text("Draw Mode: Report AI itinerary", 12, 500);
}

void ScreenInitialize() {
  stroke(200, 200, 200);
  strokeWeight(1);
  textFont(bold);
  textSize(20);
  fill(240, 240, 240);
  text("Contacting [AI]stanbul database", 12, 44);
  String a = "Contacting [AI]stanbul database_____";
  PrintToScreenLoop(a, 12, 500);
}

void DrawItineraries() {
  image(img, 0, 0);

  stroke(200, 200, 200);
  strokeWeight(1);
  textFont(mono);
  textSize(20);
  fill(240, 240, 240);
  text("Güzergahlar Çiziliyor", 12, 44);
  text("Draw Mode: User Itineraries", 12, 64);
  color c;
  c = color(255, 255, 255);

  for (int i = 0; i < printtoscreencounter; i++) {
    //for(int i = 0; i < itineraries.length; i++){
    try {
      DrawItinerary(itineraries[i], c, "User Itinerary Point");
      //println("draw itinerary " + i);
    }
    catch (NullPointerException e) {
    }
  }
  //println(printtoscreencounter);
  printtoscreencounter++;
  delay((wait/2)/itinerariescount);
}

void DrawAIItineraries() {
  image(img, 0, 0);

  stroke(200, 200, 200);
  strokeWeight(1);
  textFont(mono);
  textSize(20);
  fill(240, 240, 240);
  text("Güzergahlar Çiziliyor", 12, 44);
  text("Draw Mode: Artificial Intelligence Itineraries", 12, 64);

  for (int i = 0; i < printtoscreencounter; i++) {
    //for(int i = 0; i < itineraries.length; i++){
    try {
      DrawItinerary(AIitineraries[i], colorAI, "Markov Model Results");
    }
    catch (NullPointerException e) {
    }
  }
  //println(printtoscreencounter);
  printtoscreencounter++;
  delay((wait/2)/AIitinerariescount);
}

void DrawCCItineraries() {
  image(imgCC, 0, 0);

  stroke(200, 200, 200);
  strokeWeight(1);
  textFont(mono);
  textSize(20);
  fill(240, 240, 240);
  text("Draw Mode: User Itineraries, City Center", 12, 44);

  for (int i = 0; i < printtoscreencounter; i++) {
    //for(int i = 0; i < itineraries.length; i++){
    try {
      DrawCCItinerary(itineraries[i], 1, 5, ((255/itinerariescount) * i), str(i));
      //DrawCCItinerary(itineraries[i]);
      //println("draw itinerary " + i);
    }
    catch (NullPointerException e) {
    }
  }
  //println(printtoscreencounter);
  printtoscreencounter++;
  delay((wait/2)/itinerariescount);
}

void DrawAICCItineraries() {
  image(imgCC, 0, 0);

  stroke(200, 200, 200);
  strokeWeight(1);
  textFont(mono);
  textSize(20);
  fill(240, 240, 240);
  text("Draw Mode: Artificial Intelligence Itineraries, City Center", 12, 44);

  for (int i = 0; i < printtoscreencounter; i++) {
    //for(int i = 0; i < itineraries.length; i++){
    try {
      DrawCCItinerary(AIitineraries[i], 1, 5, ((255/AIitinerariescount) * i), str(i));
    }
    catch (NullPointerException e) {
    }
  }
  //println(printtoscreencounter);
  printtoscreencounter++;
  delay((wait/2)/AIitinerariescount);
}

void DrawInitialize() {
  image(img, 0, 0);

  String a = "Initializing [AI]stanbul Blackboard Machine Learning Application \nUser Input Data Parsed. " + usersessioncount + " answers downloaded from database \nSearched for complete itineraries. " + itinerariescount + " complete itineraries loaded from data";
  PrintToScreen(a, 12, 500);
}

void DrawAIInitialize() {
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

  String a = "Initializing [AI]stanbul Artificial Intelligence Engine_____";
  PrintToScreenLoop(a, 12, 500);
}

//called during each MODE transition to reset all variables needed
void ResetVars() {
  printtoscreencounter = 0;
  printtoscreencounter2 = 0;
  printtoscreen = "Debug [AI]istanbul data";
  int AIitineraryCounter = 1;
}

//when the state is set to writing the itinerary, the draw method will call this routine to run
void WriteItinerary() {
  image(img, 0, 0);

  stroke(200, 200, 200);
  strokeWeight(1);
  textFont(mono);
  textSize(20);
  fill(240, 240, 240);
  text("Draw Mode 1: Itinerary", 12, 44);


  //create new query to get data from the database to populate the mad lib itinerary
  //String[] lines = loadStrings("https://web.njit.edu/~sq42/ProcessingHandler.php?question=Where%20are%20you%20from%3F");
  String[] lines = loadStrings("https://web.njit.edu/~sq42/ProcessingHandler.php?question=HDis");
  //println("there are " + lines.length + " lines");
  for (int i = 0; i < lines.length; i++) {
    println("line " + i + " = " + lines[i]);
  }
  int r = int(random(lines.length));
  //println("random location value = " + r);
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
void DrawItinerary(float[] a, float[] b, float[] c, float[] d, int e, int s) {
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
  //println("itinerary MapPoint " + i.point1[0] + " " + i.point1[1]);
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

void DrawItinerary(Itinerary i, color c, String s) {
  DrawMapPoint(i.point1, 5, c, s);
  DrawMapPoint(i.point2, 5, c, s);
  //delay(100);
  DrawMapPoint(i.point3, 5, c, s);
  //delay(100);
  DrawMapPoint(i.point4, 5, c, s);
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

void DrawCCItinerary(Itinerary i, int w, int s, int c, String o) {
  DrawCCMapPoint(i.point1, s, c, c, c, o);
  DrawCCMapPoint(i.point2, s, c, c, c, o);
  DrawCCMapPoint(i.point3, s, c, c, c, o);
  DrawCCMapPoint(i.point4, s, c, c, c, o);
  DrawCCMapLine(i.point1, i.point2, w);
  DrawCCMapLine(i.point2, i.point3, w);
  DrawCCMapLine(i.point3, i.point4, w);
}

//lat/long,  lat/long,  lat/long,  lat/long,  size, color(single value)
void DrawCCItinerary(float[] a, float[] b, float[] c, float[] d, int e, int s) {
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

  fill(200, 200, 200);
  stroke(200, 200, 200);
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

  fill(200, 200, 200);
  stroke(200, 200, 200);
  strokeWeight(2);
  line(drawlong1, drawlat1, drawlong2, drawlat2);
}


//float[lat, long], image to be displayed, String info
void PlaceImage(float[] a, PImage b, String c) {
  fill(200, 200, 200);
  stroke(200, 200, 200);
  strokeWeight(1);
  textFont(mono);
  //using convert methods to simplify the code
  float drawlat = ConvertLat(a[0]);
  float drawlong = ConvertLong(a[1]);

  ellipse(drawlong, drawlat, 5, 5);

  //draw the image
  image(b, drawlong, drawlat);

  textSize(15);
  fill(200, 200, 200);
  text(c, (drawlong - 20), (drawlat - 20));
}

//float[lat, long], image to be displayed, String info
void PlaceCCImage(float[] a, PImage b, String c) {
  fill(200, 200, 200);
  stroke(200, 200, 200);
  strokeWeight(1);
  textFont(mono);
  //using convert methods to simplify the code
  float drawlat = ConvertCCLat(a[0]);
  float drawlong = ConvertCCLong(a[1]);

  ellipse(drawlong, drawlat, 5, 5);

  //draw the image
  image(b, drawlong, drawlat);

  textSize(15);
  fill(200, 200, 200);
  text(c, (drawlong - 20), (drawlat - 20));
}

float ConvertLat(float a) {
  //convert map coordinates to screen coordinates

  float bottomtotop = topedge - bottomedge; //.398
  float inputlat = a; //for instance 41.0    Y VALUE!!!

  float drawlat = ((topedge - inputlat)/bottomtotop) * screenheight; //Y VALUE FOR DRAWING 8/29/18 fix

  return(drawlat);
}

float ConvertCCLat(float a) {
  //convert map coordinates to screen coordinates

  float bottomtotop = CCtopedge - CCbottomedge;  //.11392
  float inputlat = a;                            
  //println("inputlat = " + inputlat); 

  float drawlat = ((CCtopedge - inputlat)/bottomtotop) * screenheight; //Y VALUE FOR DRAWING 8/29/18 fix   41.06623- 
  //println("drawlat = " + drawlat);

  return(drawlat);
}

float ConvertLong(float a) {
  //convert map coordinates to screen coordinates

  float lefttoright = rightedge - leftedge; 
  float inputlong = a; 

  float drawlong = ((rightedge - inputlong)/lefttoright) * screenwidth;  //X VALUE FOR DRAWING 8/29/18 fix
  drawlong = screenwidth - drawlong;

  return(drawlong);
}

float ConvertCCLong(float a) {
  //convert map coordinates to screen coordinates

  float lefttoright = CCrightedge - CCleftedge; 
  float inputlong = a; 
  //println("inputlong = " + inputlong);

  float drawlong = ((CCrightedge - inputlong)/lefttoright) * screenwidth;
  drawlong = screenwidth - drawlong;
  //println("drawlong = " + drawlong);

  return(drawlong);
}


//lat/long, weight, color, color, color, description
void DrawMapPoint(float[] a, int e, int c1, int c2, int c3, String description) {
  fill(200, 200, 200);
  stroke(200, 200, 200);
  strokeWeight(1);
  textFont(mono);
  //using convert methods to simplify the code
  float drawlat = ConvertLat(a[0]);
  //println("Draw Lat = " + drawlat);
  float drawlong = ConvertLong(a[1]);
  //println("Draw Long = " + drawlong);

  fill(c1, c2, c3);
  ellipse(drawlong, drawlat, e, e);
  textSize(10);
  fill(200, 200, 200);
  text(description, (drawlong + e), (drawlat + e));
}

//lat/long, weight, color, color, color, description
void DrawMapPoint(float[] a, int e, color c, String description) {
  fill(200, 200, 200);
  stroke(200, 200, 200);
  strokeWeight(1);
  textFont(mono);
  //using convert methods to simplify the code
  float drawlat = ConvertLat(a[0]);
  //println("Draw Lat = " + drawlat);
  float drawlong = ConvertLong(a[1]);
  //println("Draw Long = " + drawlong);

  fill(c);
  ellipse(drawlong, drawlat, e, e);
  textSize(10);
  fill(200, 200, 200);
  text(description, (drawlong + e), (drawlat + e));
}

//lat/long, weight, color, color, color, description
void DrawCCMapPoint(float[] a, int e, int c1, int c2, int c3, String description) {
  fill(200, 200, 200);
  stroke(200, 200, 200);
  strokeWeight(1);
  textFont(mono);
  float drawlat = ConvertCCLat(a[0]);
  //println("CC Draw Lat = " + drawlat);
  float drawlong = ConvertCCLong(a[1]);
  //println("CC Draw Long = " + drawlong);

  fill(c1, c2, c3);
  //ellipse(drawlat, drawlong, e, e);
  ellipse(drawlong, drawlat, e, e);
  textSize(10);
  fill(200, 200, 200);
  //text(description + drawlong + drawlat, (drawlong + e), (drawlat + e));
  text(description, (drawlong + e), (drawlat + e));
}

//lat/long, weight, color, color, color, description
void DrawCCMapPoint(float[] a, int e, color c, String description) {
  fill(200, 200, 200);
  stroke(200, 200, 200);
  strokeWeight(1);
  textFont(mono);
  float drawlat = ConvertCCLat(a[0]);
  //println("CC Draw Lat = " + drawlat);
  float drawlong = ConvertCCLong(a[1]);
  //println("CC Draw Long = " + drawlong);

  fill(c);
  //ellipse(drawlat, drawlong, e, e);
  ellipse(drawlong, drawlat, e, e);
  textSize(10);
  fill(200, 200, 200);
  //text(description + drawlong + drawlat, (drawlong + e), (drawlat + e));
  text(description, (drawlong + e), (drawlat + e));
}

void  ListRecentDataPoints() {
  image(img, 0, 0);
  stroke(200, 200, 200);
  strokeWeight(1);
  textFont(mono);
  textSize(20);
  fill(240, 240, 240);
  text("Draw Mode: List Recent Data", 12, 44);
  fill(200, 200, 200);

  /*
  //for (int i = featurecount; i > 5; i--) {
   for (int i = 1; i < featurecount; i++) {
   try {
   //text("Feature Input Found. Feature Name: "+features[i].name, 200, (70 + (17 * i)));
   text("Feature Input Found. Feature Name: "+features[(featurecount - i)].name, 200, (70 + (17 * i)));
   } 
   catch (NullPointerException f) {
   }
   }
   delay((wait/4)/featurecount);
   */

  if (printtoscreencounter < featurecount) {
    fill(200, 200, 200);
    for (int i = 0; i < printtoscreencounter; i++) {
      try {
        text("Feature Input Found. Feature Name: "+features[(featurecount - i)].name, 200, (70 + (17 * i)));
      } 
      catch (NullPointerException e) {
      }
    }
    printtoscreencounter++;
    delay((wait)/featurecount);
  }
}

void  ListFeatures() {
  for (int i = 0; i < datalog.length; i++) {
    try {
      if (datalog[i].FeatureName.length() > 4) { 
        //println("feature found");
        //println("featurecount = "+featurecount);
        println(datalog[i].FeatureName);
      }
    }
    catch (NullPointerException e) {
    }
  }
}



//when the state is set to show the IDs, the draw method will call this routine to run
void DrawIDs() {
  image(img, 0, 0);
  fill(200, 200, 200);
  stroke(200, 200, 200);
  strokeWeight(1);
  textSize(20);
  textFont(mono);
  text("Draw Mode 4: Show All DataPoints", 12, 44);


  textFont(bold);
  textSize(50);
  fill(colorFood);
  text("Ev / Home", 12, 200);
  fill(colorHome);
  text("İş / Work", 12, 300);
  fill(colorWork);
  text("Yemek / Food", 12, 400);
  fill(colorActivities);
  text("Etkinlikler / Activities", 12, 500);

  textFont(mono);
  //for(int i = 0; i < datalog.length; i++){
  for (int i = 0; i < printtoscreencounter; i++) {
    try {
      float[] temp = new float[2];
      if (datalog[i].Lat != null) {
        temp[0] = float(datalog[i].Lat);
        if (datalog[i].Lon != null) {
          temp[1] = float(datalog[i].Lon);
          if (datalog[i].qindex == 1000) {
            //DrawMapPoint(temp, 10, 255,0,0, (str(datalog[i].id) + " " + datalog[i].FeatureName));
            DrawMapPoint(temp, 10, 200, 200, 200, datalog[i].FeatureName);
          } else
            if (datalog[i].qindex == 1001) {
              //DrawMapPoint(temp, 10, 0, 255, 0, (str(datalog[i].id) + " " + datalog[i].FeatureName));
              DrawMapPoint(temp, 10, 50, 50, 50, datalog[i].FeatureName);
            } else
              if (datalog[i].qindex == 2001) {
                //DrawMapPoint(temp, 10, 0,0,255, (str(datalog[i].id) + " " + datalog[i].FeatureName));
                DrawMapPoint(temp, 10, 0, 152, 97, datalog[i].FeatureName);
              } else
                if (datalog[i].qindex == 3002) {
                  //DrawMapPoint(temp, 10, 0,0,128, (str(datalog[i].id) + " " + datalog[i].FeatureName));
                  DrawMapPoint(temp, 10, 0, 86, 152, datalog[i].FeatureName);
                }
        }
      }
    } 
    catch (NullPointerException e) {
      //println("exception called during ID drawing routine");
    }
  } 
  //println(printtoscreencounter);
  //println(datalog.length);
  printtoscreencounter++;
  if (printtoscreencounter > datalog.length) {
    printtoscreencounter = datalog.length;
  }
}





//when the state is set to show the IDs, the draw method will call this routine to run
void DrawNostalgiaIDs() {
  image(img, 0, 0);

  textFont(mono);
  fill(200, 200, 200);
  textSize(20);
  text("Draw Mode 4: Show All DataPoints: Nostalgia", 12, 44);

  textFont(bold);
  fill(colorNostalgia);
  textSize(50);
  text("Nostalgia", 12, 200);

  //for(int i = 0; i < datalog.length; i++){
  for (int i = 0; i < printtoscreencounter; i++) {
    try {
      float[] temp = new float[2];
      if (datalog[i].Lat != null) {
        temp[0] = float(datalog[i].Lat);
        if (datalog[i].Lon != null) {
          temp[1] = float(datalog[i].Lon);
          if (datalog[i].qindex == 1004) {
            DrawMapPoint(temp, 10, colorNostalgia, "Unique User ID #"+datalog[i].id);
          } else {
          }
        }
      }
    } 
    catch (NullPointerException e) {
      //println("exception called during ID drawing routine");
    }
  } 
  printtoscreencounter++;
  if (printtoscreencounter > datalog.length) {
    printtoscreencounter = datalog.length;
  }
}




void DrawWishbox() {
  image(img, 0, 0);

  textFont(mono);
  fill(200, 200, 200);
  textSize(20);
  text("Draw Mode: Wishbox", 12, 44);

  fill(152, 0, 0);
  textSize(50);
  text("Wishbox", 12, 100);

  //for(int i = 0; i < datalog.length; i++){
  for (int i = 0; i < printtoscreencounter; i++) {
    try {
      float[] temp = new float[2];
      if (datalog[i].Lat != null) {
        temp[0] = float(datalog[i].Lat);
        if (datalog[i].Lon != null) {
          temp[1] = float(datalog[i].Lon);
          if (datalog[i].qindex == 4000) {
            DrawMapPoint(temp, 10, 255, 255, 255, datalog[i].answer);
          } else {
          }
        }
      }
    } 
    catch (NullPointerException e) {
      println("exception called during ID drawing routine");
    }
  } 
  printtoscreencounter++;
  if (printtoscreencounter > datalog.length) {
    printtoscreencounter = datalog.length;
  }
}


//when the state is set to show the IDs, the draw method will call this routine to run
void DrawCCIDs() {
  image(imgCC, 0, 0);
  fill(200, 200, 200);
  stroke(200, 200, 200);
  strokeWeight(1);
  textSize(20);
  text("Draw Mode 4: Show All DataPoints, CityCenter", 12, 44);

  textFont(bold);
  textSize(50);
  fill(colorFood);
  text("Ev / Home", 12, 200);
  fill(colorHome);
  text("İş / Work", 12, 300);
  fill(colorWork);
  text("Yemek / Food", 12, 400);
  fill(colorActivities);
  text("Etkinlikler / Activities", 12, 500);

  textFont(mono);
  //for(int i = 0; i < datalog.length; i++){
  for (int i = 0; i < printtoscreencounter; i++) {
    try {
      float[] temp = new float[2];
      if (datalog[i].Lat != null) {
        temp[0] = float(datalog[i].Lat);
        if (datalog[i].Lon != null) {
          temp[1] = float(datalog[i].Lon);
          if (datalog[i].qindex == 1000) {
            DrawCCMapPoint(temp, 10, 200, 200, 200, datalog[i].FeatureName);
          } else
            if (datalog[i].qindex == 1001) {
              DrawCCMapPoint(temp, 10, 50, 50, 50, datalog[i].FeatureName);
            } else
              if (datalog[i].qindex == 1002) {
                DrawCCMapPoint(temp, 10, 0, 152, 97, datalog[i].FeatureName);
              } else
                if (datalog[i].qindex == 2001) {
                  DrawCCMapPoint(temp, 10, 0, 86, 152, datalog[i].FeatureName);
                } else
                  if (datalog[i].qindex == 3002) {
                    DrawCCMapPoint(temp, 10, 0, 0, 0, datalog[i].FeatureName);
                  } else
                    DrawCCMapPoint(temp, 10, (int(i*(255/datalog.length))), (int(i*(255/datalog.length))), (int(i*(255/datalog.length))), datalog[i].FeatureName);
        }
      }
    } 
    catch (NullPointerException e) {
      println("exception called during ID drawing routine");
    }
  } 
  //println(printtoscreencounter);
  //println(datalog.length);
  printtoscreencounter++;
  if (printtoscreencounter > datalog.length) {
    printtoscreencounter = datalog.length;
  }
}

void FindFeatureNames() {
  for (int i = 0; i < datalog.length; i++) {
    try {
      if (datalog[i].FeatureName.length() > 4) { 
        //println("feature found");
        //println("featurecount = "+featurecount);
        String featureName = datalog[i].FeatureName;
        println(datalog[i].FeatureName);
        Float featureLat = float(datalog[i].Lat);
        println(datalog[i].Lat);
        Float featureLon = float(datalog[i].Lon);
        println(datalog[i].Lon);
        features[featurecount] = new Feature(featureName, featureLat, featureLon);
        println(features[featurecount].toString());

        println("featurecount = "+featurecount);
        featurecount++;
      }
    }
    catch (NullPointerException e) {
    }
  }
}

void PrintFeaturesDebug() {
  for (int i = 0; i < features.length; i++) {
    try {
      println(features[i].name);
      println(features[i].toString());
      featurecount++;
    }
    catch (NullPointerException e) {
    }
  }
}

//when the state is set to show the IDs, the draw method will call this routine to run
void PlaceImageFeatureName(int a) {
  image(img, 0, 0);
  fill(200, 200, 200);
  stroke(200, 200, 200);
  strokeWeight(1);
  textSize(10);
  text("Draw Mode: Place Image based on Feature Name", 12, 24);

  println("PlaceImageFeatureName called");
  textFont(mono);
  for (int i = 0; i < (features.length - 1); i++) {
    try {
      float[] f = new float[2];
      f[0] = features[i].lat;
      f[1] = features[i].lon;
      DrawMapPoint(f, 4, 60, 60, 60, features[i].name);
    }
    catch (NullPointerException e) {
    }
  }


  for (int i = 0; i < a; i++) {
    try {
      Feature r = features[int(random(featurecount))];
      println("searching for feature specific images "+r.name+" "+r.lat+" "+r.lon);
      searchforgoogleimages(r.lat, r.lon, r.name);
    }
    catch (NullPointerException e) {
    }
  }
}

//when the state is set to show the IDs, the draw method will call this routine to run
void PlaceCCImageFeatureName(int a) {
  image(imgCC, 0, 0);
  fill(200, 200, 200);
  stroke(200, 200, 200);
  strokeWeight(1);
  textSize(10);
  text("Draw Mode: Place Image based on Feature Name", 12, 24);
  textFont(mono);
  for (int i = 0; i < (features.length - 1); i++) {
    try {
      float[] f = new float[2];
      f[0] = features[i].lat;
      f[1] = features[i].lon;
      DrawCCMapPoint(f, 4, 60, 60, 60, features[i].name);
    }
    catch (NullPointerException e) {
    }
  }


  for (int i = 0; i < a; i++) {
    try {
      Feature r = features[int(random(featurecount))];
      println("searching for feature specific images "+r.name+" "+r.lat+" "+r.lon);
      searchCCforgoogleimages(r.lat, r.lon, r.name);
    }
    catch (NullPointerException e) {
    }
  }
}

void GridData() {
  image(img, 0, 0);
  stroke(200, 200, 200);
  strokeWeight(1);
  textFont(mono);
  textSize(20);
  fill(240, 240, 240);
  text("Draw Mode: User Session Grid Data", 12, 44);

  textSize(30);
  fill(120, 120, 120);
  text("GRIDDING DATABASE ENTRIES", 12, 700);
  textSize(20);

  int h = datalog.length;
  int count = 0;
  //number of entries before line break
  int linebreak = 10;

  for (int i = 0; i < (h/linebreak); i++) {
    for (int y = 0; y < linebreak; y++) {
      try {
        if (datalog[count].qindex == 1000 ) {
          fill(colorHome);
        }
      } 
      catch (NullPointerException e) {
      }
      try {
        if (datalog[count].qindex == 1002 || datalog[count].qindex == 1001) {
          fill(colorWork);
        }
      }
      catch (NullPointerException e) {
      }
      try {
        if (datalog[count].qindex == 1003 || datalog[count].qindex == 1004 || datalog[count].qindex == 1005) {
          fill(255, 255, 0);
        }
      }
      catch (NullPointerException e) {
      }
      try {
        if (datalog[count].qindex == 4000) {
          fill(128, 0, 0);
        }
      }
      catch (NullPointerException e) {
      }
      try {
        if (datalog[count].qindex == 2001 || datalog[count].qindex == 2002 || datalog[count].qindex == 2003 || datalog[count].qindex == 2004) {
          fill(colorFood);
        }
      }
      catch (NullPointerException e) {
      }
      try {
        if (datalog[count].qindex == 3002 || datalog[count].qindex == 3003 || datalog[count].qindex == 3001 || datalog[count].qindex == 3004) {
          fill(colorActivities);
        }
      }
      catch (NullPointerException e) {
      }

      strokeWeight(.1);
      rect(((screenwidth/(h/linebreak))*i), ((screenheight/4)+(y*60)), ((screenwidth/(h/linebreak))-10), 20);
      //write the node id number underneath the rectangle
      textSize(10);
      fill(222, 222, 222);
      //rotate(PI/2);
      text(count, ((screenwidth/(h/linebreak))*i), (((screenheight/4)+(y*60))-5));
      count++;
    }
  }
}

//draw all nodes in a graphical way
void MapAllNodes() {
  image(img, 0, 0);
  fill(200, 200, 200);
  stroke(200, 200, 200);
  strokeWeight(1);
  textFont(mono);
  textSize(20);
  fill(240, 240, 240);
  text("Draw Mode: Map All Nodes", 12, 44);

  textSize(30);
  fill(120, 120, 120);
  text("MAPPING DATABASE NODES CONNECTIONS + NULL", 12, 700);
  textSize(20);

  int h = datalog.length;

  for (int i = 0; i < h; i++) {
    fill(random(100, 200), random(100, 200), random(100, 200)); 
    //make a rectangle with a random color x, y , width, height
    strokeWeight(.1);
    rect(((screenwidth/h)*i), (screenheight/2), ((screenwidth/h)-4), 20);
    //write the node id number underneath the rectangle

    textSize(10);
    fill(222, 222, 222);
    //rotate(PI/2);
    text(i, ((screenwidth/h)*i), ((screenheight/2) - 5));
    //rotate(PI/2);
    //rotate(PI/2);
    //rotate(PI/2);
    //draw arc from each node to another random node
    noFill();
    strokeWeight(.5);
    stroke(255);
    arc(((screenwidth/h)*i), ((screenheight/2)+25), ((screenwidth/h)*random(3, 33)), ((screenwidth/h)*random(3, 33)), 0, PI);
  }
}


//when the state is set to 5 to draw an autonomous itinerary
void DrawAIdata(int a) {
  image(img, 0, 0);

  textFont(mono);
  textSize(20);
  fill(240, 240, 240);
  text("Draw Mode 7: Show AI Data", 12, 44);
  textFont(mono);
  if (printtoscreencounter < datalog.length) {
    fill(200, 200, 200);
    for (int i = 0; i < printtoscreencounter; i++) {
      try {
        text("Artificial Intelligence Input: User Data Entry: "+datalog[(datalog.length-i-1)].id+"  Question Code "+datalog[(datalog.length-i-1)].qindex+"  Category Data "+datalog[(datalog.length-i-1)].Category, 350, (70 + (17 * i)));
      } 
      catch (NullPointerException e) {
      }
    }
    printtoscreencounter++;
    delay((wait/2)/featurecount);
  }
}

void PrintToScreen(String s, int x, int y) {
  image(img, 0, 0);
  fill(200, 200, 200);
  stroke(200, 200, 200);
  strokeWeight(1);

  textFont(mono);
  textSize(20);
  fill(240, 240, 240);
  text("Print Text To Screen", 12, 44);

  textFont(bold);

  textSize(50);
  text(s.substring(0, printtoscreencounter2), x, y);
  if (printtoscreencounter2 < s.length()) {
    printtoscreencounter2++;
  }
  //println("printtoscreenscounter = " + printtoscreencounter);
}

void PrintToScreenLoop(String s, int x, int y) {
  image(img, 0, 0);
  fill(200, 200, 200);
  stroke(200, 200, 200);
  strokeWeight(1);

  textFont(mono);
  textSize(20);
  fill(240, 240, 240);
  text("Print Text To Screen", 12, 44);

  textFont(bold);

  textSize(50);
  text(s.substring(0, printtoscreencounter), x, y);
  if (printtoscreencounter < s.length()) {
    printtoscreencounter++;
  } else {
    printtoscreencounter = 0;
    delay(1000);
  }
}

//when the state is set to 5 to draw an autonomous itinerary
int DrawAIitinerary(int a) {
  int pointcounter = 0;
  pointcounter = a;
  image(img, 0, 0);

  //int select = int(random(1, AIitineraries.length));
  int select = AIitineraries.length;
  select = 10;
  Itinerary selecteditinerary = AIitineraries[(select - 1)];

  float[] senda = new float[2];
  try {
    senda = selecteditinerary.point1;
    //println(selecteditinerary.point1);
  }
  catch (NullPointerException e) {
  }

  float[] sendb = new float[2];
  try {
    sendb = selecteditinerary.point2;

    //println(selecteditinerary.point2);
  }
  catch (NullPointerException e) {
  }

  float[] sendc = new float[2];
  try {
    sendc = selecteditinerary.point3;
    //println(selecteditinerary.point3);
  }
  catch (NullPointerException e) {
  }

  float[] sendd = new float[2];
  try {
    sendd = selecteditinerary.point4;
    //println(selecteditinerary.point4);
  }
  catch (NullPointerException e) {
  }



  textFont(mono);
  textSize(20);
  fill(240, 240, 240);
  text("Draw Mode 5: Show All DataPoints", 12, 44);

  textSize(30);
  fill(120, 120, 120);
  text("DRAWING MARKOV MODEL ITINERARIES", 12, 700);
  textSize(20);

  int e = 5;
  int s = 255;

  PrintToScreen("AI DATASET ITINERARY - MARKOV MODEL .90", 12, 100);
  stroke(colorAI);
  fill(colorAI);
  if (printtoscreencounter > 0) {
    DrawMapPoint(senda, e, colorAI, "Markov Point 1");
    //Draw AI Itinerary1 Text
  } 
  if (printtoscreencounter > 50) {
    DrawMapPoint(sendb, e, colorAI, "Markov Point 2");
    //Draw AI Itinerary2 Text
  } 
  if (printtoscreencounter > 100) {
    DrawMapPoint(sendc, e, colorAI, "Markov Point 3");
    //Draw AI Itinerary3 Text
  } 
  if (printtoscreencounter > 150) {
    DrawMapPoint(sendd, e, colorAI, "Markov Point 4");
    //Draw AI Itinerary4 Text
  } 
  if (printtoscreencounter > 200) {
    strokeWeight(5);

    DrawMapLine(senda, sendb, 5);
  } 
  if (printtoscreencounter > 250) {
    DrawMapLine(sendb, sendc, 5);
  }
  if (printtoscreencounter > 300) {
    DrawMapLine(sendc, sendd, 5);
  } 
  if (printtoscreencounter > 350) {
    for (int i = 0; i < 10; i++) {
      color c = color(50, 50, 50);
      println("i = "+i);
      //DrawItinerary(AIitineraries[i], c, "AI data");
      //DrawItinerary(AIitineraries[i]);
    }
  } 
  printtoscreencounter++;
  println("pointcounter = " + printtoscreencounter);
  return(printtoscreencounter);
}

//when the state is set to the visualizing the database, the draw method will call this routine to run
void DatabaseViz() {
  image(img, 0, 0);

  textSize(10);
  fill(200, 200, 200);
  text("Draw Mode 2: Database Viz", 12, 24);
  //Itinerary temp = new Itinerary;
  //temp = itineraries.[random(itinerariescount];
  //DrawItinerary(temp, 2, 200);
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

      PlaceImage(loc, webImg, s);
    }
  }
}



//Most all of this method comes from Jeff Thompson github.com/jeffThompson
void searchCCforgoogleimages(float x, float y, String s) {

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

      PlaceCCImage(loc, webImg, s);
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
    //println("UserSession Constructor Called. ID # = "+id);
  }



  public String toString ()
  {
    //return String.format("id: %i, question: %s answer: %s", id, question, answer);
    String r = "id: " + str(id) + ", question: " + question + " answer: " + answer;
    return r;
  }
}



//Object to store each user session. These can be loaded into some container and then queried offline in case database connection is lost.
class AISession
{
  public int id;
  public Float lat1;
  public Float lon1;
  public Float lat2;
  public Float lon2;
  public Float lat3;
  public Float lon3;
  public Float lat4;
  public Float lon4;


  AISession(int a, float b, float c, float d, float e, float f, float g, float h, float i) {
    id = a;
    lat1 = b;
    lon1 = c;
    lat2 = d;
    lon2 = e;
    lat3 = f;
    lon3 = g;
    lat4 = h;
    lon4 = i;
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

  public String toString ()
  {
    //return String.format("id: %i, question: %s answer: %s", id, question, answer);
    String r = "point1 lat: " + str(point1[0]) + " " + "point1 lon: " + str(point1[1]);
    return r;
  }
}

//Object to store an itinerary
class Feature
{
  public float lat;
  public float lon;
  public String name;

  Feature(String featureName, Float featureLat, Float featureLon) {
    name = featureName;
    lat = featureLat;
    lon = featureLon;
  }

  public String toString ()
  {
    //return String.format("id: %i, question: %s answer: %s", id, question, answer);
    String r = "name " + name + " " + "lat " + lat+ " " + "lon " + lon;
    return r;
  }
}
