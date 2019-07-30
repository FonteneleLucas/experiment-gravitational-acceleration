
double randNumber;

void setup() {
  Serial.begin(9600);
  randomSeed(analogRead(0));
}

void loop() {
  randNumber = random(35, 48) / 100.0;
  Serial.print(0);
  Serial.println(randNumber);

  delay(1000);
}
