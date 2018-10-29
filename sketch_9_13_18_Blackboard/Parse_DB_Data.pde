

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
        if ((datalog[i].qindex == 2001) || (datalog[i].qindex == 3002)) {
          temp2[0] = float(datalog[i].Lat);
          temp2[1] = float(datalog[i].Lon);
          //println("building itinerary point 3");
        } else {
          if ((datalog[i].qindex == 2007) || (datalog[i].qindex == 3007)) {
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


void FindWishbox() {
  float[] temp = new float[2];
  String wish = null;
  int r = 0;

  for (int i = 1; i < usersessioncount; i++) {
    if (datalog[i].qindex == 1000) {
      temp[0] = float(datalog[i].Lat);
      temp[1] = float(datalog[i].Lon);
    } else {
      if (datalog[i].qindex == 4000) {
        wish = datalog[i].answer;

        JSONObject json = new JSONObject();

        json.setFloat("lat1", temp[0]);
        json.setFloat("lon1", temp[1]);
        json.setString("wish", wish);

        //println("writing out wish JSON file = " + temp[0] + " " + temp[1] + " " + wish);

        saveJSONObject(json, "data/AIstanbul_Wishbox_"+r+".json");
        //println("saved json itinerary");
        wishboxcount = r;

        r++;
      }
      //println("wishboxcount = "+wishboxcount);
    }
  }
}

//search for Markov Chain Underlying Data
//for instance where do you spend the day = 1002
//1003 where
//2000 = meal
//2001 = where
//3000 = what activity
//3004 = with whom
//3005 = talk about
//3006 = what after
void FindMarkovData(int qid1, int qid2) {
  
  String qid1answer;
  String qid2answer;

  for (int i = 1; i < usersessioncount; i++) {
    if (datalog[i].qindex == qid1) {
      qid1answer = datalog[i].answer;
    } else {
      if (datalog[i].qindex == qid2) {
      qid1answer = datalog[i].answer;
      }
    }
  }
}

void FindHome(){
  //initialize the final single JSON to hold all data  
  JSONObject json = new JSONObject();
          
    for (int i = 1; i < usersessioncount; i++) {
    if (datalog[i].qindex == 1000) {
      temp[0] = float(datalog[i].Lat);
      temp[1] = float(datalog[i].Lon);
    } else {
      
      }
    }
    //then do this after the for loop has executed



        json.setFloat("lat", temp[0]);
        json.setFloat("lon", temp[1]);
        json.setString("name", buildingname);

        saveJSONObject(json, "data/AIstanbul_LostBuilding_"+r+".json");

  }
}

void ImportWishBox() {

  wishlog = new WishboxFeature[wishboxcount];
  //println("wishbox count = " + wishboxcount);

  //write datalog[r] to a local JSON file
  //Processing.data.JSONObject
  JSONObject json = new JSONObject();
  for (int i = 0; i < wishboxcount; i++) {

    json = loadJSONObject("data/AIstanbul_Wishbox_"+i+".json");

    Float Lat = json.getFloat("lat1");
    Float Lon = json.getFloat("lon1");
    String wish = json.getString("wish");
    //println("building wish log, feature number " + i + " " + Lat + " " + Lon + " " + wish);

    wishlog[i] = new WishboxFeature(Lat, Lon, wish);
  }
}

void FindLostBuilding() {
  float[] temp = new float[2];
  String buildingname = null;
  int r = 0;

  for (int i = 1; i < usersessioncount; i++) {
    if (datalog[i].qindex == 1004) {
      temp[0] = float(datalog[i].Lat);
      temp[1] = float(datalog[i].Lon);
    } else {
      if (datalog[i].qindex == 1005) {
        buildingname = datalog[i].answer;

        JSONObject json = new JSONObject();

        json.setFloat("lat", temp[0]);
        json.setFloat("lon", temp[1]);
        json.setString("name", buildingname);

        //println("writing out wish JSON file = " + temp[0] + " " + temp[1] + " " + wish);

        saveJSONObject(json, "data/AIstanbul_LostBuilding_"+r+".json");
        //println("saved json itinerary");
        lostbuildingcount = r;

        r++;
      }
      //println("lostbuildingcount = "+lostbuildingcount);
    }
  }
}

void ImportLostBuilding() {

  lostbuildinglog = new LostBuildingFeature[lostbuildingcount];

  JSONObject json = new JSONObject();
  for (int i = 0; i < lostbuildingcount; i++) {

    json = loadJSONObject("data/AIstanbul_LostBuilding_"+i+".json");

    Float Lat = json.getFloat("lat");
    Float Lon = json.getFloat("lon");
    String wish = json.getString("name");
    //println("building wish log, feature number " + i + " " + Lat + " " + Lon + " " + wish);

    lostbuildinglog[i] = new LostBuildingFeature(Lat, Lon, wish);
  }
}

LostBuildingFeature[] SearchLostBuilding(String[] searchterms) {

  println("searching lost buildings");

  //find and return all LostBuildingFeature objects that share the search terms
  LostBuildingFeature[] selects = new LostBuildingFeature[50];
  int selectscount = 0;

  for (int i = 0; i < lostbuildingcount; i++) {
    String term = lostbuildinglog[i].name;
    println(term);
    if (term.equals("AKM")) {
      selects[selectscount] = lostbuildinglog[i];
      selectscount++;
      //println("found a match");
    } else {
    }
  }
  return(selects);
}

void FindNostalgia() {
}

void FindTravel() {
}
