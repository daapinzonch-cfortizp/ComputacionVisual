import nub.primitives.*;
import nub.core.*;
import nub.processing.*;

// 1. Nub objects
Scene scene;
Node node;
Vector v1, v2, v3;
// timing
TimingTask spinningTask;
boolean yDirection;
// scaling is a power of 2
int n = 4;

// 2. Hints
boolean triangleHint = true;
boolean gridHint = true;
boolean debug = true;
boolean shadeHint = false;

// 3. Use FX2D, JAVA2D, P2D or P3D
String renderer = P2D;

// 4. Window dimension
int dim = 10;

void settings() {
  size(int(pow(2, dim)), int(pow(2, dim)), renderer);
}

void setup() {
  rectMode(CENTER);
  scene = new Scene(this);
  if (scene.is3D())
    scene.setType(Scene.Type.ORTHOGRAPHIC);
  scene.setRadius(width/2);
  scene.fit(1);

  // not really needed here but create a spinning task
  // just to illustrate some nub timing features. For
  // example, to see how 3D spinning from the horizon
  // (no bias from above nor from below) induces movement
  // on the node instance (the one used to represent
  // onscreen pixels): upwards or backwards (or to the left
  // vs to the right)?
  // Press ' ' to play it
  // Press 'y' to change the spinning axes defined in the
  // world system.
  spinningTask = new TimingTask(scene) {
    @Override
    public void execute() {
      scene.eye().orbit(scene.is2D() ? new Vector(0, 0, 1) :
        yDirection ? new Vector(0, 1, 0) : new Vector(1, 0, 0), PI / 100);
    }
  };

  node = new Node();
  node.setScaling(width/pow(2, n));

  // init the triangle that's gonna be rasterized
  randomizeTriangle();
}

void draw() {
  background(0);
  stroke(0, 255, 0);
  if (gridHint)
    scene.drawGrid(scene.radius(), (int)pow(2, n));
  if (triangleHint)
    drawTriangleHint();
  push();
  scene.applyTransformation(node);
  triangleRaster();
  pop();
}

float tri_area(boolean type){
  float vax = node.location(v2).x();
  float vbx = node.location(v3).x();
  float vcx = node.location(v1).x();
  float vay = node.location(v2).y();
  float vby = node.location(v3).y();
  float vcy = node.location(v1).y();
  if(type){
    return (((vcx-vax)*(vay - vby))- ((vcy-vay)*(vax-vbx))) ;
  }else{
    return (((vcx-vax)*(vby - vay))- ((vcy-vay)*(vbx-vax)));
  }
}

float barycentric(Vector a , Vector b,Vector c,boolean type){
  float vax = node.location(a).x();
  float vbx = node.location(b).x();
  float vcx = c.x();
  float vay = node.location(a).y();
  float vby = node.location(b).y();
  float vcy = c.y();
  if(type){
    return (((vcx-vax)*(vay - vby))- ((vcy-vay)*(vax-vbx))) ;
  }else{
    return (((vcx-vax)*(vby - vay))- ((vcy-vay)*(vbx-vax)));
  }
}

boolean edge(Vector a , Vector b,float i, float j,boolean type){
  float vax = node.location(a).x();
  float vbx = node.location(b).x();
  float vay = node.location(a).y();
  float vby = node.location(b).y();
  if(type){
    return ((((j-vax)*(vay - vby))- ((i-vay)*(vax-vbx))) >=0) ;
  }else{
    return ((((j-vax)*(vby - vay))- ((i-vay)*(vbx-vax))) >=0) ;
  }
  
}

// Implement this function to rasterize the triangle.
// Coordinates are given in the node system which has a dimension of 2^n
void triangleRaster() {
  // node.location converts points from world to node
  // here we convert v1 to illustrate the idea
  if (debug) {
    push();
    noStroke();
    float init = (pow(2, n)/2)-0.5;
    for(float i = -init; i<pow(2, n)/2; i+=1){
       for(float j = -init; j<pow(2, n)/2; j+=1){
         boolean inside = true;
         inside &= edge(v1,v2,i,j,false);
         inside &= edge(v2,v3,i,j,false);
         inside &= edge(v3,v1,i,j,false);
         boolean inside1 = true;
         inside1 &= edge(v1,v2,i,j,true);
         inside1 &= edge(v2,v3,i,j,true);
         inside1 &= edge(v3,v1,i,j,true);
         if(inside || inside1){
           float[] rgb = new float[3];
           Vector p = new Vector(j,i);
           if(inside){
             
               float area = tri_area(false);
               rgb[0] = 255*(barycentric(v2,v3,p,false)/area);
               rgb[1] = 255*(barycentric(v3,v1,p,false)/area);
               rgb[2] = 255*(barycentric(v1,v2,p,false)/area);
           }else{
              
               float area = tri_area(true);
               rgb[0] = 255*(barycentric(v2,v3,p,true)/area);
               rgb[1] = 255*(barycentric(v3,v1,p,true)/area);
               rgb[2] = 255*(barycentric(v1,v2,p,true)/area);
           }
           fill(rgb[0],rgb[1],rgb[2]);
           square(j,i,1);
         }
    }
   
    }
     pop();
  }
}

void randomizeTriangle() {
  int low = -width/2;
  int high = width/2;
  v1 = new Vector(random(low, high), random(low, high));
  v2 = new Vector(random(low, high), random(low, high));
  v3 = new Vector(random(low, high), random(low, high));
}

void drawTriangleHint() {
  push();

  if(shadeHint)
    noStroke();
  else {
    strokeWeight(2);
    noFill();
  }
  beginShape(TRIANGLES);
  if(shadeHint)
    fill(255, 0, 0);
  else
    stroke(255, 0, 0);
  vertex(v1.x(), v1.y());
  if(shadeHint)
    fill(0, 255, 0);
  else
    stroke(0, 255, 0);
  vertex(v2.x(), v2.y());
  if(shadeHint)
    fill(0, 0, 255);
  else
    stroke(0, 0, 255);
  vertex(v3.x(), v3.y());
  endShape();

  strokeWeight(5);
  stroke(255, 0, 0);
  point(v1.x(), v1.y());
  stroke(0, 255, 0);
  point(v2.x(), v2.y());
  stroke(0, 0, 255);
  point(v3.x(), v3.y());

  pop();
}

void keyPressed() {
  if (key == 'g')
    gridHint = !gridHint;
  if (key == 't')
    triangleHint = !triangleHint;
  if (key == 's')
    shadeHint = !shadeHint;
  if (key == 'd')
    debug = !debug;
  if (key == '+') {
    n = n < 7 ? n+1 : 2;
    node.setScaling(width/pow( 2, n));
  }
  if (key == '-') {
    n = n >2 ? n-1 : 7;
    node.setScaling(width/pow( 2, n));
  }
  if (key == 'r')
    randomizeTriangle();
  if (key == ' ')
    if (spinningTask.isActive())
      spinningTask.stop();
    else
      spinningTask.run();
  if (key == 'y')
    yDirection = !yDirection;
}
