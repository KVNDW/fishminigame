import ddf.minim.*;

// global variables
final static float MOVE_SPEED = 5;
final static float GAME_OBJECT_SCALE = 50.0/100;
final static float GAME_OBJECT_SIZE = 50;
final static float GRAVITY = 0.1;

final static float RIGHT_MARGIN = 400;
final static float LEFT_MARGIN = 60;
final static float VERTICAL_MARGIN = 40;

final static int NEUTRAL_FACING = 0;
final static int RIGHT_FACING = 1;
final static int LEFT_FACING = 2;

final static float WIDTH = GAME_OBJECT_SIZE*16;
final static float HEIGHT = GAME_OBJECT_SIZE*12;
final static float GROUNDLEVEL = HEIGHT - GAME_OBJECT_SIZE;

float view_x =0;
float view_y =0;

// sound
Minim m;
AudioPlayer music, s1, s2, s3, s4, s5;


Player player;
PImage sand, sand_bottom, seegrass, sky, coral, jellyfish, snack, cat, p;
ArrayList<GameObject> gameObjects;
ArrayList<GameObject> snacks;
int score;
boolean isGameOver;


ArrayList<GameObject> enemies;



void setup() {
  size(800, 600);
  imageMode(CENTER);
  
  isGameOver = false;
  
  // player
  p = loadImage("fish_jump_left.png");
  player = new Player(p, 0.5);
  player.setBottom(GROUNDLEVEL);
  player.center_x =100;
  
  player.change_x = 0;
  player.change_y = 0;
  
  // landscape
  gameObjects = new ArrayList<GameObject>();
  
  sand = loadImage("sand.png");
  sand_bottom = loadImage("sand_bottom.png");
  seegrass = loadImage("seegrass.png");
  sky = loadImage("sky.png");
  coral = loadImage("coral.png");
  jellyfish = loadImage("jellyfish.png");
  
  //snacks
  snacks = new ArrayList<GameObject>();
  snack = loadImage("snack1.png");
  score = 0;
  
  // sound
  m = new Minim(this);
  music = m.loadFile("under_the_sea.mp3", 1024);
  s1 = m.loadFile("bite.mp3", 1024);
  s2 = m.loadFile("meow.mp3", 1024);
  s3 = m.loadFile("loose_life.mp3", 1024);
  s4 = m.loadFile("lose.mp3", 1024);
  s5 = m.loadFile("win.mp3", 1024);
  
  // music.setVolume(0.005);
  // music.loop( );
  
  
  //enemy
  enemies = new ArrayList<GameObject>();
  cat = loadImage("cat_right1.png");
  
  createLandscape("map.csv");
}

void draw() {
  background(228, 247, 255);
  scroll();
  
  // display everything
  displayAll();
  
  // update objects
  if(!isGameOver){
    updateAll();
    collectSnacks();
    checkDeath();
  }

}

void scroll(){
  //left right
  float right_boundary = view_x + width - RIGHT_MARGIN;
  if (player.getRight()>right_boundary){
    view_x+= player.getRight() - right_boundary;
  }
  float left_boundary = view_x + LEFT_MARGIN;
  if (player.getLeft()<left_boundary){
    view_x-= left_boundary - player.getLeft();
  }
  //top bottom
  
  float bottom_boundary = view_y + height - VERTICAL_MARGIN;
  if (player.getBottom()>bottom_boundary){
    view_y+= player.getBottom() - bottom_boundary;
  }
  float top_boundary = view_y + VERTICAL_MARGIN;
  if (player.getTop()<top_boundary){
    view_y-= top_boundary - player.getTop();
  }
  translate(-view_x,-view_y);
}

