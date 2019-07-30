
int sensor1 = 5, sensor2 = 6;

void setup() {
  Serial.begin(9600);
//  Serial.setTimeout(100);
  pinMode(sensor1, INPUT);
  pinMode(sensor2, INPUT);
}

double tempo1 = 0;
double tempo2 = 0;
double tempoFinal = 0;
double gravidade = 0;
double h = 0.998877;
double velocidade = 0;
double values[5];
int cont = 0;
int i = 0;
bool flag = false;

void loop() {
 
  int valorS1 = digitalRead(sensor1);
  int valorS2 = digitalRead(sensor2);

  Serial.print(valorS1);
  Serial.print("    ");
  Serial.println(valorS2);
  
/*

  
  if (!valorS1) {
    tempo1 = micros();
    flag = true;
    i = 0;
  }

  if (!valorS2) {
    tempo2 = micros();
    i = 1;
   
  }

  if (i == 1 && flag) {
    flag = false;
    i = 0;
    tempoFinal = ((tempo2 - tempo1) / 1000000.0);
    Serial.print("\n");
    Serial.println(tempoFinal);
  }

  */


}
