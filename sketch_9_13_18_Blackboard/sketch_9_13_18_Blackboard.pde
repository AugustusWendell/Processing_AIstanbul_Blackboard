//import twitter4j.conf.*;
//import twitter4j.*;
//import twitter4j.auth.*;
//import twitter4j.api.*;

import java.net.HttpURLConnection;    // required for HTML download
import java.net.URL;
import java.net.URLEncoder;
import java.io.InputStreamReader;     // used to get our raw HTML source   

import de.bezier.data.sql.*;          // used to connect to MYSQL

//master Array holding all user data
UserSession[] datalog;

WishboxFeature[] wishlog;
LostBuildingFeature[] lostbuildinglog;

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
int wishboxcount = 0;
int nostalgiacount = 0;
int lostbuildingcount = 0;
int lastdatacount = 0;

int firsttextlineheight = 60;
int secondtextlineheight = 100;

int upperscreentextsize = 30;

States state = States.STATE_1;

int time;
//time between state changes
int wait = 22000;

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
  fullScreen();
  //size(1920, 1080);
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
  wishlog = new WishboxFeature[5000];
  lostbuildinglog = new LostBuildingFeature[5000];
  DownloadDB(); //goes to the GoDaddy database and pulls all the data down, writes json files locally.
  DownloadAIDB();
  ImportData(); //imports the json files from the local drive
  FindItineraries();
  ImportItineraries();
  ImportAIItineraries();
  FindFeatureNames();
  FindWishbox();
  ImportWishBox();
  FindLostBuilding();
  ImportLostBuilding();
}

void draw() {

  switch (state) {
  case STATE_1 :
    ScreenInitialize();
    break;
  case STATE_2:
    DrawInitialize();
    break;
  case STATE_3:
    DrawLastUserData();
    break;
  case STATE_4:
    DrawLastUserDataItinerary();
    break;
  case STATE_5:
    ListRecentDataPoints();
    break;
  case STATE_6:
    DrawIDs(); 
    break;
  case STATE_7: //7 AI writes out data points as text
    DrawCCIDs();
    break;
  case STATE_8: //8 AI draws as dots
    DrawItineraries();  
    break;
  case STATE_9:
    //DrawNostalgiaIDs();
    DrawCCItineraries();
    break;
  case STATE_10:
    PlaceImageFeatureName(3);
    break;
  case STATE_11:
    ReportLostBuildingCC();
    //ReportLostBuilding();
    //DatabaseViz();
    break;
  case STATE_12:
    DrawWishbox();
    //PlaceImageFeatureName(3);
    break;
  case STATE_13:
    PlaceCCImageFeatureName(5);
    break;
  case STATE_14:
    DrawAIInitialize();
    break;
  case STATE_15:
    DrawAIdata(1);
    break;
  case STATE_16:
    DrawAIitinerary(2000);
    break;
  case STATE_17:
    DrawAIItineraries();
    break;
  case STATE_18:
    DrawAICCItineraries();
    break;
  case STATE_19:
    GridData();
    break;
  }


  int d = day();    // Values from 1 - 31
  int m = month();  // Values from 1 - 12
  int y = year();
  int s = second();  // Values from 0 - 59
  int min = minute();  // Values from 0 - 59
  int h = hour();    // Values from 0 - 23

  //draw watermark
  textFont(mono);
  textSize(upperscreentextsize);
  fill(188, 188, 188);
  text("[AI]stanbul Blackboard Application 1.00      "+state+"          " +m+ "_" +d+ "  "+h+"hours "+min+"minutes "+s+"seconds", 12, 26);
  text("Draw timing: " + millis() + " milliseconds", 1400, 26);

  //check the difference between now and the previously stored time is greater than the wait interval
  if (millis() - time >= wait) {
    //println("tick");//if it is, do something
    time = millis();//also update the stored time

    //save the current draw screen
    save("screencaptures/"+state+"/ScreenCapture"+y+m+d+"_"+h+min+".jpg");

    //clear the screen
    background(0);

    ResetVars();

    textSize(upperscreentextsize);
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
                                    state = States.STATE_17;
                                  } else
                                    if (state == States.STATE_17) {
                                      state = States.STATE_18;
                                    } else
                                      if (state == States.STATE_18) {
                                        state = States.STATE_19;
                                      } else
                                        if (state == States.STATE_19) {
                                          state = States.STATE_1;
                                        }
  }
}


