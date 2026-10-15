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

  void registrarEntrada() {
    final pessoa = Pessoa(
      nome: nomeController.text,
      identificacao: idController.text,
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
    setState(() {
      pessoa.dataSaida = DateTime.now();
    });
  }

  void excluirPessoa(Pessoa pessoa) {
    setState(() {
      pessoas.remove(pessoa);
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
                        Text(
                          'Capacidade máxima: ${cinema.capacidadeMaxima} pessoas',
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          'Pessoas no local: ${cinema.pessoas}',
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
