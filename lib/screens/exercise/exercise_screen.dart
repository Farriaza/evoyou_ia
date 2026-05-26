import 'package:flutter/material.dart';

class ExerciseScreen extends StatelessWidget {

  const ExerciseScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final List<Map<String, dynamic>> muscles = [

      {
        "title": "Pectorales",
        "image": "assets/imagenes/muscles/pectorales.png",
        "description":
        "Ejercicios enfocados en desarrollar el pecho.",
      },

      {
        "title": "Espalda",
        "image": "assets/imagenes/muscles/espalda.png",
        "description":
        "Rutinas para fortalecer espalda alta y baja.",
      },

      {
        "title": "Piernas",
        "image": "assets/imagenes/muscles/piernas.png",
        "description":
        "Entrenamiento de cuadriceps, femorales y glúteos.",
      },

      {
        "title": "Biceps",
        "image": "assets/imagenes/muscles/biceps.png",
        "description":
        "Ejercicios para bíceps y antebrazo.",
      },

      {
        "title": "Triceps",
        "image": "assets/imagenes/muscles/triceps.png",
        "description":
        "Rutinas enfocadas en tríceps.",
      },

      {
        "title": "Hombros",
        "image": "assets/imagenes/muscles/hombros.png",
        "description":
        "Ejercicios para deltoides y estabilidad.",
      },

      {
        "title": "Abdominal",
        "image": "assets/imagenes/muscles/abdominal.png",
        "description":
        "Trabajo de abdomen y core.",
      },

      {
        "title": "Gemelos",
        "image": "assets/imagenes/muscles/gemelos.png",
        "description":
        "Rutinas enfocadas en pantorrillas.",
      },
    ];

    return Scaffold(

      backgroundColor: const Color(0xFF071120),

      appBar: AppBar(

        backgroundColor: Colors.transparent,

        elevation: 0,

        centerTitle: true,

        title: const Text(

          "Ejercicios",

          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(

        padding: const EdgeInsets.all(16),

        child: GridView.builder(

          itemCount: muscles.length,

          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(

            crossAxisCount: 2,

            crossAxisSpacing: 16,

            mainAxisSpacing: 16,

            childAspectRatio: 0.72,
          ),

          itemBuilder: (context, index) {

            final muscle = muscles[index];

            return GestureDetector(

              onTap: () {

                Navigator.push(

                  context,

                  MaterialPageRoute(

                    builder: (_) => MuscleDetailScreen(

                      title: muscle["title"],

                      image: muscle["image"],

                      description:
                      muscle["description"],
                    ),
                  ),
                );
              },

              child: Container(

                decoration: BoxDecoration(

                  color: const Color(0xFF111C30),

                  borderRadius:
                  BorderRadius.circular(24),

                  border: Border.all(
                    color: Colors.white10,
                  ),

                  boxShadow: const [

                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),

                child: Column(

                  children: [

                    Expanded(

                      child: ClipRRect(

                        borderRadius:
                        const BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),

                        child: Image.asset(

                          muscle["image"],

                          width: double.infinity,

                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    Padding(

                      padding: const EdgeInsets.all(14),

                      child: Column(

                        children: [

                          Text(

                            muscle["title"],

                            style: const TextStyle(

                              color: Colors.white,

                              fontSize: 18,

                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(

                            muscle["description"],

                            textAlign: TextAlign.center,

                            style: const TextStyle(

                              color: Colors.white70,

                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class MuscleDetailScreen extends StatelessWidget {

  final String title;

  final String image;

  final String description;

  const MuscleDetailScreen({

    super.key,

    required this.title,

    required this.image,

    required this.description,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFF071120),

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

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            ClipRRect(

              borderRadius:
              BorderRadius.circular(25),

              child: Image.asset(
                image,
              ),
            ),

            const SizedBox(height: 25),

            Text(

              title,

              style: const TextStyle(

                color: Colors.white,

                fontSize: 30,

                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Text(

              description,

              style: const TextStyle(

                color: Colors.white70,

                fontSize: 16,
              ),
            ),

            const SizedBox(height: 30),

            const Text(

              "Ejercicios Gym",

              style: TextStyle(

                color: Colors.cyan,

                fontSize: 22,

                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            exerciseCard(
              "Próximamente",
            ),

            const SizedBox(height: 30),

            const Text(

              "Ejercicios en Casa",

              style: TextStyle(

                color: Colors.cyan,

                fontSize: 22,

                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            exerciseCard(
              "Próximamente",
            ),
          ],
        ),
      ),
    );
  }

  Widget exerciseCard(String title) {

    return Container(

      width: double.infinity,

      padding: const EdgeInsets.all(18),

      margin: const EdgeInsets.only(bottom: 14),

      decoration: BoxDecoration(

        color: const Color(0xFF111C30),

        borderRadius:
        BorderRadius.circular(20),
      ),

      child: Row(

        children: [

          Container(

            width: 55,

            height: 55,

            decoration: BoxDecoration(

              color: Colors.cyan.withOpacity(0.15),

              borderRadius:
              BorderRadius.circular(15),
            ),

            child: const Icon(
              Icons.fitness_center,
              color: Colors.cyan,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(

            child: Text(

              title,

              style: const TextStyle(

                color: Colors.white,

                fontSize: 16,

                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}