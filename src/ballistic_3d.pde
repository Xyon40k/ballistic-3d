// Camera variables
float da = 0.01;

float ax = 0;
float ay = 0;
float az = 0;

float dd = 3;

float dx = 400;
float dy = 400;

float at = 0.0001;
float dt = 0.01;

float zoom = 5;
//

// Simulation variables
float forcemult = 1;
float frictionmult = 1;

boolean trails = false;
boolean coinfluence = false;
boolean bounded = true;
PVector boundaries = new PVector(400,400,400);
//

// Simulated objects
MassiveSystem ms = new MassiveSystem();
//

// Helper functions
float mod2pi(float n) {
  if(n > TAU) {
    return n-TAU;
  } else if(n < 0) {
    return n+TAU;
  }
  return n; 
}

float squared(float f) {
  return f*f;
}

int multSign(float f1, float f2) {
  return f1 >= 0 == f2 >= 0 ? 1 : -1;
}

int sgn(float x) {
  return x > 0 ? 1 : -1;
}
//

void setup() {
  size(800,800,P3D);
  stroke(#FFFFFF);
  strokeCap(ROUND);
  strokeWeight(3);
  
  ms.add(new GravCenter(0,0,0,10));
  ms.add(new Particle(80,0,0,5,0,1,0));
}

void draw() {
  translate(dx, dy);
  rotateX(ax);
  rotateY(ay);
  rotateZ(az);
  
  background(0);
  
  ms.update();
  ms.display();
  
  if(keyPressed) {
    if(key == CODED) {
      switch(keyCode) {
        case UP:
          dy += dd;
          break;
          
        case DOWN:
          dy -= dd;
          break;
        
        case RIGHT:
          dx -= dd;
          break;
        
        case LEFT:
          dx += dd;
          break;
      }
    } else {
      switch(key) {
        case 'a':
          ay = mod2pi(ay+da);
          break;
          
        case 'd':
          ay = mod2pi(ay-da);
          break;
          
        case 'w':
          ax = mod2pi(ax-da);
          break;
          
        case 's':
          ax = mod2pi(ax+da);
          break;
        
        case 'q':
          az = mod2pi(az-da);
          break;
          
        case 'e':
          az = mod2pi(az+da);
          break;
          
        case '+':
          zoom += zoom*0.01;
          break;
          
        case '-':
          zoom -= zoom*0.01;
          break;
          
        case 'o':
          dt -= at;
          break;
          
        case 'p':
          dt += at;
          break;
      }
    }
  }
}
