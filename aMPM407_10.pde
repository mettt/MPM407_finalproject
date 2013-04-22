// O.C.E.A.N. by Julian Dubrawski
// MPM407


import webcam.*;
import processing.video.*;
import topcodes.*;
import java.util.List; // need this to be explicit in 2.0 onward



Capture cam;
// top code scanner
topcodes.Scanner scanner; 

// 12 player objects
Player p[] = new Player[12];

// some hardcoded topcode identifiers
int[] identities = { 
  91, 93, 151, 155, 199, 203, 241, 271, 309, 313, 357, 361
};

// the network object
Network n = new Network();


// the list of particles
ArrayList<Particle> particles;


int maxParticles = 200;

// ui box positioning
int boxX = 500;
int boxY = 300;

// a constant that determines which player to send particles to
float particleCutoff = 1.8; // higher = less particles

float frameInc;

// generate a heatmap
float heatmap[][][] = new float[2][400][300];
int index = 0;
Gradient g;

// heatmap image at half size
int heatmapW = 400;
int heatmapH = 300;

PImage img = createImage(400, 300, RGB);


void setup() {

  size(800, 600);
  textSize(18);
  noSmooth();

  colorMode(HSB);

  //cam = new Capture(this, 800, 600, "USB Video Device");
  cam = new Capture(this, 640, 480);
  cam.start();

  scanner = new topcodes.Scanner(); // instantiate the object


  // each player gets a topcode number assigned to it
  for (int i=0; i < p.length; i++) {
    p[i] = new Player(identities[i]);
  }

  // build the network
  for (int i = 0; i < p.length-1; i++) {
    for (int j = 1+i; j < p.length; j++) {

      n.init(i, j);
    }
  }

  // new empty arraylist of particles
  particles = new ArrayList<Particle>();


  // gradient colourations
  g = new Gradient();
  g.addColor(color(205, 0, 255));
  g.addColor(color(205, 80, 200));
  g.addColor(color(180, 255, 120));
  g.addColor(color(180, 160, 255));
  g.addColor(color(180, 200, 255));


  // Initalize the heat map (make sure everything is 0.0)
  for (int i = 0; i < heatmapW; ++i)
    for (int j = 0; j < heatmapH; ++j)
      heatmap[index][i][j] = 0.0;
}


void draw() {


  //background(155);

  // custom frame counter
  frameInc++;


  if (cam.available() == true) { // checking availability manually instead of with event
    cam.read();

    // we need a copy of the pixels array
    // because the scanner modifies the image it is given
    int[] pixelsToTest = new int[cam.pixels.length];
    System.arraycopy(cam.pixels, 0, pixelsToTest, 0, cam.pixels.length);

    // List is a data type, codes is our copy of it
    // declare the List and set to to null (empty).
    List<TopCode> listOfcodes = null;


    // fill the list with any tags we might find
    listOfcodes = scanner.scan(pixelsToTest, cam.width, cam.height);


    // draw the image for reference
    //image(cam, 0, 0);

    // draw the codes (if any)


    // for each code found (sometimes 0 codes so nothing below runs)
    for (int i = 0; i < listOfcodes.size(); i++) {

      // for each Player
      for (int j = 0; j < p.length; j++) {

        // if and only if the player's (hardcoded) identifier matches the physical code
        if (p[j].identifier == listOfcodes.get(i).getCode()) {
          // set location
          // commented code is corrected for distortion between the webcam image and the projected image

          //p[j].x = listOfcodes.get(i).getCenterX() + sin(0.004*listOfcodes.get(i).getCenterX()+1.5)*5;

          p[j].x = listOfcodes.get(i).getCenterX();

          //p[j].y = listOfcodes.get(i).getCenterY()+110 - sin(0.0055*(listOfcodes.get(i).getCenterY()+110)+1.5)*35;

          p[j].y = listOfcodes.get(i).getCenterY();
        }
      }
    }


    //println(listOfcodes.get(i).getCode());
  }


  // main haetmap updater
  update_heatmap();

  // For each pixel, give appropriate colour
  img.loadPixels();
  for (int i = 0; i < heatmapW; ++i) {
    for (int j = 0; j < heatmapH; ++j) {

      img.pixels[j*heatmapW+i] = g.getGradient(heatmap[index][i][j]);
    }
  }
  // update the heatmap image and scale it
  img.updatePixels();
  pushMatrix();
  scale(2, 2);
  image(img, 0, 0);
  popMatrix();




  // update and display the network
  n.display(0);

  // update and display the players
  for (int i = 0; i < p.length; i++) {

    p[i].display();
  }


  // update and display particles
  for (int i = particles.size()-1; i >= 0; i--) {

    Particle p = particles.get(i);
    p.run();
  }

  // roll back the frame ccounter
  if (frameInc == 100) frameInc = 0;
}


// events to select individual players
void mouseReleased() {

  if (mouseX > boxX && mouseX < boxX+200 && mouseY > boxY && mouseY < boxY+200) {
  } 
  else {
    for (int i = 0; i < p.length; i++) {

      if (p[i].x <= mouseX + 20 && p[i].x >= mouseX - 20 && p[i].y <= mouseY + 20 && p[i].y >= mouseY - 20) {


        p[i].selected = true;
      } 
      else {
        p[i].selected = false;
      }
    }
  }
}

