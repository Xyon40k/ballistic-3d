class MassiveSystem {
  static final float maxacceptablespeed = 5; // TODO: find a good value
  
  ArrayList<GravCenter> gravs;
  ArrayList<Particle> particles;
  
  MassiveSystem() {
    gravs = new ArrayList<GravCenter>();
    particles = new ArrayList<Particle>();
  }
  
  void add(Particle p) {
    particles.add(p);
  } 
  
  void add(GravCenter g) {
    gravs.add(g);
  }
  
  void update() {
    if(coinfluence) {
      for(Particle p : particles) {
        p.update(gravs, particles);
      }
    } else {
      for(Particle p : particles) {
        p.update(gravs);
      }
    }
  }
  
  void display() {
    for(Particle p : particles) {
      p.display();
    }
    
    for(GravCenter g : gravs) {
      g.display();
    }
  }
  
  void resetTrails() {
    for(Particle p : particles) {
      p.resetTrail();
    }
  }
  
  void clearParticles() {
    particles.clear();
  }
  
  void clearGravCenters() {
    gravs.clear();
  }
  
  void cleanup() {
    Iterator<Particle> it = particles.iterator();
    while(it.hasNext()) {
      if(it.next().getSpeed() > MassiveSystem.maxacceptablespeed) {
        it.remove();
      }
    }
  }
}
