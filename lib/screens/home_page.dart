import 'package:flutter/material.dart';
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

  // mostra um SnackBar embaixo da tela
  void mostrarMensagem(String texto) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(texto)),
    );
  }

  void registrarEntrada() {
    final nome = nomeController.text.trim();
    final identificacao = idController.text.trim();

    // regra 3: nome e ID não podem ficar vazios
    if (nome.isEmpty || identificacao.isEmpty) {
      mostrarMensagem('Preencha o nome e a identificação.');
      return;
    }

    // regra 1: se estiver lotado, não deixa cadastrar
    if (cinema.lotado) {
      mostrarMensagem(
          'Ambiente lotado! Não é possível registrar uma nova entrada.');
      return;
    }

    // regra 4: entendi "simultaneamente" como "ao mesmo tempo no ambiente".
    // Então só bloqueia se já existe alguém com esse ID que ainda está no
    // ambiente. Se a pessoa já saiu, o mesmo ID pode entrar de novo.
    final idJaNoAmbiente = pessoas.any((p) =>
        p.noAmbiente &&
        p.identificacao.toLowerCase() == identificacao.toLowerCase());
    if (idJaNoAmbiente) {
      mostrarMensagem('Já existe alguém no ambiente com a identificação '
          '$identificacao.');
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
  }

  void registrarSaida(Pessoa pessoa) {
    // regra 2: quem já saiu não pode sair de novo
    if (!pessoa.noAmbiente) {
      mostrarMensagem('${pessoa.nome} já saiu do ambiente.');
      return;
    }

    setState(() {
      pessoa.dataSaida = DateTime.now();
      atualizarContador(); // a vaga volta a ficar livre
    });
  }

  void excluirPessoa(Pessoa pessoa) {
    setState(() {
      pessoas.remove(pessoa);
      atualizarContador(); // se ainda estava no ambiente, libera a vaga
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Controle de Lotação - Cinema'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // resumo da lotação
              Row(
                children: [
                  Image.asset(
                    'assets/images/cinema.png',
                    height: 80,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pessoas no local',
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          '${cinema.pessoas} / ${cinema.capacidadeMaxima}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          cinema.getMensagem(),
                          style:
                              const TextStyle(fontSize: 14, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // cadastro
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
                      controller: nomeController,
                      decoration: const InputDecoration(
                        labelText: 'Nome',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: idController,
                      decoration: const InputDecoration(
                        labelText: 'Matrícula',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: registrarEntrada,
                  child: const Text('Registrar entrada'),
                ),
              ),
              const SizedBox(height: 16),
              // lista de pessoas
              Expanded(
                child: ListView.builder(
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
