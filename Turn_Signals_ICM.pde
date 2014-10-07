// This code was adapted from a serial communication Lab in Physical Computing
// It has been modified with the intention of sending string and int values to the arduino via serial
import processing.serial.*; // import the Processing serial library
Serial myPort; // The serial port
float bgcolor, fgcolor;  // Background color, Fill color, Starting position of the ball
int count;
ArrayList data; 
boolean firstContact = false;
void setup() {
  size(800, 600);
  String portName = Serial.list()[5];
  data = new ArrayList();
  myPort = new Serial(this, portName, 9600);
  // read incoming bytes to a buffer
  // until you get a linefeed (ASCII 10)sk
  myPort.bufferUntil('\n');
  myPort.clear();
  for (int i = 0; i < 5; i++) {
    int val = i %2;
    data.add(val);
  }
}
void draw() {
  background(bgcolor);
  fill(fgcolor);
}

void serialEvent(Serial myPort) {
  // read the serial buffer:
  String myString = myPort.readStringUntil('\n');
  if (myString != null) {
    myString = trim(myString);

    if (firstContact == false) {
      if (myString.equals ("hello")) {
        myPort.clear();
        firstContact = true;
        myPort.write('A');
      }
    } else {
      // split the string at the commas
      // and convert the sections into integers:
      int sensors[] = int(split(myString, ','));
      for (int sensorNum = 0; sensorNum < sensors.length; sensorNum++) {
        print("Sensor " + sensorNum + ": " + sensors[sensorNum] + "\t");
      }
      // add a linefeed at the end:
      println(); 
      String allValues = "";
      for (int i = 0; i < data.size (); i++) {
        String val = "" + data.get(i);
        allValues += val;
        if (i < data.size() -1 ) {
          allValues += ",";
        }
        println(val);
      }
      println(allValues);
    }
    myPort.write("0");
  }
}
