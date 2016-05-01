 import processing.serial.*;
 import java.util.Random;
 
Serial port; // Create object from Serial class

int ballX = 0;
int ballY = 0;
int speedX = 2;
int speedY = 4;
int miss = 0;
int hit = 0;
int level = 1;

float x = 0;
float output = 400;
float board = 50;

void setup() {

  size(900, 450);
  port = new Serial(this, "/dev/cu.usbmodem1421", 9600); 
  port.bufferUntil('\n');
}

public void serialEvent (Serial port) {
  
  x = (float(port.readStringUntil('\n')));
  if (x > 0 && output < 800) {
    output++;
    delay(2);
  } else if (output > 0) {
    output--;
    delay(2);
  }
}

public void Restart() {
  ballX = 0;
  ballY = 0;
  speedX = 1;
  speedY = 2;
  miss = 0;
  hit = 0;
  board = 50;
}

void draw () {
  
  background(2, 132, 130); 
    
  ballX = ballX + speedX;
  ballY = ballY + speedY;
   
  fill(165, 42, 42);
  ellipse(ballX, ballY, 40, 40);
  rect(output, height - 10, board*2, 10); 
  
  fill(255);
  text("Hits: " + hit, 10, 20);
  text("Misses: " + miss, 10, 35);
  text("Level: " + level, 10, 50);
  
  if (ballX < 0 || ballX > width) {
    speedX = - speedX;
}

  if (ballY < 0) {
    speedY = - speedY;
  } else if (ballY > height) {
    speedY = - speedY;
    float distance = abs(output + 50 - ballX);
    if (distance < board) {
      port.write('1');
      hit++;
      if (level < 5) {
        board = board - 5;
        level++;
      }
    } else {
      port.write('2');
      miss++; 
    }  
}

  if (port.read() == 3 || miss > 9) { 
    Restart();
  } 
}