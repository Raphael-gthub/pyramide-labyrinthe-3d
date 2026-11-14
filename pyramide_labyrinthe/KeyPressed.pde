void keyPressed() {
  
  if (!inPyramid && key=='e'){ //enter
      posX = 1;
      posY = 0;
      dirX = 0;
      dirY = 1;
  }
  
  if (inPyramid && key=='o'){ //out
      posX = iposX;
      posY = iposY;
      pos_depart = true;
  }
  
  
  if (keyCode==38 || key=='z') { //forward
  //if (anim == 0 && (keyCode==38 || key=='z')) {
    if ( !inPyramid || (posX+dirX>=0 && posX+dirX<LABS_SIZES[etage] && posY+dirY>=0 && posY+dirY<LABS_SIZES[etage] &&
      labyrinthe.get(etage)[posY+dirY][posX+dirX]!='#')) {
      posX+=dirX; 
      posY+=dirY;
      anim=int(anim_max);
      animT = true;
      animR = false;
      animBackOff = false;
    }
  }
  if (keyCode==40|| key=='s'){ //backwards
    if (!inPyramid || (anim==0 && posY-dirY >= 0 && posY-dirY < LABS_SIZES[etage] && labyrinthe.get(etage)[posY-dirY][posX-dirX]!='#')) {
      posX-=dirX; 
      posY-=dirY;
      anim=int(anim_max);
      animT = false;
      animR = false;
      animBackOff = true;
    }
  }
  if (anim==0 && (keyCode==37|| key=='q')) { //left
    odirX = dirX;
    odirY = dirY;
    anim = int(anim_max)/2;
    int tmp = dirX; 
    dirX=dirY; 
    dirY=-tmp;
    animT = false;
    animR = true;
    animBackOff = false;
  }
  if (anim==0 && (keyCode==39 || key=='d')) { //right
    odirX = dirX;
    odirY = dirY;
    anim = int(anim_max)/2;
    animT = false;
    animR = true;
    animBackOff = false;
    int tmp = dirX; 
    dirX=-dirY; 
    dirY=tmp;
  }
  
  if (anim==0 && key == 'k'){ // one floor up (cheat)
    OneFloorUp();
  }
  if (anim==0 && key == 'j'){ // one floor down (cheat)
    OneFloorDown();
  }
  
  if (anim==0 && key == ' '){ //teleport
    if( posX == labyrinthe.get(etage).length -1
      && posY == labyrinthe.get(etage)[0].length -2){
        boolean ok = OneFloorUp();
        if (ok){
          posX = 1;
          posY = 0;
          dirX = 0;
          dirY = 1;
        }
        else{
          print("Bravo !!!"); //TODO : que faire quand on gagne! Ne marche pas toujours
        } 
    }
    else if (posX == 1 && posY == 0){
        boolean ok = OneFloorDown();
        if (ok){
          posX = labyrinthe.get(etage).length -1;
          posY = labyrinthe.get(etage)[0].length -2;
          dirX = -1;
          dirY = 0;
        }
    }
  }
  
  if (inPyramid && anim == 0 && key == 'r'){ //Restart
    //restart
    elapsed = 0; 
    posX = 1;
    posY = 0;
    dirX = 0;
    dirY = 1;
  }
  
  if (key == 'h'){
    print("HELP MENU\n");
    print("You are in a labyrinth, to get out you must go to the",
          "end of the labyrinth which is at the opposite side of where you are",
          "good luck, don't lose yourself !\n");
    print("e to enter the labyrinth\n");
    print("o to exit the labyrinth\n");
    print("zqsd or arrows to move\n");
    print("space bar to activate the teleporter\n");
    print("r to restart at first position\n");
  }
  
}

///////////////////////////////////////////////////////////////////////////
///////// One floor up and one floor down
///////////////////////////////////////////////////////////////////////////

boolean OneFloorUp(){
    if (etage < nb_etage - 1){
      //translate(0,0,-wallH[etage]); il se change sur place
      etage++;
      lastFloorChangeTime = millis();
      start = true;
      return true;
    }
    return false;
}

boolean OneFloorDown(){
    if (0 < etage){
      //translate(0,0,wallH[etage]);
      etage--;
      start = true;
      return true;
    }
    return false;
    
}
