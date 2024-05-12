class GravCenter {
  static final float gconst = 6.67428;
  static final float sizemult = 1;
  
  PVector pos;
  float mass;
  color c;
  
  GravCenter(float x, float y, float z, float mass) {
    pos = new PVector(x,y,z);
    this.mass = mass;
    if(mass > 0) {
      c = #0000E0;
    } else {
      c = #E0E000;
    }
  }
  
  GravCenter(float x, float y, float z, float mass, color c) {
    pos = new PVector(x,y,z);
    this.mass = mass;
    this.c = c;
  }
  
  PVector getInducedAccelerationOn(Particle p) {
    PVector res = new PVector(pos.x-p.pos.x,pos.y-p.pos.y,pos.z-p.pos.z);
    res.setMag(multSign(mass, p.mass)*forcemult*gconst*mass/squared(pos.dist(p.pos)));
    return res;
  }
  
  void display() {
    if(depthful) {
      fill(c); 
      pushMatrix();
      translate(zoom*pos.x, zoom*pos.y, zoom*pos.z);
      sphere(mass*GravCenter.sizemult*zoom*0.5);
      popMatrix();
    } else {
      stroke(c);
      strokeWeight(mass*GravCenter.sizemult*zoom);
      point(zoom*pos.x, zoom*pos.y, zoom*pos.z);
    }
  }
}