void createLandscape(String filename) {
  String[] lines = loadStrings(filename);
  for(int row = 0; row < lines.length; row++) {
    String[] values = split(lines[row], ",");
    for(int col = 0; col < values.length; col++) {
      // if a in array add sand
      if(values[col].equals("a")) {
        GameObject o = new GameObject(sand, GAME_OBJECT_SCALE);
        o.center_x = GAME_OBJECT_SIZE/2 + col * GAME_OBJECT_SIZE;
        o.center_y = GAME_OBJECT_SIZE/2 + row * GAME_OBJECT_SIZE;
        gameObjects.add(o);
      }
      // if b in array add sand_bottom
      else if(values[col].equals("b")) {
        GameObject o = new GameObject(sand_bottom, GAME_OBJECT_SCALE);
        o.center_x = GAME_OBJECT_SIZE/2 + col * GAME_OBJECT_SIZE;
        o.center_y = GAME_OBJECT_SIZE/2 + row * GAME_OBJECT_SIZE;
        gameObjects.add(o);
      }
      // if g in array add seegrass
      else if(values[col].equals("g")) {
        GameObject o = new GameObject(seegrass, GAME_OBJECT_SCALE);
        o.center_x = GAME_OBJECT_SIZE/2 + col * GAME_OBJECT_SIZE;
        o.center_y = GAME_OBJECT_SIZE/2 + row * GAME_OBJECT_SIZE;
        gameObjects.add(o);
      }
      // if s in array add sky
      else if(values[col].equals("s")) {
        GameObject o = new GameObject(sky, GAME_OBJECT_SCALE);
        o.center_x = GAME_OBJECT_SIZE/2 + col * GAME_OBJECT_SIZE;
        o.center_y = GAME_OBJECT_SIZE/2 + row * GAME_OBJECT_SIZE;
        gameObjects.add(o);
      }
      // if r in array add coral
      else if(values[col].equals("r")) {
        GameObject o = new GameObject(coral, GAME_OBJECT_SCALE);
        o.center_x = GAME_OBJECT_SIZE/2 + col * GAME_OBJECT_SIZE;
        o.center_y = GAME_OBJECT_SIZE/2 + row * GAME_OBJECT_SIZE;
        gameObjects.add(o);
      }
      // if j in array add jellyfish
      else if(values[col].equals("j")) {
        GameObject o = new GameObject(jellyfish, GAME_OBJECT_SCALE);
        o.center_x = GAME_OBJECT_SIZE/2 + col * GAME_OBJECT_SIZE;
        o.center_y = GAME_OBJECT_SIZE/2 + row * GAME_OBJECT_SIZE;
        gameObjects.add(o);
      }
      else if(values[col].equals("f")) {
        Snack f = new Snack(snack, GAME_OBJECT_SCALE);
        f.center_x = GAME_OBJECT_SIZE/2 + col * GAME_OBJECT_SIZE;
        f.center_y = GAME_OBJECT_SIZE/2 + row * GAME_OBJECT_SIZE;
        snacks.add(f);
      }
      
      else if(values[col].equals("c")) {
        float bLeft = col * GAME_OBJECT_SIZE;
        float bRight = bLeft + 4 * GAME_OBJECT_SIZE; // careful on platrofrom it is hardocoded to be 4
        Enemy newEnemy = new Enemy(cat, 50/72.0, bLeft, bRight);
        newEnemy.center_x = GAME_OBJECT_SIZE/2 + col * GAME_OBJECT_SIZE;
        newEnemy.center_y = GAME_OBJECT_SIZE/2 + row * GAME_OBJECT_SIZE;
        enemies.add(newEnemy);
    }
      
    }
  }
}


//jumping only on platform
public boolean isOnpPlatforms(GameObject s, ArrayList<GameObject> walls){
  s.center_y+=5;
  ArrayList<GameObject> col_list = checkCollisionList(s, walls);
  s.center_y-=5;
  if (col_list.size()>0){
  return true;}
  else{
  return false;}

}

// collision handling
public void resolveCollisions(GameObject s, ArrayList<GameObject> walls) {
  // add gravity
  s.change_y += GRAVITY;
 
  // y collision handling
  s.center_y += s.change_y;
  ArrayList<GameObject> col_list = checkCollisionList(s, walls);
  if(col_list.size() > 0) {
    GameObject collided = col_list.get(0);
    if(s.change_y > 0){
      s.setBottom(collided.getTop());
    }
    else if(s.change_y < 0){
      s.setTop(collided.getBottom());
    }
    s.change_y = 0;
  }
  
  // x collision handling
  s.center_x += s.change_x;
  col_list = checkCollisionList(s, walls);
  if(col_list.size() > 0) {
    GameObject collided = col_list.get(0);
    if(s.change_x > 0){
      s.setRight(collided.getLeft());
    }
    else if(s.change_x < 0){
      s.setLeft(collided.getRight());
    }
  }
}

boolean checkCollision(GameObject o1, GameObject o2) {
  boolean noXOverlap = o1.getRight() <= o2.getLeft() || o1.getLeft() >= o2.getRight();
  boolean noYOverlap = o1.getBottom() <= o2.getTop() || o1.getTop() >= o2.getBottom();
  if(noXOverlap || noYOverlap) {
    return false;
  }
  else {
    return true;
  }
}

