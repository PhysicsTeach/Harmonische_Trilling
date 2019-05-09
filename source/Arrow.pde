class Arrow {
  float xb;
  float yb;
  float xe;
  float ye;

  color col;

  float x1 = 0;
  float y1 = 0;
  float x2 = 0;
  float y2 = 0;
  float xs = 0;
  float ys = 0;


  Arrow(float xb, float yb, float xe, float ye, color col) {
    this.xb = xb;
    this.yb = yb;
    this.xe = xe;
    this.ye = ye;
    this.col = col;
  }

  void show() {

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


  void updatexb(float x) {
    this.xb = x;
  }  
  void updatexe(float x) {
    this.xe = x;
  }  
  void updateyb(float x) {
    this.yb = x;
  }  
  void updateye(float x) {
    this.ye = x;
  }

  void setTriangle() {    
    float delx = this.xe - this.xb;
    float dely = this.ye - this.yb;
    float dis = dist(this.xb, this.yb, this.xe, this.ye);

    this.xs = this.xb + 0.95*delx;
    this.ys = this.yb + 0.95*dely;

    float L = dist(this.xs, this.ys, this.xe, this.ye);

    float alpha = asin(dely/dis);
    float beta = HALF_PI - alpha;

    float delxx = L*cos(beta)/2;
    float delyy = L*sin(beta)/2;

    this.x1 = this.xs - delxx;
    this.y1 = this.ys + delyy;
    this.x2 = this.xs + delxx;
    this.y2 = this.ys - delyy;
  }
}
