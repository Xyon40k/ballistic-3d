class MassiveSystem {
  static final float maxacceptablespeed = 5; // TODO: find a good value
  
  ArrayList<GravCenter> gravs;
  
  MassiveSystem() {
    gravs = new ArrayList<GravCenter>();
  }
  
  void add(GravCenter g) {
    gravs.add(g);
  }
  
  void update() {
    for(GravCenter g : gravs) {
      if(g instanceof Particle) {
        ((Particle)g).move(); 
      }
    }
    
    for(GravCenter g : gravs) {
      if(g instanceof Particle) {
        ((Particle)g).update(gravs); 
      }
    }
    
    for(GravCenter g : gravs) {
      if(g instanceof Particle) {
        ((Particle)g).collapseUpdate(); 
      }
    }
  }
  
  void display() {
    for(GravCenter g : gravs) {
      g.display();
    }
  }
  
  void resetTrails() {
    for(GravCenter g : gravs) {
      if(g instanceof Particle) {
        ((Particle)g).resetTrail(); 
      }
    }
  }
  
  void clear() {
    gravs.clear();
  }
  
  void cleanup() {
    Particle p;
    for(int i = 0; i < gravs.size(); i++) {
      if(gravs.get(i) instanceof Particle) {
        p = (Particle)gravs.get(i);
        if(p.getSpeed() > MassiveSystem.maxacceptablespeed) {
          gravs.remove(i);
        }
      }
    }
  }
  
  void slow() {
    Particle p;
    for(int i = 0; i < gravs.size(); i++) {
      if(gravs.get(i) instanceof Particle) {
        p = (Particle)gravs.get(i);
        if(p.getSpeed() > MassiveSystem.maxacceptablespeed) {
          p.setSpeed(0);
        }
      }
    }
  }
}
