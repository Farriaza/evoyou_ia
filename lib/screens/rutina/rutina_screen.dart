// rutina_screen.dart

import 'package:flutter/material.dart';

class RutinaScreen extends StatelessWidget {

  const RutinaScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final List<Map<String, dynamic>> routines = [

      {
        "title": "Bajar Peso",
        "description":
        "Rutinas enfocadas en quemar grasa y cardio.",
        "icon": Icons.local_fire_department,
        "color": Colors.orange,
      },

      {
        "title": "Ganar Masa",
        "description":
        "Entrenamientos para hipertrofia muscular.",
        "icon": Icons.fitness_center,
        "color": Colors.cyan,
      },

      {
        "title": "Definición",
        "description":
        "Rutinas para marcar músculos y reducir grasa.",
        "icon": Icons.bolt,
        "color": Colors.green,
      },

      {
        "title": "Fuerza",
        "description":
        "Ejercicios pesados y progresivos.",
        "icon": Icons.sports_mma,
        "color": Colors.redAccent,
      },

      {
        "title": "Casa",
        "description":
        "Rutinas sin máquinas ni gimnasio.",
        "icon": Icons.home,
        "color": Colors.purpleAccent,
      },

      {
        "title": "Gym Completo",
        "description":
        "Entrenamientos completos de gimnasio.",
        "icon": Icons.apartment,
        "color": Colors.blueAccent,
      },
    ];

