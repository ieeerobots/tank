/*

Sketch for DFRobotShop Rover Robots

This sketch was originally written for 10-13 year-old Boy Scouts to 
learn how to program their first C++ program. 

It has been stripped down and merged into one file.

_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-
Anything with 1 is on the side that XBEE1 is, and 2 for XBEE2 side.
_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

License
-MIT License

*/
const int INPUT_TYPE_MOTOR = 1;
const int INPUT_TYPE_SPEED = 2;
const int INPUT_TYPE_LINE = 3;
const int LIGHT_DIFFERENCE = 100;

const unsigned char E1 = 6; //M1 Speed Control 
const unsigned char E2 = 5; //M2 Speed Control 
const unsigned char M1 = 8; //M1 Direction Control
const unsigned char M2 = 7; //M2 Direction Control
const unsigned char QRE1 = 2; 
const unsigned char QRE2 = A5; 
const unsigned char LED1_PIN = 5; /* Cannot be pin 3 because Timer 2 is used. */
const unsigned char LIGHT_SENSOR = A0;
const unsigned char MEDIUM_SPEED = 180;
int sensor1; 
int sensor2;

#define m1forward digitalWrite(M1, HIGH)
#define m2forward digitalWrite(M2, HIGH)
#define m1back digitalWrite(M1, LOW)
#define m2back digitalWrite(M2, LOW)

unsigned long lastheartbeat = 0;
const unsigned long HEARTBEATPERIOD = 13; 

void setup(){
    Serial.begin(9600);
    
    /* Set motors and enable pins to output */
    pinMode(M1, OUTPUT);
    pinMode(M2, OUTPUT);
    pinMode(E1, OUTPUT);
    pinMode(E2, OUTPUT);
    
    /* Set A1 to act as voltage source for light sensor. */
    pinMode(A1, OUTPUT);
    digitalWrite(A1, HIGH);
    
    /* Set LEDs to output */
    pinMode(LED1_PIN, OUTPUT);
}

void loop(){
  sensor1 = readQD(QRE1);
  sensor2 = readQD(QRE2);
  Serial.print(sensor1);
  Serial.print(", ");
  Serial.println(sensor2);
  if(sensor1 > 100){
    m1forward;
    m2forward;
    setSpeed(1, 255);
    setSpeed(2, 0);
  } else if(sensor2 > 100){
    m1forward;
    m2forward;
    setSpeed(2, 255);
    setSpeed(1, 0);
  } else {
    m1forward;
    m2forward;
    setSpeed(2, 0);
    setSpeed(1, 0);
  }
    
}
    

/* Reads QRE Line sensor and returns the amount of time it took to 
discharge the capacitor */
int readQD(unsigned char sensorPin){
    //Returns value from the QRE1113 
    //Lower numbers mean more refleacive
    //More than 3000 means nothing was reflected.
    pinMode( sensorPin, OUTPUT );
    digitalWrite( sensorPin, HIGH );
    delayMicroseconds(10);
    pinMode( sensorPin, INPUT );
  
    long time = micros();
  
    //time how long the input is HIGH, but quit after 3ms as nothing happens after that
    while (digitalRead(sensorPin) == HIGH && micros() - time < 3000);
    int diff = micros() - time;
  
    return diff;
}
/* Moves motor 1 or 2 at a certain speed. */
void setSpeed(int motor, int motorSpeed){
    if(motor == 1){
        analogWrite(E1, motorSpeed);
    }
    else if(motor == 2){
        analogWrite(E2, motorSpeed);
    }
}

