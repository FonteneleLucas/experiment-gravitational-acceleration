# Experimento Aceleração Gravitacional - APP - FLUTTER

Aplicativo para exibição dos dados do experimento para cálculo da Acelaração Gravitacional

PROTÓTIPO (Hardware): Útiliza Arduino para o cálculo da variação de tempo com dois sensores IR posicionados em um cano de PVC 
com uma distância conhecida.

O cálculo da variação de tempo é enviado para o Smartphone pelo Bluetooth (HC-05) conectado ao Arduino
A biblioteca flutter_bluetooth_serial recebe os dados de tempo e realiza os cálculos a partir da fórmula conhecida

g = 2*h/t²
