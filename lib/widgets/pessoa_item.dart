import 'package:flutter/material.dart';
import '../models/pessoa.dart';

// Cada pessoa da lista. Ele só mostra os dados e chama as funções que a
// HomePage mandou, quem decide o que fazer é a HomePage.
class PessoaItem extends StatelessWidget {
  final Pessoa pessoa;
  final VoidCallback onSaida;
  final VoidCallback onExcluir;

  const PessoaItem({
    super.key,
    required this.pessoa,
    required this.onSaida,
    required this.onExcluir,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(pessoa.nome),
        subtitle: Text(
          'ID: ${pessoa.identificacao}\n'
          'Entrada: ${pessoa.dataEntrada}\n'
          'Situação: ${pessoa.situacao}',
        ),
        isThreeLine: true,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: onSaida,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onExcluir,
            ),
          ],
        ),
      ),
    );
  }
}