void AI_Text_Itinerary() {
  image(imgCC, 0, 0);
  stroke(200, 200, 200);
  strokeWeight(1);
  textFont(mono);
  textSize(upperscreentextsize);
  fill(240, 240, 240);
  text("Draw Mode: Report AI itinerary", 12, firsttextlineheight);
}

void ScreenInitialize() {
  stroke(200, 200, 200);
  strokeWeight(1);
  textFont(bold);
  textSize(upperscreentextsize);
  fill(240, 240, 240);
  text("Contacting [AI]stanbul database", 12, firsttextlineheight);
  String a = "Contacting [AI]stanbul database_____";
  PrintToScreenLoop(a, 12, 500);
}

void DrawItineraries() {
  image(img, 0, 0);

  stroke(200, 200, 200);
  strokeWeight(1);
  textFont(mono);
  textSize(upperscreentextsize);
  fill(240, 240, 240);
  text("Güzergahlar Çiziliyor", 12, secondtextlineheight);
  text("Draw Mode: User Itineraries", 12, firsttextlineheight);
  color c;
  c = color(255, 255, 255);

  //println("drawing itineraries " + "   itineraries count = " + itineraries.length);
  //println(itinerariescount);

  for (int i = 0; i < printtoscreencounter; i++) {
    //for(int i = 0; i < itineraries.length; i++){
    try {
      if (i == (itinerariescount-1)) {
        color c1;
        c1 = color(255, 0, 0);
        DrawItinerary(itineraries[i], c1, "User Itinerary Point");
        //println("draw last itinerary red");
      } else {
        DrawItinerary(itineraries[i], c, "User Itinerary Point");
        //println("draw " + i);
      }
      //DrawItinerary(itineraries[i], c, "User Itinerary Point");
      //println("draw itinerary " + i);
    }
    catch (NullPointerException e) {
    }
  }
  //println(printtoscreencounter);
  printtoscreencounter++;
  delay((wait/2)/itinerariescount);
}

void DrawLastUserData() {
  image(img, 0, 0);

  stroke(200, 200, 200);
  strokeWeight(1);
  textFont(mono);
  textSize(upperscreentextsize);
  fill(240, 240, 240);
  text(" ", 12, secondtextlineheight);
  text("Draw Mode: Last User Input", 12, firsttextlineheight);

  //document the last user interaction
  int userid = GetUserId(usersessioncount);
  //println("user session ID = " + userid);
  lastdatacount = 0;
  for (int i = (usersessioncount -1); i > (usersessioncount - 10); i--) {
    if (datalog[i].id != userid) {
      break;
    } else {
      String report = datalog[i].toString();
      textSize(50);
      text(report, 12, (200 + (lastdatacount * 40)));
      lastdatacount++;
      delay(500);
      //println("in usersessioncount " + report);
    }
  }
}

//returns the unique UserId based on a single questions id
int GetUserId(int input) {
  int methodinput = input;
  int returnvalue = datalog[(input-1)].id;
  return(returnvalue);
}


void  DrawLastUserDataItinerary() {
  //draw the last user data itinerary
  image(img, 0, 0);

  stroke(200, 200, 200);
  strokeWeight(1);
  textFont(mono);
  textSize(upperscreentextsize);
  fill(240, 240, 240);
  //text("Güzergahlar Çiziliyor", 12, firsttextlineheight);
  text("Draw Mode: Last Complete User Itinerary", 12, firsttextlineheight);
  color c;
  c = color(255, 0, 0);

  try {
    DrawItinerary(itineraries[(itinerariescount - 1)], c, "Last User Itinerary Point");
    println("draw last user itinerary");
  }
  catch (NullPointerException e) {
  }
}

