// Import libraries
import processing.video.*;
import grafica.*; 

// Global Variables
Movie myMovie;
GPlot plot;
PGraphics pg, pg1, pg2, pg3, pg4;
PImage img;
GPointsArray myArray = new GPointsArray(0);
boolean video = false;
boolean histofilter = false;
char keytag = '0';
String p = "";
int click = 0;
int[] fclick = {0, 255};
int[] maskcor = {730, 280};
int [] histolimits = {366+87, 366+283, maskcor[1]+45, maskcor[1]+280};
//MASK
int hist[] = new int[256];
float[][] identity = { { 0, 0, 0 },{ 0, 1, 0 },{ 0, 0, 0 } }; 
float[][] edgeDetectionA = { { -1, 0, 1 },{ 0, 0, 0 },{ 1, 0, -1 } }; 
float[][] edgeDetectionB = { { 0, 1, 0 },{ 1, -4, 1 },{ 0, 1, 0 } }; 
float[][] edgeDetectionC = { { -1, -1, -1 },{ -1,  8, -1 },{ -1, -1, -1 } };
float[][] sharpen = { { 0, -1, 0 },{ -1, 5, -1 },{ 0, -1, 0 } }; 
float[][] boxBlur = { { 0.1, 0.1, 0.1 },{ 0.1, 0.1, 0.1 },{ 0.1, 0.1, 0.1 } }; 
float[][] gaussBlur3 = { { 0.0625, 0.125, 0.0625 },{ 0.125, 0.04, 0.125 },{ 0.0625, 0.125, 0.0625 } }; 
float[][] gaussBlur5 = { { 0.00390625, 0.015625, 0.0234375, 0.015625, 0.00390625 },{ 0.015625, 0.0625, 0.09375, 0.0625, 0.015625 },{ 0.0234375, 0.09375, 0.140625, 0.09375, 0.0234375 },{ 0.015625, 0.0625, 0.09375, 0.0625, 0.015625 },{ 0.00390625, 0.015625, 0.0234375, 0.015625, 0.00390625 } }; 
float[][] unsharpMask5 = { { -0.00390625, -0.015625, -0.0234375, -0.015625, -0.00390625 },{ -0.015625, -0.0625, -0.09375, -0.0625, -0.015625 },{ -0.0234375, -0.09375, 1.859365, -0.09375, -0.0234375 },{ -0.015625, -0.0625, -0.09375, -0.0625, -0.015625 },{ -0.00390625, -0.015625, -0.0234375, -0.015625, -0.00390625 } };
//STRIGN MASK
String sidentity =  " 0  0  0\n 0  1  0\n 0  0  0\n";
String sedgeDetectionA = "-1  0  1\n 0  0  0\n 1  0 -1\n";
String sedgeDetectionB = " 0  1  0\n 1 -4  1\n 0  1  0\n";
String sedgeDetectionC = "-1 -1 -1\n-1  8 -1\n-1 -1 -1\n";
String ssharpen = " 0 -1  0\n-1  5 -1\n 0 -1  0\n";
String sboxBlur = "        1  1  1\n1/9* 1  1  1\n        1  1  1\n"; 
String sgaussBlur3 = "          1  2  1\n1/16* 2  4  2\n          1  2  1\n";
String sgaussBlur5 = "            1   4    6    4   1\n            4  16  24  16  4\n1/256* 6  24  36  24  6\n            4  16  24  16  4\n            1   4    6    4   1\n";
String sunsharpMask5 =  "              1   4       6     4   1\n              4  16     24   16  4\n-1/256* 6  24  -476  24  6\n              4  16     24   16  4\n              1   4       6     4   1\n";

void setup() {
  size(1070, 620);
  pg = createGraphics(338, 362);
  pg1 = createGraphics(75, 40);
  pg2 = createGraphics(170, 40);
  pg3 = createGraphics(330, 80);
  pg4 = createGraphics(330, 330);
  g.background(255);
  header();
  img =loadImage("a.jpg");
  img.resize(330, 330);
  myMovie = new Movie(this, "b.mov");
  //myMovie.loop();
  //myMovie.volume(0);
  stroke(232, 157, 15);
}

