// lib/screens/exercise_screen.dart
import 'package:flutter/material.dart';
import '../../app_theme.dart';
// Importaciones de tus pantallas para mantener la misma navegación que tu Home
import '../profile/profile_screen.dart';
import '../settings/settings_screen.dart';
import '../chatbot/chatbot_screen.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key});

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  // Ponemos el índice por defecto para esta sección (puedes ajustarlo si usas una navegación centralizada)
  int currentIndex = 0;

  final List<Map<String, dynamic>> muscles = [
    {
      "title": "Pectorales",
      "image": "assets/imagenes/muscles/pectorales.png",
      "description": "Ejercicios enfocados en desarrollar y definir la zona pectoral.",
    },
    {
      "title": "Espalda",
      "image": "assets/imagenes/muscles/espalda.png",
      "description": "Rutinas completas para fortalecer la espalda alta y dorsales.",
    },
    {
      "title": "Piernas",
      "image": "assets/imagenes/muscles/piernas.png",
      "description": "Entrenamiento intenso de cuádriceps, femorales y glúteos.",
    },
    {
      "title": "Biceps",
      "image": "assets/imagenes/muscles/biceps.png",
      "description": "Ejercicios de aislamiento para maximizar el pico del bíceps.",
    },
    {
      "title": "Triceps",
      "image": "assets/imagenes/muscles/triceps.png",
      "description": "Rutinas enfocadas en las tres cabezas del tríceps.",
    },
    {
      "title": "Hombros",
      "image": "assets/imagenes/muscles/hombros.png",
      "description": "Ejercicios para deltoides buscando estabilidad 3D.",
    },
    {
      "title": "Abdominal",
      "image": "assets/imagenes/muscles/abdominal.png",
      "description": "Trabajo de alta intensidad para el recto abdominal y core.",
    },
    {
      "title": "Gemelos",
      "image": "assets/imagenes/muscles/gemelos.png",
      "description": "Rutinas enfocadas en dar estímulo y volumen a las pantorrillas.",
    },
  ];

  @override
  void initState() {
    super.initState();
    // ORDENAR ALFABÉTICAMENTE de la A a la Z antes de construir la vista
    muscles.sort((a, b) => a["title"].toString().compareTo(b["title"].toString()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          "Categorías de Músculo",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // RÉPLICA EXACTA DEL MENÚ INFERIOR DE TU HOME
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.bgSecondary,
          border: Border(top: BorderSide(color: AppColors.divider, width: 0.8)),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          backgroundColor: Colors.transparent,
          selectedItemColor: AppColors.accentLight,
          unselectedItemColor: AppColors.textSubtle50,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
            switch (index) {
              case 0:
              // Si pulsa progreso/atrás vuelve a la pantalla anterior
                Navigator.maybePop(context);
                break;
              case 1:
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatbotScreen()));
                break;
              case 2:
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
                break;
              case 3:
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
                break;
              default:
                break;
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.insights_rounded), label: "Progreso"),
            BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_rounded), label: "Chat IA"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
            BottomNavigationBarItem(icon: Icon(Icons.tune_rounded), label: "Config"),
          ],
        ),
      ),

      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          itemCount: muscles.length,
          physics: const NeverScrollableScrollPhysics(), // Evita scroll innecesario, entran justos
          itemBuilder: (context, index) {
            final muscle = muscles[index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: GestureDetector(
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
                child: _muscleRowCard(
                    muscle["title"],
                    muscle["description"],
                    muscle["image"]
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Tarjeta reducida para optimizar la altura de la imagen y prevenir scroll
  Widget _muscleRowCard(String title, String description, String imagePath) {
    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.textPrimary.withOpacity(0.02),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Contenedor de la imagen recortado verticalmente
          Container(
            width: 65,
            height: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(11),
                bottomLeft: Radius.circular(11),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(11),
                bottomLeft: Radius.circular(11),
              ),
              child: Hero(
                tag: 'muscle-pic-$title',
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textMuted60,
                      fontSize: 10.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.textMuted60,
              size: 11,
            ),
          ),
        ],
      ),
    );
  }
}

// PANTALLA DETALLE CON ESTRELLA DE FAVORITOS (Rutina)
class MuscleDetailScreen extends StatefulWidget {
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
  State<MuscleDetailScreen> createState() => _MuscleDetailScreenState();
}

class _MuscleDetailScreenState extends State<MuscleDetailScreen> {
  // Lista simulada de ejercicios
  final List<Map<String, dynamic>> exercises = List.generate(
    8,
        (index) => {
      "id": index,
      "name": "Ejercicio ${String.fromCharCode(65 + index)}",
      "desc": "Consejo clave o descriptor para tu ejecución.",
      "isFavorite": false, // Estado local de favorito
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Hero(
                tag: 'muscle-pic-${widget.title}',
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.22,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                    child: Image.asset(widget.image, fit: BoxFit.cover),
                  ),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black.withOpacity(0.4), Colors.transparent],
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, top: 6),
                  child: CircleAvatar(
                    backgroundColor: AppColors.bgPrimary.withOpacity(0.7),
                    radius: 18,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 14),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.textMuted60, fontSize: 12),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(width: 3, height: 14, decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(2))),
                    const SizedBox(width: 6),
                    const Text("Lista de Ejercicios", style: TextStyle(color: AppColors.accent, fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              itemCount: exercises.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final item = exercises[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: _exerciseRowCard(item),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _exerciseRowCard(Map<String, dynamic> item) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.textPrimary.withOpacity(0.04), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 55,
            height: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.1),
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(11), bottomLeft: Radius.circular(11)),
            ),
            child: const Icon(Icons.play_arrow_rounded, color: AppColors.accent, size: 22),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${item["name"]} (${widget.title})",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item["desc"],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: AppColors.textMuted60, fontSize: 11),
                  ),
                ],
              ),
            ),
          ),

          // BOTÓN DE ESTRELLA (FAVORITO / AGREGAR A RUTINA)
          IconButton(
            icon: Icon(
              item["isFavorite"] ? Icons.star_rounded : Icons.star_outline_rounded,
              color: item["isFavorite"] ? Colors.amber : AppColors.textMuted60,
              size: 22,
            ),
            onPressed: () {
              setState(() {
                item["isFavorite"] = !item["isFavorite"];
              });

              // Feedback visual rápido
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    item["isFavorite"]
                        ? "${item["name"]} añadido a tu rutina"
                        : "Eliminado de tu rutina",
                  ),
                  duration: const Duration(milliseconds: 600),
                ),
              );
            },
          ),
          const Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textMuted60, size: 10),
          ),
        ],
      ),
    );
  }
}