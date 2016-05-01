
import processing.serial.*;

/*
 *  Class ReadData
 *  Constructor (Serial s, Logger l)
 *  
 *  public method:
 *  readData() 
 *      Reads the Data from the Serial s and saves it to the Logger l
 */
 
class ReadData {
    
    private Serial myPort;
    private Logger logger;

    ReadData(Serial s, Logger l) {
            this.myPort = s;
            this.logger = l;
        }


    private void slice(String inBuffer) {
        /* check if input is has the correct starting format
        * => first 2 chars are "0:"
        * eg: 0:23.5_1:8.0_2:400
        * 0: TEMP
        * 1: PH
        * 2: Stirring
        */
     
        if (inBuffer.charAt(0) == '0' && inBuffer.charAt(1) == ':') {
            // log the whole line
            logger.newLog(inBuffer,3);
            
            // slice the temperature 0:TEMP
            int tempEnd = inBuffer.indexOf("_");
            float temperature = float(inBuffer.substring(2, tempEnd));
            logger.newLog(temperature, 0);
            inBuffer = inBuffer.substring(tempEnd+1, inBuffer.length());

            // slice the PH => 1:PH
            int phBeg = inBuffer.indexOf("1:");
            int phEnd = inBuffer.indexOf("_");
            float ph = float(inBuffer.substring(phBeg+2, phEnd));
            logger.newLog(ph, 2);

            inBuffer = inBuffer.substring(phEnd+1, inBuffer.length());
            // slice the Stirring
            int stirBeg = inBuffer.indexOf("2:");
            int stirring = int(inBuffer.substring(stirBeg+2, inBuffer.length() ));
            logger.newLog(stirring, 2);
    }
  }

  public void readData() {
    while (myPort.available () > 0) {
      String inBuffer = myPort.readString();   
      if (inBuffer != null) {
        slice(inBuffer);
      }
    }
  }
}