    return Scaffold(

      backgroundColor:
      const Color(0xFF071120),

      appBar: AppBar(

        backgroundColor: Colors.transparent,

        elevation: 0,

        centerTitle: true,

        title: const Text(

          "Rutinas",

          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(

        padding: const EdgeInsets.all(18),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            Container(

              width: double.infinity,

              padding: const EdgeInsets.all(24),

              decoration: BoxDecoration(

                borderRadius:
                BorderRadius.circular(25),

                gradient: const LinearGradient(

                  colors: [
                    Color(0xFF00C6FF),
                    Color(0xFF0072FF),
                  ],
                ),
              ),

              child: const Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  Icon(

                    Icons.auto_awesome,

                    color: Colors.white,

                    size: 45,
                  ),

                  SizedBox(height: 15),

                  Text(

                    "Selecciona Tu Objetivo",

                    style: TextStyle(

                      color: Colors.white,

                      fontSize: 28,

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(

                    "Elige el tipo de rutina que mejor se adapte a tu objetivo físico.",

                    style: TextStyle(

                      color: Colors.white70,

                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text(

              "Rutinas Disponibles",

              style: TextStyle(

                color: Colors.white,

                fontSize: 22,

                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 18),

            Expanded(

              child: GridView.builder(

                itemCount: routines.length,

                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(

                  crossAxisCount: 2,

                  crossAxisSpacing: 16,

                  mainAxisSpacing: 16,

                  childAspectRatio: 0.9,
                ),

                itemBuilder: (context, index) {

                  final routine =
                  routines[index];

                  return GestureDetector(

                    onTap: () {

                      Navigator.push(

                        context,

                        MaterialPageRoute(

                          builder: (_) =>
                              RoutineDetailScreen(

                                title:
                                routine["title"],

                                description:
                                routine["description"],

                                color:
                                routine["color"],
                              ),
                        ),
                      );
                    },

                    child: Container(

                      decoration: BoxDecoration(

                        color:
                        const Color(0xFF111C30),

                        borderRadius:
                        BorderRadius.circular(25),

                        border: Border.all(
                          color: Colors.white10,
                        ),
                      ),

                      child: Padding(

                        padding:
                        const EdgeInsets.all(18),

                        child: Column(

                          mainAxisAlignment:
                          MainAxisAlignment.center,

                          children: [

                            Container(

                              width: 70,

                              height: 70,

                              decoration: BoxDecoration(

                                color:
                                routine["color"]
                                    .withOpacity(0.15),

                                borderRadius:
                                BorderRadius.circular(
                                  22,
                                ),
                              ),

                              child: Icon(

                                routine["icon"],

                                size: 38,

                                color:
                                routine["color"],
                              ),
                            ),

                            const SizedBox(height: 18),

                            Text(

                              routine["title"],

                              textAlign:
                              TextAlign.center,

                              style:
                              const TextStyle(

                                color:
                                Colors.white,

                                fontSize: 18,

                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(

                              routine["description"],

                              textAlign:
                              TextAlign.center,

                              style:
                              const TextStyle(

                                color:
                                Colors.white70,

                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RoutineDetailScreen
    extends StatelessWidget {

  final String title;

  final String description;

  final Color color;

  const RoutineDetailScreen({

    super.key,

    required this.title,

    required this.description,

    required this.color,
  });

  @override
  Widget build(BuildContext context) {

    final List<Map<String, dynamic>> days = [

      {
        "day": "Lunes",
        "muscle": "Pecho + Triceps",
        "icon": Icons.fitness_center,
      },

      {
        "day": "Martes",
        "muscle": "Espalda + Bíceps",
        "icon": Icons.sports_gymnastics,
      },

      {
        "day": "Miércoles",
        "muscle": "Piernas",
        "icon": Icons.directions_run,
      },

      {
        "day": "Jueves",
        "muscle": "Hombros",
        "icon": Icons.accessibility_new,
      },

      {
        "day": "Viernes",
        "muscle": "Cardio + Abdomen",
        "icon": Icons.favorite,
      },

      {
        "day": "Sábado",
        "muscle": "Full Body",
        "icon": Icons.bolt,
      },
    ];

    return Scaffold(

      backgroundColor:
      const Color(0xFF071120),

      appBar: AppBar(

        backgroundColor: Colors.transparent,

        elevation: 0,

        title: Text(

          title,

          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      body: Padding(

        padding: const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            Container(

              width: double.infinity,

              padding: const EdgeInsets.all(24),

              decoration: BoxDecoration(

                color:
                const Color(0xFF111C30),

                borderRadius:
                BorderRadius.circular(25),
              ),

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  Icon(

                    Icons.fitness_center,

                    size: 50,

                    color: color,
                  ),

                  const SizedBox(height: 15),

                  Text(

                    title,

                    style: const TextStyle(

                      color: Colors.white,

                      fontSize: 30,

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(

                    description,

                    style: const TextStyle(

                      color: Colors.white70,

                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            const Text(

              "Plan Semanal",

              style: TextStyle(

                color: Colors.white,

                fontSize: 24,

                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 18),

            Expanded(

              child: ListView.builder(

                itemCount: days.length,

                itemBuilder: (context, index) {

                  final item = days[index];

                  return GestureDetector(

                    onTap: () {

                      ScaffoldMessenger.of(
                          context)

                          .showSnackBar(

                        SnackBar(

                          content: Text(
                            "${item["muscle"]} próximamente",
                          ),
                        ),
                      );
                    },

                    child: Container(

                      margin:
                      const EdgeInsets.only(
                        bottom: 16,
                      ),

                      padding:
                      const EdgeInsets.all(18),

                      decoration: BoxDecoration(

                        color:
                        const Color(
                          0xFF111C30,
                        ),

                        borderRadius:
                        BorderRadius.circular(
                          22,
                        ),

                        border: Border.all(
                          color: Colors.white10,
                        ),
                      ),

                      child: Row(

                        children: [

                          Container(

                            width: 65,

                            height: 65,

                            decoration: BoxDecoration(

                              color:
                              color.withOpacity(
                                0.15,
                              ),

                              borderRadius:
                              BorderRadius.circular(
                                18,
                              ),
                            ),

                            child: Icon(

                              item["icon"],

                              color: color,

                              size: 34,
                            ),
                          ),

                          const SizedBox(width: 18),

                          Expanded(

                            child: Column(

                              crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                              children: [

                                Text(

                                  item["day"],

                                  style:
                                  const TextStyle(

                                    color:
                                    Colors.white,

                                    fontSize:
                                    20,

                                    fontWeight:
                                    FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(
                                  height: 6,
                                ),

                                Text(

                                  item["muscle"],

                                  style:
                                  const TextStyle(

                                    color:
                                    Colors.white70,

                                    fontSize:
                                    15,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Icon(

                            Icons.arrow_forward_ios,

                            color: Colors.white38,

                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}