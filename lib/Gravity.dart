

class Gravity{
  int lancamento;
  double tempo;
  double gravidade;

  Gravity({this.lancamento, this.tempo, this.gravidade});

  int get getLancamento {
    return lancamento;
  }

  double get getTempo {
    return tempo;
  }

  double get getGravidade {
    return gravidade;
  }

  String getDados(){
    var mappedData = dados.map((data) => '${data.lancamento}, ${data.tempo}, ${data.gravidade}|');
    return mappedData.toString();
  }


  setValues(int _lancamentos, double _tempo, double _gravidade) {
    var gravity = Gravity(lancamento: _lancamentos, tempo: _tempo, gravidade: _gravidade);
    dados.add(gravity);
  }

  var dados = new List<Gravity>();


}