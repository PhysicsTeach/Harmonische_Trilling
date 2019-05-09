float RAD = 150;
float radmin = 0;
float radmax = 200;

float OFF = 50;

float centerX;
float centerY;

float pulsmin = 0;
float pulsmax = 0.1;
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

void setup() {
  fullScreen();
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
  sliders.get(0).setDefault(0.3);
  sliders.add(new Slider(800, 70, 400, "Amplitude"));
  sliders.get(1).setDefault(0.75);
  sliders.add(new Slider(800, 130, 400, "Beginfase"));
  sliders.get(2).setDefault(0);


  time = 0;
  gtime = 0;
  MOVING = false;
  graphing = false;
}

void draw() {
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
    line(0., osc.y, width, osc.y);
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

void mouseClicked() {
  for (Button b : buttons) {
    if (b.checkclicked()) {
      b.clickbutton();
    }
  }
}

void keyPressed() {
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

void updatePhi0() {
  float philen = phimax - phimin;
  float percentage = sliders.get(2).getPercentage();
  phi0 = phimin + philen*percentage;
}

void updatePulsation() {
  float pullen = pulsmax - pulsmin;
  float percentage = sliders.get(0).getPercentage();
  puls = pulsmin + pullen*percentage;
}

void updateRadius() {
  float radlen = radmax - radmin;
  float percentage = sliders.get(1).getPercentage();
  RAD = radmin + radlen*percentage;
}

void updatecircles() {
  //update the position of the circles  
  osc.updatey(RAD*sin(-1 * puls*time - phi0) + centerY);
  rot.updatey(RAD*sin(-1*puls*time - phi0) + centerY);
  rot.updatex(RAD*cos(puls*time + phi0) + centerX);
}

void drawcircle() {
  ellipseMode(RADIUS);
  stroke(0);
  noFill();
  circle(centerX, centerY, RAD);
}

void showaxes() {
  stroke(0);
  line(centerX, 0, centerX, height);
  line(0, centerY, width, centerY);
}

void drawgraph() {
  float vgraph = gtime;
  float end = osc.x + vgraph;
  if (end < width) {
    graph.add(new Bubble(end, osc.y, osc.size/10));
    graph.get(graph.size() - 1).setcol("red");
  }
}
