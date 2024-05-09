import java.util.Iterator;

class Particle extends GravCenter {
  static final float sizemult = 2;
  
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
  
  Particle(float x, float y, float z, float mass, float dx, float dy, float dz) {
    super(x,y,z,mass);
    
    if(mass > 0) {
      c = #E00000;
    } else {
      c = #00E000;
    }
    
    vel = new PVector(dx,dy,dz);
    
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
  
  void setVelocity(float dx, float dy, float dz) {
    vel.set(dx,dy,dz);
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
      trail.add(pos);
    }
    
    pos.add(vel);
    checkBoundaries();
    
    vel.add(getResultingAccelerationFrom(gravs, particles));
    vel.div(frictionmult);
  }
  
  void update(ArrayList<GravCenter> gravs) {
    if(trails) {
      trail.add(pos);
    }
    
    pos.add(vel);
    checkBoundaries();
    
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
    stroke(c);
    strokeWeight(mass*Particle.sizemult);
    point(pos.x, pos.y, pos.z);
    
    if(trails) {
      trail.display();
    }
  }
  
  void resetTrail() {
    trail.reset();
  }
  
  class Trail implements Iterable {// TODO: this
    static final int size = 1;
    
    Node head;
    Node tail;
    int count = 0;
    
    Trail() {
      
    }
  
    void display() {
      stroke(c);
      // TODO: iterate and display
    }
    
    void add(PVector pos) {
      Node newest = new Node(pos);
      if(count == 0) {
        head = newest;
        tail = newest;
        count++;
      } else if(count < mass*Particle.sizemult) {
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
      private Node curr;
      
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
