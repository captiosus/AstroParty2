class PlayerShip {
  float[][] coords = new float[3][2];
  float centroidX;
  float centroidY;
  float rotateAngle;
  float triAng1;
  float triAng2;
  float radiusPoint;
  float radiusBase;
  int player;
  int red;
  int green;
  int blue;
  
  boolean dead = false;
  boolean shipDetect = false;
  
  int w = 40;
  int h = 20;
  float errorPoint = 1;
  
  int circleHitbox = 20;
  
  int bulletSpeed = 8;
  int numBullets = 3;
  Bullet[] bullets = new Bullet[numBullets];
  
  boolean destroyed;
  boolean wallCollide;
  
  int numKills = 0;
  
  PlayerShip(int x, int y, int player) {
    destroyed = false;
    for (int i = 0; i < bullets.length; i++) {
      bullets[i] = new Bullet(player);
      bullets[i].hold(i, numBullets, centroidX, centroidY);
    }
    coords[0][0] = x;
    coords[0][1] = y;
    coords[1][0] = x - w;
    coords[1][1] = y + h/2;
    coords[2][0] = x - w;
    coords[2][1] = y - h/2;
    centroidX = (coords[0][0] + coords[1][0] + coords[2][0])/3;
    centroidY = (coords[0][1] + coords[1][1] + coords[2][1])/3;
    float c2bX = abs(coords[1][0] - centroidX);
    float c2bY = abs(coords[1][1] - centroidY);
    triAng1 = PI - atan(c2bX/c2bY);
    triAng2 = PI + atan(c2bX/c2bY);
    radiusBase = sqrt(pow(c2bX, 2) + pow(c2bY, 2));
    radiusPoint = abs(x - centroidX);
    if (player == 0) {
      red = 255;
      green = 0;
      blue = 0;
    }
    else if (player == 1) {
      red = 0;
      green = 0;
      blue = 255;
    }
    else if (player == 2) {
      red = 0;
      green = 255;
      blue = 0;
    }
    else if (player == 3) {
      red = 230;
      green = 0;
      blue = 255;
    }
  }
  
  void rotate(float angle) {
    rotateAngle += angle;
    if (rotateAngle > PI/2) {
      rotateAngle -= 2*PI;
    }
  }
  
  void moveForward(int speed) {
    if (!(coords[0][0] > width || coords[0][0] < 0 || 
    coords[0][1] > height || coords[0][1] < 0) && !(shipDetect)) {
      centroidX += speed * cos(rotateAngle);
      centroidY += speed * sin(rotateAngle);
    }
  }
  
  boolean circleIntersect(PlayerShip other) {
    if (destroyed || other.destroyed) {
      return false;
    }
    float xDistance = centroidX - other.centroidX;
    float yDistance = centroidY - other.centroidY;
    float hypotenuse = sqrt(pow(xDistance, 2) + pow(yDistance, 2));
    if (hypotenuse < circleHitbox) {
      bounce(hypotenuse, xDistance, yDistance, other.centroidX, other.centroidY, other);
      return true;
    }
    return false;
  }
    
  
  void bounce(float hypotenuse, float xDistance, 
  float yDistance, float otherX, float otherY, PlayerShip other) {
    float angle = atan(yDistance/xDistance);
    float bounceDistance = circleHitbox - hypotenuse;
    float bounceX = cos(angle) * bounceDistance + 1;
    float bounceY = sin(angle) * bounceDistance + 1;
    if (otherX > centroidX) {
      if (coords[0][0] - bounceX < 0) {
        other.centroidX += bounceX;
      }
      else {
        centroidX -= bounceX;
      }
    }
    else {
       if (coords[0][0] + bounceX > width) {
        other.centroidX -= bounceX;
      }
      else {
        centroidX += bounceX;
      }
    }
    if (otherY > centroidY) {
      if (coords[0][1] + bounceY < 0) {
        other.centroidY += bounceY;
      }
      else {
        centroidY -= bounceY;
      }
    }
    else {
      if (coords[0][1] + bounceY > height) {
        other.centroidY -= bounceY;
      }
      else {
        centroidY += bounceY;
      }
    }
  }
  
  boolean inBounds() {
    return !(coords[0][0] > width || coords[0][0] < 0 || 
    coords[0][1] > height || coords[0][1] < 0 ||
    coords[1][0] > width || coords[1][0] < 0 || 
    coords[1][1] > height || coords[1][1] < 0 ||
    coords[2][0] > width || coords[2][0] < 0 || 
    coords[2][1] > height || coords[2][1] < 0);
  }

  boolean squareCheck(PlayerShip other) {
    if (abs(centroidX - other.centroidX) < 2*radiusPoint 
    && abs(centroidY - other.centroidY) < 2*radiusPoint) {
      return true;
    }
    else {
      return false;
    }
  }
  void update() {
    coords[0][0] = centroidX + radiusPoint * cos(rotateAngle);
    coords[0][1] = centroidY + radiusPoint * sin(rotateAngle);
    coords[1][0] = centroidX + radiusBase * cos(rotateAngle + triAng1);
    coords[1][1] = centroidY + radiusBase * sin(rotateAngle + triAng1);
    coords[2][0] = centroidX + radiusBase * cos(rotateAngle + triAng2);
    coords[2][1] = centroidY + radiusBase * sin(rotateAngle + triAng2);
  }
  
  boolean intersect(float[] P1 , float[] P2, float[] Q1, float[] Q2) {
    float denominator=((P2[0]-P1[0])*(Q2[1]-Q1[1]))-((P2[1]-P1[1])*(Q2[0]-Q1[0]));
    float num1=((P1[1]-Q1[1])*(Q2[0]-Q1[0]))-((P1[0]-Q1[0])*(Q2[1]-Q1[1]));
    float num2=((P1[1]-Q1[1])*(P2[0]-P1[0]))-((P1[0]-Q1[0])*(P2[1]-P1[1]));
    
    if (denominator == 0) {
      return (num1 == 0 && num2 == 0);
    }
    
    float r = num1 / denominator;
    float s = num2 / denominator;
    
    return (r >= 0 && r <= 1) && (s >= 0 && s<= 1);
  }

  void shoot() {
    for (int i = 0; i < bullets.length; i++) {
      if (bullets[i].onHold == true) {
        bullets[i].shoot(coords[0][0], coords[0][1], rotateAngle);
        break;
      }
    }
  }

  void bullet() {
    for (int i = 0; i < bullets.length; i++) {
      Bullet b = bullets[i];
      b.rotate += PI/100;
      if (b.onHold == false && !(b.x > width + b.rad || b.x < 0 - b.rad || 
      b.y > height + b.rad|| b.y < 0 - b.rad)) {
        b.moveForward(bulletSpeed); 
      }
      else {
        if (b.reloadCounter < b.reload && b.onHold == false) {
          b.reloadCounter++;
        }
        else {
          b.hold(i, numBullets, centroidX, centroidY);
        }
      }
      b.display();
    }
  }
  
  boolean squareCheckBullet(Bullet b) {
    float squareX = centroidX - radiusPoint;
    float squareY = centroidY - radiusPoint;
    float closestX;
    float closestY;
    if (b.x < squareX) {
      closestX = squareX;
    }
    else if (b.x > squareX + 2*radiusPoint) {
      closestX = squareX + 2*radiusPoint;
    }
    else {
      closestX = b.x;
    }
    if (b.y < squareY) {
      closestY = squareY;
    }
    else if (b.y > squareY + 2*radiusPoint) {
      closestY = squareY + 2*radiusPoint;
    }
    else {
      closestY = b.y;
    }
    if(pow((closestX - b.x), 2) + pow((closestY - b.y), 2) < pow(b.rad, 2)) {
      return true;
    }
    return false;
  }
  
  boolean bulletCollide(Bullet b) {
    PVector side1 = new PVector(coords[0][0] - coords[1][0], coords[0][1] - coords[1][1]);
    PVector side2 = new PVector(coords[0][0] - coords[2][0], coords[0][1] - coords[2][1]);
    PVector side3 = new PVector(coords[1][0] - coords[2][0], coords[1][1] - coords[2][1]);
    PVector test1 = new PVector(b.x - coords[0][0], b.y - coords[0][1]);
    PVector test2 = new PVector(b.x - coords[1][0], b.y - coords[1][1]);
    PVector test3 = new PVector(b.x - coords[2][0], b.y - coords[2][1]);
    float yDist1 = test1.dot(side1)/side1.mag();
    float xDist1 = pow(test1.mag(), 2) - pow(yDist1, 2);
    float yDist2 = test2.dot(side2)/side2.mag();
    float xDist2 = pow(test2.mag(), 2) - pow(yDist2, 2);
    float yDist3 = test3.dot(side3)/side3.mag();
    float xDist3 = pow(test3.mag(), 2) - pow(yDist3, 2);
    if (xDist1 <= pow(b.rad, 2)) {
      if (test1.dot(side1) > 0 && yDist1 < side1.mag()) {
        return true;
      }
    }
    else if (xDist2 <= pow(b.rad, 2)) {
      if (test2.dot(side2) > 0 && yDist2 < side2.mag()) {
        return true;
      }
    }
    else if (xDist3 <= pow(b.rad, 2)) {
      if (test3.dot(side3) > 0 && yDist3 < side3.mag()) {
        return true;
      }
    }
    return false;
  }
  
  void destroy() {
    destroyed = true;
  }
  
  void display() {
    stroke(255, 255, 255);
    fill(red, green, blue);
    triangle(coords[0][0], coords[0][1], coords[1][0], coords[1][1],
    coords[2][0], coords[2][1]);
    bullet();
  }
  
 /* 
  boolean intersect(float[] P1 , float[] P2, float[] Q1, float[] Q2) {
    float denominator=((P2[0]-P1[0])*(Q2[1]-Q1[1]))-((P2[1]-P1[1])*(Q2[0]-Q1[0]));
    float nu;
        i--;1[0])*(Q2[1]-Q1[1]));
    float num2=((P1[1]-Q1[1])*(P2[0]-P1[0]))-((P1[0]-Q1[0])*(P2[1]-P1[1]));
    
    if (denominator == 0) {
      return (num1 == 0 && num2 == 0);
    }
    
    float r = num1 / denominator;
    float s = num2 / dominator;
    
    return (r >= 0 && r <= 1) && (s >= 0 && s<= 1);
  }

  boolean triangleCheck(PlayerShip other) {
    boolean[] tests = new boolean[9];
    tests[0] = intersect(coords[0], coords[1], other.coords[0], other.coords[1]);    
    tests[1] = intersect(coords[0], coords[1], other.coords[1], other.coords[2]); 
    tests[2] = intersect(coords[0], coords[1], other.coords[0], other.coords[2]);  
    tests[3] = intersect(coords[1], coords[2], other.coords[0], other.coords[1]);  
    tests[4] = intersect(coords[1], coords[2], other.coords[1], other.coords[2]);  
    tests[5] = intersect(coords[1], coords[2], other.coords[0], other.coords[2]);  
    tests[6] = intersect(coords[0], coords[2], other.coords[0], other.coords[1]);  
    tests[7] = intersect(coords[0], coords[2], other.coords[1], other.coords[2]);  
    tests[8] = intersect(coords[0], coords[2], other.coords[0], other.coords[2]);  
    for (int x = 0; x < tests.length; x++) {
      if (tests[x]) {
        return true;
      }
    }
    return false;
  }
  */
}
