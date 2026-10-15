import 'package:flutter/material.dart';
import '../models/ambiente.dart';
import '../models/pessoa.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Controle de Lotação - Cinema'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Image.asset(
                'assets/images/cinema.png',
                height: 160,
              ),
              const SizedBox(height: 20),
              Text(
                'Capacidade máxima: ${cinema.capacidadeMaxima} pessoas',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              const Text(
                'Pessoas no local',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                '${cinema.pessoas}',
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                cinema.getMensagem(),
                style: const TextStyle(fontSize: 18, color: Colors.red),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: idController,
                decoration: const InputDecoration(
                  labelText: 'Identificação / matrícula',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: registrarEntrada,
                child: const Text('Registrar entrada'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
