boolean click = false;
float angle=PI/25;
int times = 0;
PShape puntero, linex, liney, cruz, cuadradocruz, circulos;
PGraphics pg, pg1;
int[] movement = {0,0};
void header() {
  textSize(32);
  fill(0, 0, 0);
  text("Taller de Ilusiones Visuales", 250, 30); 
  text("", 430, 60); 
  textSize(15);
  text("Daniel Pinzón - Christian Ortiz", 330, 50);  
  text("Septiembre 2019", 375, 70); 
  textSize(25);
  text("-- Menu --", 625, 105); 
  textSize(13);
  text("Elija la ilusión que desea ver de este menú. Puede ver el\nestado de la ilusión, puede mostrarla/ocultarla haciendo click", 510, 130); 
  text("1.Colour Asimilation", 510, 175); 
  text("2.Hering Ilusion", 510, 195); 
  text("3.Stroboscopic effect", 510, 215); 
  text("4.Munker-White Illusion", 510, 235); 
  text("5.Motion-Induced Blindness", 510, 255); 
  text("6.Moiré Patterns", 510, 275); 
  //text("7.N/A", 510, 295); 
  //text("8.N/A", 510, 315); 
  //text("9.N/A", 510, 335); 
  line(500, 340, 1070, 340);
  line(500, 342, 1070, 342);
  textSize(20);
}
void setup() {
  size(900, 620);
  background(255);
  rect(4, 114, 501, 501);
  header();
  pg = createGraphics(500, 500);
  pg1 = createGraphics(390, 300);
  puntero = createShape();
  puntero.beginShape();
  puntero.fill(0);
  puntero.stroke(0);
  puntero.vertex(0, 0);
  puntero.vertex(5, 5);
  puntero.vertex(80, 5);
  puntero.vertex(85, 0);
  puntero.vertex(80, -5);
  puntero.vertex(5, -5);
  puntero.endShape(CLOSE);
  cuadradocruz = createShape(GROUP);
  for (int i = 0; i<301; i+=50) {
    for (int j = 0; j<301; j+=50) {
      strokeWeight(3);
      stroke(50, 50, 250);
      linex = createShape();
      linex.beginShape();
      linex.vertex(i-10, j);
      linex.vertex(i+10, j);
      linex.endShape();
      liney = createShape();
      liney.beginShape();
      liney.vertex(i, j-10);
      liney.vertex(i, j+10);
      liney.endShape();
      cruz = createShape(GROUP);
      cruz.addChild(linex);
      cruz.addChild(liney);
      cuadradocruz.addChild(cruz);
    }
  }
}

void mouseClicked() {
  if (click) {
    click = false;
  } else {
    click = true;
  }
}

PShape drawcircles(color c, int inicio) {
  strokeWeight(6);
  stroke(c);
  noFill();
  circulos = createShape(GROUP);
  for (int i = inicio; i <400; i+=24) {
    PShape circulito =createShape(ELLIPSE, 0, 0, i, i);
    circulos.addChild(circulito);
  }
  return circulos;
}

