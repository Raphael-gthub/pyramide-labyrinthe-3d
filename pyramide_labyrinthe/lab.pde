void creation_tout_labyrinthe(){
  
  for (int i = 0; i < nb_etage; ++i) {
      //int size_of_this_labyrinth = int(map(i, 0, nb_etage, ORIGINAL_LAB_SIZE, 4));
      LABS_SIZES[i] = ORIGINAL_LAB_SIZE - 2* i; // si on mets trop de labyrinthes
      //LABS_SIZES[i] = size_of_this_labyrinth;
      char[][] labyrinthLayer = new char[LABS_SIZES[i]][LABS_SIZES[i]];
      deja_visite.add(new boolean[LABS_SIZES[i]][LABS_SIZES[i]]);
      int[][][] sideLayer = new int[LABS_SIZES[i]][LABS_SIZES[i]][4];
      initLabyrinthe(labyrinthLayer, sideLayer, LABS_SIZES[i]);
      labyrinthe.add(labyrinthLayer);
      sides.add(sideLayer);
      //print("Etage n°",i,"\n");
      //afficheASCIILabyrinthe(labyrinthLayer, LABS_SIZES[i]);
      
      //PARTIE PSHAPE
      wallW[i] = width/ORIGINAL_LAB_SIZE;
      wallH[i] = height/ORIGINAL_LAB_SIZE; //GOTTA DO SOMETHING ABOUT THIS
      //wallW[i] = width/LABS_SIZES[i];
      //wallH[i] = height/LABS_SIZES[i];
      anim = int(anim_max);
      
      PShape ceiling0P;
      PShape ceiling1P;
      ceiling0P = createShape();
      ceiling1P = createShape();
      ceiling0P.beginShape(QUADS);
      ceiling1P.beginShape(QUADS);
      ceiling0P.noStroke();
      ceiling1P.noStroke();
      ceiling0P.texture(textureSol); //ceiling you see
      ceiling1P.texture(textureSol); // ceiling you don't see
      

      PShape laby0;
      laby0 = createShape();
      laby0.beginShape(QUADS);
      laby0.texture(textureMur);
      laby0.noStroke();
      //laby0.stroke(255, 32);
      //laby0.strokeWeight(0.5);
      
      
      creeJoliLabyrinthe(laby0, ceiling0P, ceiling1P, i, wallW[i], wallH[i]);
      laby0.endShape();
     
      ceiling0P.endShape();
      ceiling1P.endShape();
      lab[i] = laby0;
      ceiling0[i] = ceiling0P;
      ceiling1[i] = ceiling1P;
  }

}










///////////////////////////////////////////////////////////////////////////
///////// INITIALISATION DU LABYRINTHE/////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
void initLabyrinthe(char[][] labyrinthe, int[][][] sides, int size){
  int todig = 0;
  for (int j=0; j<size; j++) {
    for (int i=0; i<size; i++) {
      sides[j][i][0] = 0;
      sides[j][i][1] = 0;
      sides[j][i][2] = 0;
      sides[j][i][3] = 0;
      if (j%2==1 && i%2==1) {
        labyrinthe[j][i] = '.';
        todig ++;
      } else
        labyrinthe[j][i] = '#';
    }
  }
  int gx = 1;
  int gy = 1;
  while (todig>0 ) {
    int oldgx = gx;
    int oldgy = gy;
    int alea = floor(random(0, 4)); // selon un tirage aleatoire
    if      (alea==0 && gx>1)          gx -= 2; // le fantome va a gauche
    else if (alea==1 && gy>1)          gy -= 2; // le fantome va en haut
    else if (alea==2 && gx<size-2) gx += 2; // .. va a droite
    else if (alea==3 && gy<size-2) gy += 2; // .. va en bas

    if (labyrinthe[gy][gx] == '.') {
      todig--;
      labyrinthe[gy][gx] = ' ';
      labyrinthe[(gy+oldgy)/2][(gx+oldgx)/2] = ' ';
    }
  }

  labyrinthe[0][1]                   = ' '; // entree //what ??
  labyrinthe[size-2][size-1] = ' '; // sortie

  for (int j=1; j<size-1; j++) {
    for (int i=1; i<size-1; i++) {
      if (labyrinthe[j][i]==' ') {
        if (labyrinthe[j-1][i]=='#' && labyrinthe[j+1][i]==' ' &&
          labyrinthe[j][i-1]=='#' && labyrinthe[j][i+1]=='#')
          sides[j-1][i][0] = 1;// c'est un bout de couloir vers le haut 
        if (labyrinthe[j-1][i]==' ' && labyrinthe[j+1][i]=='#' &&
          labyrinthe[j][i-1]=='#' && labyrinthe[j][i+1]=='#')
          sides[j+1][i][3] = 1;// c'est un bout de couloir vers le bas 
        if (labyrinthe[j-1][i]=='#' && labyrinthe[j+1][i]=='#' &&
          labyrinthe[j][i-1]==' ' && labyrinthe[j][i+1]=='#')
          sides[j][i+1][1] = 1;// c'est un bout de couloir vers la droite
        if (labyrinthe[j-1][i]=='#' && labyrinthe[j+1][i]=='#' &&
          labyrinthe[j][i-1]=='#' && labyrinthe[j][i+1]==' ')
          sides[j][i-1][2] = 1;// c'est un bout de couloir vers la gauche
      }
    }
  }
}

