

class Gravity {
  double h = 1.0;
  int lancamento;
  double tempo;
  double gravidade;

  Gravity({this.lancamento, this.tempo, this.gravidade});

  var dados = new List<Gravity>();


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
    lancamento = _lancamentos;
    tempo = _tempo;
    gravidade = calculaGravidade(lancamento, tempo);

    var gravity = Gravity(lancamento: lancamento, tempo: tempo, gravidade: gravidade);
    dados.add(gravity);
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
    for(int i = 0; i < lancamento;i++){
//      print("N: ${i} : G: ${dados.elementAt(i).gravidade}");
      cont += dados.elementAt(i).tempo;
    }

    return cont / lancamento;

  }


}