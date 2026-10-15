import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'cores.dart';
import 'screens/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR'); // carrega os dados de data em português
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Controle de Lotação',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: corFundo,
        colorScheme: const ColorScheme.dark(
          primary: corVermelho,
          onPrimary: corTexto,
          surface: corCartao,
          onSurface: corTexto,
        ),
        // fonte Poppins em todo o app
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme)
            .apply(bodyColor: corTexto, displayColor: corTexto),
        appBarTheme: AppBarTheme(
          backgroundColor: corFundo,
          foregroundColor: corTexto,
          centerTitle: true,
          titleTextStyle: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: corTexto,
          ),
        ),
        // campos de texto
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: corCartao,
          labelStyle: const TextStyle(color: corTextoSecundario),
          prefixIconColor: corTextoSecundario,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: corVermelho, width: 2),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: corVermelho,
            foregroundColor: corTexto,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
        ),
      ),
      home: const HomePage(),
    );
  }
}
