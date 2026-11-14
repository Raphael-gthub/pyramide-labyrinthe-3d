int posMomieX = 0;
int posMomieY = 0;
int momieDirX = -1;
int momieDirY = 0;
boolean start = true;
int animMomie = 0;
int countAnim = 60;


void deplaceMomie(PShape Momie) {
  if(countAnim == 60) {
    countAnim = 0;
    if(animMomie == 0) {
      changeDirection();
    }
    else {
      animMomie = 0;
    }
  }
  
  else if(animMomie == 0){
    float tailleCase = wallW[0];
    translate(momieDirX * tailleCase/60 * countAnim,
              momieDirY * tailleCase/60 * countAnim, 0);
    countAnim++;
  }
  else if(animMomie == -1) {
    Momie.rotateZ(-PI/120);
    countAnim++;
  }
  else if(animMomie == 1) {
    Momie.rotateZ(PI/120);
    countAnim++;
  }
  else if(animMomie == 2) {
    Momie.rotateZ(PI/60);
    countAnim++;
  }
}

void changeDirection() {
  if(animMomie == 0) {
    if(!start) {
      posMomieX += momieDirX;
      posMomieY += momieDirY;
    }
    else {
      start = false;
    }
    int dir = choisiDirection();
    
    if(dir == 1) {
      int copie = momieDirX;
      momieDirX = momieDirY;
      momieDirY = -copie;
      animMomie = -1;
    }
    else if(dir == 2) {
      int copie = momieDirX;
      momieDirX = -momieDirY;
      momieDirY = copie;
      animMomie = 1;
    }
    else if(dir == 3) {
      momieDirX = -momieDirX;
      momieDirY = -momieDirY;
      animMomie = 2;
    }
    else if(dir == 0) {
    }
    else {
      print("IL Y A UN PROBLEME....."); 
    }
  }
}

int choisiDirection() {
  boolean[] chxDir = new boolean[4];
  chxDir[0] = dirValide(posMomieX, momieDirX, posMomieY, momieDirY);
  chxDir[1] = dirValide(posMomieX, momieDirY, posMomieY, -momieDirX);
  chxDir[2] = dirValide(posMomieX, -momieDirY, posMomieY, momieDirX);
  chxDir[3] = !chxDir[0] && !chxDir[1] && !chxDir[2];
  
  int nbChx = 0;
  for(int i = 0; i < 4; i++) {
    if (chxDir[i]) {
      nbChx++;
    }
  }
  float rand = random(1, nbChx+1);
  int chx = int(rand);
  for(int i = 0; i < 4; i++) {
    if(chxDir[i]) {
      chx--;
      if(chx == 0) {
        return i;
      }
    }
  }
  return -1;
}

boolean dirValide(int x1, int x2, int y1, int y2) {
  return x1+x2>=0 && x1+x2<LABS_SIZES[etage] && y1+y2>=0 && y1+y2<LABS_SIZES[etage] &&
         labyrinthe.get(etage)[y1+y2][x1+x2]!='#';
}
