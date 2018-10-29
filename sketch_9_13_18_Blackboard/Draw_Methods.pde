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
  DrawMapPoint(i.point3, 5, c, s);
  DrawMapPoint(i.point4, 5, c, s);

  //DrawMapLine(i.point1, i.point2, 5);
  //DrawMapLine(i.point2, i.point3, 5);
  //DrawMapLine(i.point3, i.point4, 5);

  DrawMapLine(i.point1, i.point2, 2, c);
  DrawMapLine(i.point2, i.point3, 2, c);
  DrawMapLine(i.point3, i.point4, 2, c);
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

void DrawMapLine(float[] a, float[] b, int weight, color c) {
  //using convert methods to simplify the code
  float drawlat1 = ConvertLat(a[0]);
  float drawlong1 = ConvertLong(a[1]);

  //using convert methods to simplify the code
  float drawlat2 = ConvertLat(b[0]);
  float drawlong2 = ConvertLong(b[1]);

  fill(c);
  stroke(c);
  strokeWeight(weight);
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
  strokeWeight(weight);
  line(drawlong1, drawlat1, drawlong2, drawlat2);
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