void afficheASCIILabyrinthe(char[][] lab, int size){
  // un affichage texte pour vous aider a visualiser le labyrinthe en 2D
  for (int j=0; j<size; j++) {
    for (int i=0; i<size; i++) {
      print(lab[j][i]);
    }
    println("");
  }
}



///////////////////////////////////////////////////////////////////////////
///////// PSHAPE LABYRINTHE////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////

void creeJoliLabyrinthe(PShape laby0, PShape ceiling0P, PShape ceiling1P, int eta, float wallW, float wallH){ //eta pour etage
  
  for (int j=0; j<LABS_SIZES[eta]; j++) {
    for (int i=0; i<LABS_SIZES[eta]; i++) {
      if (labyrinthe.get(eta)[j][i]=='#') {
        
        laby0.fill(i*25, j*25, 255-i*10+j*10); // or tint
        laby0.tint(240);
        if (j==0 || labyrinthe.get(eta)[j-1][i]==' ') {
          laby0.normal(0, -1, 0);
          for (int k=0; k<WALLD; k++)
            for (int l=-WALLD; l<WALLD; l++) {
              //float d1 = 15*(noise(0.3*(i*WALLD+(k+0)), 0.3*(j*WALLD), 0.3*(l+0))-0.5);
              //if (k==0)  d1=0;
              //if (l==-WALLD) d1=-2*abs(d1);
              laby0.vertex(i*wallW-wallW/2+(k+0)*wallW/WALLD, j*wallH-wallH/2, (l+0)*50/WALLD, 0, 0);
              
              //float d2 =15*(noise(0.3*(i*WALLD+(k+1)), 0.3*(j*WALLD), 0.3*(l+0))-0.5);
              //if (k+1==WALLD ) d2=0;
              //if (l==-WALLD) d2=-2*abs(d2);
              laby0.vertex(i*wallW-wallW/2+(k+1)*wallW/WALLD, j*wallH-wallH/2, (l+0)*50/WALLD, 1, 0);
              
              //float d3 = 15*(noise(0.3*(i*WALLD+(k+1)), 0.3*(j*WALLD), 0.3*(l+1))-0.5);
              //if (k+1==WALLD ||l+1==WALLD) d3=0;
              laby0.vertex(i*wallW-wallW/2+(k+1)*wallW/WALLD, j*wallH-wallH/2, (l+1)*50/WALLD, 1, 1);
              
              //float d4 = 15*(noise(0.3*(i*WALLD+(k+0)), 0.3*(j*WALLD), 0.3*(l+1))-0.5);
              //if (k==0 ||l+1==WALLD) d4=0;
              laby0.vertex(i*wallW-wallW/2+(k+0)*wallW/WALLD, j*wallH-wallH/2, (l+1)*50/WALLD, 0, 1);
            }
        }

        if (j==LABS_SIZES[eta]-1 || labyrinthe.get(eta)[j+1][i]==' ') {
          laby0.normal(0, 1, 0);
          for (int k=0; k<WALLD; k++)
            for (int l=-WALLD; l<WALLD; l++) {
              laby0.vertex(i*wallW-wallW/2+(k+0)*wallW/WALLD, j*wallH+wallH/2, (l+1)*50/WALLD, 0, 0);
              laby0.vertex(i*wallW-wallW/2+(k+1)*wallW/WALLD, j*wallH+wallH/2, (l+1)*50/WALLD, 1, 0);
              laby0.vertex(i*wallW-wallW/2+(k+1)*wallW/WALLD, j*wallH+wallH/2, (l+0)*50/WALLD, 1, 1);
              laby0.vertex(i*wallW-wallW/2+(k+0)*wallW/WALLD, j*wallH+wallH/2, (l+0)*50/WALLD, 0, 1);
            }
        }

        if (i==0 || labyrinthe.get(eta)[j][i-1]==' ') {
          laby0.normal(-1, 0, 0);
          for (int k=0; k<WALLD; k++)
            for (int l=-WALLD; l<WALLD; l++) {
              laby0.vertex(i*wallW-wallW/2, j*wallH-wallH/2+(k+0)*wallW/WALLD, (l+1)*50/WALLD, 0, 0);
              laby0.vertex(i*wallW-wallW/2, j*wallH-wallH/2+(k+1)*wallW/WALLD, (l+1)*50/WALLD, 1, 0);
              laby0.vertex(i*wallW-wallW/2, j*wallH-wallH/2+(k+1)*wallW/WALLD, (l+0)*50/WALLD, 1, 1);
              laby0.vertex(i*wallW-wallW/2, j*wallH-wallH/2+(k+0)*wallW/WALLD, (l+0)*50/WALLD, 0, 1);
            }
        }

        if (i==LABS_SIZES[eta]-1 || labyrinthe.get(eta)[j][i+1]==' ') {
          laby0.normal(1, 0, 0);
          for (int k=0; k<WALLD; k++)
            for (int l=-WALLD; l<WALLD; l++) {
              laby0.vertex(i*wallW+wallW/2, j*wallH-wallH/2+(k+0)*wallW/WALLD, (l+0)*50/WALLD, 0, 0);
              laby0.vertex(i*wallW+wallW/2, j*wallH-wallH/2+(k+1)*wallW/WALLD, (l+0)*50/WALLD, 1, 0);
              laby0.vertex(i*wallW+wallW/2, j*wallH-wallH/2+(k+1)*wallW/WALLD, (l+1)*50/WALLD, 1, 1);
              laby0.vertex(i*wallW+wallW/2, j*wallH-wallH/2+(k+0)*wallW/WALLD, (l+1)*50/WALLD, 0, 1);
            }
        }
        
        ceiling1P.fill(32, 255, 0); //No uv texture coordinates supplied with vertex() call
                                    // apply u, v everywhere makes the whole thing too heavy
        ceiling1P.normal(0, 0, 1);
        ceiling1P.vertex(i*wallW-wallW/2, j*wallH-wallH/2, 50, 0, 0);
        ceiling1P.vertex(i*wallW+wallW/2, j*wallH-wallH/2, 50, 1, 0);
        ceiling1P.vertex(i*wallW+wallW/2, j*wallH+wallH/2, 50, 1, 1);
        ceiling1P.vertex(i*wallW-wallW/2, j*wallH+wallH/2, 50, 0, 1);        
      } else {
        laby0.fill(192); // ground
        laby0.tint(130);
        laby0.normal(0, 0, 1);
        laby0.vertex(i*wallW-wallW/2, j*wallH-wallH/2, -50, 0, 0);
        laby0.vertex(i*wallW+wallW/2, j*wallH-wallH/2, -50, 1, 0);
        laby0.vertex(i*wallW+wallW/2, j*wallH+wallH/2, -50, 1, 1);
        laby0.vertex(i*wallW-wallW/2, j*wallH+wallH/2, -50, 0, 1);
        
        ceiling0P.fill(100); // top of walls
        ceiling0P.tint(130);
        ceiling0P.vertex(i*wallW-wallW/2, j*wallH-wallH/2, 50, 0, 0);
        ceiling0P.vertex(i*wallW+wallW/2, j*wallH-wallH/2, 50, 1, 0);
        ceiling0P.vertex(i*wallW+wallW/2, j*wallH+wallH/2, 50, 1, 1);
        ceiling0P.vertex(i*wallW-wallW/2, j*wallH+wallH/2, 50, 0, 1);
      }
    }
  }
}





