int nbParticules = 300;
Particule[] particulesMomie;
Particule[] particulesTP;

class Particule {
  float x;
  float y;
  float z;
  float taille;
  float phase;
  
  Particule(boolean sphere) {
    float rayon;
    if(sphere) {
      rayon = 5 + random(10);
    }
    else {
      rayon = 250 + random(100);
    }
    float angle1 = random(TWO_PI);
    float angle2 = random(TWO_PI);
    
    x = rayon * cos(angle1) * sin(angle2);
    y = rayon * sin(angle1) * sin(angle2);
    
    if(sphere) {
      z = rayon * cos(angle2);
      taille = random(0.2, 1);
    }
    else {
      z = 400 + rayon * cos(angle2);
      taille = random(4, 8);
    }
    phase = random(TWO_PI);
  }
  
  void updatePos() {
    x += 0.5 * sin(phase + frameCount * 0.05);
    y += 0.5 * cos(phase + frameCount * 0.05);
    z += 0.5 * sin(phase + frameCount * 0.07);
  }
  
  void display(boolean sphere) {
    pushMatrix();
    translate(x, y, z);
    rotateX(frameCount * 0.01);
    rotateY(frameCount * 0.01);
    
    fill(30, 20, 10, 200); //4e paramètre de fill : opacité!
    noStroke();
    if(sphere) {
      fill(200, 50, 50);
      sphere(taille);
    }
    else{
      beginShape(QUADS);
      float s = taille/2;
      vertex(-s, -s, 0);
      vertex( s, -s, 0);
      vertex( s,  s, 0);
      vertex(-s,  s, 0);
      endShape();
    }
    
    popMatrix();
  }
}

void creeParticulesMomie() {
  particulesMomie = new Particule[nbParticules];
  for (int i = 0; i < nbParticules; i++) {
    particulesMomie[i] = new Particule(false);
  }
}

void creeParticulesTP() {
  particulesTP = new Particule[nbParticules/2];
  for (int i = 0; i < nbParticules/2; i++) {
    particulesTP[i] = new Particule(true);
  }
}

void displayParticulesMomie() {
  for (int i = 0; i < nbParticules; i++) {
    particulesMomie[i].updatePos();
    particulesMomie[i].display(false);
  }
}

void displayParticulesTP(boolean update) {
  if(update) {
    for (int i = 0; i < nbParticules/2; i++) {
      particulesTP[i].updatePos();
      particulesTP[i].display(true);
    }
  }
  else {
    for (int i = 0; i < nbParticules/2; i++) {
      particulesTP[i].display(true);
    }
  }
}
