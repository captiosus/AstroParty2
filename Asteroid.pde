class Asteroid {

  int diameter;
  float xpos;
  float ypos;
  float angle;
  float speed;
  
  float squareX = xpos - diameter/2;
  float squareY = ypos - diameter/2;

  Asteroid(int d, float x, float y, float speed) {
    diameter = d;
    xpos = x;
    ypos = y;
    this.speed = speed;
    angle = random(-1*PI/2, PI/2);
  }

  void move() {
    if (xpos + diameter/2 > width || xpos - diameter/2 < 0
    || ypos + diameter/2 > height || ypos - diameter/2 <0) {
      angle += PI/2;
      xpos += speed*cos(angle);
      ypos += speed*sin(angle);
    }
    else {
      xpos += speed*cos(angle);
      ypos += speed*sin(angle);
    }
  }
  void asteroidCollide(Asteroid other) {
    float xDif = pow(other.xpos - xpos, 2);
    float yDif = pow(other.ypos - ypos, 2);
    if (xDif + yDif < pow(diameter/2 + other.diameter/2, 2)) {
      angle = (angle + other.angle)/2;
      other.angle = (angle + other.angle)/2;
      speed = (speed + other.speed)/2;
      other.speed = (speed + other.speed)/2;
    }
  }
  
  void playerCollide(PlayerShip other) {
    float xDif = pow(other.centroidX - xpos, 2);
    float yDif = pow(other.centroidY - ypos, 2);
    if (xDif + yDif < pow(diameter/2 + 10, 2)) { 
      bounce(sqrt(xDif + yDif), other.centroidX - xpos, other.centroidY - ypos, 
      other.centroidX, other.centroidY, other);
    }
  }
  
  void bounce(float hypotenuse, float xDistance, 
  float yDistance, float otherX, float otherY, PlayerShip other) {
    float angle = atan(yDistance/xDistance);
    float bounceDistance = 10 + diameter/2 - hypotenuse;
    float bounceX = cos(angle) * bounceDistance + 1;
    float bounceY = sin(angle) * bounceDistance + 1;
    if (otherX > xpos) {
      if (other.coords[0][0] - bounceX < 0) {
        other.centroidX += bounceX;
      }
      else {
        xpos -= bounceX;
      }
    }
    else {
       if (other.coords[0][0] + bounceX > width) {
        other.centroidX -= bounceX;
      }
      else {
        xpos += bounceX;
      }
    }
    if (otherY > ypos) {
      if (other.coords[0][1] + bounceY < 0) {
        other.centroidY += bounceY;
      }
      else {
        ypos -= bounceY;
      }
    }
    else {
      if (other.coords[0][1] + bounceY > height) {
        other.centroidY -= bounceY;
      }
      else {
        ypos += bounceY;
      }
    }
  }
  
  void bulletCheck(PlayerShip p) {
    for (int i = 0; i < (p.bullets).length; i++) {
      Bullet b = p.bullets[i];
      if (!b.onHold) {
        float hypotenuse = sq(xpos - b.x) + sq(ypos - b.y);
        if (sqrt(hypotenuse) <= b.rad + diameter/2) {
          b.x = 3000;
          b.y = 3000;
        }
      }
    }
  }
  
  void wallCheck(Wall o) {
    float wallT = o.ycor;
    float wallB = o.ycor + o.h;
    float wallL = o.xcor;
    float wallR = o.xcor + o.w;
    float bulletT = ypos - diameter/2;
    float bulletB = ypos + diameter/2;
    float bulletL = xpos - diameter/2;
    float bulletR = xpos + diameter/2;
    
     if ((bulletT < wallB && bulletT > wallT && bulletL > wallL && bulletL < wallR)
      || (bulletT < wallB && bulletT > wallT && bulletR < wallR && bulletR > wallL)
      || (bulletB < wallB && bulletB > wallT && bulletL > wallL && bulletL < wallR)
      || (bulletB < wallB && bulletB > wallT && bulletR < wallR && bulletR > wallL)) {
        angle += PI;
     }
  }
      
  
  void display() {
    stroke(255, 255, 255);
    fill(255, 255, 255);
    ellipse(xpos, ypos, diameter, diameter);
  }
}
