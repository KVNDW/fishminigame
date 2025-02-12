public class Player extends AnimatedGameObject{
 int lives;
 boolean onPlatform, inPlace;
 PImage[] standRight;
 PImage[] standLeft;
 PImage[] jumpRight;
 PImage[] jumpLeft;
 
 public Player(PImage img, float scale){
    super(img, scale);
    lives = 3;
    direction = LEFT_FACING;
    onPlatform = true;
    inPlace = true;
    standLeft = new PImage[1];
    standLeft[0] = loadImage("fish_left.png");
    standRight = new PImage[1];
    standRight[0] = loadImage("fish_right.png");
    jumpLeft = new PImage[2];
    jumpLeft[0] = loadImage("fish_jump_left.png");
    jumpLeft[1] = loadImage("fish_jump2_left.png");
    jumpRight = new PImage[2];
    jumpRight[0] = loadImage("fish_jump_right.png");
    jumpRight[1] = loadImage("fish_jump2_right.png");
    moveLeft = new PImage[2];
    moveLeft[0] = loadImage("fish_swim1_left.png");
    moveLeft[1] = loadImage("fish_swim2_left.png");
    moveRight = new PImage[2];
    moveRight[0] = loadImage("fish_swim1_right.png");
    moveRight[1] = loadImage("fish_swim2_right.png");
    currentImages = standRight;
 }
 
 @Override
 public void updateAnimation(){
   onPlatform = isOnpPlatforms(this, gameObjects);
   inPlace = change_x == 0 && change_y == 0;
   super.updateAnimation();
   selectDirection();
 }
 
 @Override
 public void selectDirection(){
  if (change_x > 0){
    direction = RIGHT_FACING;
  }
  else if(change_x < 0){
    direction = LEFT_FACING;
  }
 }
 
 @Override
 public void selectCurrentImages(){
   if(direction == RIGHT_FACING){
     if(inPlace){
       currentImages = standRight;
     }
     else if(!onPlatform){
       currentImages = jumpRight;
     }
     else{
       currentImages = moveRight;
     }
   }
   else if(direction == LEFT_FACING){
     if(inPlace){
       currentImages = standLeft;
     }
     else if(!onPlatform){
       currentImages = jumpLeft;
     }
     else{
       currentImages = moveLeft;
     }
   }
  }
}
