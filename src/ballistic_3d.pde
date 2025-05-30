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

float zoom = 1;
//

// Simulation variables
float forcemult = 1;
float frictionmult = 1;
float refinement = 3; // TODO: implement this somehow
float minDist = 0.1;

boolean trails = true;
boolean depthful = true;

boolean coinfluence = false; // TODO: fix influence when rho=0
boolean bounded = false;
PVector boundaries = new PVector(400,400,400);
boolean collisions = true;
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

color getGradient(color startc, color endc, float t) {
  int r1 = (startc >> 16) & 0xFF;
  int g1 = (startc >> 8) & 0xFF;
  int b1 = startc & 0xFF;

  int r2 = (endc >> 16) & 0xFF;
  int g2 = (endc >> 8) & 0xFF;
  int b2 = endc & 0xFF;

  return color(r1+t*(r2-r1), g1+t*(g2-g1), b1+t*(b2-b1));
}
//

void setup() {
  size(800,800,P3D);
  if(!depthful) {
    stroke(#FFFFFF);
    strokeCap(ROUND);
  } else {
    sphereDetail(12,6);
    noStroke();
  }
  
  // two gravs with circle spread of particles, coinf = off
  //ms.add(new GravCenter(-100,0,0,20));
  //ms.add(new GravCenter(100,0,0,20));
  //for(int i = 0; i < 12; i++) {
  //  ms.add(new Particle(0,0,0,5).setVelocity(sin(i*TAU/12),2*cos(i*TAU/12),2*sin(i*TAU/12)).setInfiniteTrail());
  //}
  
  // tetrahedron of particles with grav core, coinf = on
  //ms.add(new Particle(100,-100,-100,5).setVelocity(-1,1,0).setInfiniteTrail());
  //ms.add(new Particle(-100,100,-100,5).setVelocity(0,-1,1).setInfiniteTrail());
  //ms.add(new Particle(-100,-100,100,5).setVelocity(1,1,0).setInfiniteTrail());
  //ms.add(new Particle(100,100,100,5).setVelocity(0,-1,-1).setInfiniteTrail());
  //ms.add(new GravCenter(0,0,0,25));
  
  // triangle of gravs with 3 particles, coinf = off
  //for(int i = 0; i < 3; i++) {
  //  ms.add(new GravCenter(100*sin(i*TAU/3),100*-cos(i*TAU/3),0, 20));
  //  ms.add(new Particle(0,0,0,5).setVelocity(2*sin((i+0.6)*TAU/3),2*-cos((i+0.6)*TAU/3),0).setInfiniteTrail());
  //}
  
  // cube of gravs with random velocity particles, coinf = off
  for(int i = 0; i < 8; i++) {
    ms.add(new GravCenter(100*((i&1)*2-1),100*((i>>1&1)*2-1),100*((i>>2&1)*2-1), 20));
  }
  ms.add(new Particle(0,0,0,5).setVelocity(PVector.random3D().mult(2)).setInfiniteTrail());
  
  //ms.add(new GravCenter(0,0,0,10));
  //ms.add(new Particle(100,10,0,5).setVelocity(-1,1,0).setSpeed(0.1));
  //ms.add(new Particle(-100,-10,0,5).setVelocity(1,-1,0).setSpeed(0.1));
}

void draw() {
  translate(dx, dy);
  rotateX(ax);
  rotateY(ay);
  rotateZ(az);
  
  background(0);
  
  ms.update();
  ms.display();
  
  // Camera controls
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
        case 'c':
          ms.cleanup();
          break;
          
        case 't':
          ms.slow();
          break;
          
        case 'r':
          ms.resetTrails();
          break;
        
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
