# Controle de Lotação 2.0 - Gerenciamento de Acessos

Projeto do Checkpoint 02 de Mobile Application Development (FIAP). É a evolução do app do Checkpoint 01: antes ele só contava quantas pessoas estavam no local, agora ele cadastra cada pessoa que entra, mostra quem está dentro e registra a saída.

## Ambiente escolhido

Cinema, com capacidade máxima de 80 pessoas. O visual (vinho escuro, vermelho das poltronas e lilás da tela) foi tirado da imagem `assets/images/cinema.png` do Checkpoint 01.

## Integrantes

- Luigi Martins - RM568381
- Pedro Relich - RM567933

## O que o app faz

- Cadastra a pessoa com nome e matrícula. A data e a hora de entrada são pegas na hora do cadastro.
- Mostra a lista de pessoas com nome, matrícula, data/hora de entrada e situação ("No ambiente" ou "Saiu").
- Mostra o contador "X / 80" e a mensagem de lotação do Checkpoint 01 (pode entrar, quase cheio, lotado).
- Deslizando um item para a esquerda aparecem as ações SAÍDA e EXCLUIR. As duas pedem confirmação num AlertDialog.
- Toda operação dá retorno com SnackBar (sucesso ou erro).

### Regras

- O ambiente nunca passa da capacidade. Lotado, o cadastro é bloqueado.
- Quem já saiu não pode ter a saída registrada de novo.
- Nome e matrícula não podem ficar vazios (espaços não contam).
- Não dá para cadastrar uma matrícula que já está no ambiente. Se a pessoa já saiu, a mesma matrícula pode entrar de novo.
- Excluir alguém que ainda está no ambiente libera a vaga no contador.

## Como rodar

Precisa ter o Flutter instalado (foi testado com o Flutter 3.47.7). Na pasta do projeto:

```
flutter pub get
flutter run
```

Na primeira vez a fonte Poppins é baixada pelo google_fonts, então o aparelho/emulador precisa estar com internet.

Para testar a lógica sem emulador, tem um teste de widget que simula o fluxo todo (cadastro, lotação, ID repetido, saída e exclusão):

```
flutter test
```

## Ícone do app

O logo é um ingresso de cinema com uma poltrona, desenhado em SVG (`assets/icon/icon.svg`) e exportado para PNG. O `icon_foreground.png` é só o símbolo, usado no ícone adaptativo do Android. Para gerar os ícones de novo depois de mexer na imagem:

```
dart run flutter_launcher_icons
```

## Estrutura

```
lib/
  main.dart                 tema do app (cores e fonte) e MaterialApp
  cores.dart                cores em hexadecimal
  models/
    ambiente.dart           capacidade e mensagem de lotação (do Checkpoint 01)
    pessoa.dart             nome, identificação, data de entrada e de saída
  screens/
    home_page.dart          tela principal, com as regras e o setState
  widgets/
    pessoa_item.dart        item da lista, com o Slidable
assets/
  images/cinema.png         imagem do Checkpoint 01
  icon/                     logo (svg e png)
test/
  fluxo_test.dart           teste do fluxo do app
```

## Tecnologias e pacotes

- Flutter e Dart, com StatefulWidget e setState
- [intl](https://pub.dev/packages/intl): formatação de data e hora (dd/MM/yyyy HH:mm)
- [google_fonts](https://pub.dev/packages/google_fonts): fonte Poppins
- [flutter_slidable](https://pub.dev/packages/flutter_slidable): ações de deslizar no item da lista
- [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons): ícone do app
