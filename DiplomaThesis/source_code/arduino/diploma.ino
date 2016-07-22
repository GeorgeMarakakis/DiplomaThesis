// Includes the Servo library
#include <Servo.h>

// Defines Trig and Echo pins of the Ultrasonic Sensors
const int trigPinHor = 10;
const int echoPinHor = 11;

const int trigPinVer = 5;
const int echoPinVer = 6;


// Variables for the duration and the distance
long durationHor;
int distanceHor;
long durationVer;
int distanceVer;

float SPEEDair = 0.034;//in miliseconds

int T=20;//Water Temperature in Celcius Degrees
int S=30;//Salinity
int Z=0.1;//Depth in meters
float SPEEDwater = pow(10,-4) * float( 1492.9 + 3*(T - 10) - 6 * pow(10,-3)*pow(T-10,2) - 4 * pow(10,-2)*pow(T-18,2) + 1.2 * (S - 35) - pow(10,-2)*(T - 18)*(S - 35) + (Z/61)  );


Servo myServo; // Creates a servo object for controlling the servo motor

void setup() { 
  // put your setup code here, to run once:
  pinMode(trigPinHor, OUTPUT); // Sets the trigPinHor as an Output
  pinMode(echoPinHor, INPUT); // Sets the echoPinHor as an Input
  pinMode(trigPinVer, OUTPUT); // Sets the trigPinVer as an Output
  pinMode(echoPinVer, INPUT); // Sets the echoPinVer as an Input
  Serial.begin(9600);
  myServo.attach(12); // Defines on which pin is the servo motor attached
}

void loop() {
  // put your main code here, to run repeatedly:
  /*
  Serial.print("SPEEDair = ");
  Serial.print(SPEEDair,3);
  Serial.println();
  Serial.print("SPEEDwater = ");
  Serial.print(SPEEDwater,3);
  Serial.println();
  */
  // rotates the servo motor from 15 to 165 degrees
  for(int i=15;i<=165;i++){  
      myServo.write(i);
      delay(30);//miliseconds
      
      // Calls a function for calculating the distance measured by the Ultrasonic sensor for each degree
      distanceHor = calculateDistanceHor();
      distanceVer = calculateDistanceVer();
      
      Serial.print(i); // Sends the current degree into the Serial Port
      //Serial.print(" degs - ");
      Serial.print(","); // Sends addition character right next to the previous value needed later in the Processing IDE for indexing
      //Serial.print(" Hor: ");
      Serial.print(distanceHor); // Sends the distance value into the Serial Port
      //Serial.print(" cm - Ver: ");
      Serial.print("-"); // Sends addition character right next to the previous value needed later in the Processing IDE for indexing
      Serial.print(distanceVer);
      //Serial.print(" cm ");
      Serial.print("."); // Sends addition character right next to the previous value needed later in the Processing IDE for indexing
      //Serial.println();
      //Serial.println();
      //delay(1000);//miliseconds - for testing
      }
      
  // Repeats the previous lines from 165 to 15 degrees
  for(int i=165;i>15;i--){  
      myServo.write(i);
      delay(30);
      
      // Calls a function for calculating the distance measured by the Ultrasonic sensor for each degree
      distanceHor = calculateDistanceHor();
      distanceVer = calculateDistanceVer();
      
      Serial.print(i); // Sends the current degree into the Serial Port
      //Serial.print(" degs - ");
      Serial.print(","); // Sends addition character right next to the previous value needed later in the Processing IDE for indexing
      //Serial.print(" Hor: ");
      Serial.print(distanceHor); // Sends the distance value into the Serial Port
      //Serial.print(" cm - Ver: ");
      Serial.print("-"); // Sends addition character right next to the previous value needed later in the Processing IDE for indexing
      Serial.print(distanceVer);
      //Serial.print(" cm ");
      Serial.print("."); // Sends addition character right next to the previous value needed later in the Processing IDE for indexing
      //Serial.println();
      //Serial.println();
      //delay(1000);//miliseconds - for testing
      }
}



// Function for calculating the distance measured by the Ultrasonic sensor in the Horizontal Axis
int calculateDistanceHor(){ 
  
  digitalWrite(trigPinHor, LOW); 
  delayMicroseconds(2);
  // Sets the trigPinHor on HIGH state for 10 micro seconds
  digitalWrite(trigPinHor, HIGH); 
  delayMicroseconds(10);
  digitalWrite(trigPinHor, LOW);
  durationHor = pulseIn(echoPinHor, HIGH); // Reads the echoPinHor, returns the sound wave travel time in microseconds
  /*
  Serial.print("Horizontal Duration(microsecs) = ");
  Serial.print(durationHor);
  Serial.println();
  */
  distanceHor= durationHor*SPEEDair/2;
  return distanceHor;
}



// Function for calculating the distance measured by the Ultrasonic sensor in the Vertical Axis
int calculateDistanceVer(){ 
  
  digitalWrite(trigPinVer, LOW); 
  delayMicroseconds(2);
  // Sets the trigPinVer on HIGH state for 10 micro seconds
  digitalWrite(trigPinVer, HIGH); 
  delayMicroseconds(10);
  digitalWrite(trigPinVer, LOW);
  durationVer = pulseIn(echoPinVer, HIGH); // Reads the echoPinVer, returns the sound wave travel time in microseconds
  /*
  Serial.print("Horizontal Duration(microsecs) = ");
  Serial.print(durationHor);
  Serial.println();
  */
  distanceVer= durationVer*SPEEDair/2;
  return distanceVer;
}
