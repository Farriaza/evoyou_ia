import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../auth/login_screen.dart';
import '../profile/profile_screen.dart';
import '../settings/settings_screen.dart';
import '../look/look_screen.dart';
import '../exercise/exercise_screen.dart';
import '../running/running_screen.dart';
import '../nutrition/nutrition_screen.dart';
import '../rutina/rutina_screen.dart';
import '../chatbot/chatbot_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String apodo = "";
  String foto = "";
  bool loading = true;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    cargarUsuario();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    cargarUsuario();
  }

  Future<void> cargarUsuario() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final doc = await FirebaseFirestore.instance
          .collection("usuarios")
          .doc(user.uid)
          .get();

      if (!mounted) return;

      setState(() {
        apodo = doc.data()?["apodo"] ?? "";
        foto = doc.data()?["fotoPerfil"] ?? "";
        loading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  void _irAPerfil() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfileScreen()),
    ).then((_) async => await cargarUsuario());
  }

  void _irAChatbot() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ChatbotScreen()),
    );
  }

  Widget _menuCard({
    required String titulo,
    required IconData icono,
    required Color color,
    required VoidCallback onTap,
    String? badge,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: const Color(0xFF0D1A2D),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: color.withOpacity(0.15), width: 1),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.06),
              blurRadius: 20,
              spreadRadius: 1,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Fondo degradado sutil
            Positioned(
              top: -20,
              right: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(0.06),
                ),
              ),
            ),
            // Contenido
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: color.withOpacity(0.12),
                    ),
                    child: Icon(icono, color: color, size: 22),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titulo,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                      if (badge != null)
                        Text(
                          badge,
                          style: TextStyle(
                            color: color.withOpacity(0.8),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tieneFoto = foto.isNotEmpty && File(foto).existsSync();

    return Scaffold(
      backgroundColor: const Color(0xFF071120),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0D1A2D),
          border: Border(
            top: BorderSide(color: Colors.white.withOpacity(0.06), width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          backgroundColor: Colors.transparent,
          selectedItemColor: Colors.cyan,
          unselectedItemColor: Colors.white38,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() => currentIndex = index);

            if (index == 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Módulo progreso próximamente")),
              );
            }
            if (index == 1) _irAChatbot();
            if (index == 2) _irAPerfil();
            if (index == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.insights_outlined),
              activeIcon: Icon(Icons.insights),
              label: "Progreso",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline_rounded),
              activeIcon: Icon(Icons.chat_bubble_rounded),
              label: "Chat IA",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: "Perfil",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.tune_outlined),
              activeIcon: Icon(Icons.tune),
              label: "Config",
            ),
          ],
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator(color: Colors.cyan))
          : SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  GestureDetector(
                    onTap: _irAPerfil,
                    child: Container(
                      padding: const EdgeInsets.all(2.5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Colors.cyan.withOpacity(0.8),
                            Colors.blue.withOpacity(0.5),
                          ],
                        ),
                      ),
                      child: CircleAvatar(
                        key: UniqueKey(),
                        radius: 26,
                        backgroundColor: Colors.white10,
                        backgroundImage: tieneFoto
                            ? MemoryImage(File(foto).readAsBytesSync())
                            : null,
                        child: !tieneFoto
                            ? const Icon(Icons.person,
                            size: 24, color: Colors.white)
                            : null,
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Hola, ",
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              apodo,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              " 👋",
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          "Listo para avanzar hoy",
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    onPressed: logout,
                    icon: const Icon(
                      Icons.logout_rounded,
                      color: Colors.white38,
                      size: 20,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Título sección
              const Text(
                "Módulos",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 12),

              // Grid
              Expanded(
                child: GridView(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.1,
                  ),
                  children: [
                    _menuCard(
                      titulo: "Rutina",
                      icono: Icons.fitness_center,
                      color: Colors.cyan,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const RutinaScreen()),
                      ),
                    ),
                    _menuCard(
                      titulo: "Ejercicios",
                      icono: Icons.sports_gymnastics,
                      color: Colors.orange,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ExerciseScreen()),
                      ),
                    ),
                    _menuCard(
                      titulo: "Alimentación",
                      icono: Icons.restaurant_menu,
                      color: Colors.green,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const NutritionScreen()),
                      ),
                    ),
                    _menuCard(
                      titulo: "Running",
                      icono: Icons.directions_run_rounded,
                      color: Colors.redAccent,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const RunningScreen()),
                      ),
                    ),
                    _menuCard(
                      titulo: "Coach IA",
                      icono: Icons.psychology,
                      color: Colors.purpleAccent,
                      onTap: _irAChatbot,
                    ),
                    _menuCard(
                      titulo: "Look",
                      icono: Icons.auto_awesome,
                      color: Colors.blueAccent,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const LookScreen()),
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
