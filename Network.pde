// network object

class Network {


  // only need to evaluate every connecetion made ie: not #1 to #1 and either #2 to #3 or 3# to #2
  // thus a sort of hash table? or a mock 2d array?
  ArrayList<Integer> g = new ArrayList<Integer>();


  Network() {
  }

  // build the array
  void init(int _i, int _j) {


    g.add(_i);
    g.add(_j);
  }




  void display(float strength) {


    for (int i = 0; i < g.size(); i++) {
      if (i == g.size()-1) break;

      // evaluate the strength of this connection (w/ arbitrary weights)
      // absolute maths to get the two values within 40% of eachother
      if (abs(p[g.get(i+1)].open-p[g.get(i)].open)>(p[g.get(i+1)].open/2)) {
      } 
      else {
        strength += 0.3;
        //p[g.get(i)].str += 1;
        //p[g.get(i+1)].str += 1;
      }

      if (abs(p[g.get(i+1)].cons-p[g.get(i)].cons)>(p[g.get(i+1)].cons/4)) {
      } 
      else {
        strength += 0.3;
        //p[g.get(i)].str += 1;
        //p[g.get(i+1)].str += 1;
      }

      if (abs(p[g.get(i+1)].extra-p[g.get(i)].extra)>(p[g.get(i+1)].extra/1.2)) {
      } 
      else {
        strength += 0.3;
        //p[g.get(i)].str += 1;
        //p[g.get(i+1)].str += 1;
      }

      if (abs(p[g.get(i+1)].agree-p[g.get(i)].agree)>(p[g.get(i+1)].agree/2)) {
      } 
      else {
        strength += 0.5;
        //p[g.get(i)].str += 1;
        //p[g.get(i+1)].str += 1;
      }

      if (abs(p[g.get(i+1)].neuro-p[g.get(i)].agree)>(p[g.get(i+1)].neuro/4)) {
      } 
      else {
        strength += 0.3;
        //p[g.get(i)].str += 1;
        //p[g.get(i+1)].str += 1;
      }
      if (dist(p[g.get(i)].x, p[g.get(i)].y, p[g.get(i+1)].x, p[g.get(i+1)].y) <= 30) {
        strength += 0.2;
      }

      //add up all the strengths and set them 
        p[g.get(i)].str = strength;
      p[g.get(i+1)].str = strength;



      // }

      // draw network based on strengths
      pushStyle();
      stroke(55);
      strokeWeight(p[g.get(i)].str + p[g.get(i+1)].str);
      if (p[g.get(i)].x != 850 && p[g.get(i+1)].x != 850) line(p[g.get(i)].x, p[g.get(i)].y, p[g.get(i+1)].x, p[g.get(i+1)].y);
      popStyle();

      // reset the cumulative strength for the next set of connections
      strength = 0;
    }

    // emit particles every 100 frames
    if (frameInc == 100 && particles.size() < maxParticles) {
      for (int i = 0; i < p.length; i++) {

        for (int j = 0; j < p.length; j++) {


          // if the strength is greater than  and the two being compared are not the same
          if (p[i].str+p[j].str > particleCutoff && i != j && p[j].x != 850) {


            particles.add(new Particle(new PVector(p[i].x, p[i].y), new PVector(p[j].x, p[j].y), i, j));
          }
        }
      }
    }
  }
}