void DrawAIItineraries() {
  image(img, 0, 0);

  stroke(200, 200, 200);
  strokeWeight(1);
  textFont(mono);
  textSize(upperscreentextsize);
  fill(240, 240, 240);
  text("Güzergahlar Çiziliyor", 12, secondtextlineheight);
  text("Draw Mode: Artificial Intelligence Itineraries", 12, firsttextlineheight);

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
  textSize(upperscreentextsize);
  fill(240, 240, 240);
  text("Draw Mode: User Itineraries, City Center", 12, firsttextlineheight);

  for (int i = 0; i < printtoscreencounter; i++) {
    //for(int i = 0; i < itineraries.length; i++){
    try {
      if (i == itinerariescount) {
        color c1;
        c1 = color(255, 0, 0);
        //DrawCCItinerary(itineraries[i], c1, str(i));
      } else {
        DrawCCItinerary(itineraries[i], 1, 5, ((255/itinerariescount) * i), str(i));
      }
      //DrawCCItinerary(itineraries[i], 1, 5, ((255/itinerariescount) * i), str(i));
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
  textSize(upperscreentextsize);
  fill(240, 240, 240);
  text("Draw Mode: Artificial Intelligence Itineraries, City Center", 12, firsttextlineheight);

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
  textSize(upperscreentextsize);
  fill(240, 240, 240);
  text("Draw Mode 1: Itinerary", 12, firsttextlineheight);


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



void  ListRecentDataPoints() {
  image(img, 0, 0);
  stroke(200, 200, 200);
  strokeWeight(1);
  textFont(mono);
  textSize(upperscreentextsize);
  fill(240, 240, 240);
  text("Draw Mode: List Recent Data", 12, firsttextlineheight);
  fill(200, 200, 200);

  /*
  //for (int i = featurecount; i > 5; i--) {
   for (int i = 1; i < featurecount; i++) {
   try {
   //text("Feature Input Found. Feature Name: "+features[i].name, 200, (70 + (17 * i)));
   text("Feature Input Found. Feature Name: "+features[(featurecount - i)].name, 200, (70 + (20 * i)));
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
        text("Feature Input Found. Feature Name: "+features[(featurecount - i)].name, 200, (100 + (25 * i)));
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
  stroke(200, 200, 200);
  strokeWeight(1);
  textFont(mono);
  textSize(upperscreentextsize);
  fill(240, 240, 240);
  text("Draw Mode 4: Show All DataPoints", 12, firsttextlineheight);


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

  stroke(200, 200, 200);
  strokeWeight(1);
  textFont(mono);
  textSize(upperscreentextsize);
  fill(240, 240, 240);
  text("Draw Mode 4: Show All DataPoints: Nostalgia", 12, firsttextlineheight);

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


//when the state is set to show the IDs, the draw method will call this routine to run
void DrawNostalgiaSelects() {
  image(img, 0, 0);

  stroke(200, 200, 200);
  strokeWeight(1);
  textFont(mono);
  textSize(upperscreentextsize);
  fill(240, 240, 240);
  text("Draw Mode 4: Show Select DataPoints: Nostalgia", 12, firsttextlineheight);

  textFont(bold);
  fill(colorNostalgia);
  textSize(50);
  text("Nostalgia Selects", 12, 200);

  //pick a random number of 5

  //for(int i = 0; i < datalog.length; i++){
  for (int i = 0; i < printtoscreencounter; i++) {
    try {
      float[] temp = new float[2];
      if (datalog[i].Lat != null) {
        temp[0] = float(datalog[i].Lat);
        if (datalog[i].Lon != null) {
          temp[1] = float(datalog[i].Lon);
          if (datalog[i].qindex == 1004) {
            //DrawMapPoint(temp, 10, colorNostalgia, "Unique User ID #"+datalog[i].id);
            String text = datalog[(i+1)].answer;
            DrawMapPoint(temp, 10, colorNostalgia, "Unique User ID #"+text);
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

  stroke(200, 200, 200);
  strokeWeight(1);
  textFont(mono);
  textSize(upperscreentextsize);
  fill(240, 240, 240);
  text("Draw Mode: Wishbox", 12, firsttextlineheight);

  fill(152, 0, 0);
  textSize(50);
  text("Wishbox", 12, 200);

  int wishboxselector = int(random(wishboxcount));

  WishboxFeature wish = wishlog[wishboxselector];
  float[] temp = new float[2];
  temp[0] = wish.lat;
  temp[1] = wish.lon;

  try {
    DrawMapPoint(temp, 10, 255, 255, 255, wish.name);
    textSize(100);
    text(wish.name, 12, 300);
  } 
  catch (NullPointerException e) {
    println("exception called during Wishbox drawing routine");
  }

  delay(1200);
}

void ReportLostBuilding() {
  image(img, 0, 0);

  stroke(200, 200, 200);
  strokeWeight(1);
  textFont(mono);
  textSize(upperscreentextsize);
  fill(240, 240, 240);
  text("Draw Mode: Reporting Nostalgia: LostBuildings", 12, firsttextlineheight);
  textSize(30);

  
  textFont(bold);
  fill(colorNostalgia);
  textSize(20);
  //text("Nostalgia Selects", 12, 200);
    String[] lines = loadStrings("list.txt");
  for (int i = 0 ; i < lines.length; i++) {
    text(lines[i], 12, 200 + (15 * i));
  }
  
  //load images

  float[] coordinates = new float[2];

  PImage AKMimage;
  AKMimage = loadImage("AKM.jpeg");
    AKMimage.resize(0, 50);
  coordinates[0] = 41.036594;
  coordinates[1] = 28.987806;
  PlaceImage(coordinates, AKMimage, "AKM");
  
  PImage HAYDARimage;
  HAYDARimage = loadImage("HAYDAR.jpg");
    HAYDARimage.resize(0, 50);
  coordinates[0] = 40.996772;
  coordinates[1] = 29.019191;
  PlaceImage(coordinates, HAYDARimage, "HAYDAR");
  
  PImage STADIUMimage;
  STADIUMimage = loadImage("STADIUM.jpg");
  STADIUMimage.resize(0, 50);
  coordinates[0] = 41.036594;
  coordinates[1] = 28.987806;
  PlaceImage(coordinates, STADIUMimage, "STADIUM");
  
  PImage TAKSIMimage;
  TAKSIMimage = loadImage("TAKSIM.jpg");
    TAKSIMimage.resize(0, 50);
  coordinates[0] = 41.035683;
  coordinates[1] = 28.981194;
  PlaceImage(coordinates, TAKSIMimage, "TAKSIM");
  
    PImage CINEMAimage;
  CINEMAimage = loadImage("CINEMA.jpg");
    CINEMAimage.resize(0, 50);
  coordinates[0] = 41.034973;
  coordinates[1] = 28.979594;
  PlaceImage(coordinates, CINEMAimage, "CINEMA");
  
      PImage HAGIASOFIAimage;
  HAGIASOFIAimage = loadImage("HAGIASOFIA.jpg");
    HAGIASOFIAimage.resize(0, 50);
  coordinates[0] = 41.008425;
  coordinates[1] = 28.980368;
  PlaceImage(coordinates, HAGIASOFIAimage, "HAGIA SOFIA");





}

void ReportLostBuildingCC() {
  image(imgCC, 0, 0);

  stroke(200, 200, 200);
  strokeWeight(1);
  textFont(mono);
  textSize(upperscreentextsize);
  fill(240, 240, 240);
  text("Draw Mode: Reporting Nostalgia: LostBuildings City Center", 12, firsttextlineheight);
  textSize(30);

  
  textFont(bold);
  fill(colorNostalgia);
  textSize(20);
  //text("Nostalgia Selects", 12, 200);
    String[] lines = loadStrings("list.txt");
  for (int i = 0 ; i < lines.length; i++) {
    text(lines[i], 12, 200 + (15 * i));
  }
  
  //load images

  float[] coordinates = new float[2];

  PImage AKMimage;
  AKMimage = loadImage("AKM.jpeg");
    AKMimage.resize(0, 50);
  coordinates[0] = 41.036594;
  coordinates[1] = 28.987806;
  PlaceCCImage(coordinates, AKMimage, "AKM");
  
  PImage HAYDARimage;
  HAYDARimage = loadImage("HAYDAR.jpg");
    HAYDARimage.resize(0, 50);
  coordinates[0] = 40.996772;
  coordinates[1] = 29.019191;
  PlaceCCImage(coordinates, HAYDARimage, "HAYDAR");
  
  PImage STADIUMimage;
  STADIUMimage = loadImage("STADIUM.jpg");
  STADIUMimage.resize(0, 50);
  coordinates[0] = 41.036594;
  coordinates[1] = 28.987806;
  PlaceCCImage(coordinates, STADIUMimage, "STADIUM");
  
  PImage TAKSIMimage;
  TAKSIMimage = loadImage("TAKSIM.jpg");
    TAKSIMimage.resize(0, 50);
  coordinates[0] = 41.035683;
  coordinates[1] = 28.981194;
  PlaceCCImage(coordinates, TAKSIMimage, "TAKSIM");
  
    PImage CINEMAimage;
  CINEMAimage = loadImage("CINEMA.jpg");
    CINEMAimage.resize(0, 50);
  coordinates[0] = 41.034973;
  coordinates[1] = 28.979594;
  PlaceCCImage(coordinates, CINEMAimage, "CINEMA");
  
      PImage HAGIASOFIAimage;
  HAGIASOFIAimage = loadImage("HAGIASOFIA.jpg");
    HAGIASOFIAimage.resize(0, 50);
  coordinates[0] = 41.008425;
  coordinates[1] = 28.980368;
  PlaceCCImage(coordinates, HAGIASOFIAimage, "HAGIA SOFIA");
}

void DrawLostBuilding() {
  image(img, 0, 0);

  stroke(200, 200, 200);
  strokeWeight(1);
  textFont(mono);
  textSize(upperscreentextsize);
  fill(240, 240, 240);
  text("Draw Mode: LostBuilding", 12,firsttextlineheight);

  String[] searchterms = new String[2];
  SearchLostBuilding(searchterms);
  text(searchterms.length, 12, 100);
}


//when the state is set to show the IDs, the draw method will call this routine to run
void DrawCCIDs() {
  image(imgCC, 0, 0);
  stroke(200, 200, 200);
  strokeWeight(1);
  textFont(mono);
  textSize(upperscreentextsize);
  fill(240, 240, 240);
  text("Draw Mode 4: Show All DataPoints, CityCenter", 12, firsttextlineheight);

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
  stroke(200, 200, 200);
  strokeWeight(1);
  textFont(mono);
  textSize(upperscreentextsize);
  fill(240, 240, 240); //<>//
  text("Draw Mode: Place Image based on Feature Name", 12, firsttextlineheight);

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
  stroke(200, 200, 200);
  strokeWeight(1);
  textFont(mono);
  textSize(upperscreentextsize);
  fill(240, 240, 240);
  text("Draw Mode: Place Image based on Feature Name", 12, firsttextlineheight);
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
  textSize(upperscreentextsize);
  fill(240, 240, 240);
  text("Draw Mode: User Session Grid Data", 12, firsttextlineheight);

  textSize(30);
  fill(120, 120, 120);
  text("GRIDDING DATABASE ENTRIES", 12, 700);
  textSize(20);

  int h = datalog.length;
  int count = 0;
  //number of entries before line break
  int linebreak = 30;

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
      rect(((screenwidth/(h/linebreak))*i), ((screenheight/15)+(y*60)), ((screenwidth/(h/linebreak))-5), 20);
      //write the node id number underneath the rectangle
      textSize(10);
      fill(222, 222, 222);
      //rotate(PI/2);
      text(count, ((screenwidth/(h/linebreak))*i), (((screenheight/15)+(y*60))-3));
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
  textSize(upperscreentextsize);
  fill(240, 240, 240);
  text("Draw Mode: Map All Nodes", 12, firsttextlineheight);

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

  stroke(200, 200, 200);
  strokeWeight(1);
  textFont(mono);
  textSize(upperscreentextsize);
  fill(240, 240, 240);
  text("Draw Mode 7: Show AI Data", 12, firsttextlineheight);
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
  textSize(upperscreentextsize);
  fill(240, 240, 240);
  text("Print Text To Screen", 12, firsttextlineheight);

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
  textSize(upperscreentextsize);
  fill(240, 240, 240);
  text("Print Text To Screen", 12, firsttextlineheight);

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



  stroke(200, 200, 200);
  strokeWeight(1);
  textFont(mono);
  textSize(upperscreentextsize);
  fill(240, 240, 240);
  text("Draw Mode 5: Show All DataPoints", 12, firsttextlineheight);

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

  stroke(200, 200, 200);
  strokeWeight(1);
  textFont(mono);
  textSize(upperscreentextsize);
  fill(240, 240, 240);
  text("Draw Mode 2: Database Viz", 12, firsttextlineheight);
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
