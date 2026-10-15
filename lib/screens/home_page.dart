import 'package:flutter/material.dart';
import '../cores.dart';
import '../models/ambiente.dart';
import '../models/pessoa.dart';
import '../widgets/pessoa_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Ambiente cinema = Ambiente.cinema();

  // controllers dos campos do cadastro
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController idController = TextEditingController();

  List<Pessoa> pessoas = [];

  @override
  void dispose() {
    nomeController.dispose();
    idController.dispose();
    super.dispose();
  }

  // atualiza o contador do ambiente com quem está no ambiente agora
  void atualizarContador() {
    cinema.pessoas = pessoas.where((p) => p.noAmbiente).length;
  }

  // mostra um SnackBar embaixo da tela (vermelho quando é erro)
  void mostrarMensagem(String texto, {bool erro = false}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          texto,
          style: TextStyle(color: erro ? corTexto : corFundo),
        ),
        backgroundColor: erro ? corVermelhoEscuro : corTexto,
      ),
    );
  }

  void registrarEntrada() {
    final nome = nomeController.text.trim();
    final identificacao = idController.text.trim();

    // regra 3: nome e ID não podem ficar vazios
    if (nome.isEmpty || identificacao.isEmpty) {
      mostrarMensagem('Preencha o nome e a identificação.', erro: true);
      return;
    }

    // regra 1: se estiver lotado, não deixa cadastrar
    if (cinema.lotado) {
      mostrarMensagem(
        'Ambiente lotado! Não é possível registrar uma nova entrada.',
        erro: true,
      );
      return;
    }

    // regra 4: entendi "simultaneamente" como "ao mesmo tempo no ambiente".
    // Então só bloqueia se já existe alguém com esse ID que ainda está no
    // ambiente. Se a pessoa já saiu, o mesmo ID pode entrar de novo.
    final idJaNoAmbiente = pessoas.any((p) =>
        p.noAmbiente &&
        p.identificacao.toLowerCase() == identificacao.toLowerCase());
    if (idJaNoAmbiente) {
      mostrarMensagem(
        'Já existe alguém no ambiente com a identificação $identificacao.',
        erro: true,
      );
      return;
    }

    final pessoa = Pessoa(
      nome: nome,
      identificacao: identificacao,
      dataEntrada: DateTime.now(), // data de entrada gerada na hora
    );

    setState(() {
      pessoas.insert(0, pessoa);
      atualizarContador();
    });

    nomeController.clear();
    idController.clear();
    mostrarMensagem('Entrada de $nome registrada com sucesso!');
  }

  // abre o AlertDialog e devolve true se a pessoa apertou CONFIRMAR
  Future<bool> confirmar(String titulo, String mensagem) async {
    final resposta = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: corCartao,
        title: Text(titulo),
        content: Text(mensagem),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'CANCELAR',
              style: TextStyle(color: corTextoSecundario),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'CONFIRMAR',
              style: TextStyle(color: corVermelhoClaro),
            ),
          ),
        ],
      ),
    );
    return resposta == true; // se fechou o dialog sem escolher, vira false
  }

  Future<void> registrarSaida(Pessoa pessoa) async {
    // regra 2: quem já saiu não pode sair de novo
    if (!pessoa.noAmbiente) {
      mostrarMensagem('${pessoa.nome} já saiu do ambiente.', erro: true);
      return;
    }

    final confirmou = await confirmar(
      'Registrar saída',
      'Confirmar a saída de ${pessoa.nome}?',
    );
    if (!confirmou || !mounted) return;

    setState(() {
      pessoa.dataSaida = DateTime.now();
      atualizarContador(); // a vaga volta a ficar livre
    });
    mostrarMensagem('Saída de ${pessoa.nome} registrada.');
  }

  Future<void> excluirPessoa(Pessoa pessoa) async {
    final confirmou = await confirmar(
      'Excluir pessoa',
      'Deseja excluir ${pessoa.nome} da lista?',
    );
    if (!confirmou || !mounted) return;

    setState(() {
      pessoas.remove(pessoa);
      atualizarContador(); // se ainda estava no ambiente, libera a vaga
    });
    mostrarMensagem('${pessoa.nome} foi excluído(a) da lista.');
  }

  // cor do contador muda conforme a lotação
  Color get corLotacao {
    if (cinema.lotado) return corVermelhoClaro;
    if (cinema.quaseCheio) return corAlerta;
    return corTexto;
  }

  IconData get iconeLotacao {
    if (cinema.lotado) return Icons.block;
    if (cinema.quaseCheio) return Icons.warning_amber_rounded;
    return Icons.check_circle_outline;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.local_movies, color: corVermelhoClaro),
            SizedBox(width: 8),
            Flexible(
              child: Text(
                'Controle de Lotação - Cinema',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Column(
            children: [
              // cartão com a lotação do cinema
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: corCartao,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'assets/images/cinema.png',
                            width: 112,
                            height: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Pessoas no ambiente',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: corTextoSecundario,
                                ),
                              ),
                              Text(
                                '${cinema.pessoas} / ${cinema.capacidadeMaxima}',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: corLotacao,
                                  height: 1.2,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(iconeLotacao,
                                      size: 16, color: corLotacao),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      cinema.getMensagem(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: corLotacao,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // barra de ocupação
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: cinema.pessoas / cinema.capacidadeMaxima,
                        minHeight: 8,
                        backgroundColor: corFundo,
                        color: corLotacao == corTexto
                            ? corVermelho
                            : corLotacao,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // cadastro de pessoa
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: nomeController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Nome',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: idController,
                      decoration: const InputDecoration(
                        labelText: 'Matrícula',
                        prefixIcon: Icon(Icons.badge_outlined),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: registrarEntrada,
                  icon: const Icon(Icons.login),
                  label: const Text('Registrar entrada'),
                ),
              ),
              const SizedBox(height: 16),
              // título da lista
              Row(
                children: [
                  Text(
                    'Pessoas (${pessoas.length})',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // dica de como usar o Slidable (encolhe se faltar espaço)
                  const Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.swipe_left,
                            size: 16, color: corTextoSecundario),
                        SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            'deslize para saída ou excluir',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 11, color: corTextoSecundario),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // lista de pessoas (ou aviso se ainda não tem ninguém)
              Expanded(
                child: pessoas.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.event_seat,
                                size: 48, color: corTextoSecundario),
                            SizedBox(height: 8),
                            Text(
                              'Nenhuma pessoa cadastrada ainda',
                              style: TextStyle(color: corTextoSecundario),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: pessoas.length,
                        itemBuilder: (context, index) {
                          final pessoa = pessoas[index];
                          // passa a pessoa e as funções pro PessoaItem
                          return PessoaItem(
                            key: ObjectKey(pessoa),
                            pessoa: pessoa,
                            onSaida: () => registrarSaida(pessoa),
                            onExcluir: () => excluirPessoa(pessoa),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
