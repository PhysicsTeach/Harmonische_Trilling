float RAD = 200;
float OFF = 50;

float centerX;
float centerY;

float PULS = 0.03;

boolean graphing;
boolean MOVING;

Bubble osc;
Bubble rot;

ArrayList<Button> buttons;
ArrayList<Bubble> graph;

int time;
int gtime;

void setup() {
  fullScreen();
  centerX = OFF + RAD;
  centerY = height/2 + 90;

  osc = new Bubble(centerX, centerY, 20);
  rot = new Bubble(centerX + RAD, centerY, 20);
  osc.setcol("red");
  rot.setcol("blue");
  rot.togglevisible();

  graph = new ArrayList<Bubble>();
  buttons = new ArrayList<Button>();
  buttons.add(new Button(10, 10, 50, "Red Ball"));
  buttons.get(0).clickbutton();
  buttons.add(new Button(90, 10, 50, "Blue Ball"));
  buttons.add(new Button(170, 10, 50, "Axes"));
  buttons.add(new Button(250, 10, 50, "Start/Stop"));
  buttons.add(new Button(330, 10, 50, "Reset"));
  buttons.add(new Button(10, 70, 50, "Connect"));
  buttons.add(new Button(410, 10, 50, "Graph"));
  buttons.add(new Button(90, 70, 50, "y component"));
  buttons.add(new Button(width - 80, 10, 50, "quit"));

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

  updatecircles();


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
  
  // Y COMPONENT 7
    if (buttons.get(7).clicked) {
    stroke(255,0,0);
    strokeWeight(4);
    int offset = 0;
    line(centerX - offset, centerY, centerX - offset, osc.y);
    strokeWeight(1);
  }
  
  //EXIT 8
  if(buttons.get(8).clicked){
    exit();
  }



  if (graphing) {
    drawgraph();
    for (Bubble b : graph) {
      b.show();
    }
  }



  if (MOVING) {
    time += 1;
    if(graphing){
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

void updatecircles() {
  osc.updatey(RAD*sin(-1 * PULS*time) + centerY);
  rot.updatey(RAD*sin(-1*PULS*time) + centerY);
  rot.updatex(RAD*cos(PULS*time) + centerX);
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
