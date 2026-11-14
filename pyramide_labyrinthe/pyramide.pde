
void initPyramide(PShape pyramide, float hauteurBloc, int nbEtage){
  float tailleCarre = wallH[0]*(labyrinthe.get(0).length);
  noStroke();
  int e = 0;
  for (; e < nbEtage ; ++e) {
      if (tailleCarre-12 < 200){ e--; break;}
      if (e!=0) tailleCarre -= 12;
      
      PShape newBloc = createShape();
      
      newBloc.beginShape(QUADS);
      newBloc.texture(texturePetitBloc);
      initBloc(newBloc, tailleCarre, hauteurBloc, tailleCarre, tailleCarre/wallH[0]);
      newBloc.endShape();
      newBloc.translate(-tailleCarre/2, -e*hauteurBloc, -tailleCarre/2); //empile les bloc
      pyramide.addChild(newBloc);

    }
  PShape chapeauPointu = createShape();
  chapeauPointu.beginShape(TRIANGLES);
  chapeauPointu.noStroke();
  initDemiDiamant(chapeauPointu,tailleCarre, 16.*hauteurBloc, tailleCarre);
  chapeauPointu.texture(texturePyramide);
  chapeauPointu.endShape();
  chapeauPointu.translate(-tailleCarre/2, -e*hauteurBloc, -tailleCarre/2);
  //chapeauPointu.translate(-2000, -700, -2000);
  //chapeauPointu.translate(0, +e*hauteurBloc, 0);
  
  //chapeauPointu.rotateY(PI/4);
  pyramide.addChild(chapeauPointu);
    
  }
  //pyramide.fill(255, 255, 0);


void initPyramideTriangulaire(PShape pyramide, float hauteur){
  float tailleCarre = wallH[0]*(labyrinthe.get(0).length);
  pyramide.beginShape(TRIANGLE);
  pyramide.noStroke();
  
  //ground
  // Define the square using two triangles
  initDemiDiamant(pyramide, tailleCarre, hauteur, tailleCarre);
  pyramide.texture(texturePyramide);
  pyramide.translate(-tailleCarre/2, HAUTEUR+15, -tailleCarre/2);
  
  pyramide.endShape();

}


void initBloc(PShape bloc, float largeur, float hauteur, float profondeur, float nb_repetitions) {
  textureWrap(REPEAT);
  // Define the vertices for the 6 faces of the bloc
  // Back face
  //bloc.normal(-1, 0, 1); // Normal pointing in the +Z direction
  bloc.vertex(0, 0, profondeur, 0, 0); // Bottom left
  bloc.vertex(largeur, 0, profondeur, nb_repetitions, 0); // Bottom right
  bloc.vertex(largeur, hauteur, profondeur, nb_repetitions, 1); // Top right
  bloc.vertex(0, hauteur, profondeur, 0, 1); // Top left
  
  // Front face
  //bloc.normal(0, 0, -1); // Normal pointing in the -Z direction
  bloc.vertex(0, 0, 0, 0, 0); // Bottom left
  bloc.vertex(largeur, 0, 0, nb_repetitions, 0); // Bottom right
  bloc.vertex(largeur, hauteur, 0, nb_repetitions, 1); // Top right
  bloc.vertex(0, hauteur, 0, 0, 1); // Top left
  
  // Left face
  // bloc.normal(-1, 0, 0); // Normal pointing in the -X direction
  bloc.vertex(0, 0, 0, 0, 0); // Bottom left
  bloc.vertex(0, 0, profondeur, nb_repetitions, 0); // Bottom right
  bloc.vertex(0, hauteur, profondeur, nb_repetitions, 1); // Top right
  bloc.vertex(0, hauteur, 0, 0, 1); // Top left
  
  // Right face
  // bloc.normal(1, 0, 0); // Normal pointing in the +X direction
  bloc.vertex(largeur, 0, 0, 0, 0); // Bottom left
  bloc.vertex(largeur, 0, profondeur, nb_repetitions, 0); // Bottom right
  bloc.vertex(largeur, hauteur, profondeur, nb_repetitions, 1); // Top right
  bloc.vertex(largeur, hauteur, 0, 0, 1);// Top left
  
  // Top face
  // bloc.normal(0, 1, 0); // Normal pointing in the +Y direction
  bloc.vertex(0, hauteur, 0, 0, 0); // Bottom left
  bloc.vertex(largeur, hauteur, 0, nb_repetitions, 0); // Bottom right
  bloc.vertex(largeur, hauteur, profondeur, nb_repetitions, 1); // Top right
  bloc.vertex(0, hauteur, profondeur, 0, 1); // Top left
  
  // Bottom face
  //bloc.normal(0, -1, 0); // Normal pointing in the -Y direction
  bloc.vertex(0, 0, 0, 0, 0); // Bottom left
  bloc.vertex(largeur, 0, 0, nb_repetitions, 0); // Bottom right
  
  bloc.vertex(largeur, 0, profondeur, nb_repetitions, nb_repetitions); // Top right
  bloc.vertex(0, 0, profondeur, 0, nb_repetitions); // Top left
  
  
}




