
void draw_TP(){
    pushMatrix();
    translate(wallH[etage]*(labyrinthe.get(etage).length -1),
            wallH[etage]*(labyrinthe.get(etage)[0].length - 2), -wallH[etage]/2);
    shape(TP,0,0);
    displayParticulesTP(true);
    popMatrix();
            
    if (etage > 0){
      pushMatrix();
      translate(wallH[etage],0,-wallH[etage]/2);
      shape(TP,0,0);
      displayParticulesTP(false);
      popMatrix();
      
    }
}


PShape creeJoliTP(float R, float r, int uCount, int vCount, PImage texture) {
  PShape donut = createShape();
  donut.beginShape(QUAD_STRIP);
  donut.texture(texture);
  //donut.texture(texture);
  donut.noStroke();
  //donut.fill(0, 245, 0);

  for (int i = 0; i < uCount; i++) {
    float u = map(i, 0, uCount, 0, 2*PI);
    float nextU = map(i + 1, 0, uCount, 0, TWO_PI);
    
    for (int j = 0; j <= vCount; j++) {
      float v = map(j, 0, vCount, 0, 2*PI);
      // Une fonction qui met les elements de j entre 0 et 2*PI
      
      // Premier vertex
      float x1 = (R + r * cos(v)) * cos(u);
      float y1 = (R + r * cos(v)) * sin(u);
      float z1 = r * sin(v);

      // deuxième vertex
      float x2 = (R + r * cos(v)) * cos(u + 2*PI / uCount);
      float y2 = (R + r * cos(v)) * sin(u + 2*PI / uCount);
      float z2 = r * sin(v);

      float uTex1 = map(u, 0, TWO_PI, 0, texture.width);
      float uTex2 = map(nextU, 0, TWO_PI, 0, texture.width);
      float vTex = map(v, 0, TWO_PI, 0, texture.height);
      
      donut.vertex(x1, y1, z1, uTex1, vTex);
      donut.vertex(x2, y2, z2, uTex2, vTex);
    }
  }
  
  donut.endShape();
  return donut;
}
