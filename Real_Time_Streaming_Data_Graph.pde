import processing.serial.*; // Must import Serial library in order to use serial interface
float hum = 0;
float tempr = 0;
color rectColor, lineColor = 0;
int lastTime = 0;
int margin = 70;
int window = 10000; // window of time
float tempX, tempY =0; // temp valur for create line chart
void setup()
{
  size(450, 450);
  background(255);
  Serial arduinoConnection; // set serial name
  arduinoConnection = new Serial(this, "COM7", 115200); // set new serial port that connect to Arduino board (port number can be difference)
  drawLine();
}
void drawLine() // draw chart base 
{
  stroke(0);
  strokeWeight(1);
  textSize(12);
  line(margin-10, (height-margin)+10, width+10-margin, (height-margin)+10); // x-axis
  line(margin-10, (height-margin)+10, margin-10, margin-10); // y-axis
  line(width-margin+10, (height-margin)+10, width+10-margin, margin-10); // secondary y-axis
  int step = (width- 2 * margin)/(window / 1000);
  int seconds = 0;
  fill(0);
  // x-axis lable
  for (int i = margin; i <= width-margin; i+=step)
  {
    int y = height-margin+25;
    int x = i;
    text(seconds++, x, y);
  }
  // y-axis lable
  int distance = 0;
  step = (height - 2 * margin)/(10);
  for (int i = height-margin; i >= margin; i-=step)
  {
    int x = margin-35;
    int y = i;
    text(distance, x, y);
    distance+=10;
  }
  // secondary y-axis lable
  int percent = 0;
  step = (height - 2 * margin)/(10);
  for (int i = height-margin; i >= margin; i-=step)
  {
    int x = width-50;
    int y = i;
    text(percent+" %", x, y);
    percent+=10;
  }
  // create text
  text("Temperature(*C)", margin-45, margin-25);
  text("Time(sec.)", height-margin-20, height-30);
  text("Humidity(%)", width-margin-50, margin-25);
  textSize(16);
  text("Temperature and Humidity", width/2-margin*2, margin-50); // chart title
  // create legend
  textSize(10);
  text("Humidity", width/2+30, height-15);
  text("Temperature", width/2-margin*2+20, height-15);
  // line legend
  stroke(lineColor);
  strokeWeight(2);
  fill(rectColor);
  line(width/2, height-20, width/2+20, height-20);
  ellipse(width/2, height-20, 5, 5);
  // bar legend
  fill(rectColor, 75);
  noStroke();
  rect(width/2-margin*2, height-30, 15, 15, 3);
}
void draw()
{
  // Sharp IR range sensor can return value between 0–140 (as distance value in cm.) sometimes it return negative value
  try { 
    if (tempr>140) tempr = 140;
  }
  catch(Exception range) {
    println("Error reading distance data"); // in case the value can’t store in float, print out error
    println(range);
    tempr = 0;
  }
  // create initial value
  float x = 0;
  float y = 0;
  float yLine = 0;
  int currTime = millis()%window;
  if (currTime < lastTime)
  {
    reset(); // reset the chart when it reached the end (10 seconds)
  }
  fill(rectColor, 75);
  float arrayTemp [];
  if (currTime - lastTime > 500)
  {
    float lightIntensity = map(hum, 1023, 0, 100, 0); // map humidity value to percentage (0–100%)
    x = map(currTime, 0, window, margin, width-margin);
    y = map(tempr, 140, 0, margin, height-margin);
    yLine = map(lightIntensity, 100, 0, margin, height-margin);
    drawLineChart(x, yLine); // draw line chart
    float barHeight = (height-margin)-y;
    noStroke();
    rect(x, y, 10, barHeight, 3);
    lastTime = currTime;
  }
  saveFrame("frame####.png");
}
void drawLineChart(float x, float y)
{
  strokeWeight(2);
  if (tempX == 0 && tempY == 0) // if it is the first time running => no line
  {
    tempX = x; // set current value to temp value
    tempY = y;
  } else { 
    stroke(lineColor);
    ellipse(x, y, 5, 5);
    line(tempX, tempY, x, y);
    tempX = x;
    tempY = y;
  }
}
void reset()
{
  background(255); // reset the chart
  lastTime = 0;
  tempX =0; // reset temp value for line chart
  tempY =0; // reset temp value for line chart
  rectColor = color(random(255), random(255), random(255)); // random color for bar chart
  lineColor = color(random(255), random(255), random(255)); // random color for line chart
  drawLine(); // recreate the chart component
}
void serialEvent(Serial port)
{
  String data = port.readStringUntil('\n'); // read data from serial port and store it to string value
  if (data != null) // the loop runs when data is not empty
  {
    data = trim(data); // try to sanitize whitespace away from input
    float[] temp = float(split(data, ","));
    try { 
      hum = temp[0];
      tempr = temp[1];
    }
    catch(Exception ex) {
      println("Error parsing data"); // in case the value can’t store in float, print out error
      println(ex);
      tempr = -1;
    }
    println(hum + " " + tempr ); // print value from serial port
  }
}
