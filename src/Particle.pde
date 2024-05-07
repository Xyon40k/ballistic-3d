class Particle extends GravCenter {
  static final float sizemult = 1;
  
  PVector vel;
  Trail trail;
  
  Particle(float x, float y, float z, float mass) {
    super(x,y,z,mass);
    
    if(mass > 0) {
      c = #E00000;
    } else {
      c = #00E000;
    }
    
    vel = new PVector(0,0,0);
    
    if(trails) {
      resetTrail();
    }
  }
  
  Particle(float x, float y, float z, float mass, color c) {
    super(x,y,z,mass,c);
    
    vel = new PVector(0,0,0);
    
    if(trails) {
      resetTrail();
    }
  }
  
  void update(ArrayList<GravCenter> gravs, ArrayList<Particle> particles) {
    if(trails) {
      trail.add(pos);
    }
    
    pos.add(vel);
    vel.add(getResultingAccelerationFrom(gravs, particles));
    vel.div(frictionmult);
  }
  
  void update(ArrayList<GravCenter> gravs) {
    if(trails) {
      trail.add(pos);
    }
    
    pos.add(vel);
    vel.add(getResultingAccelerationFrom(gravs));
    vel.div(frictionmult);
  }
  
  @Override
  PVector getInducedAccelerationOn(Particle p) {
    if(p == this) {
      return new PVector(0,0,0);
    }
    return super.getInducedAccelerationOn(p);
  }
  
  PVector getResultingAccelerationFrom(ArrayList<GravCenter> gravs, ArrayList<Particle> particles) {
    PVector res = new PVector(0,0,0);
    for(GravCenter g : gravs) {
      res.add(g.getInducedAccelerationOn(this));
    }

    for(Particle p : particles) {
      res.add(p.getInducedAccelerationOn(this));
    }
    
    return res;
  }
  
  PVector getResultingAccelerationFrom(ArrayList<GravCenter> gravs) {
    PVector res = new PVector(0,0,0);
    for(GravCenter g : gravs) {
      res.add(g.getInducedAccelerationOn(this));
    }
    
    return res;
  }
  
  @Override
  void display() {
    super.display();
    
    if(trails) {
      trail.display();
    }
  }
  
  void resetTrail() {
    trail.reset();
  }
  
  class Trail { // TODO: this
    void display() {
      
    }
    
    void add(PVector pos) {
      
    }
    
    void reset() {
      
    }
  }
}
