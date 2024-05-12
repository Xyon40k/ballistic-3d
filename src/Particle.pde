import java.util.Iterator;

class Particle extends GravCenter {
  static final float sizemult = 1;
  static final int defaulttraillength = 100;
  static final int trailupdateperiod = 5;
  
  PVector vel;
  PVector nextVel;
  Trail trail;
  int trailupdatecounter = 0;
  
  Particle(float x, float y, float z, float mass) {
    this(x,y,z,mass,mass*Particle.sizemult);
  }
  
  Particle(float x, float y, float z, float mass, float size) {
    super(x,y,z,mass,size);
    
    if(mass > 0) {
      c = #E00000;
    } else {
      c = #00E000;
    }
    
    vel = new PVector(0,0,0);
    
    if(trails) {
      trail = new Trail(defaulttraillength);
    }
  }
  
  Particle(float x, float y, float z, float mass, float size, color c) {
    super(x,y,z,mass,size,c);
    
    vel = new PVector(0,0,0);
    
    if(trails) {
      trail = new Trail(defaulttraillength);
    }
  }
  
  Particle setVelocity(float dx, float dy, float dz) {
    vel.set(dx,dy,dz);
    return this;
  }
  
  Particle setVelocity(PVector nv) {
    vel.set(nv);
    return this;
  }
  
  float getSpeed() {
    return vel.mag();
  }
  
  Particle setSpeed(float s) {
    vel.setMag(s);
    return this;
  }
  
  void checkBoundaries() {
    if(bounded) {
      if(abs(pos.x) > boundaries.x) {
        pos.x = sgn(pos.x)*boundaries.x;
        vel.x *= -1;
      }
      
      if(abs(pos.y) > boundaries.y) {
        pos.y = sgn(pos.y)*boundaries.y;
        vel.y *= -1;
      }
      
      if(abs(pos.z) > boundaries.z) {
        pos.z = sgn(pos.z)*boundaries.z;
        vel.z *= -1;
      }
    }
  }
  
  void update(ArrayList<GravCenter> gravs, ArrayList<Particle> particles) {
    if(trails) {
      if(trailupdatecounter == 0) {
        trail.add(pos.copy());
      }
      
      trailupdatecounter = (trailupdatecounter+1) % Particle.trailupdateperiod;
    }
    
    interactWith(gravs, particles);
    checkBoundaries();
  }
  
  void update(ArrayList<GravCenter> gravs) {
    update(gravs, null);
  }
  
  void interactWith(ArrayList<GravCenter> gravs, ArrayList<Particle> particles) {
    PVector res = new PVector(0,0,0);
    
    PVector tmp;
    for(GravCenter g : gravs) {
      tmp = g.getDisplacementFrom(pos);
      if(tmp.mag() < g.getSize()+size) {
        // TODO: implement elastic collision
      }
      tmp.setMag(multSign(mass, g.getMass())*forcemult*gconst*g.getMass()/g.getDisplacementFrom(pos).magSq());
      res.add(tmp);
    }
    
    if(particles != null) {
      for(Particle p : particles) {
        if(p == this) {
          continue;
        }
        
        tmp = p.getDisplacementFrom(pos);
        tmp.setMag(multSign(mass, p.getMass())*forcemult*gconst*p.getMass()/p.getDisplacementFrom(pos).magSq());
        res.add(tmp);
      }
    }
    
    nextVel = PVector.add(vel, res).div(frictionmult);
  }
  
  void interactWith(ArrayList<GravCenter> gravs) {
    interactWith(gravs, null);
  }
  
  void collapseUpdate() {
    vel = nextVel;
  }
  
  void move() {
    pos.add(vel);
  }
  
  /*@Override
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
    
    if(particles != null) {
      for(Particle p : particles) {
        res.add(p.getInducedAccelerationOn(this));
      }
    }
    
    return res;
  }
  
  PVector getResultingAccelerationFrom(ArrayList<GravCenter> gravs) {
    return getResultingAccelerationFrom(gravs, null);
  }*/
  
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
  
  class Trail implements Iterable<PVector> {
    static final int drawsize = 1;
    
    Node head;
    Node tail;
    int capacity;
    int count = 0;
    color startc = c;
    color endc = #D2E33D;
    
    Trail(int cap, color startc, color endc) {
      this.startc = startc;
      this.endc = endc;
      capacity = cap;
    }
    
    Trail(int cap) {
      capacity = cap;
    }
  
    void display() {
      strokeWeight(Trail.drawsize);
      
      PVector last = pos;
      int i = 0;
      for(PVector p : this) {
        stroke(getGradient(startc, endc, (i+1)*(1.0f/capacity)));
        line(zoom*last.x,zoom*last.y,zoom*last.z,zoom*p.x,zoom*p.y,zoom*p.z);
        last = p;
        i++;
      }
      
      noStroke();
    }
    
    void add(PVector pos) {
      Node newest = new Node(pos);
      if(count == 0) {
        head = newest;
        tail = newest;
        count++;
      } else if(count < capacity) {
        newest.setNext(head);
        head.setPrev(newest);
        head = newest;
        count++;
      } else {
        newest.setNext(head);
        head.setPrev(newest);
        head = newest;
        tail.getPrev().setNext(null);
        tail = tail.getPrev();
      }
    }
    
    void reset() {
      head = null;
      tail = null;
      count = 0;
    }
    
    TrailIterator iterator() {
      return new TrailIterator();
    }
    
    class TrailIterator implements Iterator<PVector> {
      Node curr;
      
      TrailIterator() {
        curr = head;
      }
      
      PVector next() {
        PVector v = curr.getValue();
        curr = curr.getNext();
        return v;
      }
      
      boolean hasNext() {
        return curr != null;
      }
    }
    
    class Node {
      PVector p;
      Node next;
      Node prev;
      
      Node(PVector val) {
        p = val;
      }
      
      PVector getValue() {
        return p;
      }
      
      void setNext(Node n) {
        next = n;
      }
      
      Node getNext() {
        return next;
      }
      
      void setPrev(Node n) {
        prev = n;
      }
      
      Node getPrev() {
        return prev;
      }
    }
  }
}
