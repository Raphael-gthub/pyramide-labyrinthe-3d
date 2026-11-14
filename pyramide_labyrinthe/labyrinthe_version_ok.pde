int ORIGINAL_LAB_SIZE = 21;

int iposX = ORIGINAL_LAB_SIZE/2 - 1;
int iposY = -10;

int originalPosX = 1;
int originalPosY = 0;

int posX = iposX;
int posY = iposY;

int dirX = 0;
int dirY = 1;
int odirX = 0;
int odirY = 1;
int WALLD = 1;

float wallW[]; // is this not wall width ?
float wallH[]; // wall height ??
float HAUTEUR = 100;

int anim;
float anim_max = 40.0;
float anim_turn_max = 20.0;
boolean animT=false;
boolean animR=false;
boolean animBackOff = false;

//LABYRINTHE/PYRAMIDE
boolean inPyramid = false;
boolean pos_depart = true;

//Flickering
float maxBrightness = 1.2;
float minBrightness = 0.1;        // Final dim glow
float fadeDuration = 120000;      // 1 minutes = 60,000 ms
float elapsed = 0;
float lastFloorChangeTime = 0;



int etage;
int nb_etage = 9; //If you change this you also have to change the ORIGINAL_LAB_SIZE

ArrayList<char[][]> labyrinthe; // une ArrayList de labyrinthe en char
ArrayList<boolean[][]> deja_visite; // une ArrayList de labyrinthe en char
ArrayList<int[][][]> sides; // une ArrayList de sides

int LABS_SIZES[]; // la taille de tous les labyrinthes

PShape lab[]; // Les labyrinthes en PShape, les vrais
PShape ceiling0[]; // Un ceiling pour chaque étage
PShape ceiling1[];
PShape TP;
PShape pyramide;
PShape solExt;

PImage textureMur;
PImage textureSol;
PImage textureTP;
PImage texturePyramide;
PImage textureSable;
PImage texturePetitBloc;

PShader solShinyShader;
PShader DefaultShader;

void setup() { 
  //pixelDensity(2);
  randomSeed(2);
  textureMode(NORMAL);
  frameCount = 60;
  
  
  solShinyShader = loadShader("myFragmentShader.glsl", "myVertexShader.glsl");
  DefaultShader = loadShader("new_Frag.glsl", "new_Vert.glsl");
  
  textureMur = loadImage("pyramide-tex.jpg");
  textureSol = loadImage("pyramide-tex.jpg");
  textureTP = loadImage("teleporteur.jpg");
  texturePyramide = loadImage("pyramide-tex.jpg");
  textureSable = loadImage("sand.jpg");
  texturePetitBloc = loadImage("petit-bloc.jpg");
  size(1000, 1000, P3D);
  etage = 0;
  labyrinthe = new ArrayList<>();
  deja_visite = new ArrayList<>();
  sides = new ArrayList<>();
  LABS_SIZES = new int[nb_etage];
  lab = new PShape[nb_etage];
  wallH = new float[nb_etage];
  wallW = new float[nb_etage];
  ceiling0 = new PShape[nb_etage];
  ceiling1 = new PShape[nb_etage];
  
  
  
  // BOUCLE DE CREATION DU LABYRINTHE ET DES PSHAPES (c.f. : fichier lab)
  creation_tout_labyrinthe();
  
  //CREATION DU POINT DE TELEPORTATION
  TP = creeJoliTP(20,3,300,300, textureTP); //Note : pas de texture pour l'instant
  
  //CREATION DE LA PYRAMIDE

  pyramide = createShape(GROUP);
  //initPyramideTriangulaire(pyramidfe, nb_etage*200); //taillecarre, largeurGrosBloc, hauteurGrosBloc
  initPyramide(pyramide, 15, 90); //taillecarre, largeurGrosBloc, hauteurGrosBloc
  
  solExt = initSolExt(solExt);
  
  randomSeed((int)millis()); // Change la graine en fonction du temps écoulé
                             // Comme ça les déplacements de la momie sont vraiment aléatoires !
  creeMomie();
  creeParticulesMomie();
  creeParticulesTP();
}

void draw() {
  //shader(myShader); rend tout horriblement moche !
  background(135,206,235);
  sphereDetail(6);
  //The more you advance the less light you have
  flickering_magic();
  
  /*
  float time = 2. * millis() * 0.0015;
  float flicker = map(noise(time), 0, 1, 0.82, 1.0); // flickers between 0.9 and 1.0
  DefaultShader.set("u_brightness", flicker);
  */
  //DefaultShader.set("u_time", (float)frameCount);
  if (anim>0) anim--;
  
  
  noStroke();
  //booleen pour verifier si on est dans la pyramide
  inPyramid = posX>=0 && posX<LABS_SIZES[0] && posY >=0 && posY <LABS_SIZES[0];
  //on est dans la pyramide si on est au moins dans le premier etage, à modifier si bug
  
  //Si je suis dans la pyramide je dessine ma miniMap
  //(attention l'ordre dans lequel je dessine les choses est important
  if (inPyramid){
    if ( pos_depart ){
      posX = originalPosX; posY = originalPosY;
      pos_depart = false;  
    }
    background(0);
    drawMiniMap();
  }
  
  
  // defini perspective après miniMap, car miniMap change la perspective
  perspective(2*PI/3, float(width)/float(height), 1, 10000);
  
  
  // Si je ne suis pas dans la pyramide, je l'affiche
  if ( ! inPyramid ){
    rotateX(-PI/2);
    translate(wallW[0]*(labyrinthe.get(0).length - 1)/2 , +HAUTEUR/4 ,wallW[0]*(labyrinthe.get(0).length -1)/2);
    
    shape(pyramide);

    
    solShinyShader.set("lightPosition", new PVector(-500, -500, -500)); //+is left - is right, - is up + is down, - is behind + is forward
    solShinyShader.set("viewPosition", new PVector(500, 500, 1000));
    // If other values like shininess need to be dynamic, update them as well:
    solShinyShader.set("shininess", 4.);
    solShinyShader.set("specularColor", new PVector(0.2,0.2, 0.2));
    solShinyShader.set("ambientLight", new PVector(0.4, 0.4, 0.4));
    
    shader(solShinyShader);
    
    //shader(DefaultShader);
    shape(solExt);
    resetShader();
  }
  
  // La camera qui bouge en fonction de l'animation  
  camera_animation();
  
    
  //Dessine labyrinthe seulement si je suis dans la pyramide
  if (inPyramid){
    //LIGHTING
    //lumiere_RGB();
    //lights();
    lumiere();
    shader(DefaultShader);
    shape(lab[etage],0,0);
    
    noStroke();
    shape(ceiling0[etage], 0, 0);
    resetShader();
    portesAvecSphere();
    
    //Dessine le point de téléportation
    sphereDetail(20);
    draw_TP();
    //PLACEMENT ET DEPLACEMENT DE LA MOMIE
    pushMatrix();
    dessine_momie();
    displayParticulesMomie();
    popMatrix();
    
    jeSuisAvecLaMomie();
  }
  
  
}

