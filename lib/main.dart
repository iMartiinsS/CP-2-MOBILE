import 'package:flutter/material.dart';
import 'models/ambiente.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Controle de Lotação',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Ambiente cinema = Ambiente.cinema();

  void entrou() {
    setState(() {
      if (cinema.pessoas < cinema.capacidadeMaxima) {
        cinema.pessoas = cinema.pessoas + 1;
      }
    });
  }

  void saiu() {
    setState(() {
      if (cinema.pessoas > 0) {
        cinema.pessoas = cinema.pessoas - 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Controle de Lotação - Cinema'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/cinema.png',
              height: 160,
            ),
            SizedBox(height: 20),
            Text(
              'Capacidade máxima: ${cinema.capacidadeMaxima} pessoas',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Pessoas no local',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              '${cinema.pessoas}',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              cinema.getMensagem(),
              style: TextStyle(fontSize: 18, color: Colors.red),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: saiu,
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                  child: Text('Saiu', style: TextStyle(color: Colors.white)),
                ),
                SizedBox(width: 20),
                TextButton(
                  onPressed: entrou,
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: Text('Entrou', style: TextStyle(color: Colors.white)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
