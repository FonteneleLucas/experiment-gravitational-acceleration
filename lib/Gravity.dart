import 'dart:math';

class Gravity {
  double h = 0.50;
  int lancamento;
  double tempo;
  double gravidade;

  Gravity({this.lancamento, this.tempo, this.gravidade});

  var dados = new List<Gravity>();
  var tempoOrdenado = new List<double>();
  var gravidadeOrdenado = new List<double>();



  int get getLancamento {
    return lancamento;
  }

  double get getTempo {
    return tempo;
  }

  double get getGravidade {
    return gravidade;
  }

//  String getDados() {
//    var mappedData = dados.map((data) => '${data.lancamento}, ${data
//        .tempo}, ${data.gravidade}|');
//    return mappedData.toString();
//  }

  //if tempo > 0
  setValues(int _lancamentos, double _tempo) {
//    if(tempo != 0){
      lancamento = _lancamentos;
      tempo = _tempo;
      gravidade = calculaGravidade(lancamento, tempo);

      var gravity = Gravity(lancamento: lancamento, tempo: tempo, gravidade: gravidade);
      dados.add(gravity);
//    }

  }

  clearData(){
    dados.clear();
    tempoOrdenado.clear();
    gravidadeOrdenado.clear();
  }

  clearLast(){
    dados.remove(dados.length-1);
  }

  double calculaGravidade(int lancamento, double tempo) {
    return (2 * h / (tempo * tempo));
  }

  double calcGravidadeMedia() {
    double cont = 0;
    for(int i = 0; i < lancamento;i++){
//      print("N: ${i} : G: ${dados.elementAt(i).gravidade}");
      cont += dados.elementAt(i).gravidade;
    }

    return cont / lancamento;

  }

  double tempoMedio() {
    double cont = 0;
    for(int i = 0; i < dados.length;i++){
//      print("N: ${i} : G: ${dados.elementAt(i).gravidade}");
      cont += dados.elementAt(i).tempo;
    }
    return cont / dados.length;
  }

  double varianciaTempo(){
    double _var = 0;
    for(int i = 0; i < dados.length;i++){
      _var +=  pow((dados.elementAt(i).tempo - tempoMedio()),2);
    }
    return _var/dados.length;
  }

  double desvioPadraoTempo(){
    return sqrt(varianciaTempo());
  }


  double varianciaGravidade(){
    double _var = 0;
    for(int i = 0; i < dados.length;i++){
      _var +=  pow((dados.elementAt(i).gravidade - calcGravidadeMedia()),2);
    }
    return _var/dados.length;
  }

  double desvioPadraoGravidade(){
    return sqrt(varianciaGravidade());
  }

  void sortTempo(){
    for(int i = 0; i < dados.length;i++){
      tempoOrdenado.add(dados.elementAt(i).tempo);
    }
    tempoOrdenado.sort();
    print(tempoOrdenado.toString());
  }

  void sortGravidade(){
    for(int i = 0; i < dados.length;i++){
      gravidadeOrdenado.add(dados.elementAt(i).gravidade);
    }
    gravidadeOrdenado.sort();
    print(gravidadeOrdenado.toString());
  }

  double medianaTempo(){
    int medio = (tempoOrdenado.length/2).toInt();
    double calc = 0;
    if(tempoOrdenado.length % 2 == 0){
      //0,1,2,3,4,5
      calc = (tempoOrdenado.elementAt(medio-1) + tempoOrdenado.elementAt(medio))/2;
    }else{
      //0,1,2,3,4
      calc = (tempoOrdenado.elementAt(medio));

    }
    return calc;
  }

  double medianaGravidade(){
    int medio = (gravidadeOrdenado.length/2).toInt();
    double calc = 0;
    if(gravidadeOrdenado.length % 2 == 0){
      //0,1,2,3,4,5
      calc = (gravidadeOrdenado.elementAt(medio-1) + gravidadeOrdenado.elementAt(medio))/2;
    }else{
      //0,1,2,3,4
      calc = (gravidadeOrdenado.elementAt(medio));
    }
    return calc;
  }


}