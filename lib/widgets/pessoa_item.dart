import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import '../cores.dart';
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

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      // desliza pra esquerda e aparecem as ações SAÍDA e EXCLUIR
      child: Slidable(
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.62, // largura das ações, pra caber o texto EXCLUIR
          children: [
            SlidableAction(
              onPressed: (context) {
                Slidable.of(context)?.close(); // fecha o item deslizado
                onSaida();
              },
              backgroundColor: corAlerta,
              foregroundColor: corFundo,
              icon: Icons.logout,
              label: 'SAÍDA',
            ),
            SlidableAction(
              onPressed: (context) {
                Slidable.of(context)?.close();
                onExcluir();
              },
              backgroundColor: corVermelho,
              foregroundColor: corTexto,
              icon: Icons.delete,
              label: 'EXCLUIR',
              borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(16),
              ),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: corCartao,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor:
                    pessoa.noAmbiente ? corVermelho : corTextoSecundario,
                child: Icon(
                  pessoa.noAmbiente ? Icons.person : Icons.exit_to_app,
                  color: corFundo,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            pessoa.nome,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // etiqueta da situação
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: pessoa.noAmbiente
                                ? corVermelho
                                : Colors.transparent,
                            border: Border.all(
                              color: pessoa.noAmbiente
                                  ? corVermelho
                                  : corTextoSecundario,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            pessoa.situacao,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: pessoa.noAmbiente
                                  ? corTexto
                                  : corTextoSecundario,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ID: ${pessoa.identificacao}\n'
                      'Entrada: ${formato.format(pessoa.dataEntrada)}'
                      '$saida',
                      style: const TextStyle(
                        fontSize: 12,
                        color: corTextoSecundario,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
