import processing.serial.*; // imports library for serial communication
import java.awt.event.KeyEvent; // imports library for reading the data from the serial port
import java.io.IOException;

Serial myPort; // defines Object Serial

// defubes variables
String angle="";
String distanceHor="";
String distanceVer="";
String data="";
String noObject;
int pixsDistance;
int iAngle, iDistanceHor, iDistanceVer;
int indexAngle=0;
int indexDistance=0;
PFont orcFont;






void setup() {
  /*          size()  
  Defines the dimension of the display window width and height in units of pixels. 
  In a program that has the setup() function, the size() function must be the first line of code inside setup().
  The system variables width and height are set by the parameters passed to this function. */
  
  size (1360, 700); // ***CHANGE THIS TO YOUR SCREEN RESOLUTION***
  
  /*          smooth()  
  Draws all geometry with smooth (anti-aliased) edges.  */  
  smooth();// smooth(level): level=2,3,4 or 8
  
  myPort = new Serial(this,"COM10", 9600); // starts the serial communication
  myPort.bufferUntil('.'); // reads the data from the serial port up to the character '.'. So actually it reads this: angle,distance.
  orcFont = loadFont("OCRAExtended-30.vlw");
}





          /*          draw()
            Called directly after setup(), the draw() function continuously executes the lines of code contained inside its block 
            until the program is stopped or noLoop() is called. 
            draw() is called automatically and should never be called explicitly.*/
void draw() {
  
  /*          fill() 
  Sets the color used to fill shapes. 
  This color is either specified in terms of the RGB or HSB color depending on the current colorMode(). 
  The default color space is RGB, with each value in the range from 0 to 255. */  
  fill(98,245,31);// fill(v1, v2, v3):  v1=red/hue,  v2=green/saturation,  v3=blue/brightness
  
  textFont(orcFont);
  
  // simulating motion blur and slow fade of the moving line
  
  /*          noStroke()        related to rect()  
  Disables drawing the stroke (outline). If both noStroke() and noFill() are called, 
  nothing will be drawn to the screen. */  
  noStroke();
  
  fill(0,4);// fill(rgb, alpha): rgb=color,  alpha=opacity 
  
  /*           rect()  
  Draws a rectangle to the screen. 
  By default, the first two parameters set the location of the upper-left corner, 
  the third sets the width, and the fourth sets the height.  */
  rect(7*width/10, 0, width, height); // rect(a, b, c, d): a=x-coord, b=y-coord, c=width, d=height 
  
  fill(98,245,31); // green color
  
  // calls the functions for drawing the radar
  drawRadarHorizontal();
  drawLineHorizontal();
  drawObjectHorizontal();
  drawTextHorizontal();
  
  drawRadarVertical(); 
  drawLineVertical();
  drawObjectVertical();
  drawTextVertical(); 
}






void serialEvent (Serial myPort) { // starts reading data from the Serial Port
  // reads the data from the Serial Port up to the character '.' and puts it into the String variable "data".
  
  data = myPort.readStringUntil('.');
  data = data.substring(0,data.length()-1);
  
  indexAngle = data.indexOf(","); // find the character ',' and puts it into the variable "indexAngle"
  indexDistance = data.indexOf("-"); // find the character '-' and puts it into the variable "indexDistance"
  
  angle = data.substring(0, indexAngle); // read the data from position "0" to position of the variable indexAngle or thats the value of the angle the Arduino Board sent into the Serial Port
  
  distanceHor = data.substring(indexAngle+1, indexDistance); // read the data from position "indexAngle" to position "indexDistance" , thats the value of the distanceHor
  distanceVer = data.substring(indexDistance+1, data.length()); // read the data from position "indexDistance" to the end of the data , thats the value of the distanceVer
  
  // converts the String variables into Integer
  iAngle = int(angle);
  iDistanceHor = int(distanceHor);
  iDistanceVer = int(distanceVer);
}







