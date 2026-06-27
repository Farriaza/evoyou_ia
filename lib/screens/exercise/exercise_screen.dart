// lib/screens/exercise/exercise_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import '../../app_theme.dart';
import '../profile/profile_screen.dart';
import '../settings/settings_screen.dart';
import '../chatbot/chatbot_screen.dart';

// ─────────────────────────────────────────────
// HELPER: Favoritos por usuario
// ─────────────────────────────────────────────
class FavoritesManager {
  static String _key(String userId) => 'favorites_$userId';

  static Future<Set<String>> load(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key(userId)) ?? [];
    return list.toSet();
  }

  static Future<void> save(String userId, Set<String> favorites) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key(userId), favorites.toList());
  }

  static Future<void> toggle(String userId, String exerciseId) async {
    final favorites = await load(userId);
    if (favorites.contains(exerciseId)) {
      favorites.remove(exerciseId);
    } else {
      favorites.add(exerciseId);
    }
    await save(userId, favorites);
  }
}

// ─────────────────────────────────────────────
// PANTALLA PRINCIPAL: Categorías de Músculo
// ─────────────────────────────────────────────
class ExerciseScreen extends StatefulWidget {
  final String userId;
  const ExerciseScreen({super.key, required this.userId});

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
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
      "title": "Cardio",
      "image": "assets/imagenes/muscles/cardio.png",
      "description": "Rutinas cardiovasculares para mejorar resistencia y quemar calorías.",
    },
  ];

  @override
  void initState() {
    super.initState();
    muscles.sort(
            (a, b) => a["title"].toString().compareTo(b["title"].toString()));
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
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.bgSecondary,
          border:
          Border(top: BorderSide(color: AppColors.divider, width: 0.8)),
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
            setState(() => currentIndex = index);
            switch (index) {
              case 0:
                Navigator.maybePop(context);
                break;
              case 1:
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ChatbotScreen()));
                break;
              case 2:
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ProfileScreen()));
                break;
              case 3:
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const SettingsScreen()));
                break;
            }
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.insights_rounded), label: "Progreso"),
            BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_rounded), label: "Chat IA"),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), label: "Perfil"),
            BottomNavigationBarItem(
                icon: Icon(Icons.tune_rounded), label: "Config"),
          ],
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          itemCount: muscles.length,
          physics: const NeverScrollableScrollPhysics(),
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
                        userId: widget.userId,
                      ),
                    ),
                  );
                },
                child: _muscleRowCard(
                  muscle["title"],
                  muscle["description"],
                  muscle["image"],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _muscleRowCard(
      String title, String description, String imagePath) {
    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: AppColors.textPrimary.withOpacity(0.02), width: 1),
      ),
      child: Row(
        children: [
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
                child: Image.asset(imagePath,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 4),
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
            child: Icon(Icons.arrow_forward_ios_rounded,
                color: AppColors.textMuted60, size: 11),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// PANTALLA DETALLE: Lista de ejercicios filtrada por músculo y ambiente
// ─────────────────────────────────────────────
class MuscleDetailScreen extends StatefulWidget {
  final String title;   // coincide con campo "musculo" del JSON
  final String image;
  final String description;
  final String userId;

  const MuscleDetailScreen({
    super.key,
    required this.title,
    required this.image,
    required this.description,
    required this.userId,
  });

  @override
  State<MuscleDetailScreen> createState() => _MuscleDetailScreenState();
}

class _MuscleDetailScreenState extends State<MuscleDetailScreen> {
  // 'gym' | 'casa'
  String _ambienteFiltro = 'gym';

  List<Map<String, dynamic>> _todosEjercicios = [];
  Set<String> favoriteIds = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // Leer el JSON como lista plana
      final jsonString =
      await rootBundle.loadString('assets/data/ejercicios.json');
      final jsonList = json.decode(jsonString) as List<dynamic>;

      // Filtrar por el campo "musculo" que coincide con widget.title
      final filtrados = jsonList
          .map((e) => Map<String, dynamic>.from(e as Map))
          .where((e) =>
      (e['musculo'] ?? '').toString() == widget.title)
          .toList();

      // Ordenar por "orden"
      filtrados.sort((a, b) =>
          (a['orden'] as int? ?? 0).compareTo(b['orden'] as int? ?? 0));

      final favs = await FavoritesManager.load(widget.userId);

      setState(() {
        _todosEjercicios = filtrados;
        favoriteIds = favs;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error cargando ejercicios: $e');
      setState(() => isLoading = false);
    }
  }

  /// Ejercicios filtrados por ambiente actual
  List<Map<String, dynamic>> get _ejerciciosFiltrados =>
      _todosEjercicios
          .where((e) => (e['ambiente'] ?? '') == _ambienteFiltro)
          .toList();

  Future<void> _toggleFavorite(
      String exerciseId, String exerciseName) async {
    await FavoritesManager.toggle(widget.userId, exerciseId);
    final favs = await FavoritesManager.load(widget.userId);
    setState(() => favoriteIds = favs);

    if (!mounted) return;
    final isFav = favoriteIds.contains(exerciseId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(isFav
            ? "$exerciseName añadido a tu rutina"
            : "Eliminado de tu rutina"),
        duration: const Duration(milliseconds: 700),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ejercicios = _ejerciciosFiltrados;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Hero image header ──
          Stack(
            children: [
              Hero(
                tag: 'muscle-pic-${widget.title}',
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.22,
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(20)),
                    child:
                    Image.asset(widget.image, fit: BoxFit.cover),
                  ),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(20)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.4),
                        Colors.transparent
                      ],
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, top: 6),
                  child: CircleAvatar(
                    backgroundColor:
                    AppColors.bgPrimary.withOpacity(0.7),
                    radius: 18,
                    child: IconButton(
                      icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: AppColors.textPrimary,
                          size: 14),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ── Título, descripción y filtro gym/casa ──
          Padding(
            padding: const EdgeInsets.only(
                left: 20, right: 20, top: 12, bottom: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      color: AppColors.textMuted60, fontSize: 12),
                ),
                const SizedBox(height: 12),

                // ── Selector Gym / Casa ──
                Row(
                  children: [
                    _ambienteChip(label: 'Gym', valor: 'gym',
                        icono: Icons.fitness_center),
                    const SizedBox(width: 8),
                    _ambienteChip(label: 'Casa', valor: 'casa',
                        icono: Icons.home_rounded),
                    const Spacer(),
                    Container(
                      width: 3,
                      height: 14,
                      decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(2)),
                    ),
                    const SizedBox(width: 6),
                    const Text("Lista de Ejercicios",
                        style: TextStyle(
                            color: AppColors.accent,
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),

          // ── Lista ──
          Expanded(
            child: isLoading
                ? const Center(
                child: CircularProgressIndicator(
                    color: AppColors.accent))
                : ejercicios.isEmpty
                ? const Center(
                child: Text("Sin ejercicios disponibles",
                    style: TextStyle(
                        color: AppColors.textMuted60)))
                : ListView.builder(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 4),
              itemCount: ejercicios.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                  const EdgeInsets.only(bottom: 6),
                  child:
                  _exerciseRowCard(ejercicios[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _ambienteChip(
      {required String label,
        required String valor,
        required IconData icono}) {
    final selected = _ambienteFiltro == valor;
    return GestureDetector(
      onTap: () => setState(() => _ambienteFiltro = valor),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.accent.withOpacity(0.15)
              : AppColors.bgCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? AppColors.accent
                : AppColors.textMuted60.withOpacity(0.3),
            width: 1.2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icono,
                size: 13,
                color: selected
                    ? AppColors.accent
                    : AppColors.textMuted60),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: selected
                    ? AppColors.accent
                    : AppColors.textMuted60,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _exerciseRowCard(Map<String, dynamic> item) {
    // Usamos "nombre + ambiente" como ID único para favoritos
    final exerciseId =
        '${item["nombre"]}_${item["ambiente"]}';
    final isFavorite = favoriteIds.contains(exerciseId);
    final videoFile = item['videoFile']?.toString() ?? '';
    final videoPath =
    videoFile.isNotEmpty ? 'assets/video/$videoFile' : '';

    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: AppColors.textPrimary.withOpacity(0.04),
            width: 1),
      ),
      child: Row(
        children: [
          // Botón play
          GestureDetector(
            onTap: () {
              if (videoPath.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ExerciseVideoScreen(
                      exerciseName: item['nombre'] ?? '',
                      videoAssetPath: videoPath,
                    ),
                  ),
                );
              }
            },
            child: Container(
              width: 55,
              height: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(11),
                    bottomLeft: Radius.circular(11)),
              ),
              child: const Icon(Icons.play_arrow_rounded,
                  color: AppColors.accent, size: 22),
            ),
          ),

          // Nombre y descripción
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (videoPath.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ExerciseVideoScreen(
                        exerciseName: item['nombre'] ?? '',
                        videoAssetPath: videoPath,
                      ),
                    ),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      item['nombre'] ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item['descripcion'] ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: AppColors.textMuted60,
                          fontSize: 11),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Estrella favorito
          IconButton(
            icon: Icon(
              isFavorite
                  ? Icons.star_rounded
                  : Icons.star_outline_rounded,
              color:
              isFavorite ? Colors.amber : AppColors.textMuted60,
              size: 22,
            ),
            onPressed: () =>
                _toggleFavorite(exerciseId, item['nombre'] ?? ''),
          ),

          const Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(Icons.arrow_forward_ios_rounded,
                color: AppColors.textMuted60, size: 10),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// PANTALLA DE VIDEO: Sin audio
// ─────────────────────────────────────────────
class ExerciseVideoScreen extends StatefulWidget {
  final String exerciseName;
  final String videoAssetPath;

  const ExerciseVideoScreen({
    super.key,
    required this.exerciseName,
    required this.videoAssetPath,
  });

  @override
  State<ExerciseVideoScreen> createState() => _ExerciseVideoScreenState();
}

class _ExerciseVideoScreenState extends State<ExerciseVideoScreen> {
  late VideoPlayerController _controller;
  bool _initialized = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoAssetPath)
      ..initialize().then((_) {
        setState(() => _initialized = true);
        _controller.setVolume(0.0); // sin audio
        _controller.play();
      }).catchError((e) {
        debugPrint('Error cargando video: $e');
        setState(() => _hasError = true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.exerciseName,
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
      ),
      body: Center(
        child: _hasError
            ? const Text("Error al cargar el video.",
            style: TextStyle(color: Colors.white70))
            : !_initialized
            ? const CircularProgressIndicator(color: Colors.white)
            : GestureDetector(
          onTap: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
              if (!_controller.value.isPlaying)
                const Icon(Icons.play_circle_fill,
                    color: Colors.white54, size: 64),
            ],
          ),
        ),
      ),
    );
  }
}