void jeSuisAvecLaMomie(){
  if (posX == posMomieX && posY == posMomieY){
    jOublieCarte();
  }
}

void jOublieCarte(){
  for(int i = 0 ; i < deja_visite.get(etage).length; ++i)
      for(int j = 0; j < deja_visite.get(etage)[i].length;++j)
          deja_visite.get(etage)[i][j] = false;
}

void flickering_magic(){
  elapsed = millis() - lastFloorChangeTime;
  float fade = map(elapsed, 0, fadeDuration, maxBrightness, minBrightness);
  fade = constrain(fade, minBrightness, maxBrightness);

  // Add flicker using noise
  float flicker = map(noise(elapsed * 0.005), 0, 1, 0.82, 1.0);
  float combined = fade * flicker;

  DefaultShader.set("u_brightness", combined);
}



void dessine_momie(){
    if(start) {
    posMomieX = (labyrinthe.get(etage).length -1);
    posMomieY = (labyrinthe.get(etage)[0].length - 2);
    }
    
    deplaceMomie(Momie);
    translate(wallH[etage] * posMomieX,wallH[etage] * posMomieY, -50);
    
    scale(0.08);
    shape(Momie);

}

void camera_animation(){
  if (animT){
    camera((posX-dirX*anim/anim_max)*wallW[etage],      (posY-dirY*anim/anim_max)*wallH[etage],      -15+0.75*sin(anim*PI/5.0), 
           (posX-dirX*anim/anim_max+dirX)*wallW[etage], (posY-dirY*anim/anim_max+dirY)*wallH[etage], -15+1*sin(anim*PI/5.0), 0, 0, -1);
  }
  else if (animR)
    camera(posX*wallW[etage], posY*wallH[etage], -15, 
          (posX+(odirX*anim+dirX*(anim_turn_max-anim))/anim_turn_max)*wallW[etage],
          (posY+(odirY*anim+dirY*(anim_turn_max-anim))/anim_turn_max)*wallH[etage], -15-5*sin(anim*PI/20.0), 0, 0, -1);
  
  else if (animBackOff)
    camera((posX+dirX*anim/anim_max)*wallW[etage],      (posY+dirY*anim/anim_max)*wallH[etage],      -15+1*sin(anim*PI/5.0), //less smooth on purpose
           (posX+dirX*anim/anim_max+dirX)*wallW[etage], (posY+dirY*anim/anim_max+dirY)*wallH[etage], -15+2*sin(anim*PI/5.0), 0, 0, -1);
  
  else {
    camera(posX*wallW[etage], posY*wallH[etage], -15, 
           (posX+dirX)*wallW[etage], (posY+dirY)*wallH[etage], -15, 0, 0, -1);
  }
}

void lumiere_RGB(){
  lightFalloff(0.0, 0.01, 0.0001);
  // 247, 147, 76
  //laby0.tint(i*25, j*25, 255-i*10+j*10);
  float r = posX*25;
  float g = posY*25;
  float b = 255 - posX*10 + posY*10;
  
  if (animT)
    pointLight(r, g, b, (posX-dirX*anim/anim_max)*wallW[etage], (posY-dirY*anim/anim_max)*wallH[etage], 15);
  else if (animBackOff)
    pointLight(r, g*0.9, b, (posX+dirX*anim/anim_max)*wallW[etage], (posY+dirY*anim/anim_max)*wallH[etage], 15);
  else if (inPyramid)//animR is in the else too
    pointLight(r, g, b*0.9, posX*wallW[etage], posY*wallH[etage], 15);
  else{
    //nothing here yet, light outside the pyramid ?
  }
}

void lumiere(){
  lightFalloff(0.1, 0.01, 0.0001);
  
  if (animT)
    pointLight(255, 220, 180, (posX-dirX*anim/anim_max)*wallW[etage], (posY-dirY*anim/anim_max)*wallH[etage], -15);
  else if (animBackOff)
    pointLight(255, 220, 180, (posX+dirX*anim/anim_max)*wallW[etage], (posY+dirY*anim/anim_max)*wallH[etage], -15);
  else if (inPyramid){
    pointLight(255, 220, 180, posX*wallW[etage], posY*wallH[etage], -5);
  }
  else{
    //nothing here yet, light outside the pyramid ?
  }

}