void draw() {
  String des="";
  pg.beginDraw();
  pg.strokeWeight(1);
  pg.background(255);
  if (key=='1') {
    des = "Colour Asimilation\nLa ilusión hace que usted vea los dos cuadrados de\nla esquina superior derecha y la inferior izquierda\nde diferentes colores (Azul y Verde), si la desactiva\npodrá ver que son del mismo color.";
    pg.stroke(0, 255, 150);
    pg.fill(0, 255, 150);
    pg.rect(0, 250, 250, 250);
    pg.rect(250, 0, 250, 250);
    if (click) {

      for (int i = 0; i<500; i+=12) {
        pg.stroke(255, 155, 10);
        pg.fill(255, 155, 10);
        pg.rect(0, i, 250, 5);
        pg.stroke(255, 0, 252);
        pg.fill(255, 0, 252);
        pg.rect(250, i, 250, 5);
      }
      for (int i = 0; i<250; i+=12) {
        pg.stroke(255, 155, 10);
        pg.fill(255, 155, 10);
        pg.rect(250, i+258, 250, 5);
        pg.stroke(255, 0, 252);
        pg.fill(255, 0, 252);
        pg.rect(0, i+6, 250, 5);
      }
    }
  } else if (key=='2') {
    des = "Hering Ilusion\nLa ilusión hace que usted vea que las dos líneas\nparalelas (Rojas) se vean un poco curvas.";
    pg.strokeWeight(2);
    pg.stroke(160, 0, 0);
    pg.line(210, 0, 210, 500);
    pg.line(290, 0, 290, 500);
    if (click) {
      pg.strokeWeight(1);
      pg.stroke(0, 0, 160);
      for (int i = 0; i<205; i+=15) {
        pg.line(i, 0, 500-i, 500);
        pg.line(500-i, 0, i, 500);
      }
      for (int i = 15; i<485; i+=15) {
        pg.line(0, i, 500, 500-i);
      }
    }
  } else if (key=='3') {
    des =  "Stroboscopic effect\nLa ilusion le permitirá ver 4 movimientos distintos,\nen 4 objetos que se mueven de manera periódica\nSuperior Izquierda: No hay destello, movimiento\nnormal.\nSuperior Derecha: Hay destello, movimiento en\nsentido contrario.\nInferior Izquierda: Hay destello, no hay movimiento.\nInferior Derecha: Hay destello, traslado 180°.";
    angle = PI/25;
    times+=1;
    puntero.rotate(angle);
    pg.shape(puntero, 125, 125);
    pg.shape(puntero, 375, 125);
    pg.shape(puntero, 125, 375);
    pg.shape(puntero, 375, 375);
    if (click) {
      pg.stroke(204);
      pg.fill(204);
      if (times%40!=0) {
        pg.rect(250, 0, 250, 250);
      }
      if (times%50!=0) {
        pg.rect(0, 250, 250, 250);
      }
      if (times%25!=0) {
        pg.rect(250, 250, 250, 250);
      }
    }
  } else if (key=='4') {
    des = "Munker-White Illusion\nLa ilusión hace que un disco se vea más oscuro que\nel otro, si la desactiva podrá ver que son del mismo color.";
    if (click) {
      for (int i = 0; i< 500; i+=23) {
        pg.stroke(10, 193, 20);
        pg.fill(10, 193, 20);
        pg.rect(0, i, 250, 10);
        pg.stroke(255);
        pg.fill(255);
        pg.rect(250, i+12, 250, 10);
      }
    }
    pg.stroke(255, 219, 10);
    pg.fill(255, 219, 10);
    pg.circle(125, 250, 200);
    pg.circle(375, 250, 200);
    if (click) {
      for (int i = 0; i< 500; i+=23) {
        pg.stroke(10, 193, 20);
        pg.fill(10, 193, 20);
        pg.rect(250, i, 250, 10);
        pg.stroke(255);
        pg.fill(255);
        pg.rect(0, i+12, 250, 10);
      }
    }
  } else if (key=='5') {
    des = "Motion-Induced Blindness\nSi se fija en el punto del centro (Verde/Rojo) podrá\nver quelos puntos amarillos irán desapareciendo.";
    times+=1;
    pg.background(0);
    pg.translate(250, 250);
    if (click) {
      pg.rotate(angle);
      pg.shape(cuadradocruz, -150, -150);
      angle+=PI/90;
      pg.rotate(-angle);
    } else {
      pg.shape(cuadradocruz, -150, -150);
    }
    pg.translate(-250, -250);
    pg.strokeWeight(6);
    if (times%50<25) {
      pg.stroke(30, 247, 68);
    } else {
      pg.stroke(247, 30, 68);
    }
    pg.point(250, 250);
    pg.strokeWeight(9);
    pg.stroke(255, 236, 18);
    pg.point(250, 175);
    pg.point(175, 325);
    pg.point(325, 325);
  } else if (key=='6') {
    des = "Moiré Patterns\nLa ilusión le permite ver bandas oscuras curvas,\nesto debido al movimiento y la superposición del\nconjunto de anillos amarillo.";
    PShape circuloverde = drawcircles(color(255, 236, 18), 20);
    pg.shape(circuloverde, 250, 250);
    PShape circuloamarillo = drawcircles(color(30, 247, 68), 32);
    if(click){
       int it = 0;
       while(it<2){
         if(movement[0]==100){
           movement[0]-=1;
         }
         if(movement[1]==100){
           movement[1]-=1;
         }
         int ran = int(random(4));
         if(ran==0){
           movement[0]+=1;
         }else if(ran==1){
           movement[0]-=1;
         }else if(ran==2){
           movement[1]+=1;
         }else{
           movement[1]-=1;
         }
         it+=1;
       }
       pg.shape(circuloamarillo, 250+movement[0], 250+movement[1]);
    }else{
       pg.shape(circuloamarillo, 250, 250);
    }
    
  }
  pg.endDraw();
  image(pg, 5, 115);
  pg1.beginDraw();
  pg1.background(255);
  String s = "";
  if (!click) {
    s = "Apagado";
    pg1.fill(250, 20, 20);
  } else {
    s = "Encendido";
    pg1.fill(20, 250, 20);
  }
  pg1.circle(20, 20, 20);
  pg1.textSize(18);
  pg1.text(s, 40, 27);
  pg1.fill(0);
  pg1.textSize(15);
  pg1.text(des, 5, 60);
  pg1.endDraw();
  image(pg1, 510, 350);
}