void header() {
  fill(255, 255, 255);
  rect(195, 0, 687, 75);
  textSize(32);
  fill(0, 0, 0);
  text("Taller de Análisis de Imágenes por Software ", 200, 30); 
  text("", 430, 60); 
  textSize(15);
  text("Daniel Pinzón - Christian Ortiz", 430, 50);  
  text("Septiembre 2019", 475, 70); 
  textSize(25);
  text("-- Menu --", 460, 110); 
  textSize(18);
  text("Para ver el análisis en imágenes presione (i/I) y en videos (v/V) ,luego elija la operación deseada del siguiente menú.", 20, 135); 
  
  textSize(15);
  text("Escala de Grises: Promedio RGB (1) ", 98, 165); 
  text("Escala de Grises: Luma 709 (2)", 98, 185); 
  text("Escala de Grises: Luma 601 (3)", 98, 205); 
  text("Máscara de Identidad (4)", 98, 225); 
  text("Máscara Detección de Bordes A (5)", 410, 165); 
  text("Máscara Detección de Bordes B (6)", 410, 185); 
  text("Máscara Detección de Bordes C (7)", 410, 205); 
  text("Máscara Enfocar (8)", 410, 225); 
  text("Máscara Box Blur (9)", 730, 165); 
  text("Máscara Gaussian Blur 3x3 (q)", 730, 185); 
  text("Máscara Gaussian Blur 5x5 (w)", 730, 205); 
  text("Máscara Unsharp (e)", 730, 225); 
  line(0, 230, 1070, 230);
  line(0, 232, 1070, 232);
  textSize(20);
  text("Imagen Original", 90, maskcor[1]-15);
  fill(255, 255, 255);
  rect(8, maskcor[1]-2, 333, 333);
  rect(maskcor[0]-2, maskcor[1]-2, 333, 333);
}

void makehist() {
  pg1.beginDraw();
  pg1.background(255);
  pg1.endDraw();
  pg2.beginDraw();
  pg2.background(255);
  pg2.endDraw();
  image(pg1, 420, 590);
  image(pg2, 520, 590);
  pg3.beginDraw();
  pg3.background(255);
  pg3.fill(0, 0, 0);
  pg3.textSize(20);
  pg3.text("Histograma", 120, 30);
  pg3.textSize(10);
  pg3.text("Seleccione la sección que quiere segmentar", 20, 48);
  pg3.endDraw();
  image(pg3, 366, maskcor[1]-45);
  plot = new GPlot(this, 366, maskcor[1]+5, 330, 330);
  for (int i = 0; i< 256; i++) {
    myArray.add(i, hist[i]);
  }
  plot.setPointColor(258);
  plot.setPoints(myArray);
  plot.defaultDraw();  
  hist = new int[256];
}

void cleanGraphics() {
  pg = createGraphics(338, 362);
  pg.beginDraw();
  for (int i = 0; i<pg.height; i+=1) {
    for (int j = 0; j<pg.width; j+=1) {
      color white = color(255, 255, 255);
      pg.set(i, j, white);
    }
  }
  pg.fill(255, 255, 255);
  pg.rect(0, 28, 333, 333);
  pg.endDraw();
}

color convolution(int x, int y, float[][] matrix, int matrixsize, PImage img1)
{
  float rtotal = 0.0;
  float gtotal = 0.0;
  float btotal = 0.0;
  int offset = matrixsize / 2;
  for (int i = 0; i < matrixsize; i++) {
    for (int j= 0; j < matrixsize; j++) {
      // What pixel are we testing
      int xloc = x+i-offset;
      int yloc = y+j-offset;
      int loc = xloc + img1.width*yloc;
      // Make sure we haven't walked off our image, we could do better here
      loc = constrain(loc, 0, img1.pixels.length-1);
      // Calculate the convolution
      rtotal += (red(img1.pixels[loc]) * matrix[i][j]);
      gtotal += (green(img1.pixels[loc]) * matrix[i][j]);
      btotal += (blue(img1.pixels[loc]) * matrix[i][j]);
    }
  }
  // Make sure RGB is within range
  rtotal = constrain(rtotal, 0, 255);
  gtotal = constrain(gtotal, 0, 255);
  btotal = constrain(btotal, 0, 255);
  // Return the resulting color
  return color(rtotal, gtotal, btotal);
}

