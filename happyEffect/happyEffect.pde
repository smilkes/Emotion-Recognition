//import java.util.Map;
PImage img;
JSONObject json;

//HashMap<String,Integer> hm = new HashMap<String,Integer>();

//hm.put("VERY_UNLIKELY", 0);
//hm.put("UNLIKELY", 1);
//hm.put("POSSIBLE", 2);
//hm.put("LIKELY", 3);
//hm.put("VERY_UNLIKELY", 4);
int id;
String joy;
String anger;
String surprise;
String sorrow;

void setup() {
  img = loadImage("01.jpg");
  json = loadJSONObject("01.json");
  size(600,1200);
  //img.resize(width,height);
  
  id = json.getInt("id");
  joy = json.getString("joy");
  anger = json.getString("anger");
  surprise = json.getString("surprise");
  sorrow = json.getString("sorrow");
  
}

void draw() {
  //background(0);
  //image(img,0,0);
  happy();
  puText();
}

void happy() {
     for (int i = 0; i<20; i++){
    float x = random(width);
    float y = random(height);
    color c = img.get(int(x),int(y));
    noStroke();
    fill(c,int(random(5,255)));
    ellipse(x,y,int(random(5,100)),int(random(5,90)));
  } 
}

void puText() {
  textSize(50);
  fill(0,0,0);
  text("joy " + joy, 50,200);
  text("anger "+ anger, 50, 300);
  text("surprise "+surprise, 50, 400);
  text("sorrow " +sorrow, 50, 500);
}
