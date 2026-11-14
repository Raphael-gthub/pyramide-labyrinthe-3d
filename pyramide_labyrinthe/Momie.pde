PShape Momie;
PShape Corps;
PShape Jambes;
PShape Cou;
PShape Tete;
PShape Bras;
PShape Yeux;

float largeurBande = 15;
float hauteurEtageBande = largeurBande/3;

// CREATION DES PARTIES DU CORPS

void creeMomie() {
  Momie = createShape(GROUP);
  
  creeCorps();
  Momie.addChild(Corps);
  
  creeJambes();
  Momie.addChild(Jambes);
  
  creeCou();
  Momie.addChild(Cou);
  
  creeTete();
  Momie.addChild(Tete);
  
  Bras = createShape(GROUP);
  creeArm(true);
  creeArm(false);
  Momie.addChild(Bras);
  Momie.rotateZ(PI/3.6);
  Momie.rotateZ(PI/2);
}




PShape creeBande(float rayon, float z) {
  PShape bande = createShape();
  bande.beginShape(QUAD_STRIP);
  bande.noStroke();
  int start = (int)random(50);
  int stop = start + 50 + (int)random(50);
  for(int b=start; b<=stop; b++) {
    float a = b/50. * TWO_PI;
    float x = rayon * cos(a);
    float y = rayon * sin(a);
    bande.vertex(x, y, z + b*largeurBande/50);
    bande.vertex(x, y, z + largeurBande + b*largeurBande/50);
  }
  bande.endShape();
  return bande;
}

float creeNoise(int i){
  float noiseFactor = 20 * noise(i, frameCount);
  fill(150 + 2*noiseFactor, 150 + 2*noiseFactor, 50 + 2*noiseFactor);
  return noiseFactor;
}


void creeJambes() {
  Jambes = createShape(GROUP);
  
  for(int i = 0; i <= 32; i++) {
    float noiseFactor = creeNoise(i);
    
    float z = hauteurEtageBande *i;
    float rayon = 36 + i + noiseFactor;
    
    PShape bande = creeBande(rayon, z);
    Jambes.addChild(bande);
  }
}

void creeCorps() {
  Corps = createShape(GROUP);
  Corps.translate(0, 0, hauteurEtageBande * 32);
  
  for(int i = -32; i <= 32; i++) {
    float noiseFactor = creeNoise(i);
    
    float z = hauteurEtageBande *(i + 32);
    float rayon = 100 - abs(i) + noiseFactor;
    
    PShape bande = creeBande(rayon, z);
    Corps.addChild(bande);
  }
}

void creeCou() {
  Cou = createShape(GROUP);
  Cou.translate(0, 0, (hauteurEtageBande) * 96);
  
  for(int i = -8; i <= 8; i++) {
    float noiseFactor = creeNoise(i);
    
    float z = hauteurEtageBande *(i + 8);
    float rayon = 44 + 3*abs(i) + noiseFactor/2;
    
    PShape bande = creeBande(rayon, z);
    Cou.addChild(bande);
  }
}