void maskvid(float[][]matrix, String nummask, int size) {
  pg = createGraphics(myMovie.width, myMovie.height);
  if (pg.width!=0 && pg.height!=0) {
    pg.beginDraw();
    pg.fill(0, 0, 0);
    for (int x = 0; x <myMovie.width; x++) {
      for (int y = 0; y <myMovie.height; y++ ) {
        color c = convolution(x, y, matrix, matrix.length, myMovie);
        pg.set(x, y, c);
      }
    }
    pg.endDraw();
    pg3.beginDraw();
    pg3.background(255);
    pg3.fill(0, 0, 0);
    pg3.textSize(20);
    pg3.text("Máscara", 120, 30);
    pg3.endDraw();
    image(pg3, 366, maskcor[1]-45);
    pg4.beginDraw();
    pg4.background(255);
    pg4.fill(0, 0, 0);
    pg4.textSize(size);
    pg4.text(nummask, 20, 90);
    pg4.endDraw();
    image(pg4, 366, maskcor[1]);
  }
}

void maskimg(String mask, float[][]matrix, String nummask, int size) {
  pg.beginDraw();
  pg.fill(0, 0, 0);
  pg.textSize(20);
  pg.text(mask, 0, 20);
  for (int x = 0; x <img.width; x++) {
    for (int y = 0; y <img.height; y++ ) {
      color c = convolution(x, y, matrix, matrix.length, img);
      pg.set(x+2, y+30, c);
    }
  }
  pg.endDraw();
  pg3.beginDraw();
  pg3.background(255);
  pg3.fill(0, 0, 0);
  pg3.textSize(20);
  pg3.text("Máscara", 120, 30);
  pg3.endDraw();
  image(pg3, 366, maskcor[1]-45);
  pg4.beginDraw();
  pg4.background(255);
  pg4.fill(0, 0, 0);
  pg4.textSize(size);
  pg4.text(nummask, 20, 90);
  pg4.endDraw();
  image(pg4, 366, maskcor[1]);
}

void grisrgbvid() {
  pg = createGraphics(myMovie.width, myMovie.height);
  if (pg.width!=0 && pg.height!=0) {
    pg.beginDraw();
    for (int i = 0; i<myMovie.width; i+=1) {
      for (int j = 0; j<myMovie.height; j+=1) {
        int rgbmean = (int)(red(myMovie.get(i, j)) + green(myMovie.get(i, j)) + blue(myMovie.get(i, j)))/3;
        color grey = color(rgbmean, rgbmean, rgbmean);
        pg.set(i, j, grey);
      }
    }
    pg.endDraw();
  }
}

void grisrgbimg() {
  pg.beginDraw();
  pg.fill(0, 0, 0);
  pg.textSize(20);
  pg.text("Escala de Grises: Promedio RGB", 0, 20); 
  for (int i = 0; i<img.height; i+=1) {
    for (int j = 0; j<img.width; j+=1) {
      int rgbmean = (int)(red(img.get(i, j)) + green(img.get(i, j)) + blue(img.get(i, j)))/3;
      if (histofilter) {
        if (!(rgbmean>=findpoint(fclick[0]) && rgbmean<=findpoint(fclick[1]))) {
          rgbmean = 255;
        }
      } else if (!video) {
        hist[rgbmean]++;
      }
      color grey = color(rgbmean, rgbmean, rgbmean);
      pg.set(i+2, j+30, grey);
    }
  }
  pg.endDraw();
  if (!video && !histofilter) {
    makehist();
  }
}

void grisrluma709vid() {
  pg = createGraphics(myMovie.width, myMovie.height);
  if (pg.width!=0 && pg.height!=0) {
    pg.beginDraw();
    for (int i = 0; i<myMovie.width; i+=1) {
      for (int j = 0; j<myMovie.height; j+=1) {
        int rgbmean = (int)(0.2126*red(myMovie.get(i, j)) + 0.7152*green(myMovie.get(i, j)) + 0.0722*blue(myMovie.get(i, j)));
        color grey = color(rgbmean, rgbmean, rgbmean);
        pg.set(i, j, grey);
      }
    }
    pg.endDraw();
  }
}

