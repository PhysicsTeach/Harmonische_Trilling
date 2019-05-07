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

    this.xe = this.x + 1.5* size;
    this.ye = this.y + size;

    this.clicked = false;
  }

  void show() {
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

  void clickbutton() {
    this.clicked = !this.clicked;
  }

  boolean checkclicked() {
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
