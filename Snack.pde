public class Snack extends AnimatedGameObject{
  public Snack(PImage img, float scale){
  super(img,scale);
  println("snack created");
  standNeutral = new PImage[4];
  standNeutral[0] = loadImage("snack1.png");
  standNeutral[1] = loadImage("snack2.png");
  standNeutral[2] = loadImage("snack3.png");
  standNeutral[3] = loadImage("snack4.png");
  currentImages = standNeutral;

}



}
