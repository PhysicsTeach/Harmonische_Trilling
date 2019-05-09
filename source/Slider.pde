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
    this.whitespace = 0.05*scale;

    this.text = text;
    this.textsize = 0.2*scale;

    this.sx = this.x + this.textsize + this.whitespace;
    this.slen = this.len - this.textsize - this.whitespace;
    this.orb = new Bubble(this.sx + this.slen/2, this.y + this.wid/2, this.wid/2);
    
    this.setDefault();
  }

  void setDefault(float def) {
    this.defaultperc = def;
    this.perc = this.defaultperc;
    this.shiftToPerc();
    
  }

  void setDefault() {
    this.defaultperc = 0.5;
    this.perc = this.defaultperc;
  }
  
  void shiftToPerc(){
    float xn = this.sx + this.perc * this.slen;
    this.orb.updatex(xn);
  }

  void show() {
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

  void reset() {
    this.orb.updatex(this.sx + this.slen/2);
    this.perc = this.defaultperc;
    this.shiftToPerc();
  }

  void update() {
    this.orb.updatex(mouseX);
    this.perc = map(mouseX, this.sx, this.sx + this.slen, 0, 1);
  }

  boolean checkHovering() {
    if (mouseX >= this.sx && mouseX <= this.sx + this.slen && mouseY >= this.y && mouseY <= this.y + this.wid) {
      return true;
    }    
    return false;
  }

  float getPercentage() {
    return this.perc;
  }
  
  void setPercentage(float ne){
    this.perc = ne;
  }
}
