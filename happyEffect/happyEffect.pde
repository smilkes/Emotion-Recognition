//anger inspired by ryoho https://openprocessing.org/sketch/1084140
//sorrow inspired by the coding train pixel manipulation

PImage img;
JSONObject json;

int id, joy, anger, surprise, sorrow;

//String[] emotion_list = {};
//int[] emotion_likelihood = {};

//array list and variables for anger particle system
ArrayList<Particle> particles;
float attforce, repforce;
int numParticle= 5000;

//array list and variables for the joy particle system
ArrayList<Particle_2> particles_2;
float xoff,yoff,zoff,inc,col;
int spread, cols, rows, num;
PVector[] vectors;



void setup() {
  strokeWeight(int(random(2,20)));
  background(0);
  img = loadImage("01.jpg");
  json = loadJSONObject("01.json");
  size(600,1200);
  //img.resize(width,height);
  
  //grabbing the values of emotions this is what you use to modify the functions
  id = json.getInt("id");
  joy = json.getInt("joy");
  anger = json.getInt("anger");
  surprise = json.getInt("surprise");
  sorrow = json.getInt("sorrow");
  
  //modifyers of anger
  repforce = anger*2;
  attforce = anger*0.2;
  
  //anger particle system make a condition here for only if anger is >1
  particles = new ArrayList<Particle>();
  for (int i= 0; i< numParticle; i++) {
    particles.add(new Particle(random(width), random(height),int(random(width)), int(random(height))));
  }
  
  //surprise particle system make condiition here for surprise >1
  if (joy >=1) {
    init_joy();
  }
}

void draw() {
  //background(0);
  //image(img,0,0);
    if (surprise >=1) {
    surprise();
  }
  if (sorrow>=1){
    sorrow();
    filter(GRAY);
  }
  
  if (anger>=1){
      anger();
      filter(POSTERIZE,8);
      //filter(GRAY);
  }
  if (joy >= 1) {
    joy();
  }
  

  noStroke();

  puText(); 
}

// ANGER __________________________________________________


void anger(){
    if (millis() < 2000){
      image(img,0,0);
    }
    //else{
    //  fill(0,20);  
    //  rect(0,0,width,height);
    //}
    
    for (int i = 0; i <particles.size(); i++){
    Particle p = particles.get(i);
    p.move();
    p.display();
    
  }
}

//particle class for anger function
class Particle {
  PVector position, target, velocity, acceleration;
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
    velocity.mult(10);
    velocity.add(acceleration);
    velocity.limit(3);
    position.add(velocity);
  }
  void display() {
    stroke(color_joy, 90);
    point(position.x,position.y);
  }
    
}

// SORROW  ----------------------------------------------------------

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


//JOY -----------------------------------------------

//function to initiate joy in setup
void init_joy(){
  spread = joy;
  inc = random(0.1,0.8);
  num = 5000;
  col = random(255);
  cols = floor(width/spread)+1;
  rows = floor(height/spread) +1;
  vectors = new PVector[cols*rows];
  particles_2 = new ArrayList<Particle_2>();
  
  for (int j = 0; j < num;  j++){
    particles_2.add(new Particle_2());
  }
}

//function to call joy in draw
void joy(){
  
  //adding conditional to show picture immediately before the effect is applied
  if (millis() < 2000){
    image(img,0,0);
  }
  else{
    fill(255,20);  
    rect(0,0,width,height);
  }
  //filter(INVERT);
  //filter(THRESHOLD);
  //filter(POSTERIZE,3);
  filter(DILATE);
  //fill(1, 190, 254,20);

  xoff = 0;
  for (int y = 0; y <rows; y++){
    xoff = 0;
    for (int x= 0; x< cols; x++){
      float angle = noise(xoff,yoff, zoff) * PI *(joy/2)+1;
      PVector v = PVector.fromAngle(angle);
      v.setMag(1);
      vectors[x + y * cols] = v;
      xoff += inc;
    }
    yoff += inc;
  }
  zoff += 0.0005;
  if (col <255)col += 0.5;
  else col= 0 ;
  for (Particle_2 p2 : particles_2)p2.run();
}


//particle class for joy
class Particle_2{
  PVector pos, vel, acc, prev;
  float max = random(2,8);
  
  Particle_2() {
    pos = new PVector(width/3, height/2);
    prev = new PVector(pos.x, pos.y);
    vel = new PVector(0,0);
    acc = new PVector(0,0);
  }
  
  void copy() {
    prev.x = pos.x;
    prev.y = pos.y;
  }
  
  void run() {
    follow();
    update();
    show();
  }
  
  void update() {
    pos.add(vel);
    vel.limit(max);
    vel.add(acc);
    acc.mult(0);
    if (pos.x > width) {
      pos.x = 0;
      copy();
    }
    if (pos.x < 0) {
      pos.x = width;
      copy();
    }
    if (pos.y > height) {
      pos.y = 0;
      copy();
    }
    if (pos.y < 0) {
      pos.y = height;
      copy();
    }
  }
    void follow() {
      int x = floor(pos.x / spread);
      int y = floor(pos.y / spread);
      PVector force = vectors[x+y*cols];
      acc.add(force);
    }
    void show(){
      color c = img.get(int(pos.x), int(pos.y));
      stroke(c);
      line(pos.x,pos.y,prev.x, prev.y);
      copy();
    }
  }


// SURPRISE  filler code to change -------------------------------------
      
void surprise() {
  image(img,0,0);
  if (millis()/1000%2==0){
    filter(INVERT);
  }
  else  {
    filter(POSTERIZE,3);
  }
  //filter(THRESHOLD);
}


//TEXT -----------------------------------------------------
//test text function
void puText() {
  textSize(50);
  fill(0,0,0);
  text("joy " + str(joy), 50,200);
  text("anger "+ str(anger), 50, 300);
  text("surprise "+str(surprise), 50, 400);
  text("sorrow " +str(sorrow), 50, 500);
}

    
