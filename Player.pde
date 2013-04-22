// player class and ui
class Player {

  float x, y;
  
  float lastX, lastY;
  
  int identifier;
  // the player data
  float colour;
  float open;
  float cons;
  float extra;
  float agree;
  float neuro;


  boolean selected = false;

  float str;

  int localInc;

  Player(int ident) {

    identifier = ident;


    // to know whether or not the player has moved
    lastX = 1;
    lastY = 1;

    //colour = random(128);
    open = random(128);
    cons = random(128);
    extra = random(128);
    agree = random(128);
    neuro = random(128);
  }






  void display() {

    ellipseMode(CENTER);


    fill(colour, 255, 255);
    ellipse(x, y, 20, 20);


    noFill();



    // selection ui
    if (selected) {

      pushMatrix();
      translate(boxX, boxY);
      fill(155);
      stroke(100);
      rect(0, 0, 200, 200);
      fill(86);
      stroke(0);
      text(identifier, 0, 24);
      fill(0);
      text("colour", 10, 50);
      colourSlider(10, 40, colour);

      text("+", 126, 70);
      text("-", 10, 70);

      text("Openness", 10, 90);
      slider(10, 80, open, 0);
      text("Conscientiousness", 10, 110); //self-discipline, carefulness, thoroughness, self-organization, deliberation , and need for achievement
      slider(10, 100, cons, 1);
      text("Extraversion", 10, 130);
      slider(10, 120, extra, 2);
      text("Agreeableness", 10, 150);
      slider(10, 140, agree, 3);
      text("Neuroticism", 10, 170);
      slider(10, 160, neuro, 4);



      popMatrix();
    }





    // to remove objects temporarily in the event the topcode is lost
    if (lastX != x && lastY != y) {
      lastX = x;
      lastY = y;
      localInc = 0;
    }

    if (lastX == x && lastY == y) {
      localInc++;
      if (localInc > 150) {
        disable();
      }
    }
  }

  void disable() {
    x = 850;
    y = 650;
  }

  // colour slider ui creator
  void colourSlider(float tempx, float tempy, float tempcolour) {

    line(tempx, tempy, tempx + 128, tempy);
    fill(tempcolour, 255, 255, 200);
    rect(tempx+tempcolour/2, tempy - 11, 14, 24);
    fill(0);

    if (mousePressed && mouseX-boxX >= tempx && mouseX-boxX <= tempx+128 && mouseY-boxY >= tempy-11 && mouseY-boxY <= tempy+13) {
      colour = map(mouseX-boxX, tempx, tempx + 128, 0, 255);
    }
  }

  // slider ui creator
  void slider(float tempx, float tempy, float data, int type) {

    fill(0, 200);
    line(tempx, tempy, tempx + 128, tempy);
    rect(tempx+data, tempy - 7, 14, 20);

    if (mousePressed && mouseX-boxX >= tempx && mouseX-boxX <= tempx+128 && mouseY-boxY >= tempy-7 && mouseY-boxY <= tempy+13) {

      if (type == 0) open = map(mouseX-boxX, tempx, tempx + 128, 0, 128);
      if (type == 1) cons = map(mouseX-boxX, tempx, tempx + 128, 0, 128);
      if (type == 2) extra = map(mouseX-boxX, tempx, tempx + 128, 0, 128);
      if (type == 3) agree = map(mouseX-boxX, tempx, tempx + 128, 0, 128);
      if (type == 4) neuro = map(mouseX-boxX, tempx, tempx + 128, 0, 128);
    }



    fill(0);
  }
}