///////////////////////////////////////////////////////////////////////////
///////// portes avec Sphere////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////

// Fonction pour dessiner une croix rouge en 3D
void dessinerCroix3D(float taille, float epaisseur) {
  
  noStroke();
  rotateY(PI/2);
  // Première barre diagonale
  pushMatrix();
  rotateZ(PI / 4);
  box(taille, epaisseur, epaisseur);
  popMatrix();

  // Deuxième barre diagonale
  pushMatrix();
  rotateZ(-PI / 4);
  box(taille, epaisseur, epaisseur);
  popMatrix();
}



void portesAvecSphere(){ //fait maintenant des croix
    //fond de couloir
  for (int j=0; j<LABS_SIZES[etage]; j++) {
    for (int i=0; i<LABS_SIZES[etage]; i++) {
      pushMatrix();
      translate(i*wallW[etage], j*wallH[etage], 0);
      if (labyrinthe.get(etage)[j][i]=='#') {
        beginShape(QUADS);
        lights();
        if (sides.get(etage)[j][i][3]==1) {//mur de devant
          pushMatrix();
          translate(0, -wallH[etage]/2, 30); 
          if (i==posX || j==posY) {
            fill(i*25, j*25, 255-i*10+j*10);
            rotateY(PI/2);
            rotateZ(PI/2);
            dessinerCroix3D(40, 4); // taille et épaisseur   
            
            spotLight(i*25, j*25, 255-i*10+j*10, 0, -15, 15, 0, 0, -1, PI/4, 1);
          }
          popMatrix();
        }

        if (sides.get(etage)[j][i][0]==1) { //mur de derrière
          pushMatrix();
          translate(0, wallH[etage]/2, 30); 
          if (i==posX || j==posY) {
            rotateY(PI/2);
            rotateZ(PI/2);
            fill(i*25, j*25, 255-i*10+j*10);
            dessinerCroix3D(40, 4); // taille et épaisseur
            spotLight(i*25, j*25, 255-i*10+j*10, 0, -15, 15, 0, 0, -1, PI/4, 1);
          }
          popMatrix();
        }
         
         if (sides.get(etage)[j][i][1]==1) {//mur à gauche
          pushMatrix();
          translate(-wallW[etage]/2, 0, 30); 
          if (i==posX || j==posY) {
            fill(i*25, j*25, 255-i*10+j*10);
            dessinerCroix3D(40, 4); // taille et épaisseur
            spotLight(i*25, j*25, 255-i*10+j*10, 0, -15, 15, 0, 0, -1, PI/4, 1);
            //pointLight(i*25, j*25, 255-i*10+j*10, 0, 0, 0);
            //translate(0,15,0);
            
          }
          popMatrix();
        }
        
        if (sides.get(etage)[j][i][2]==1) {//mur à droite
          pushMatrix();
          translate(wallW[etage]/2, 0, 30);
          if (i==posX || j==posY) {
            fill(i*25, j*25, 255-i*10+j*10);
            dessinerCroix3D(40, 4); // taille et épaisseur           
            spotLight(i*25, j*25, 255-i*10+j*10, 0, -15, 15, 0, 0, -1, PI/4, 1);
          }
          popMatrix();
        }
      } 
      popMatrix();
    }
  }
}
