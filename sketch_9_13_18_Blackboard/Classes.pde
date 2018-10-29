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

//Object to store a Nostalgia Feature
class NostalgiaFeature
{
  public float lat;
  public float lon;
  public String name;

  NostalgiaFeature(String featureName, Float featureLat, Float featureLon) {
    name = featureName;
    lat = featureLat;
    lon = featureLon;
  }

  public String toString ()
  {
    //return String.format("id: %i, question: %s answer: %s", id, question, answer);
    String r = "NostalgiaFeature name " + name + " " + "lat " + lat+ " " + "lon " + lon;
    return r;
  }
}

//Object to store a Wishbox Feature
class WishboxFeature
{
  public float lat;
  public float lon;
  public String name;

  WishboxFeature(Float featureLat, Float featureLon, String wish) {
    name = wish;
    lat = featureLat;
    lon = featureLon;
  }

  public String toString ()
  {
    //return String.format("id: %i, question: %s answer: %s", id, question, answer);
    String r = "WishboxFeature name " + name + " " + "lat " + lat+ " " + "lon " + lon;
    return r;
  }
}

//Object to store a LostBuilding Feature
class LostBuildingFeature
{
  public float lat;
  public float lon;
  public String name;

  LostBuildingFeature(Float featureLat, Float featureLon, String featureName) {
    name = featureName;
    lat = featureLat;
    lon = featureLon;
  }

  public String toString ()
  {
    //return String.format("id: %i, question: %s answer: %s", id, question, answer);
    String r = "LostBuilding name " + name + " " + "lat " + lat+ " " + "lon " + lon;
    return r;
  }
}
