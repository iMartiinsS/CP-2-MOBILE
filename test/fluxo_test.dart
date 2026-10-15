import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:controle_lotacao_cinema/screens/home_page.dart';
import 'package:controle_lotacao_cinema/widgets/pessoa_item.dart';

// Testa o fluxo do app sem precisar de emulador:
// cadastrar, lotar, passar da capacidade, ID repetido, sair, sair de novo e excluir.
void main() {
  setUpAll(() async {
    await initializeDateFormatting('pt_BR');
  });

  Future<void> abrirApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2200);
    tester.view.devicePixelRatio = 2.75;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const MaterialApp(home: HomePage()));
  }

  Future<void> cadastrar(WidgetTester tester, String nome, String id) async {
    await tester.enterText(find.widgetWithText(TextField, 'Nome'), nome);
    await tester.enterText(find.widgetWithText(TextField, 'Matrícula'), id);
    await tester.tap(find.text('Registrar entrada'));
    await tester.pumpAndSettle();
  }

  // procura o nome só dentro da lista (e não nos campos de texto)
  Finder naLista(String nome) {
    return find.descendant(
      of: find.byType(PessoaItem),
      matching: find.text(nome),
    );
  }

  // desliza o item pra esquerda e toca na ação (SAÍDA ou EXCLUIR)
  Future<void> acaoDoItem(WidgetTester tester, String nome, String acao) async {
    await tester.drag(find.text(nome), const Offset(-400, 0));
    await tester.pumpAndSettle();
    await tester.tap(find.text(acao));
    await tester.pumpAndSettle();
  }

  testWidgets('cadastra uma pessoa e mostra na lista', (tester) async {
    await abrirApp(tester);
    expect(find.text('0 / 80'), findsOneWidget);
    expect(find.text('Nenhuma pessoa cadastrada ainda'), findsOneWidget);

    await cadastrar(tester, 'Maria', '123');

    expect(naLista('Maria'), findsOneWidget);
    expect(find.textContaining('ID: 123'), findsOneWidget);
    expect(find.text('No ambiente'), findsOneWidget);
    expect(find.text('1 / 80'), findsOneWidget);
    expect(find.text('Entrada de Maria registrada com sucesso!'),
        findsOneWidget);
  });

  testWidgets('não cadastra com nome ou ID vazio', (tester) async {
    await abrirApp(tester);

    await cadastrar(tester, '   ', '123');
    expect(find.text('Preencha o nome e a identificação.'), findsOneWidget);
    expect(find.text('0 / 80'), findsOneWidget);

    await cadastrar(tester, 'Maria', '   ');
    expect(find.text('0 / 80'), findsOneWidget);
  });

  testWidgets('bloqueia ID repetido enquanto está no ambiente', (tester) async {
    await abrirApp(tester);
    await cadastrar(tester, 'Maria', 'RM1');
    await cadastrar(tester, 'João', 'rm1');

    expect(
        find.text('Já existe alguém no ambiente com a identificação rm1.'),
        findsOneWidget);
    expect(naLista('João'), findsNothing);
    expect(find.text('1 / 80'), findsOneWidget);
  });

  testWidgets('saída: confirma, atualiza situação e contador', (tester) async {
    await abrirApp(tester);
    await cadastrar(tester, 'Maria', '123');

    // cancelar não muda nada
    await acaoDoItem(tester, 'Maria', 'SAÍDA');
    expect(find.text('Confirmar a saída de Maria?'), findsOneWidget);
    await tester.tap(find.text('CANCELAR'));
    await tester.pumpAndSettle();
    expect(find.text('No ambiente'), findsOneWidget);
    expect(find.text('1 / 80'), findsOneWidget);

    // confirmar registra a saída
    await acaoDoItem(tester, 'Maria', 'SAÍDA');
    await tester.tap(find.text('CONFIRMAR'));
    await tester.pumpAndSettle();
    expect(find.text('Saiu'), findsOneWidget);
    expect(find.textContaining('Saída: '), findsOneWidget);
    expect(find.text('0 / 80'), findsOneWidget);
    expect(find.text('Saída de Maria registrada.'), findsOneWidget);

    // sair de novo é bloqueado, sem abrir o dialog
    await acaoDoItem(tester, 'Maria', 'SAÍDA');
    expect(find.text('Maria já saiu do ambiente.'), findsOneWidget);
    expect(find.text('CONFIRMAR'), findsNothing);

    // quem saiu pode entrar de novo com o mesmo ID
    await cadastrar(tester, 'Maria 2', '123');
    expect(naLista('Maria 2'), findsOneWidget);
    expect(find.text('1 / 80'), findsOneWidget);
  });

  testWidgets('excluir quem está no ambiente libera a vaga', (tester) async {
    await abrirApp(tester);
    await cadastrar(tester, 'Maria', '123');

    await acaoDoItem(tester, 'Maria', 'EXCLUIR');
    expect(find.text('Deseja excluir Maria da lista?'), findsOneWidget);
    await tester.tap(find.text('CONFIRMAR'));
    await tester.pumpAndSettle();

    expect(naLista('Maria'), findsNothing);
    expect(find.text('0 / 80'), findsOneWidget);
    expect(find.text('Maria foi excluído(a) da lista.'), findsOneWidget);
  });

  testWidgets('lotação: não passa de 80 e libera vaga ao excluir',
      (tester) async {
    await abrirApp(tester);
    for (var i = 1; i <= 80; i++) {
      await cadastrar(tester, 'Pessoa $i', 'ID$i');
    }
    expect(find.text('80 / 80'), findsOneWidget);
    expect(find.text('Ambiente lotado'), findsOneWidget);

    // a 81ª pessoa é barrada
    await cadastrar(tester, 'Pessoa 81', 'ID81');
    expect(
        find.text('Ambiente lotado! Não é possível registrar uma nova entrada.'),
        findsOneWidget);
    expect(naLista('Pessoa 81'), findsNothing);
    expect(find.text('80 / 80'), findsOneWidget);

    // excluir alguém libera uma vaga
    await acaoDoItem(tester, 'Pessoa 80', 'EXCLUIR');
    await tester.tap(find.text('CONFIRMAR'));
    await tester.pumpAndSettle();
    expect(find.text('79 / 80'), findsOneWidget);

    await cadastrar(tester, 'Pessoa 81', 'ID81');
    expect(naLista('Pessoa 81'), findsOneWidget);
    expect(find.text('80 / 80'), findsOneWidget);
  });
}
