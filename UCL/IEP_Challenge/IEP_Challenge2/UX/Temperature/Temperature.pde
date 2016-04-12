// Individual design for temperature interface component 
// @author Fraser Savage
import java.lang.String;
import java.util.Random;
import controlP5.*;
// Operation variables
float targetTempMin, targetTempMax, currentTemp;
// Timing variables
long lastTimeMillis;
// Control P5 Interface Components
ControlP5 cp5;
Slider minTemp, maxTemp;
Chart tempChart;
Button setTemp;
Textlabel minTempText, maxTempText, currentTempText;
// Logger
Logger logger;

/**
 * Set up method, initialises the temperature controls, scene and variables.
 * Positions start from top left and go down and across.
 * Labels are set in the addX function of the ControlP5 object. 
 */
void setup() {
  // Sets the stage size
  size(400,400);
  
  // Instantiate the Logger
  logger = new Logger();
  
  lastTimeMillis = System.currentTimeMillis();
  
  // Instantiate the control p5 manager.
  cp5 = new ControlP5(this);
  
  // Instantiate the minimum temperature slider control.
  targetTempMin = 20.0;
  minTemp = new Slider(cp5, "MinTemp").setPosition(20, 50).setSize(30, 250).setMin(0.0).setMax(70.0).setValue(targetTempMin);
  
  // Instantiate the maximum temperature slider control.
  targetTempMax = 35.0;
  maxTemp = new Slider(cp5, "MaxTemp").setPosition(80, 50).setSize(30, 250).setMin(0.0).setMax(70.0).setValue(targetTempMax);
  
  // Instantiate the button used to set the temperatures. 
  setTemp = new Button(cp5, "SetTemp").setPosition(20, 320).setSize(90, 20).activateBy(ControlP5.RELEASE);
  
  // Create the Textlabel for the current temp
  currentTempText = new Textlabel(cp5, "0", 20, 10, 50, 10); 
  
  // Create Textlabels for min and max temp
  minTempText = new Textlabel(cp5, Float.toString(targetTempMin), 20, 20, 50, 10);
  maxTempText = new Textlabel(cp5, Float.toString(targetTempMax), 20, 30, 50, 10);
  
  // Create a line chart for temperature
  tempChart = new Chart(cp5, "TemperatureChart").setPosition(140, 50).setSize(180, 125).setRange(0, 70).setDecimalPrecision(2).setView(Chart.LINE);
  tempChart.addDataSet("temperature");
  tempChart.updateData("temperature",targetTempMin,getCurrentTemp(),getCurrentTemp(),getCurrentTemp());
}

/**
 * Render loop, continuously draws the sliders and the background, clearing visual artifacts.
 * Background value taken ranges from 0-255 for monochrome in this case.
 */
void draw() {
  background(50);
  // Checks the time delta to update the current temp mock value 
  if (checkTimeDelta(System.currentTimeMillis(), 500)) {
    currentTemp = getCurrentTemp();
  }
  
  // Updates the temperature text.
  updateTempText();
  
  // Renders the updated text labels.
  drawTempText();
  
  // Updates the chart's data.
  tempChart.updateData("temperature", getPastTemp(25));
  
}

boolean checkTimeDelta(long currentTimeMillis, long desiredDeltaMillis) {
  if (currentTimeMillis - lastTimeMillis > desiredDeltaMillis) {
    lastTimeMillis = currentTimeMillis;
    return true;
  } else {
    return false;
  }
}

/**
 * Updates the temperature text labels.
 *
 */
void updateTempText() {
  currentTempText.setText(String.format("Current Temp: %.2f", currentTemp));
  minTempText.setText(String.format("Min Temp: %.2f", targetTempMin));
  maxTempText.setText(String.format("Max Temp: %.2f", targetTempMax));
}

/**
 * Renders the temperature text labels.
 *
 */
void drawTempText() {
  currentTempText.draw(this);
  minTempText.draw(this);
  maxTempText.draw(this); 
}

/**
 * Sets the temperature variables to the values
 *
 */
public void SetTemp(int val) {
  // Updates the target min temp and max temp with the current slider values.
  if (minTemp.getValue() < maxTemp.getValue()) {
    targetTempMin = minTemp.getValue();
    targetTempMax = maxTemp.getValue();
    print(String.format("New minimum temp is: %.2f.\n", targetTempMin));
    print(String.format("New maximum temp is: %.2f.\n", targetTempMax));
    // Do something to send an update to the microcontroller through a write data class of some kind?
    // eg:
    // serialPort.write("_T" + String.format("%.2f,%.2f", targetTempMin, targetTempMax));
    // So writing to the serialPort a string such as "_T25.72,32.44" 
  } else {
    // Give an error if min > max
    print("Sorry min was greater than max.\n");
  }
}

/**
 * Method that mocks input data to test interface display.
 * 
 */
float getCurrentTemp() {
  // This is the mock temperature method
  /*
  Random mockTemp = new Random();
  float range = targetTempMax - targetTempMin;
  return (
     targetTempMin +
     (range/2) +
     (mockTemp.nextFloat() * (range + targetTempMin) * 0.1)
     ); 
  */
  // Using data from the logger
  return logger.lastTemp();
}

/**
 * Method that gets most recent n values for temperature from logger.
 *
 */
float[] getPastTemp(int n) {
  /*
  float mockTemps[] = new float[n];
  for (int i = 0; i < n; i++) {
    mockTemps[i] = getCurrentTemp(); 
  }
  return mockTemps;
  */
  
  // For no mock data
  int i = 0;
  ArrayList<Float> nTemps = logger.xTemp(n);
  float[] pastTemps = new float[n];
  for (Float f : nTemps) {
    if (f == null) {
      pastTemps[i++] = 0;
    } else {
      pastTemps[i++] = f;
    }
  }
  return pastTemps;
}