void grisrluma709img() {
  pg.beginDraw();
  pg.fill(0, 0, 0);
  pg.textSize(20);
  pg.text("Escala de Grises: Luma 709", 0, 20); 
  for (int i = 0; i<img.height; i+=1) {
    for (int j = 0; j<img.width; j+=1) {
      int rgbmean = (int)(0.2126*red(img.get(i, j)) + 0.7152*green(img.get(i, j)) + 0.0722*blue(img.get(i, j)));
      if (histofilter) {
        if (!(rgbmean>=findpoint(fclick[0]) && rgbmean<=findpoint(fclick[1]))) {
          rgbmean = 255;
        }
      } else if (!video) {
        hist[rgbmean]++;
      }
      color grey = color(rgbmean, rgbmean, rgbmean);
      pg.set(i+2, j+30, grey);
    }
  }
  pg.endDraw();
  if (!video && !histofilter) {
    makehist();
  }
}

void grisrluma601vid() {
  pg = createGraphics(myMovie.width, myMovie.height);
  if (pg.width!=0 && pg.height!=0) {
    pg.beginDraw();
    for (int i = 0; i<myMovie.width; i+=1) {
      for (int j = 0; j<myMovie.height; j+=1) {
        int rgbmean = (int)(0.2989*red(myMovie.get(i, j)) + 0.5870*green(myMovie.get(i, j)) + 0.1140*blue(myMovie.get(i, j)));
        color grey = color(rgbmean, rgbmean, rgbmean);
        pg.set(i, j, grey);
      }
    }
    pg.endDraw();
  }
}

void grisrluma601img() {
  pg.beginDraw();
  pg.fill(0, 0, 0);
  pg.textSize(20);
  pg.text("Escala de Grises: Luma 601", 0, 20); 

  for (int i = 0; i<img.height; i+=1) {
    for (int j = 0; j<img.width; j+=1) {
      int rgbmean = (int)(0.2989*red(img.get(i, j)) + 0.5870*green(img.get(i, j)) + 0.1140*blue(img.get(i, j)));
      if (histofilter) {
        if (!(rgbmean>=findpoint(fclick[0]) && rgbmean<=findpoint(fclick[1]))) {
          rgbmean = 255;
        }
      } else if (!video) {
        hist[rgbmean]++;
      }
      color grey = color(rgbmean, rgbmean, rgbmean);
      pg.set(i+2, j+30, grey);
    }
  }
  pg.endDraw();
  if (!video && !histofilter) {
    makehist();
  }
}

void mouseClicked() {
  if ((keytag=='1'||keytag=='2'||keytag=='3') && !video) {
    if (mouseY >= histolimits[2] && mouseY <= histolimits[3]) {
      if (mouseX>=histolimits[0] && mouseX<=histolimits[1]) {
        if (click==0) {
          click = 1;
          fclick[0] = mouseX;
        } else if (click==1) {
          if (fclick[0] < mouseX) {
            //maskcor[1]+260
            rect(fclick[0], maskcor[1]+45, mouseX-fclick[0], 230 );
            fclick[1] = mouseX;
          } else {
            rect(mouseX, maskcor[1]+45, fclick[0]-mouseX, 230);
            fclick[1] = fclick[0];
            fclick[0] = mouseX;
          }
          click = 2;   
          pg3.beginDraw();
          pg3.fill(232, 157, 15, 63);
          pg3.rect(270, 29, 50, 20);
          pg3.fill(0, 0, 0);
          pg3.textSize(15);
          pg3.text("Reset", 275, 45);
          pg3.endDraw();
          image(pg3, 366, maskcor[1]-45);
          histofilter = true;
          cleanGraphics();
          if (keytag=='1') {
            grisrgbimg();
          } else if (keytag=='2') {
            grisrluma709img();
          } else if (keytag=='3') {
            grisrluma601img();
          }
          image(pg, maskcor[0]-2, maskcor[1]-30);
        }
      }
    } else if (mouseX>=366+270 && mouseX<=366+320 && mouseY>=maskcor[1]-45+20 && mouseY<=maskcor[1]-45+49) {

      myArray = new GPointsArray(0); 
      reset();
      if (keytag=='1') {
        grisrgbimg();
      } else if (keytag=='2') {
        grisrluma709img();
      } else if (keytag=='3') {
        grisrluma601img();
      }
      image(pg, maskcor[0]-2, maskcor[1]-30);
    }
  }
}

