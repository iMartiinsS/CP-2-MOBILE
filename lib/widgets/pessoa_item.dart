import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
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
    final formato = DateFormat('dd/MM/yyyy HH:mm', 'pt_BR');

    // a saída só aparece depois que a pessoa sai
    String saida = '';
    if (pessoa.dataSaida != null) {
      saida = '\nSaída: ${formato.format(pessoa.dataSaida!)}';
    }

    // desliza pra esquerda e aparecem as ações SAÍDA e EXCLUIR
    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              Slidable.of(context)?.close(); // fecha o item deslizado
              onSaida();
            },
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            icon: Icons.logout,
            label: 'SAÍDA',
          ),
          SlidableAction(
            onPressed: (context) {
              Slidable.of(context)?.close();
              onExcluir();
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'EXCLUIR',
          ),
        ],
      ),
      child: Card(
        child: ListTile(
          title: Text(pessoa.nome),
          subtitle: Text(
            'ID: ${pessoa.identificacao}\n'
            'Entrada: ${formato.format(pessoa.dataEntrada)}'
            '$saida\n'
            'Situação: ${pessoa.situacao}',
          ),
        ),
      ),
    );
  }
}
