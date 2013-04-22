// particle class

class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;

  // aiming vector
  PVector attractor;
  

  float lifespan;

  // this particle's emitter and the one it was aiming for
  int index, jndex;


  //constructor
  Particle(PVector l, PVector _attract, int _index, int _jndex) {
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
    location = l.get();
    // particle lifespan
    lifespan = 200.0;
    attractor = _attract.get();

    index = _index;
    jndex = _jndex;
  }

  void run() {
    update();
    display();

    collision();
  }

  // Method to update location
  void update() {

    velocity.limit(1);
    acceleration.limit(1);

    velocity.add(acceleration);
    location.add(velocity);
    lifespan -= 2.0;

    PVector diff = PVector.sub(attractor, location);

    diff.normalize();
    diff.mult(1);

    acceleration.set(diff);
    
    // each particle colorizes the heatmap according to it's location
    apply_heat((int)location.x/2, (int)location.y/2, 3, .1);


    if (lifespan < 0.0) {
      particles.remove(this);
    }

    // remove particles if the get within a certain distance of the target player   
    if (dist(p[jndex].x, p[jndex].y, location.x, location.y) <= 5) {
      particles.remove(this);
    }


  }

  // Method to display
  void display() {
    stroke(0);
    noFill();
    ellipse(location.x, location.y, 4, 4);
  }

  void collision() {
    // for all the players
    for (int i = 0; i < p.length; i++) {
      // if the hit particle is not the one that emitted it
      if (i != index && particles.size() < maxParticles) {
        // for all the other players, not the emitter
        for (int j = 0; j < p.length; j++) {
          // if there is a collision
          if (dist(p[i].x, p[i].y, location.x, location.y) <= 5) {
            // if strength is within thresholds, and not aimed at the emitting player and not aimed at the target player
            if (p[i].str + p[j].str > particleCutoff && i != j && j != jndex && j != index && p[j].x != 850) {
              // emitt more particles
              particles.add(new Particle(new PVector(p[jndex].x, p[jndex].y), new PVector(p[j].x, p[j].y), jndex, j));
            }
          }
        }
      }
    }
  }
}

