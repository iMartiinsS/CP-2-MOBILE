// classe do ambiente (desafio extra)
class Ambiente {
  String nome;
  int capacidadeMaxima;
  int qtdPessoas;

  Ambiente(this.nome, this.capacidadeMaxima, this.qtdPessoas);

  Ambiente.cinema() : nome = 'Cinema', capacidadeMaxima = 80, qtdPessoas = 0;

  int get pessoas => qtdPessoas;

  set pessoas(int valor) {
    if (valor < 0) valor = 0;
    if (valor > capacidadeMaxima) valor = capacidadeMaxima;
    qtdPessoas = valor;
  }

  // regra de quase cheio usando getter, como pedido no enunciado
  bool get quaseCheio => qtdPessoas >= capacidadeMaxima * 0.8;

  bool get lotado => qtdPessoas >= capacidadeMaxima;

  String getMensagem() {
    if (lotado) {
      return 'Ambiente lotado';
    } else if (quaseCheio) {
      return 'Atenção: ambiente quase cheio';
    } else {
      return 'Pode entrar';
    }
  }
}
