import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'login_screen.dart';
import '../home/home_screen.dart';

class SplashScreen extends StatefulWidget {

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() =>
      _SplashScreenState();
}

class _SplashScreenState
    extends State<SplashScreen> {

  @override
  void initState() {

    super.initState();

    verificarSesion();
  }

  Future<void> verificarSesion() async {

    await Future.delayed(
      const Duration(seconds: 2),
    );

    final user =
        FirebaseAuth.instance.currentUser;

    // NO EXISTE SESIÓN

    if (user == null) {

      if (!mounted) return;

      Navigator.pushReplacement(

        context,

        MaterialPageRoute(

          builder: (_) =>
          const LoginScreen(),
        ),
      );

      return;
    }

    // VALIDAR FIRESTORE

    final doc =
    await FirebaseFirestore.instance

        .collection("usuarios")

        .doc(user.uid)

        .get();

    // SI EL USUARIO NO EXISTE

    if (!doc.exists) {

      await FirebaseAuth.instance
          .signOut();

      if (!mounted) return;

      Navigator.pushReplacement(

        context,

        MaterialPageRoute(

          builder: (_) =>
          const LoginScreen(),
        ),
      );

      return;
    }

    // USUARIO VÁLIDO

    if (!mounted) return;

    Navigator.pushReplacement(

      context,

      MaterialPageRoute(

        builder: (_) =>
        const HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return const Scaffold(

      backgroundColor:
      Color(0xFF0F172A),

      body: Center(

        child:
        CircularProgressIndicator(
          color: Colors.cyan,
        ),
      ),
    );
  }
}