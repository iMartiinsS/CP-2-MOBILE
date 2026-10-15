# CP1 Mobile - Controle de Lotação

Projeto do checkpoint 01 de Mobile Application Development.

Ambiente escolhido: Cinema (capacidade máxima de 80 pessoas)

## Integrantes
- (colocar nome aqui)

## O que o app faz
- Mostra quantas pessoas estão no local
- Botão Entrou aumenta o contador (não passa da capacidade máxima)
- Botão Saiu diminui o contador (não fica negativo)
- Mostra mensagem de acordo com a lotação (pode entrar / quase cheio / lotado)

Desafio extra: fiz a classe Ambiente em lib/models/ambiente.dart com atributos, construtor nomeado, getter, setter e método.

## Rodar o projeto
Precisa ter o Flutter instalado.

Como esse zip só tem o lib/, pubspec.yaml e as imagens (sem as pastas do android/ios), o jeito mais fácil é:

```
flutter create teste
```

e depois copiar a pasta lib/ e assets/ pra dentro do projeto criado, colar o pubspec.yaml e rodar:

```
flutter pub get
flutter run
```