public ArrayList<GameObject> checkCollisionList(GameObject o, ArrayList<GameObject> list) {
  ArrayList<GameObject> collision_list = new ArrayList<GameObject>();
  for(GameObject a : list) {
    if(checkCollision(o, a)) {
      collision_list.add(a);
    }
  }
  return collision_list;
}

// move player
void keyPressed() {
  if(keyCode == RIGHT) {
    player.change_x = MOVE_SPEED;
    //player.facingRight = true; // this was for facing image left not needed anymore
  }
  else if(keyCode == LEFT) {
    player.change_x = -MOVE_SPEED;
   // player.facingRight = false; // this was for facing image left not needed anymore
  }
  else if(keyCode == UP) {
    player.change_y = -MOVE_SPEED;
  }
  else if(keyCode == DOWN) {
    player.change_y = MOVE_SPEED;
  }//key code asdfw
  if (key == 'D' || key == 'd') {
    player.change_x = MOVE_SPEED;
   // player.facingRight = true; // this was for facing image left not needed anymore
  }
  else if (key == 'A' || key == 'a') {
    player.change_x = -MOVE_SPEED;
    //player.facingRight = false; // this was for facing image left not needed anymore
  }
  //no double jump
  else if ((key == 'W' || key == 'w')&& isOnpPlatforms(player,gameObjects)) {
    player.change_y = -MOVE_SPEED;
  }
  else if (key == 'S' || key == 's') {
    player.change_y = MOVE_SPEED;
  }
}

void keyReleased() {
  if(keyCode == RIGHT) {
    player.change_x = 0;
  }
  else if(keyCode == LEFT) {
    player.change_x = 0;
  }
  else if(keyCode == UP) {
    player.change_y = 0;
  }
  else if(keyCode == DOWN) {
    player.change_y = 0;
  }
  // asdw keys released
    if (key == 'D' || key == 'd' || key == 'A' || key == 'a') {
    player.change_x = 0;
  }
  if (key == 'W' || key == 'w' || key == 'S' || key == 's') {
    player.change_y = 0;
  }
  if (isGameOver && key == ' ') {
    setup();
  }
}

void collectSnacks(){
 //count score and remove snack
  ArrayList<GameObject> collision_list = checkCollisionList(player, snacks);
  if(collision_list.size() > 0){
    for(GameObject snack: collision_list){
       snacks.remove(snack);
       score++;
       s1.play();
       s1.rewind();
    }
  }
  if(snacks.size() == 0){
    isGameOver = true;
  }
}

void displayAll(){
   // landscape
  for(GameObject o: gameObjects) {
    o.display();
  }
  
  //snacks
  for(GameObject f: snacks) {
    f.display();
    ((AnimatedGameObject)f).updateAnimation();
  }
  
  player.display();
  
  //enemy
  for (GameObject e : enemies) {
    ((AnimatedGameObject)e).display();
    ((AnimatedGameObject)e).update();
    ((AnimatedGameObject)e).updateAnimation();
  } 
  
  //display score
  textSize(24);
  fill(209, 122, 29);
  text("Lives: " + player.lives, 25 + view_x, view_y + 30);
  text("Snacks: " + score, width - 120 + view_x, view_y + 30);
  
  if(isGameOver){
    if(player.lives == 0){
      text("YOU LOSE!", view_x + width/2, view_y + height/2);
      s4.play();
    }
    else{
      text("YOU WIN!", view_x + width/2, view_y + height/2);
      s5.play();
    }
    text("Press SPACE to restart!", view_x + width/2 - 60, view_y + height/2 + 50);
  }
}

void updateAll(){
  player.updateAnimation();
  resolveCollisions(player, gameObjects); 
}

void checkDeath(){
  boolean collideEnemy = false;
  for(GameObject e : enemies){
    collideEnemy = checkCollision(player, e);
    if(collideEnemy){
      s2.play();
      s2.rewind();
      break;
    }
  }
  boolean fallOffCliff = player.getBottom() > height;
  if(fallOffCliff){
    s3.play();
    s3.rewind();
  }
  if(collideEnemy || fallOffCliff) {
    player.lives--;
    if(player.lives == 0){
      isGameOver = true;
    }
    else{
      player.center_x =100;
      player.setBottom(GROUNDLEVEL);
    }
  }
}
