// pessoa que entra e sai do cinema
class Pessoa {
  String nome;
  String identificacao;
  DateTime dataEntrada;
  DateTime? dataSaida; // fica null enquanto a pessoa estiver no ambiente

  Pessoa({
    required this.nome,
    required this.identificacao,
    required this.dataEntrada,
    this.dataSaida,
  });

  // se ainda não saiu, está no ambiente
  bool get noAmbiente => dataSaida == null;

  String get situacao => noAmbiente ? 'No ambiente' : 'Saiu';
}
