import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class harmonic extends PApplet {

float RAD = 150;
float radmin = 0;
float radmax = 200;

float OFF = 50;

float centerX;
float centerY;

float pulsmin = 0;
float pulsmax = 0.1f;
float puls;

float phi0;
float phimin = 0;
float phimax = TWO_PI;

boolean graphing;
boolean MOVING;

Bubble osc;
Bubble rot;
Arrow fasor;

ArrayList<Button> buttons;
ArrayList<Bubble> graph;
ArrayList<Slider> sliders;

int time;
int gtime;

public void setup() {
  
  centerX = OFF + 200;
  centerY = height/2 + 90;

  osc = new Bubble(centerX, centerY, 20);
  rot = new Bubble(centerX + RAD, centerY, 20);
  osc.setcol("red");
  rot.setcol("blue");
  rot.togglevisible();

  fasor = new Arrow(centerX, centerY, rot.x, rot.y, color(0));

  graph = new ArrayList<Bubble>();
  buttons = new ArrayList<Button>();
  buttons.add(new Button(10, 10, 50, "Rode Bal")); //0
  buttons.get(0).clickbutton();
  buttons.add(new Button(90, 10, 50, "Blauwe Bal")); //1
  buttons.add(new Button(170, 10, 50, "Assen")); //2
  buttons.add(new Button(250, 10, 50, "Start/Stop")); //3
  buttons.add(new Button(330, 10, 50, "Reset")); //4
  buttons.add(new Button(170, 70, 50, "Verbind")); //5
  buttons.add(new Button(410, 10, 50, "Grafiek")); //6
  buttons.add(new Button(10, 70, 50, "y component")); //7
  buttons.add(new Button(width - 80, 10, 50, "quit")); //8
  buttons.add(new Button(90, 70, 50, "Fasor")); //9

  sliders = new ArrayList<Slider>();
  sliders.add(new Slider(800, 10, 400, "Pulsatie"));
  sliders.get(0).setDefault(0.3f);
  sliders.add(new Slider(800, 70, 400, "Amplitude"));
  sliders.get(1).setDefault(0.75f);
  sliders.add(new Slider(800, 130, 400, "Beginfase"));
  sliders.get(2).setDefault(0);


  time = 0;
  gtime = 0;
  MOVING = false;
  graphing = false;
}

public void draw() {
  background(255);
  if (buttons.get(1).clicked) {
    drawcircle();
  }

  for (Button b : buttons) {
    b.show();
  }

  for (Slider s : sliders) {
    s.show();
  }

  updatePhi0();
  updateRadius();
  updatePulsation();
  updatecircles();

  // Y COMPONENT 7
  if (buttons.get(7).clicked) {
    stroke(255, 0, 0);
    strokeWeight(4);
    int offset = 0;
    line(centerX - offset, centerY, centerX - offset, osc.y);
    strokeWeight(1);
  }
  // SHOW RED BALL 0
  if (buttons.get(0).clicked) {
    osc.show();
  }

  // SHOW BLUE BALL 1
  if (buttons.get(1).clicked) {
    rot.show();
  }

  //SHOWAXES BUTTON 2
  if (buttons.get(2).clicked) {
    showaxes();
  }

  // START OR STOP 3
  if (buttons.get(3).clicked) {
    MOVING = !MOVING;
    buttons.get(3).clicked = false;
  }

  //RESET 4
  if (buttons.get(4).clicked) {
    time = 0;
    graphing = false;
    graph.clear();    
    buttons.get(4).clickbutton();

    for (Slider s : sliders) {
      s.reset();
    }
  }

  //CONNECT 5
  if (buttons.get(5).clicked) {
    stroke(0);
    line(0.f, osc.y, width, osc.y);
  }

  //GRAPH 6
  if (buttons.get(6).clicked) {
    graphing = !graphing;
    gtime = 0;
    buttons.get(6).clickbutton();
    updatecircles();
  }

  //EXIT 8
  if (buttons.get(8).clicked) {
    exit();
  }

  //FASOR 9
  if (buttons.get(9).clicked) {
    fasor.updatexe(rot.x);
    fasor.updateye(rot.y);
    fasor.show();
  }

  //If the mouse is pressed, do sliders.
  if (mousePressed) {
    for (Slider s : sliders) {
      if (s.checkHovering()) {
        s.update();
      }
    }
  }



  if (graphing) {
    drawgraph();
    for (Bubble b : graph) {
      b.show();
    }
  }



  if (MOVING) {
    time += 1;
    if (graphing) {
      gtime += 1;
    }
  }
}

public void mouseClicked() {
  for (Button b : buttons) {
    if (b.checkclicked()) {
      b.clickbutton();
    }
  }
}

public void keyPressed() {
  if (keyCode == RIGHT) {
    for (Slider s : sliders) {
      if (s.checkHovering()) {
        float nextval = 20* s.getPercentage();
        nextval = floor(nextval);
        nextval = nextval*5 + 5;
        nextval = nextval / 100;
        if (nextval > 1) {
          nextval = 1;
        }
        s.setPercentage(nextval);
        s.shiftToPerc();
      }
    }
  }  
  if (keyCode == LEFT) {
    for (Slider s : sliders) {
      if (s.checkHovering()) {
        float nextval = 20* s.getPercentage();
        nextval = floor(nextval);
        nextval = nextval*5 - 5;
        nextval = nextval / 100;
        if (nextval < 0) {
          nextval = 0;
        }
        s.setPercentage(nextval);
        s.shiftToPerc();
      }
    }
  }
}

public void updatePhi0() {
  float philen = phimax - phimin;
  float percentage = sliders.get(2).getPercentage();
  phi0 = phimin + philen*percentage;
}

public void updatePulsation() {
  float pullen = pulsmax - pulsmin;
  float percentage = sliders.get(0).getPercentage();
  puls = pulsmin + pullen*percentage;
}

public void updateRadius() {
  float radlen = radmax - radmin;
  float percentage = sliders.get(1).getPercentage();
  RAD = radmin + radlen*percentage;
}

public void updatecircles() {
  //update the position of the circles  
  osc.updatey(RAD*sin(-1 * puls*time - phi0) + centerY);
  rot.updatey(RAD*sin(-1*puls*time - phi0) + centerY);
  rot.updatex(RAD*cos(puls*time + phi0) + centerX);
}

public void drawcircle() {
  ellipseMode(RADIUS);
  stroke(0);
  noFill();
  circle(centerX, centerY, RAD);
}

public void showaxes() {
  stroke(0);
  line(centerX, 0, centerX, height);
  line(0, centerY, width, centerY);
}

public void drawgraph() {
  float vgraph = gtime;
  float end = osc.x + vgraph;
  if (end < width) {
    graph.add(new Bubble(end, osc.y, osc.size/10));
    graph.get(graph.size() - 1).setcol("red");
  }
}
class Arrow {
  float xb;
  float yb;
  float xe;
  float ye;
  
  int col;

  float x1 = 0;
  float y1 = 0;
  float x2 = 0;
  float y2 = 0;
  float xs = 0;
  float ys = 0;


  Arrow(float xb, float yb, float xe, float ye, int col) {
    this.xb = xb;
    this.yb = yb;
    this.xe = xe;
    this.ye = ye;
    this.col = col;
  }

  public void show() {

    this.setTriangle();
    stroke(col);
    fill(col);
    strokeWeight(3);

    line(xb, yb, xe, ye);
    triangle(xe, ye, x1, y1, x2, y2);

    strokeWeight(1);
    noStroke();
    noFill();
  }


  public void updatexb(float x) {
    this.xb = x;
  }  
  public void updatexe(float x) {
    this.xe = x;
  }  
  public void updateyb(float x) {
    this.yb = x;
  }  
  public void updateye(float x) {
    this.ye = x;
  }

  public void setTriangle() {    
    float delx = this.xe - this.xb;
    float dely = this.ye - this.yb;
    float dis = dist(this.xb, this.yb, this.xe, this.ye);

    this.xs = this.xb + 0.95f*delx;
    this.ys = this.yb + 0.95f*dely;

    float L = abs(dist(this.xs, this.ys, this.xe, this.ye));

    float alpha = atan2(dely,delx);
    float beta = HALF_PI - alpha;

    float delxx = L*cos(beta)/2;
    float delyy = L*sin(beta)/2;

    this.x1 = this.xs - delxx;
    this.y1 = this.ys + delyy;
    this.x2 = this.xs + delxx;
    this.y2 = this.ys - delyy;
  }
  
}
class Bubble {
  float x;
  float y;
  float size;

  float startx;
  float starty;

  float vx;
  float vy;

  int col;

  boolean visible;

  Bubble(float x, float y, float s) {
    this.x = x;
    this.y = y;
    this.startx = x;
    this.starty = y;
    this.size = s;
    this.visible = true;
  }

  public void setcol(String col) {
    if (col == "red") {
      this.col = color(255,0,0);
    } else if (col == "blue") {
      this.col = color(0,0,255);
    } else if (col == "green") {
      this.col = color(0,255,0);
    } else {
      print("ERROR: NO VALID COLOR DEFINED");
    }
  }

  public void show() {
    ellipseMode(RADIUS);
    noStroke();
    fill(this.col);
    circle(this.x, this.y, this.size);
  }

  public void togglevisible() {
    visible = !visible;
  }

  public void updatex(float x) {
    this.x = x;
  }

  public void updatey(float y) {
    this.y = y;
  }

  public void resetpos() {
    this.x = this.startx;
    this.y = this.starty;
  }
}
class Button {

  float x;
  float y;
  float size;
  String text;

  float xe;
  float ye;

  boolean clicked;


  Button(float x, float y, float size, String text) {
    this.x = x;
    this.y = y;
    this.size = size;
    this.text = text;

    this.xe = this.x + 1.5f* size;
    this.ye = this.y + size;

    this.clicked = false;
  }

  public void show() {
    if (!clicked) {
      fill(150);
    } else {
      fill(0, 250, 0);
    }
    stroke(0);
    rectMode(CORNERS);
    rect(x, y, xe, ye);
    fill(0);
    textAlign(CENTER, CENTER);
    text(this.text, x, y, xe, ye);
  }

  public void clickbutton() {
    this.clicked = !this.clicked;
  }

  public boolean checkclicked() {
    if (mouseX >= this.x && mouseX <= this.xe) {
      if (mouseY >= this.y && mouseY <= this.ye) {
        return true;
      }
    } else {
      return false;
    }
    return false;
  }
}
class Slider {

  //Location and size
  float x;
  float y;
  float len;
  float wid;
  float whitespace;

  //text
  String text;
  float textsize;

  //slider
  float sx;
  float slen;
  Bubble orb;

  //percentage
  float perc;
  float defaultperc;


  Slider(float x, float y, float scale, String text) {
    this.x = x;
    this.y = y;
    this.len = scale;
    this.wid = 50;
    this.whitespace = 0.05f*scale;

    this.text = text;
    this.textsize = 0.2f*scale;

    this.sx = this.x + this.textsize + this.whitespace;
    this.slen = this.len - this.textsize - this.whitespace;
    this.orb = new Bubble(this.sx + this.slen/2, this.y + this.wid/2, this.wid/2);
    
    this.setDefault();
  }

  public void setDefault(float def) {
    this.defaultperc = def;
    this.perc = this.defaultperc;
    this.shiftToPerc();
    
  }

  public void setDefault() {
    this.defaultperc = 0.5f;
    this.perc = this.defaultperc;
  }
  
  public void shiftToPerc(){
    float xn = this.sx + this.perc * this.slen;
    this.orb.updatex(xn);
  }

  public void show() {
    //show the text
    rectMode(CORNERS);
    fill(0);
    textAlign(CENTER, CENTER);
    text(this.text, this.x, this.y, this.x + this.textsize, this.y + this.wid);

    //show the slider
    stroke(0, 255, 0);
    strokeWeight(50);
    line(this.sx, this.y + this.wid/2, this.orb.x, this.y + this.wid/2);
    stroke(150);
    line(this.orb.x, this.y + this.wid/2, this.sx + this.slen, this.y + this.wid/2);
    stroke(0);
    strokeWeight(1);

    //show the little button that you slide around
    this.orb.show();
  }

  public void reset() {
    this.orb.updatex(this.sx + this.slen/2);
    this.perc = this.defaultperc;
    this.shiftToPerc();
  }

  public void update() {
    this.orb.updatex(mouseX);
    this.perc = map(mouseX, this.sx, this.sx + this.slen, 0, 1);
  }

  public boolean checkHovering() {
    if (mouseX >= this.sx && mouseX <= this.sx + this.slen && mouseY >= this.y && mouseY <= this.y + this.wid) {
      return true;
    }    
    return false;
  }

  public float getPercentage() {
    return this.perc;
  }
  
  public void setPercentage(float ne){
    this.perc = ne;
  }
}
  public void settings() {  fullScreen(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "harmonic" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
