import processing.serial.*;
import controlP5.*;
import java.util.Random;
import java.lang.String;

Serial myPort;        // Serial port
float temp, pH, stirring;
float targetTemp, targetpH, targetStirring;
long lastTimeMillis;

ControlP5 cp5;

int myColorBackground = color(0,0,0);

Knob myKnobA; // Change Temperature 
Knob myKnobB; // Change pH 
Knob myKnobC; // Change Stirring 
Knob currentTemp; // Current Temperature
Knob currentpH; // Current pH
Knob currentStirring; // Current Stirring

Chart myChartA; // Temperature Line Graph
Chart myChartB; // pH Line Graph

void setup() {
  
  // myPort = new Serial(this, nameOfPort, 9600);
  // myPort.bufferUntil('\n');
  
  size(1000,550);
  smooth();
  noStroke();
  
  cp5 = new ControlP5(this);
  
  temp = 15;
  
  myKnobA = cp5.addKnob("Set Temp")
               .setRange(15,35)
               .setValue(temp)
               .setPosition(100,70)
               .setRadius(50)
               .setNumberOfTickMarks(10)
               .snapToTickMarks(false)
               .setDragDirection(Knob.HORIZONTAL)
               ;
                     
  myKnobB = cp5.addKnob("Set pH")
               .setRange(0,14.0)
               .setValue(220)
               .setPosition(100,210)
               .setRadius(50)
               .setNumberOfTickMarks(10)
               .setTickMarkLength(4)
               .snapToTickMarks(false)
               .setDragDirection(Knob.HORIZONTAL)
               ;
  myKnobC = cp5.addKnob("Set Stirring (RPM)")
               .setRange(0,255)
               .setValue(220)
               .setPosition(100,350)
               .setRadius(50)
               .setNumberOfTickMarks(10)
               .setTickMarkLength(4)
               .snapToTickMarks(false)
               .setDragDirection(Knob.HORIZONTAL)
               ;
               
  currentTemp = cp5.addKnob("Current Temp")
               .setRange(15,35)
               .setValue(15)
               .setPosition(275,70)
               .setRadius(50)
               .setNumberOfTickMarks(10)
               .setTickMarkLength(4)
               .snapToTickMarks(false)
               .lock()
               ;
               
  currentpH = cp5.addKnob("Current pH")
              .setRange(0,14)
              .setValue(0)
              .setPosition(275,210)
              .setRadius(50)
              .setNumberOfTickMarks(10)
              .setTickMarkLength(4)
              .snapToTickMarks(false)
              .lock()
              ;
               
  currentStirring = cp5.addKnob("Current Stirring")
               .setRange(0,400)
               .setValue(0)
               .setPosition(275,350)
               .setRadius(50)
               .setNumberOfTickMarks(10)
               .setTickMarkLength(4)
               .snapToTickMarks(false)
               .lock()
               ;
               
  myChartA = cp5.addChart("Temperature past 24 hours")
               .setPosition(450, 70)
               .setSize(400, 90)
               .setRange(0, 14)
               .setDecimalPrecision(2)
               .setView(Chart.LINE)
               ;

  myChartA.addDataSet("temp");
  myChartA.setColors("temp", color(255), color(100, 155, 220));
  myChartA.setColorBackground(0);
  myChartA.updateData("temp", 1, 2, 10, 3);
  
  myChartB = cp5.addChart("pH past 24 hours")
             .setPosition(450, 220)
             .setSize(400, 90)
             .setRange(0, 14)
             .setDecimalPrecision(2)
             .setView(Chart.LINE) 
             ;

  myChartB.addDataSet("pH");
  myChartB.setColors("pH", color(255), color(100, 155, 220));
  myChartB.setColorBackground(0);
  myChartB.updateData("pH", 1, 14, 10, 3);

}

void draw() {
  background(myColorBackground);
 
  //x-y axis for temperature graph
  stroke(255);
  line(449,70,449,160);
  stroke(255);
  line(449,160,849,160);
  
  for (int i = 65; i < 166; i = i + 15) {
        
    if (i == 65) {
    
    fill(255);
    textSize(9);
    text("Temp. C", 430, i);
    
    } else {
    
    fill(255);
    textSize(9);
    text(Integer.toString(Math.abs((i/3) - 66)), 430, i);
  
    }
  
  }
 
  //x-y axis for pH graph
  stroke(255);
  line(449,220,449,310);
  stroke(255);
  line(449,310,849,310);
  
  fill(255);
  textSize(9);
  text("pH", 430, 210);
  
  for (int i = 225; i < 316; i = i + 45) {
    
    fill(255);
    textSize(9);
    text(Integer.toString(7 - (i - 270)/45 * 7), 430, i);
      
  }
  
}

void knob(int theValue) {
  myColorBackground = color(theValue);
  println("a knob event. setting background to "+theValue);
}

