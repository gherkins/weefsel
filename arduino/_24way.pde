#include <Messenger.h>
Messenger message = Messenger(); 
//as output 1 sucks
int ledPin1 = 25;
int ledPin2 = 2;
int ledPin3 = 3;
int ledPin4 = 4;
int ledPin5 = 5;
int ledPin6 = 6;
int ledPin7 = 7;
int ledPin8 = 8;

int ledPin9 = 9;
int ledPin10 = 10;
int ledPin11 = 11;
int ledPin12 = 12;
int ledPin13 = 13;
int ledPin14 = 14;
int ledPin15 = 15;
int ledPin16 = 16;

int ledPin17 = 17;
int ledPin18 = 18;
int ledPin19 = 19;
int ledPin20 = 20;
int ledPin21 = 21;
int ledPin22 = 22;
int ledPin23 = 23;
int ledPin24 = 24;

int value = 0;
int section = 0;

void setup() {

  pinMode(ledPin1, OUTPUT);
  pinMode(ledPin2, OUTPUT);
  pinMode(ledPin3, OUTPUT);
  pinMode(ledPin4, OUTPUT);
  pinMode(ledPin5, OUTPUT);
  pinMode(ledPin6, OUTPUT);
  pinMode(ledPin7, OUTPUT);
  pinMode(ledPin8, OUTPUT);

  pinMode(ledPin9, OUTPUT);
  pinMode(ledPin10, OUTPUT);
  pinMode(ledPin11, OUTPUT);
  pinMode(ledPin12, OUTPUT);
  pinMode(ledPin13, OUTPUT);
  pinMode(ledPin14, OUTPUT);
  pinMode(ledPin15, OUTPUT);
  pinMode(ledPin16, OUTPUT);

  pinMode(ledPin17, OUTPUT);
  pinMode(ledPin18, OUTPUT);
  pinMode(ledPin19, OUTPUT);
  pinMode(ledPin20, OUTPUT);
  pinMode(ledPin21, OUTPUT);
  pinMode(ledPin22, OUTPUT);
  pinMode(ledPin23, OUTPUT);
  pinMode(ledPin24, OUTPUT);

  Serial.begin(9600);

  //attach callback to message listener 
  message.attach(messageReady);
}

void messageReady() {
  section = 1;

Serial.println("receiving:");

  while ( message.available() ) {
    
    value = message.readInt();

    Serial.print("section: ");
    Serial.print(section);
    Serial.print(" - value: ");
    Serial.println( value );

    switch( section ){
    case 1:
      digitalWrite(ledPin1, HIGH && (value & B10000000));
      digitalWrite(ledPin2, HIGH && (value & B01000000));
      digitalWrite(ledPin3, HIGH && (value & B00100000));
      digitalWrite(ledPin4, HIGH && (value & B00010000));
      digitalWrite(ledPin5, HIGH && (value & B00001000));
      digitalWrite(ledPin6, HIGH && (value & B00000100));
      digitalWrite(ledPin7, HIGH && (value & B00000010));
      digitalWrite(ledPin8, HIGH && (value & B00000001));
      break;

    case 2:
      digitalWrite(ledPin9, HIGH && (value & B10000000));
      digitalWrite(ledPin10, HIGH && (value & B01000000));
      digitalWrite(ledPin11, HIGH && (value & B00100000));
      digitalWrite(ledPin12, HIGH && (value & B00010000));
      digitalWrite(ledPin13, HIGH && (value & B00001000));
      digitalWrite(ledPin14, HIGH && (value & B00000100));
      digitalWrite(ledPin15, HIGH && (value & B00000010));
      digitalWrite(ledPin16, HIGH && (value & B00000001));
      break;

    case 3:
      digitalWrite(ledPin17, HIGH && (value & B10000000));
      digitalWrite(ledPin18, HIGH && (value & B01000000));
      digitalWrite(ledPin19, HIGH && (value & B00100000));
      digitalWrite(ledPin20, HIGH && (value & B00010000));
      digitalWrite(ledPin21, HIGH && (value & B00001000));
      digitalWrite(ledPin22, HIGH && (value & B00000100));
      digitalWrite(ledPin23, HIGH && (value & B00000010));
      digitalWrite(ledPin24, HIGH && (value & B00000001));
      break; 
    }

    section++;
  }
}


//listen to serial port for messages
void loop() {
  while ( Serial.available() )  message.process( Serial.read () );
}







