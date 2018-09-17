import de.bezier.data.sql.*;

MySQL db;

void setup() {
  
  size(1500, 738);
  background(0);
  //UserSession[] datalog = new UserSession[100];
  
DownloadDB();

}

void DownloadDB(){
      //DB setup - must be on an NJIT IP??
    //db = new MySQL( this, "sql3.njit.edu:3306", "aistan_rsrch", "aistan_rsrch", "J8mDan3y" );  // open database file
    //db = new MySQL( this, "sql2.njit.edu:3306", "wendell", "wendell", "voFt89Bx0" );  // open database file
    db = new MySQL( this, "augustuswendell.net:3306", "AIQuestionsMain", "augustuswendell", "@Rtist999" );  // open database file
    //db.setDebug(false);
    db.setDebug(true);
    
        if ( db.connect() )
    {
        /*
        String[] tableNames = db.getTableNames();
        println(tableNames);
        db.query("SELECT COUNT(*) FROM AIQuestionsMain");
        db.next();
        println( "number of rows: " + db.getInt(1) );
        */
        
        /*
        db.query("SELECT * FROM AIQuestionsMain");
        while (db.next())
        {
            String s = db.getString("name");
            int n = db.getInt("fuid");
            println(s + "   " + n);
        }
        */
        String[] tableNames = db.getTableNames();
        String[] columnNames;
        println(tableNames);
        db.query( "SELECT * FROM %s", tableNames[1] );
        
        while (db.next())
        {
            //columnNames = db.getColumnNames();
            //println(columnNames);
            int y = 0;
            y = db.getInt("ID");
            int x = 0;
            x = db.getInt("qindex");
            String b = db.getString("question");
            String c = db.getString("Category");
            String d = db.getString("Type");
            String e = db.getString("FeatureType");
            String f = db.getString("FeatureName");
            String g = db.getString("Lat");
            String h = db.getString("Long");
            String i = db.getString("answer");
            println( y + " " + x +  " " + b +  " " + c +  " " + d +  " " + e +  " " + f +  " " + g +  " " + h +  " " + i );
            
            //make a new object and put the data into it
            //datalog[y] = UserSession(y, b, i);
        }
    }
}

//ID qindex datetime question Category Type FeatureType FeatureName Lat Long answer


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
    String Long;
    String answer;
    
    void UserSession(int a, String b, String c) {
      id = a;
      question = b;
      answer = c;
    }

    
   /*
   public String toString ()
    {
        //return String.format("id: %d, fieldOne: %s fieldTwo: %d", id, fieldOne, fieldTwo);
    }
    */
    
    public void setId ( int id ) {
        this.id = id;
    }
    
    public int getId () {
        return id;
    }
}
