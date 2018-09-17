import de.bezier.data.sql.*;

MySQL db;
UserSession[] datalog;

void setup() {
  
  size(1500, 738);
  background(0);
  datalog = new UserSession[100];
  
DownloadDB();

}

void DownloadDB(){
  
  
      //DB setup - must be on an NJIT IP??
    //db = new MySQL( this, "sql3.njit.edu:3306", "aistan_rsrch", "aistan_rsrch", "J8mDan3y" );  // open database file
    //db = new MySQL( this, "sql2.njit.edu:3306", "wendell", "wendell", "voFt89Bx0" );  // open database file
    //db = new MySQL( this, "augustuswendell.net:3306", "augustuswendell", "aistanbul", "=OFA*qUuAU3Y" );  // open database file
    //db = new MySQL( this, "107.180.41.145", "augustuswendell", "aistanbul", "=OFA*qUuAU3Y" );  // open database file
    //db = new MySQL( this, "107.180.41.145", "augustuswendell", "augustuswendell_augustuswendell", "augustuswendell_@Rtist999" );  // open database file
    //db.setDebug(false);
    db = new MySQL( this, "107.180.41.145", "IstanbulQuestions", "aistanbul", "=OFA*qUuAU3Y" );  // open database file
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
        
        
        db.query("INSERT INTO Answers (qindex, question, Category, Type, FeatureType, FeatureName, Lat, Lon) VALUES (3, 'Where do you live?', 'Biraz kendinizden bahseder misiniz? / Tell me a little bit about yourself.', 'map', 'NULL', 'NULL', '41.04', '28.65')");
        //db.query("INSERT INTO Answers (qindex, question, Category, Type) VALUES (3, 'Where do you live?', 'Biraz kendinizden bahseder misiniz? / Tell me a little bit about yourself.', 'map')");

         //db.query("SELECT COUNT(*) FROM Answers");
        db.query("SELECT * FROM Answers");
        //db.next();
        int r = 0;
        
        while (db.next())
        {
            //columnNames = db.getColumnNames();
            //println(columnNames);
            int y = 0;
            y = db.getInt("ID");
            int x = 0;
            x = db.getInt("qindex");
            int z = 0;
            z = db.getInt("datetime");
            String b = db.getString("question");
            String c = db.getString("Category");
            String d = db.getString("Type");
            String e = db.getString("FeatureType");
            String f = db.getString("FeatureName");
            String g = db.getString("Lat");
            String h = db.getString("Lon");
            String i = db.getString("answer");
            println( y + " " + x +  " " + z + " " + b +  " " + c +  " " + d +  " " + e +  " " + f +  " " + g +  " " + h +  " " + i );
            
            //make a new object and put the data into it
            datalog[r] = new UserSession(y, x, z, b, c, d, e, f, g, h, i);
            
            //write datalog[r] to a local JSON file
            JSONObject json;

            json = new JSONObject();

            json.setInt("id", y);
            json.setInt("qindex", x);
            json.setInt("datetime", z);
            json.setString("question", "b");
            json.setString("Category", "c");
            json.setString("Type", "d");
            json.setString("FeatureType", "e");
            json.setString("FeatureName", "f");
            json.setString("Lat", "g");
            json.setString("Lon", "h");
            json.setString("answer", "i");
            

            saveJSONObject(json, "data/AIstanbul_id_"+y+".json");
            
            //increment counter
            r++;
        }
        
    }
}

//Object to store each user session. These can be loaded into some container and then queried offline in case database connection is lost.
class UserSession
{
    int id;
    int qindex;
    int datetime;
    public String question;
    public String Category;
    String Type;
    String FeatureType;
    String FeatureName;
    String Lat;
    String Lon;
    String answer;
    
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
    }
}
