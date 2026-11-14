
///////////////////////////////////////////////////////////////////////////
///////// MINIMAP
///////////////////////////////////////////////////////////////////////////


void drawMiniMap(){
  pushMatrix();
  perspective();
  camera(width/2.0, height/2.0, (height/2.0) / tan(PI*30.0 / 180.0), width/2.0, height/2.0, 0, 0, 1, 0);
  noLights();
  stroke(0);
  if (posX>0 && posX<LABS_SIZES[etage]-1 && posY >0 && posY <LABS_SIZES[etage] -1){
     if( ! deja_visite.get(etage)[posY][posX]){
         deja_visite.get(etage)[posY+1][posX-1] = true;
         deja_visite.get(etage)[posY][posX-1] = true;
         deja_visite.get(etage)[posY-1][posX-1] = true;
         
         deja_visite.get(etage)[posY+1][posX] = true;
         deja_visite.get(etage)[posY][posX] = true;
         deja_visite.get(etage)[posY-1][posX] = true;
         
         deja_visite.get(etage)[posY+1][posX+1] = true;
         deja_visite.get(etage)[posY][posX+1] = true;
         deja_visite.get(etage)[posY-1][posX+1] = true;
     }
      }
  for (int j=0; j<LABS_SIZES[etage]; j++) {
    for (int i=0; i<LABS_SIZES[etage]; i++) {
        
      if (labyrinthe.get(etage)[j][i]=='#' && deja_visite.get(etage)[j][i]) {
        
        fill(i*25, j*25, 255-i*10+j*10);
        pushMatrix();
        translate(50+i*wallW[etage]/8, 50+j*wallH[etage]/8, 50);
        box(wallW[etage]/10, wallH[etage]/10, 5);
        popMatrix();
      }
    }
  }
  pushMatrix();
  fill(0, 255, 0);
  noStroke();
  translate(50+posX*wallW[etage]/8, 50+posY*wallH[etage]/8, 50);
  sphere(3); // Dessine la sphere
  stroke(255);
  
  strokeWeight(3); // Dessine la ligne de vision
  line(0, 0, dirX*12, dirY*12);
  
  //Maigre ajout de Raphaël à la minimap :)
  line(dirX*11, dirY*11, dirX * 8 + 4, dirY * 8);
  line(dirX*11, dirY*11, dirX * 8 - 4, dirY * 8);
  line(dirX*11, dirY*11, dirX * 8, dirY * 8 + 4);
  line(dirX*11, dirY*11, dirX * 8, dirY * 8 - 4);
  
  noStroke();
  strokeWeight(1);
  popMatrix();
  popMatrix();
}


//PShape creerArrow(){
  



//}
