class GravCenter {
  static final float gconst = 6.67428;
  static final float sizemult = 1;
  
  PVector pos;
  float mass;
  float size;
  color c;
  
  GravCenter(float x, float y, float z, float mass) {
    this(x,y,z,mass,mass*GravCenter.sizemult);
  }
  
  GravCenter(float x, float y, float z, float mass, float size) {
    pos = new PVector(x,y,z);
    this.mass = mass;
    this.size = size;
    if(mass > 0) {
      c = #0000E0;
    } else {
      c = #E0E000;
    }
  }
  
  GravCenter(float x, float y, float z, float mass, float size, color c) {
    pos = new PVector(x,y,z);
    this.mass = mass;
    this.size = size;
    this.c = c;
  }
  
  float getMass() {
    return mass;
  }
  
  float getSize() {
    return size;
  }
  
  /*PVector getInducedAccelerationOn(Particle p) {
    PVector res = new PVector(pos.x-p.pos.x,pos.y-p.pos.y,pos.z-p.pos.z);
    res.setMag(multSign(mass, p.mass)*forcemult*gconst*mass/squared(pos.dist(p.pos)));
    return res;
  }*/
  
  void display() {
    if(depthful) {
      fill(c); 
      pushMatrix();
      translate(zoom*pos.x, zoom*pos.y, zoom*pos.z);
      sphere(size*zoom*0.5);
      popMatrix();
    } else {
      stroke(c);
      strokeWeight(size*zoom);
      point(zoom*pos.x, zoom*pos.y, zoom*pos.z);
    }
  }
  
  PVector getDisplacementFrom(PVector v) {
    return new PVector(pos.x-v.x, pos.y-v.y, pos.z-v.z);
  }
  
  PVector getDisplacementTo(PVector v) {
    return new PVector(v.x-pos.x, v.y-pos.y, v.z-pos.z);
  }
}