void drawRadarHorizontal() {
  /*                pushMatrix();
     Pushes the current transformation matrix onto the matrix stack. 
     Understanding pushMatrix() and popMatrix() requires understanding the concept of a matrix stack. 
     The pushMatrix() function saves the current coordinate system to the stack and popMatrix() restores the prior coordinate system. 
     pushMatrix() and popMatrix() are used in conjuction with the other transformation functions and may be embedded to control the scope of the transformations. */
  pushMatrix();
  noStroke();
  fill(0,4); 
  rect(0, 0, 7*width/10, 3*height/4);
  translate(7*width/20, 2*height/3); // moves the starting coordinats to new location
  noFill();//Disables filling geometry. If both noStroke() and noFill() are called, nothing will be drawn to the screen. 
  strokeWeight(2);//Sets the width of the stroke used for lines, points, and the border around shapes. All widths are set in units of pixels.
  stroke(98,245,31);
  
  // draws the arc lines
  /*    a   float: x-coordinate of the arc's ellipse
        b   float: y-coordinate of the arc's ellipse
        c   float: width of the arc's ellipse by default
        d   float: height of the arc's ellipse by default
        start   float: angle to start the arc, specified in radians
        stop   float: angle to stop the arc, specified in radians */
  arc(0,0,(width*0.65),(width*0.65),PI,TWO_PI);
  arc(0,0,(width*0.52),(width*0.52),PI,TWO_PI);
  arc(0,0,(width*0.39),(width*0.39),PI,TWO_PI);
  arc(0,0,(width*0.26),(width*0.26),PI,TWO_PI);
  arc(0,0,(width*0.13),(width*0.13),PI,TWO_PI);
  
  // draws the angle lines
  /*  x1   float: x-coordinate of the first point
      y1   float: y-coordinate of the first point
      x2   float: x-coordinate of the second point
      y2   float: y-coordinate of the second point
  */
  line(-7*width/20+10,0,7*width/20-10,0);
  line(0,0,(-7*width/20+10)*cos(radians(30)),(-7*width/20+10)*sin(radians(30)));
  line(0,0,(-7*width/20+10)*cos(radians(60)),(-7*width/20+10)*sin(radians(60)));
  line(0,0,(-7*width/20-10)*cos(radians(90)),(-7*width/20+10)*sin(radians(90)));
  line(0,0,(-7*width/20+10)*cos(radians(120)),(-7*width/20+10)*sin(radians(120)));
  line(0,0,(-7*width/20+10)*cos(radians(150)),(-7*width/20+10)*sin(radians(150)));
  //line((-7*width/20-10)*cos(radians(30)),0,(-7*width/20+50),0);
  
  popMatrix();/*Pops the current transformation matrix off the matrix stack. 
  Understanding pushing and popping requires understanding the concept of a matrix stack. 
  The pushMatrix() function saves the current coordinate system to the stack and popMatrix() restores the prior coordinate system. 
  pushMatrix() and popMatrix() are used in conjuction with the other transformation functions 
  and may be embedded to control the scope of the transformations. */
}







void drawLineHorizontal() {
  pushMatrix();
  strokeWeight(9);
  stroke(30,250,60);
  translate(7*width/20, 2*height/3); // moves the starting coordinats to new location
  line(0,0,(7*width/20-10)*cos(radians(iAngle)),-(7*width/20-10)*sin(radians(iAngle))); // draws the line according to the angle
  popMatrix();
}





void drawObjectHorizontal() {
  pushMatrix();
  translate(7*width/20, 2*height/3); // moves the starting coordinats to new location
  strokeWeight(9);
  stroke(255,10,10); // red color
  pixsDistance = int(iDistanceHor*(width*0.00065)); // covers the distance from the sensor from cm to pixels : width*0.00065=(width*0.325)/500=(width*0.65/2)/500=442px(line.length)/500cm
  // limiting the range to 440 cms
  if(iDistanceHor<440){
    // draws the object according to the angle and the distance
  line(pixsDistance*cos(radians(iAngle)),-pixsDistance*sin(radians(iAngle)),(7*width/20-10)*cos(radians(iAngle)),-(7*width/20-10)*sin(radians(iAngle)));
  }
  popMatrix();
}






void drawTextHorizontal() { // draws the texts on the screen
  
  pushMatrix();
  if(iDistanceHor>=440) {
      noObject = "Out of Range";
      }
  else {
      noObject = "In Range";
      }
      
  fill(0,0,0);//fill(0,0,0);
  noStroke();
  rect(0, 3*height/4, 7*width/20, 1*height/4);
  fill(98,245,31);
  textSize(20);
  
  /*        text(c, x, y) :    Draws text to the screen.
    
    c   char: the alphanumeric character to be displayed
    x   float: x-coordinate of text
    y   float: y-coordinate of text                   */
  text("5m",22,2*height/3+25);
  text("4m",110,2*height/3+25);
  text("3m",198,2*height/3+25);
  text("2m",286,2*height/3+25);
  text("1m",374,2*height/3+25);
  text("0",471,2*height/3+25);
  text("1m",553,2*height/3+25);
  text("2m",641,2*height/3+25);
  text("3m",728,2*height/3+25);
  text("4m",817,2*height/3+25);
  text("5m",905,2*height/3+25);
  textSize(20);
  
  text("  HORIZONTAL ", 0, 2*height/3+height/8);
  text("Object: " + noObject, 0, 2*height/3+height/6);
  text("Angle: " + iAngle +" °", 0, 2*height/3+height/5);
  text("Distance: ", 0, 2*height/3+height/4);
  
  if(iDistanceHor<440) {
      text(iDistanceHor +" cm", 150, 2*height/3+height/4);
      }
      
  textSize(20);
  fill(98,245,60);
  
  translate(885,220);
  rotate(-radians(-60));
  text("30°",0,0);
  resetMatrix();
  translate(710,45);
  rotate(-radians(-30));
  text("60°",0,0);
  resetMatrix();
  /*translate((width-width*0.507)+width/2*cos(radians(90)),(height-height*0.0833)-width/2*sin(radians(90)));
  rotate(radians(0));
  text("90°",0,0);
  resetMatrix(); */
  translate(215,60);
  rotate(radians(-30));
  text("120°",0,0);
  resetMatrix();
  translate(50,245);
  rotate(radians(-60));
  text("150°",0,0);
  
  popMatrix();
}




















