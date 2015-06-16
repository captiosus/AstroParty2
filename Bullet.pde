class Bullet {
  float x;
  float y;
  float angle;
  float rotate;
  int player;
  boolean onHold;
  
  int rad = 5;
  
  int reload = 80;
  int reloadCounter = 0;
   
  Bullet(int player) {
    rotate = 0;
    this.player = player;
  }
  
  void moveForward(int speed) {
    x += speed * cos(angle);
    y += speed * sin(angle);
  }
  
  void shoot(float x, float y, float angle) {
    onHold = false;
    this.x = x;
    this.y = y;
    this.angle = angle;
  }
    
  void hold(int num, int total, float centerX, float centerY) {
    reloadCounter = 0;
    onHold = true;
    float individual = 2*PI / total;
    this.x = centerX + 30*cos(individual*num + rotate);
    this.y = centerY + 30*sin(individual*num + rotate);
  }
  
  void display() {
    stroke(255, 255, 255);
    fill(255, 255, 255);
    ellipse(x, y, rad, rad);
  }
}
