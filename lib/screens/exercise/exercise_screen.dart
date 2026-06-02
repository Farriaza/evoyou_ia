// lib/screens/exercise_screen.dart
import 'package:flutter/material.dart';

class ExerciseScreen extends StatelessWidget {
  const ExerciseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> muscles = [
      {
        "title": "Pectorales",
        "image": "assets/imagenes/muscles/pectorales.png",
        "description": "Ejercicios enfocados en desarrollar, dar volumen y definir la zona pectoral.",
      },
      {
        "title": "Espalda",
        "image": "assets/imagenes/muscles/espalda.png",
        "description": "Rutinas completas para fortalecer la espalda alta, densidad de dorsales y zona baja.",
      },
      {
        "title": "Piernas",
        "image": "assets/imagenes/muscles/piernas.png",
        "description": "Entrenamiento intenso enfocado en cuádriceps, femorales, abductores y glúteos.",
      },
      {
        "title": "Biceps",
        "image": "assets/imagenes/muscles/biceps.png",
        "description": "Ejercicios de aislamiento para maximizar el pico de los bíceps y fuerza del antebrazo.",
      },
      {
        "title": "Triceps",
        "image": "assets/imagenes/muscles/triceps.png",
        "description": "Rutinas enfocadas en las tres cabezas del tríceps para conseguir unos brazos masivos.",
      },
      {
        "title": "Hombros",
        "image": "assets/imagenes/muscles/hombros.png",
        "description": "Ejercicios para deltoides anteriores, laterales y posteriores buscando estabilidad 3D.",
      },
      {
        "title": "Abdominal",
        "image": "assets/imagenes/muscles/abdominal.png",
        "description": "Trabajo de alta intensidad para fortalecer el recto abdominal, oblicuos y estabilidad del core.",
      },
      {
        "title": "Gemelos",
        "image": "assets/imagenes/muscles/gemelos.png",
        "description": "Rutinas enfocadas en dar estímulo, potencia y volumen a las pantorrillas.",
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF071120),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Categorías de Músculo",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        itemCount: muscles.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 0.85, // Proporción más equilibrada
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
                    description: muscle["description"],
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF111C30),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.cyan.withOpacity(0.15),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Imagen de fondo con animación Hero
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(19),
                      child: Hero(
                        tag: 'muscle-pic-${muscle["title"]}',
                        child: Image.asset(
                          muscle["image"],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  // Degradado oscuro inferior para asegurar lectura del título
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(19),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.1),
                            Colors.black.withOpacity(0.85),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Texto centrado abajo de manera minimalista
                  Positioned(
                    bottom: 12,
                    left: 12,
                    right: 12,
                    child: Text(
                      muscle["title"],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabecera de la imagen con botón personalizado de retroceso integrado
            Stack(
              children: [
                Hero(
                  tag: 'muscle-pic-$title',
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.38,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(32),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyan.withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(32),
                      ),
                      child: Image.asset(
                        image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                // Degradado suave superior para visibilidad del botón de salida
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.4),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                // Botón de Volver Flotante Premium
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, top: 10),
                    child: CircleAvatar(
                      backgroundColor: const Color(0xFF071120).withOpacity(0.7),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título Principal
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Descripción que se removió de la Grid principal
                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 14.5,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Sección Rutinas Gym
                  _sectionHeader("Ejercicios Gym"),
                  const SizedBox(height: 14),
                  _exerciseCard("Próximamente disponible en EvoYou AI"),

                  const SizedBox(height: 28),

                  // Sección Rutinas Casa
                  _sectionHeader("Ejercicios en Casa"),
                  const SizedBox(height: 14),
                  _exerciseCard("Próximamente disponible en EvoYou AI"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String sectionTitle) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: Colors.cyan,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          sectionTitle,
          style: const TextStyle(
            color: Colors.cyan,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _exerciseCard(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111C30),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.04), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.cyan.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.lock_clock_outlined, // Cambiado por un icono estético de "Próximamente/Espera"
              color: Colors.cyan,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}