void drawRadarVertical() {
  pushMatrix();
  translate(11*width/15,height/2); // moves the starting coordinats to new location
  noFill();
  strokeWeight(2);
  stroke(98,245,31);
  
  // draws the arc lines
  arc(0,0,(width*0.5),(width*0.5),-HALF_PI,HALF_PI);
  arc(0,0,(width*0.4),(width*0.4),-HALF_PI,HALF_PI);
  arc(0,0,(width*0.3),(width*0.3),-HALF_PI,HALF_PI);
  arc(0,0,(width*0.2),(width*0.2),-HALF_PI,HALF_PI);
  arc(0,0,(width*0.1),(width*0.1),-HALF_PI,HALF_PI);
  
  // draws the angle lines
  line(0,-3*width/11+10,0,3*width/11-10);
  line(0,0,(3*width/11-10)*cos(radians(30)),(3*width/11-10)*sin(radians(30)));
  line(0,0,(3*width/11-10)*cos(radians(60)),(3*width/11-10)*sin(radians(60)));
  line(0,0,-(3*width/11-10)*cos(radians(90)),-(3*width/11-10)*sin(radians(90)));
  line(0,0,-(3*width/11-10)*cos(radians(120)),-(3*width/11-10)*sin(radians(120)));
  line(0,0,-(3*width/11-10)*cos(radians(150)),-(3*width/11-10)*sin(radians(150)));
  line(0,0,(3*width/11-10),0);
  popMatrix();
}







void drawLineVertical() {
  pushMatrix();
  strokeWeight(9);
  stroke(30,250,60);
  translate(11*width/15,height/2); // moves the starting coordinats to new location
  line(0,0,(3*width/11-10)*cos(radians(iAngle-90)),-(3*width/11-10)*sin(radians(iAngle-90))); // draws the line according to the angle
  popMatrix();
}







void drawObjectVertical() {
  pushMatrix();
  translate(11*width/15,height/2); // moves the starting coordinats to new location
  strokeWeight(9);
  stroke(255,10,10); // red color
  pixsDistance = int(iDistanceVer*(width*0.0005)); // covers the distance from the sensor from cm to pixels : width*0.0005=width/2000=(width*0.5/2)(line.length)/500cm
  // limiting the range to 440 cms
  if(iDistanceVer<440){
    // draws the object according to the angle and the distance
  line(pixsDistance*cos(radians(iAngle-90)),-pixsDistance*sin(radians(iAngle-90)),(3*width/11-10)*cos(radians(iAngle-90)),-(3*width/11-10)*sin(radians(iAngle-90)));
  }
  popMatrix();
}








void drawTextVertical() { // draws the texts on the screen
  
  pushMatrix();
  if(iDistanceVer>=440) {
      noObject = "Out of Range";
      }
  else {
      noObject = "In Range";
      }
      
  fill(0,0,0);
  noStroke();
  rect(7*width/20, 3*height/4, 7*width/20, 1*height/4);
  fill(98,245,31);
  textSize(20);
  
  text("5m",970,15);
  text("4m",970,83);
  text("3m",970,150);
  text("2m",970,219);
  text("1m",970,287);
  text("0",970,358);
  text("1m",970,424);
  text("2m",970,491);
  text("3m",970,559);
  text("4m",970,627);
  text("5m",970,694);
  textSize(20);
  
  text("  VERTICAL ", 7*width/20, 2*height/3+height/8);
  text("Object: " + noObject, 7*width/20, 2*height/3+height/6);
  text("Angle: " + iAngle +" °", 7*width/20, 2*height/3+height/5);
  text("Distance: ", 7*width/20, 2*height/3+height/4);
  
  if(iDistanceVer<440) {
      text(iDistanceVer +" cm", 7*width/20+150, 2*height/3+height/4);
      }
      
  textSize(20);
  fill(98,245,60);
  
  text("60°",1185,20);
  text("30°",1325,155);
  text("-30°",1315,559);
  text("-60°",1175,694);
  
  popMatrix();
}
