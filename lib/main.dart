import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'app_theme.dart';
import 'screens/auth/splash_screen.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // Fija la orientación y la barra de navegación del sistema
  // para que NUNCA interfiera con el navBar de la app.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Barra de navegación del sistema (gesto/botones del celular)
  // se pinta del mismo color que el fondo para que no se superponga visualmente.
  AppTheme.applySystemUI();

  // Edge-to-edge: la app se extiende detrás de las barras del sistema,
  // Flutter maneja el padding con SafeArea/MediaQuery.
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const EvoYouAI());
}

class EvoYouAI extends StatelessWidget {

  const EvoYouAI({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      title: 'EvoYou AI',

      // ── Tema centralizado ──────────────────────────────────
      theme: AppTheme.theme,

      home: const SplashScreen(),
    );
  }
}