void initDemiDiamant(PShape forme, float largeur, float hauteur, float profondeur) {
  
  // face avant
  forme.vertex(0, 0, 0, 0, 0);      
  forme.vertex(largeur, 0, 0, 1, 0);      
  forme.vertex(largeur/2, -hauteur, profondeur/2, 0.5, 1);     
  
  //face gauche
  forme.vertex(0, 0, 0, 0, 0);      
  forme.vertex(0, 0, profondeur, 1, 0);      
  forme.vertex(largeur/2, -hauteur, profondeur/2, 0.5, 1);      
  
  // face droite
  forme.vertex(largeur, 0, 0, 0, 0);      
  forme.vertex(largeur, 0, profondeur, 1, 0);   
  forme.vertex(largeur/2, -hauteur, profondeur/2, 0.5, 1);  
  
  // face derriere
  forme.vertex(0, 0, profondeur, 0, 0);      
  forme.vertex(largeur, 0, profondeur, 1, 0);      
  forme.vertex(largeur/2, -hauteur, profondeur/2, 0.5, 1);
  
  //Face du dessous
  forme.vertex(0, 0, 0, 0, 0);      
  forme.vertex(0, 0, profondeur, 1, 0);
  forme.vertex(largeur, 0, 0, 0.5 , 1);
  
  forme.vertex(largeur, 0, 0, 0, 0);      // Bas gauche
  forme.vertex(0, 0, profondeur, 1, 0);      // Haut gauche
  forme.vertex(largeur, 0, profondeur, 0.5 , 1);  // Sommet
  
}


PShape initSolExt(PShape solExt) {
  solExt = createShape();
  solExt.rotateX(PI/2);
  solExt.beginShape(QUAD);
  solExt.noStroke();
  //solExt.fill(210, 180, 120);
  // ajout d'une texture
  solExt.texture(textureSable);
  
  float[][] bruitTab = new float[401][401];
  for(int i = 0; i < 401; i++) {
    for(int j = 0; j < 401; j++) {
      bruitTab[i][j] = 10 * noise(i * 0.25f, j * 0.25f);
    }
  }
  
  for(int i = -200; i < 200; i++) {
    for(int j = -200; j < 200; j++) {
      float z1 = -15 + bruitTab[i+200][j+200];
      float z2 = -15 + bruitTab[i+201][j+200];
      float z3 = -15 + bruitTab[i+201][j+201];
      float z4 = -15 + bruitTab[i+200][j+201];
      solExt.vertex(i*8, j*8, z1, 0, 0);
      solExt.vertex(i*8 + 8, j*8, z2, 1, 0);
      solExt.vertex(i*8 + 8, j*8 + 8, z3, 1, 1);
      solExt.vertex(i*8, j*8 + 8, z4, 0, 1);
    }
  }
  solExt.endShape();
  return solExt;
}
