public class Enemy extends AnimatedGameObject{
  float boundaryLeft, boundaryRight;
  public Enemy(PImage img, float scale, float bLeft, float bRight){
  super(img,scale);
  println("enemy created");
  moveLeft = new PImage[2];
  moveLeft[0] =loadImage("cat_left1.png");
  moveLeft[1] =loadImage("cat_left2.png");
  moveRight =  new PImage[2];
  moveRight[0] =loadImage("cat_right1.png");
  moveRight[1] =loadImage("cat_right2.png");
  currentImages = moveRight;
  direction = RIGHT_FACING;
  boundaryLeft= bLeft;
  boundaryRight= bRight;
  change_x= 2;
}

void update(){
  super.update();
  if(getLeft()<= boundaryLeft){
    setLeft(boundaryLeft);
    change_x*=-1;
  }
  else if(getRight()>= boundaryRight){
    setRight(boundaryRight);
    change_x*=-1;
  }
  
}



}
