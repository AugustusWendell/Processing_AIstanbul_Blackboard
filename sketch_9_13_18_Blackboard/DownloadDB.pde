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
