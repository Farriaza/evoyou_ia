// home_screen.dart

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

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState
    extends State<HomeScreen> {

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

      final user =
          FirebaseAuth.instance.currentUser;

      if(user == null) return;

      final doc =
      await FirebaseFirestore.instance

          .collection("usuarios")

          .doc(user.uid)

          .get();

      if(!mounted) return;

      setState(() {

        apodo =
            doc.data()?["apodo"] ?? "";

        foto =
            doc.data()?["fotoPerfil"] ?? "";

        loading = false;
      });

    } catch(e){

      print(e);
    }
  }

  Future<void> logout() async {

    await FirebaseAuth.instance.signOut();

    if (!mounted) return;

    Navigator.pushReplacement(

      context,

      MaterialPageRoute(
        builder: (_) =>
        const LoginScreen(),
      ),
    );
  }

  Widget menuCard({

    required String titulo,

    required IconData icono,

    required Color color,

    required VoidCallback onTap,
  }) {

    return GestureDetector(

      onTap: onTap,

      child: AnimatedContainer(

        duration:
        const Duration(milliseconds: 250),

        curve: Curves.easeInOut,

        decoration: BoxDecoration(

          color:
          const Color(0xFF101B31),

          borderRadius:
          BorderRadius.circular(30),

          border: Border.all(

            color:
            color.withOpacity(0.18),

            width: 1.2,
          ),

          boxShadow: [

            BoxShadow(

              color:
              color.withOpacity(0.05),

              blurRadius: 25,

              spreadRadius: 1,

              offset: const Offset(0, 8),
            ),
          ],
        ),

        child: Column(

          mainAxisAlignment:
          MainAxisAlignment.center,

          children: [

            Container(

              padding:
              const EdgeInsets.all(16),

              decoration: BoxDecoration(

                shape: BoxShape.circle,

                gradient: LinearGradient(

                  colors: [

                    color.withOpacity(0.20),

                    color.withOpacity(0.06),
                  ],

                  begin: Alignment.topLeft,

                  end: Alignment.bottomRight,
                ),
              ),

              child: Icon(

                icono,

                color: color,

                size: 34,
              ),
            ),

            const SizedBox(height: 20),

            Text(

              titulo,

              style: const TextStyle(

                color: Colors.white,

                fontSize: 17,

                fontWeight:
                FontWeight.w600,

                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xFF071120),

      bottomNavigationBar:
      BottomNavigationBar(

        currentIndex: currentIndex,

        backgroundColor:
        const Color(0xFF111C30),

        selectedItemColor:
        Colors.cyan,

        unselectedItemColor:
        Colors.white54,

        selectedFontSize: 13,

        unselectedFontSize: 12,

        elevation: 0,

        type:
        BottomNavigationBarType.fixed,

        onTap: (index) {

          setState(() {

            currentIndex = index;
          });

          // PROGRESO

          if (index == 0) {

            ScaffoldMessenger.of(context)

                .showSnackBar(

              const SnackBar(

                content: Text(
                  "Módulo progreso próximamente",
                ),
              ),
            );
          }

          // PERFIL

          if (index == 1) {

            Navigator.push(

              context,

              MaterialPageRoute(
                builder: (_) =>
                const ProfileScreen(),
              ),

            ).then((_) async {

              await cargarUsuario();
            });
          }

          // CONFIG

          if (index == 2) {

            Navigator.push(

              context,

              MaterialPageRoute(
                builder: (_) =>
                const SettingsScreen(),
              ),
            );
          }
        },

        items: const [

          BottomNavigationBarItem(

            icon: Icon(
              Icons.insights,
            ),

            label: "Progreso",
          ),

          BottomNavigationBarItem(

            icon: Icon(
              Icons.person_outline,
            ),

            label: "Perfil",
          ),

          BottomNavigationBarItem(

            icon: Icon(
              Icons.tune,
            ),

            label: "Config",
          ),
        ],
      ),

      body: loading

          ? const Center(

        child:
        CircularProgressIndicator(
          color: Colors.cyan,
        ),
      )

          : SafeArea(

        child: Padding(

          padding:
          const EdgeInsets.all(22),

          child: Column(

            children: [

              Row(

                children: [

                  GestureDetector(

                    onTap: () {

                      Navigator.push(

                        context,

                        MaterialPageRoute(
                          builder: (_) =>
                          const ProfileScreen(),
                        ),

                      ).then((_) async {

                        await cargarUsuario();
                      });
                    },

                    child: Container(

                      padding:
                      const EdgeInsets.all(3),

                      decoration: BoxDecoration(

                        shape: BoxShape.circle,

                        border: Border.all(
                          color: Colors.cyan
                              .withOpacity(0.6),
                        ),
                      ),

                      child: CircleAvatar(

                        key: UniqueKey(),

                        radius: 34,

                        backgroundColor:
                        Colors.white10,

                        backgroundImage:

                        foto.isNotEmpty &&
                            File(foto).existsSync()

                            ? MemoryImage(

                          File(
                            foto,
                          ).readAsBytesSync(),
                        )

                            : null,

                        child:

                        foto.isEmpty ||

                            !File(foto)
                                .existsSync()

                            ? const Icon(

                          Icons.person,

                          size: 30,

                          color:
                          Colors.white,
                        )

                            : null,
                      ),
                    ),
                  ),

                  const SizedBox(
                    width: 18,
                  ),

                  Expanded(

                    child: Column(

                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                      children: [

                        Text(

                          apodo,

                          style:
                          const TextStyle(
                            color:
                            Colors.white,
                            fontSize:
                            28,
                            fontWeight:
                            FontWeight
                                .bold,
                            letterSpacing:
                            0.4,
                          ),
                        ),

                        const SizedBox(
                          height: 5,
                        ),

                        const Text(

                          "Tu evolución comienza hoy",

                          style:
                          TextStyle(
                            color:
                            Colors.white54,
                            fontSize:
                            14,
                            letterSpacing:
                            0.2,
                          ),
                        ),
                      ],
                    ),
                  ),

                  IconButton(

                    onPressed: logout,

                    icon: const Icon(

                      Icons.logout_rounded,

                      color:
                      Colors.white70,
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 30,
              ),

              Expanded(

                child: GridView(

                  physics:
                  const BouncingScrollPhysics(),

                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(

                    crossAxisCount: 2,

                    mainAxisSpacing: 18,

                    crossAxisSpacing: 18,

                    childAspectRatio: 1,
                  ),

                  children: [

                    // RUTINA

                    menuCard(

                      titulo: "Rutina",

                      icono:
                      Icons.fitness_center,

                      color: Colors.cyan,

                      onTap: () {

                        Navigator.push(

                          context,

                          MaterialPageRoute(
                            builder: (_) =>
                            const RutinaScreen(),
                          ),
                        );
                      },
                    ),

                    // EJERCICIOS

                    menuCard(

                      titulo: "Ejercicios",

                      icono:
                      Icons.sports_gymnastics,

                      color: Colors.orange,

                      onTap: () {

                        Navigator.push(

                          context,

                          MaterialPageRoute(
                            builder: (_) =>
                            const ExerciseScreen(),
                          ),
                        );
                      },
                    ),

                    // ALIMENTACION

                    menuCard(

                      titulo: "Alimentación",

                      icono:
                      Icons.restaurant_menu,

                      color:
                      Colors.green,

                      onTap: () {

                        Navigator.push(

                          context,

                          MaterialPageRoute(
                            builder: (_) =>
                            const NutritionScreen(),
                          ),
                        );
                      },
                    ),

                    // RUNNING

                    menuCard(

                      titulo: "Running",

                      icono:
                      Icons.directions_run_rounded,

                      color: Colors.redAccent,

                      onTap: () {

                        Navigator.push(

                          context,

                          MaterialPageRoute(
                            builder: (_) =>
                            const RunningScreen(),
                          ),
                        );
                      },
                    ),

                    // COACH IA

                    menuCard(

                      titulo: "Coach IA",

                      icono:
                      Icons.psychology,

                      color:
                      Colors.purpleAccent,

                      onTap: () {

                        ScaffoldMessenger.of(context)

                            .showSnackBar(

                          const SnackBar(

                            content: Text(
                              "Coach IA próximamente",
                            ),
                          ),
                        );
                      },
                    ),

                    // LOOK

                    menuCard(

                      titulo: "Look",

                      icono:
                      Icons.auto_awesome,

                      color: Colors.blueAccent,

                      onTap: () {

                        Navigator.push(

                          context,

                          MaterialPageRoute(
                            builder: (_) =>
                            const LookScreen(),
                          ),
                        );
                      },
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