//
// Fork by Rupert Russell of Circle Tree by Agoston Nagy
// https://www.openprocessing.org/sketch/138954
// 

int maxCells = 21000; 
float startradius = 380; // was 450

float minRadius = 2; 
int count = 0;
float speed = 10000;
int startTime, maxTime;
int cellCount, oldCellCount;
ArrayList Cells = new ArrayList(); 

void setup()
{
  size(9411, 9411);
  background(0);
  noStroke();

  Cell C = new Cell(new PVector(width/2, height/2), null, startradius);
}

void metro(int maxTime)
{
  int elapsed = millis() - startTime;
  if (elapsed>maxTime)
  {
    int over = elapsed-maxTime;
    startTime=millis()-over;

    for (int c=0; c<Cells.size(); c++)
    {
      Cell C = (Cell) Cells.get(c); 
      if (Cells.size() < maxCells && C.radius > minRadius)
      {
        C.grow();
      }
    }
  }
}

void draw() {
  background(178, 228, 15); 
  oldCellCount = Cells.size();

  metro(int(speed));
  if (Cells.size() > oldCellCount) {
    println("Cells.size() = " + Cells.size());
    oldCellCount = Cells.size();
  }


  for (int c=0; c<Cells.size(); c++)
  {

    Cell C = (Cell) Cells.get(c); 
    C.render();
  }
}

void mouseReleased()
{

  save("tree_9411M_" + count + ".png");
  println("saved tree_9411M_" + count + ".png");
  println("Cells.size() = " + Cells.size() );
  count++ ;
}

void keyPressed() {
  println("Key Press - Cells.size() = " + Cells.size() );
}


class Cell {
  PVector pos; 
  float radius; 

  int child; 
  int age; 
  int maxAge = 20; 
  Cell parent; 

  float alpha = 0;

  Cell(PVector _pos, Cell _parent, float _radius)
  { 
    pos = _pos;
    parent = _parent;
    radius = _radius;
    age = 0; 
    child = 0;    
    Cells.add(this);
  }

  void render() {


    noStroke();
    fill(50, 205-child*35, 255); 
    ellipse(pos.x, pos.y, radius*2, radius*2); 

    if (parent == null) //  start cell (no parent)
    { 
      fill(255);
      ellipse(pos.x, pos.y, 15, 15);
    }

    strokeWeight(2); // was 1;
    stroke(255);

    if (parent != null)
    { 
      line(pos.x, pos.y, parent.pos.x, parent.pos.y);
    }

    for  (int c=0; c<Cells.size(); c++)
    {

      Cell C = (Cell)  Cells.get(c);
      if (child<1)  //  last cell (no children)
      { 
        noStroke();
        fill(255, 0, 0);
        ellipse(pos.x, pos.y, 5, 5); // red dot at center
      }
    }
  }

  void grow()
  {
    float nextradius = radius * 0.915; // was 0.9

    for (int i=0; i<3; i++)
    { 
      boolean collide = false; // boolean switch for collisions
      float growAngle = int(random(8))*(PI/4); // (0, 45, 90, 135, 180, 225, 270 or 315)     
      PVector growPos = new PVector( pos.x +  cos(growAngle)*(radius+nextradius), pos.y + sin(growAngle)*(radius+nextradius)); 
      //  check collisions
      for  (int c=0; c<Cells.size(); c++)
      {
        Cell C = (Cell)  Cells.get(c);
        if (C != this  && growPos.dist(C.pos) < radius + C.radius) 
        { 
          collide = true; 
          nextradius *= 0.915  ;
        }
      }
      if (! collide) { 
        Cell newCell = new Cell(growPos, this, nextradius); 
        child++; 
        return;
      }
    }
  }
}