void creeTete() {
  Tete = createShape(GROUP);
  Tete.translate(0, 0, hauteurEtageBande * 112);
  
  for(int i = -12; i <= 12; i++) {
    float noiseFactor = creeNoise(i);
    
    float z = hauteurEtageBande * (i + 12);
    float rayon = 80 - abs(i) + noiseFactor/4;
    
    PShape bande = creeBande(rayon, z);
    Tete.addChild(bande);
    
    // CREATION DES YEUX
    if(i==9) {
      pushMatrix();
      
      PShape Yeux = createShape(GROUP);
      
      PShape oeilGauche = creeOeilAplati(15, 1.5, true, false);
      PShape intOeilGauche = createShape(SPHERE, 11);
      intOeilGauche.setFill(color(0));
      //intOeilGauche.noStroke();
      float a1 = 0;
      float x1 = rayon * cos(a1);
      float y1 = rayon * sin(a1);
      oeilGauche.translate(x1, y1, z);
      intOeilGauche.translate(x1+5, y1+3, z);
      
      
      PShape oeilDroit = creeOeilAplati(15, 1.5, false, false);
      PShape intOeilDroit = createShape(SPHERE, 11);
      intOeilDroit.setFill(color(0));
      //intOeilDroit.noStroke();
      float a2 = 2*PI/5;
      float x2 = rayon * cos(a2);
      float y2 = rayon * sin(a2);
      oeilDroit.translate(x2, y2, z);
      intOeilDroit.translate(x2+6, y2+4, z);
      
      Yeux.addChild(oeilGauche);
      Yeux.addChild(oeilDroit);
      Yeux.addChild(intOeilGauche);
      Yeux.addChild(intOeilDroit);
      Tete.addChild(Yeux);
      popMatrix();
    }
  }
  
  for(int i = 0; i < 8; i++) {
    float noiseFactor = creeNoise(i);
    
    float z = hauteurEtageBande * (i + 24);
    float rayon = 68 - 6*abs(i) + noiseFactor/4;
    
    PShape bande = creeBande(rayon, z);
    Tete.addChild(bande);
  }
}

PShape creeOeilAplati(float rayon, float facteurX, boolean rotate1, boolean rotate2) {
  int detail = 20; // précision de la sphère
  PShape oeil = createShape();
  oeil.beginShape(TRIANGLE_STRIP);
  oeil.fill(255);
  if(rotate1) {
    oeil.rotateZ(PI/2);
  }
  if(rotate2) {
    oeil.rotateY(PI/2);
    oeil.fill(0);
  }
  oeil.noStroke();

  for (int i = 0; i < detail; i++) {
    float theta1 = PI * i / detail;
    float theta2 = PI * (i + 1) / detail;
    
    for (int j = 0; j <= detail; j++) {
      float phi = TWO_PI * j / detail;

      // Premier point
      float x1 = facteurX * rayon * sin(theta1) * cos(phi);
      float y1 = rayon * sin(theta1) * sin(phi);
      float z1 = rayon * cos(theta1);

      // Deuxième point
      float x2 = facteurX * rayon * sin(theta2) * cos(phi);
      float y2 = rayon * sin(theta2) * sin(phi);
      float z2 = rayon * cos(theta2);
      oeil.vertex(x1, y1, z1);
      oeil.vertex(x2, y2, z2);
    }
  }
  oeil.endShape();
  return oeil;
}

void creeArm(boolean droit) {
  PShape arm = createShape(GROUP);
  if(droit){
    arm.translate(0, 60, hauteurEtageBande * 102);
  }
  else{
    arm.translate(0, -60, hauteurEtageBande * 102);
  }
  arm.rotateZ(PI/4.5);
  for(int i = 0; i <= 69; i++) {
    float noiseFactor = creeNoise(i);
    
    float z = hauteurEtageBande/1.5 *(i + 8);
    float rayon;
    if(i < 10) {
      rayon = 35 - 2*i + noiseFactor/2;
    }
    else if(i < 30) {
      rayon = 15 + (i-10)*3/4 + noiseFactor/2;
    }
    else if(i<50) {
      rayon = 30 - (i-30)*3/4 + noiseFactor/2;
    }
    else if(i<55) {
      rayon = 15 + (i-50)*4 + noiseFactor/2;
    }
    else if(i<65) {
      rayon = 35 - (i-55) + noiseFactor/2;
    }
    else {
      rayon = 25 - (i-65) * 4;
    }

    PShape bande = createShape();
    bande.beginShape(QUAD_STRIP);
    bande.noStroke();
    int start = (int)random(50);
    int stop = start + 50 + (int)random(50);
    for(int b=start; b<=stop; b++) {
      float a = b/50. * TWO_PI;
      float x = rayon * cos(a);
      float y = rayon * sin(a);
      float z1 = z + b*largeurBande/50;
      float z2 = z + largeurBande/1.5 + b*largeurBande/50;
      bande.vertex(z1, y, x);
      bande.vertex(z2, y, x);
    }
    bande.endShape();
    
    arm.addChild(bande);
  }
  Bras.addChild(arm);
}
