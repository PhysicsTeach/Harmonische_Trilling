class Bubble {
  float x;
  float y;
  float size;

  float startx;
  float starty;

  float vx;
  float vy;

  color col;

  boolean visible;

  Bubble(float x, float y, float s) {
    this.x = x;
    this.y = y;
    this.startx = x;
    this.starty = y;
    this.size = s;
    this.visible = true;
  }

  void setcol(String col) {
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

  void show() {
    ellipseMode(RADIUS);
    noStroke();
    fill(this.col);
    circle(this.x, this.y, this.size);
  }

  void togglevisible() {
    visible = !visible;
  }

  void updatex(float x) {
    this.x = x;
  }

  void updatey(float y) {
    this.y = y;
  }

  void resetpos() {
    this.x = this.startx;
    this.y = this.starty;
  }
}
