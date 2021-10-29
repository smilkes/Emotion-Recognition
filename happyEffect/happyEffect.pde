//anger inspired by ryoho https://openprocessing.org/sketch/1084140
//sorrow inspired by the coding train pixel manipulation


PImage img;
JSONObject json;

float attforce;
float repforce;

int numParticle= 5000;

int id;
int joy;
int anger;
int surprise;
int sorrow;

//String[] emotion_list = {};
//int[] emotion_likelihood = {};


//array list for anger particle system
ArrayList<Particle> particles;

void setup() {
  strokeWeight(int(random(2,20)));
  background(0);
  img = loadImage("01.jpg");
  json = loadJSONObject("01.json");
  size(600,1200);
  //img.resize(width,height);
  
  id = json.getInt("id");
  joy = json.getInt("joy");
  anger = json.getInt("anger");
  surprise = json.getInt("surprise");
  sorrow = json.getInt("sorrow");
  
  //modifyers of anger
  repforce = anger*2;
  attforce = anger*0.2;
  
  //anger particle system
  particles = new ArrayList<Particle>();
  for (int i= 0; i< numParticle; i++) {
    particles.add(new Particle(random(width), random(height),int(random(width)), int(random(height))));
  }
    
}

void draw() {
  //background(0);
  //image(img,0,0);
  sorrow();
  if (anger>=1){
      anger();
  }

  noStroke();

  puText();

  
}

void anger(){
    for (int i = 0; i <particles.size(); i++){
    Particle p = particles.get(i);
    p.move();
    p.display();
    
  }
}

//sorrow function just picks colors and draws ellipses randomly 
void sorrow() {
     for (int i = 0; i<500; i++){
      float x = random(width);
      float y = random(height);
      color c = img.get(int(x),int(y));
      noStroke();
      float value = sorrow*30;
      fill(c,value);
      ellipse(x,y,int(random(5,sorrow*7)),int(random(5,sorrow*10)));
      //ellipse(x,y,15,15);
  } 
}

//test text function
void puText() {
  textSize(50);
  fill(0,0,0);
  text("joy " + str(joy), 50,200);
  text("anger "+ str(anger), 50, 300);
  text("surprise "+str(surprise), 50, 400);
  text("sorrow " +str(sorrow), 50, 500);
}

//particle class for surprise function
class Particle {
  PVector position;
  PVector target;
  PVector velocity;
  PVector acceleration;
  color color_joy;
  int x_move;
  int y_move;
  
  
  Particle(float x, float y, int x_m, int y_m){
    x_move = x_m;
    y_move = y_m;
    
    position = new PVector(x,y);
    target = position.copy();
    velocity = new PVector(0,0);
    acceleration = new PVector(0,0);
    color_joy =img.get(int(x),int(y));   
  }
  
  void move() {
    PVector attraction = target.sub(position);
    attraction.mult(attforce);
    PVector mouse_pos = new PVector(x_move, y_move);
    PVector tmpForce =  mouse_pos.sub(position);
    tmpForce.limit(20);
    PVector repulsion = tmpForce.copy().normalize().mult(-30).sub(tmpForce);
    repulsion.mult(repforce);
    
    acceleration = attraction.add(repulsion);
    velocity.mult(3);
    velocity.add(acceleration);
    velocity.limit(3);
    position.add(velocity);
  }
  void display() {
    stroke(color_joy, 90);
    point(position.x,position.y);
  }
    
}