void reset() {
  histofilter = false;
  click = 0;
  fclick[0] = 0;
  fclick[1] = 255;
}

int findpoint(int x) {
  int point = 0;
  for (int i = 0; i<256; i++) {
    if (i*0.75 > x-(histolimits[0]+2)) {
      break;
    } else {
      point = i;
    }
  }
  return point;
}

void update(int x, int y) {
  if ((keytag=='1'||keytag=='2'||keytag=='3') && !video) {
    if (x>=histolimits[0] && x<=histolimits[1]) {
      if (y >= histolimits[2] && y <= histolimits[3]) {
        cursor(HAND);
        int point = findpoint(x);
        if (p!="Pixel: "+str(point)) {
          plot.setPoints(myArray);
          plot.defaultDraw();
          if (click==1) {
            line(fclick[0], maskcor[1]+45, fclick[0], maskcor[1]+275);
          } else if (click==2) {
            fill(232, 157, 15, 63);
            rect(fclick[0], maskcor[1]+45, fclick[1]-fclick[0], 230);
          }
          if (click != 2) {
            line(x, maskcor[1]+45, x, maskcor[1]+275);
            pg1.beginDraw();
            pg1.background(255);
            pg1.fill(0, 0, 0);
            pg1.textSize(15);
            p = "Pixel: "+str(point);
            pg1.text(p, 0, 20); 
            pg1.endDraw();
          }          
          pg2.beginDraw();
          pg2.background(255);
          pg2.fill(0, 0, 0);
          pg2.textSize(15);
          String p1 = "";
          if (click == 0) {
            p1 = "Rango: "+str(point)+" - "+str(fclick[1]);
          } else if (click == 1) {
            if (point>findpoint(fclick[0])) {
              p1 = "Rango: "+str(findpoint(fclick[0]))+" - "+str(point);
            } else {
              p1 = "Rango: "+str(point)+" - "+str(findpoint(fclick[0]));
            }
          } else {
            p1 = "Rango: "+str(findpoint(fclick[0]))+" - "+str(findpoint(fclick[1]));
          }
          pg2.text(p1, 0, 20); 
          pg2.endDraw();
        }
      } else {
        cursor(ARROW);
      }
    } else {
      cursor(ARROW);
    }
    if (click!=0) {
      if (x>=366+270 && x<=366+320 && y>=maskcor[1]-45+20 && y<=maskcor[1]-45+49) {
        pg3.beginDraw();
        pg3.fill(232, 157, 15, 45);
        pg3.rect(270, 29, 50, 20);
        pg3.fill(0, 0, 0);
        pg3.textSize(15);
        pg3.text("Reset", 275, 45);
        pg3.endDraw();
        image(pg3, 366, maskcor[1]-45);
      } else {
        pg3.beginDraw();
        pg3.background(255);
        pg3.fill(0, 0, 0);
        pg3.textSize(20);
        pg3.text("Histograma", 120, 30);
        pg3.textSize(10);
        pg3.text("Seleccione la sección que quiere segmentar", 20, 48);
        pg3.fill(232, 157, 15, 63);
        pg3.rect(270, 29, 50, 20);
        pg3.fill(0, 0, 0);
        pg3.textSize(15);
        pg3.text("Reset", 275, 45);
        pg3.endDraw();
        image(pg3, 366, maskcor[1]-45);
      }
    }
    image(pg1, 420, 590);
    image(pg2, 520, 590);
  }
}

void movieEvent(Movie m) {
  m.read();
}

