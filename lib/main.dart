import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

import 'screens/auth/splash_screen.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

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

      theme: ThemeData.dark(),

      home: const SplashScreen(),
    );
  }
}