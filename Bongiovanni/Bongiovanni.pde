PImage img, outBongio;
PGraphics bongioCopy;

String iname = "colorbird2";
String iExt = ".jpg";
String outExt = ".png";

boolean selecting = true;
boolean finalizing = false;
boolean drawing = false;
int topLim = 0;
int bottomLim = 0;
int leftLim = 0;
int rightLim = 0;

boolean fixedWidthTrigger = false;
int fixedWidth = 20;

boolean fixedHeightTrigger = true;
int fixedHeight = 40;

void setup() {
  img = loadImage(iname + iExt);
  bongioCopy = createGraphics(img.width, img.height);
  bongioCopy.copy(img, 0, 0, img.width, img.height, 0, 0, img.width, img.height);
  size(img.width, img.height);
  rectMode(CORNERS);
}

void draw()
{
  bongioCopy.beginDraw();
  image(img, 0, 0);
  if (selecting || finalizing)
  {
    stroke(255, 0, 0);
    line(mouseX, 0, mouseX, height);
    line(0, mouseY, width, mouseY);
    if (finalizing)
    {
      noFill();
      rect(leftLim, topLim, mouseX, mouseY);
    }
  } else if (drawing)
  {
    
    image (img, 0, 0);
    stroke(255, 0, 0);
    noFill();
    strokeWeight(1);

    img.loadPixels();

    outBongio = bongiovanniSort(bongioCopy, leftLim, topLim, rightLim, bottomLim, 0.0);
    outBongio.save(iname + "Bongiovanni.png");
    image(outBongio, 0, 0);
    img = outBongio;
    resetParams();
    bongioCopy.endDraw();
  }
}

void mousePressed()
{
  if (selecting)
  {
    topLim = mouseY;
    leftLim = mouseX;
    selecting = false;
    finalizing = true;
  } else if (finalizing)
  {
    if (mouseX < leftLim)
    {
      rightLim = leftLim;
      leftLim = mouseX;
    } else
    {
      rightLim = mouseX;
    }
    if (mouseY < bottomLim)
    {
      bottomLim = topLim;
      topLim = mouseY;
    } else
    {
      bottomLim = mouseY;
    }
    if (fixedWidthTrigger)
    {
      rightLim = leftLim + fixedWidth;
    }
    if (fixedHeightTrigger)
    {
     bottomLim = topLim + fixedHeight; 
    }
    drawing = true;
    finalizing = false;
    selecting = false;
  }
}

PImage bongiovanniSort(PGraphics copyImg, int row, int col, int wide, int tall, float angle)
{
  /*
   Receive image and coordinate of the point to start drawing
   Copy pixels starting at (row,col) and going for wide
   Repeat copied pixels for tall
   Later features:   
   - ANGLE should determine angle of melting
   - More painterly drop shape
   - Layering strands
   */

  int actualWidth = wide-row;
  float halfWidth = (wide-row)/2.0;
  color c[] = new color[actualWidth];
  for (int i = 0; i < actualWidth; i++)
  {
    c[i] = img.pixels[i+row+(col*copyImg.width)];
  }
  //Drip
  int half_r;
  for (int r = 0; r < actualWidth; r++)
  {
    half_r = floor(r/2.0);
    copyImg.strokeWeight(0.5);
    copyImg.noStroke();
    copyImg.fill(c[half_r]);
    copyImg.arc((row+wide)/2.0, tall*1.0, float(actualWidth-r), float(actualWidth-r), HALF_PI, PI);
  }
  for (int r = 0; r < actualWidth; r++)
  {
    half_r = floor(r/2.0);  
    copyImg.fill(c[actualWidth - 1 - half_r]);    
    copyImg.arc((row+wide)/2.0, tall*1.0, float(actualWidth-r), float(actualWidth-r), 0, HALF_PI);
  }

  //Drop
  for (int h = 0; h < floor (tall-col); h++)
  {
    for (int i = 0; i < wide-row; i++)
    {
      copyImg.set((i + row), col+h, c[i]);
    }
  }
  return copyImg;
}

void resetParams()
{
  drawing = false;
  finalizing = false;
  selecting = true;
  topLim = 0;
  leftLim = 0;
  rightLim = 0;
  bottomLim = 0;
}