void draw() {
  update(mouseX, mouseY);

  if (video) {
    image(myMovie, 10, maskcor[1], 330, 330);
  } else {
    image(img, 10, maskcor[1]);
  }
  if (keyPressed) {
    if (key == 'v' || key == 'V') {
      pg3.beginDraw();
      pg3.background(255);
      pg3.endDraw();
      image(pg3, 366, maskcor[1]-45);
      pg4.beginDraw();
      pg4.background(255);
      pg4.endDraw();
      image(pg4, 366, maskcor[1]);
      myMovie.loop();
      cleanGraphics();
      image(pg, maskcor[0]-2, maskcor[1]-30);
      video = true;
      keytag = '0';
    }
    if (key == 'i' || key == 'I') {
      pg3.beginDraw();
      pg3.background(255);
      pg3.endDraw();
      image(pg3, 366, maskcor[1]-45);
      pg4.beginDraw();
      pg4.background(255);
      pg4.endDraw();
      image(pg4, 366, maskcor[1]);
      myMovie.stop();
      cleanGraphics();
      video = false;
      keytag = '0';
      image(pg, maskcor[0]-2, maskcor[1]-30);
    }
    //Promedio RGB
    if (key == '1') {
      keytag = '1';
      myArray = new GPointsArray(0);
      reset();
      cleanGraphics();
      grisrgbimg();
      image(pg, maskcor[0]-2, maskcor[1]-30);
      if (video) {
        grisrgbvid();
        image(pg, maskcor[0], maskcor[1], 330, 330);
      }
    }
    //Luma 709
    if (key == '2') {
      keytag = '2';
      reset();
      myArray = new GPointsArray(0);
      cleanGraphics();
      grisrluma709img();
      image(pg, maskcor[0]-2, maskcor[1]-30);
      if (video) {
        grisrluma709vid();
        image(pg, maskcor[0], maskcor[1], 330, 330);
      }
    }
    //Luma 601
    if (key == '3') {
      keytag = '3';
      reset();
      myArray = new GPointsArray(0);
      cleanGraphics();
      grisrluma601img();
      image(pg, maskcor[0]-2, maskcor[1]-30);
      if (video) {
        grisrluma601vid();
        image(pg, maskcor[0], maskcor[1], 330, 330);
      }
    }
    //Identity
    if (key == '4') {
      keytag = '4';
      reset();
      myArray = new GPointsArray(0);
      cleanGraphics();
      maskimg("Máscara de Identidad", identity, sidentity, 70);
      image(pg, maskcor[0]-2, maskcor[1]-30);
      if (video) {
        maskvid(identity, sidentity, 70);
        image(pg, maskcor[0], maskcor[1], 330, 330);
      }
    }
    //Edge Detection A
    if (key == '5') {
      keytag = '5';
      reset();
      myArray = new GPointsArray(0);
      cleanGraphics();
      maskimg("Máscara Detección de Bordes A", edgeDetectionA, sedgeDetectionA, 70);
      image(pg, maskcor[0]-2, maskcor[1]-30);
      if (video) {
        maskvid(edgeDetectionA, sedgeDetectionA, 70);
        image(pg, maskcor[0], maskcor[1], 330, 330);
      }
    }
    //Edge Detection B
    if (key == '6') {
      keytag = '6';
      reset();
      myArray = new GPointsArray(0);
      cleanGraphics();
      maskimg("Máscara Detección de Bordes B", edgeDetectionB, sedgeDetectionB, 70);
      image(pg, maskcor[0]-2, maskcor[1]-30);
      if (video) {
        maskvid(edgeDetectionB, sedgeDetectionB, 70);
        image(pg, maskcor[0], maskcor[1], 330, 330);
      }
    }
    //Edge Detection C
    if (key == '7') {
      keytag = '7';
      reset();
      myArray = new GPointsArray(0);
      cleanGraphics();
      maskimg("Máscara Detección de Bordes C", edgeDetectionC, sedgeDetectionC, 70);
      image(pg, maskcor[0]-2, maskcor[1]-30);
      if (video) {
        maskvid(edgeDetectionC, sedgeDetectionC, 70);
        image(pg, maskcor[0], maskcor[1], 330, 330);
      }
    }
    //Enfocar
    if (key == '8') {
      keytag = '8';
      reset();
      myArray = new GPointsArray(0);
      cleanGraphics();
      maskimg("Máscara Enfocar", sharpen, ssharpen, 70);
      image(pg, maskcor[0]-2, maskcor[1]-30);
      if (video) {
        maskvid(sharpen, ssharpen, 70);
        image(pg, maskcor[0], maskcor[1], 330, 330);
      }
    }
    //Box Blur
    if (key == '9') {
      keytag = '9';
      reset();
      myArray = new GPointsArray(0);
      cleanGraphics();
      maskimg("Máscara Box Blur", boxBlur, sboxBlur, 50);
      image(pg, maskcor[0]-2, maskcor[1]-30);
      if (video) {
        maskvid(boxBlur, sboxBlur, 50);
        image(pg, maskcor[0], maskcor[1], 330, 330);
      }
    }
    //Gaussian blur 3x3
    if (key == 'q' || key == 'Q') {
      keytag = 'q';
      reset();
      myArray = new GPointsArray(0);
      cleanGraphics();
      maskimg("Máscara Gaussian Blur 3x3", gaussBlur3, sgaussBlur3, 45);
      image(pg, maskcor[0]-2, maskcor[1]-30);
      if (video) {
        maskvid(gaussBlur3, sgaussBlur3, 45);
        image(pg, maskcor[0], maskcor[1], 330, 330);
      }
    }
    //Gaussian blur 5x5
    if (key == 'w' || key == 'W') {
      keytag = 'w';
      reset();
      myArray = new GPointsArray(0);
      cleanGraphics();
      maskimg("Máscara Gaussian Blur 5x5", gaussBlur5, sgaussBlur5, 25);
      image(pg, maskcor[0]-2, maskcor[1]-30);
      if (video) {
        maskvid(gaussBlur5, sgaussBlur5, 25);
        image(pg, maskcor[0], maskcor[1], 330, 330);
      }
    }
    //Unsharp 5x5
    if (key == 'e' || key == 'E') {
      keytag = 'e';
      reset();
      myArray = new GPointsArray(0);
      cleanGraphics();
      maskimg("Máscara Unsharp", unsharpMask5, sunsharpMask5, 20);
      image(pg, maskcor[0]-2, maskcor[1]-30);
      if (video) {
        maskvid(unsharpMask5, sunsharpMask5, 20);
        image(pg, maskcor[0], maskcor[1], 330, 330);
      }
    }
  }
  if (video) {
    if(keytag!='0'){
    frameRate(30);
    if (keytag=='1') {
      grisrgbvid();
      image(pg, maskcor[0], maskcor[1], 330, 330);
    } else if (keytag=='2') {
      grisrluma709vid();
      image(pg, maskcor[0], maskcor[1], 330, 330);
    } else if (keytag=='3') {
      grisrluma601vid();
      image(pg, maskcor[0], maskcor[1], 330, 330);
    } else if (keytag=='4') {
      maskvid(identity, sidentity, 70);
      image(pg, maskcor[0], maskcor[1], 330, 330);
    } else if (keytag=='5') {
      maskvid(edgeDetectionA, sedgeDetectionA, 70);
      image(pg, maskcor[0], maskcor[1], 330, 330);
    } else if (keytag=='6') {
      maskvid(edgeDetectionB, sedgeDetectionB, 70);
      image(pg, maskcor[0], maskcor[1], 330, 330);
    } else if (keytag=='7') {
      maskvid(edgeDetectionC, sedgeDetectionC, 70);
      image(pg, maskcor[0], maskcor[1], 330, 330);
    } else if (keytag=='8') {
      maskvid(sharpen, ssharpen, 70);
      image(pg, maskcor[0], maskcor[1], 330, 330);
    } else if (keytag=='9') {
      maskvid(boxBlur, sboxBlur, 50);
      image(pg, maskcor[0], maskcor[1], 330, 330);
    } else if (keytag=='q') {
      maskvid(gaussBlur3, sgaussBlur3, 45);
      image(pg, maskcor[0], maskcor[1], 330, 330);
    } else if (keytag=='w') {
      maskvid(gaussBlur5, sgaussBlur5, 25);
      image(pg, maskcor[0], maskcor[1], 330, 330);
    } else if (keytag=='e') {
      maskvid(unsharpMask5, sunsharpMask5, 20);
      image(pg, maskcor[0], maskcor[1], 330, 330);
    }
    pg2.beginDraw();
    pg2.background(255);
          pg2.fill(0, 0, 0);
          pg2.textSize(15);
          pg2.text("Frame Rate: "+str(frameRate), 0, 20); 
          pg2.endDraw();
          image(pg2, 520, 590);
  }
  }
}
