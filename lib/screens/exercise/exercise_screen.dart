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
    {"title": "Pectorales", "image": "assets/imagenes/muscles/pectorales.png", "description": "Ejercicios enfocados en desarrollar y definir la zona pectoral."},
    {"title": "Espalda", "image": "assets/imagenes/muscles/espalda.png", "description": "Rutinas completas para fortalecer la espalda alta y dorsales."},
    {"title": "Piernas", "image": "assets/imagenes/muscles/piernas.png", "description": "Entrenamiento intenso de cuádriceps, femorales y glúteos."},
    {"title": "Biceps", "image": "assets/imagenes/muscles/biceps.png", "description": "Ejercicios de aislamiento para maximizar el pico del bíceps."},
    {"title": "Triceps", "image": "assets/imagenes/muscles/triceps.png", "description": "Rutinas enfocadas en las tres cabezas del tríceps."},
    {"title": "Hombros", "image": "assets/imagenes/muscles/hombros.png", "description": "Ejercicios para deltoides buscando estabilidad 3D."},
    {"title": "Abdominal", "image": "assets/imagenes/muscles/abdominal.png", "description": "Trabajo de alta intensidad para el recto abdominal y core."},
    {"title": "Cardio", "image": "assets/imagenes/muscles/cardio.png", "description": "Rutinas cardiovasculares para mejorar resistencia y quemar calorías."},
  ];

  @override
  void initState() {
    super.initState();
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
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: 0.5),
        ),
      ),
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
            setState(() => currentIndex = index);
            switch (index) {
              case 0: Navigator.maybePop(context); break;
              case 1: Navigator.push(context, MaterialPageRoute(builder: (_) => const ChatbotScreen())); break;
              case 2: Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())); break;
              case 3: Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())); break;
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
          itemBuilder: (context, index) {
            final muscle = muscles[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(
                  builder: (_) => MuscleDetailScreen(
                    title: muscle["title"],
                    image: muscle["image"],
                    description: muscle["description"],
                    userId: widget.userId,
                  ),
                )),
                child: _muscleRowCard(muscle["title"], muscle["description"], muscle["image"]),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _muscleRowCard(String title, String description, String imagePath) {
    return Container(
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.textPrimary.withOpacity(0.02), width: 1),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 65,
            height: double.infinity,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(11), bottomLeft: Radius.circular(11)),
              child: Hero(
                tag: 'muscle-pic-$title',
                child: Image.asset(imagePath, fit: BoxFit.cover, alignment: Alignment.topCenter),
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
                  Text(title, maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.textPrimary, fontSize: 13.5, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 1),
                  Text(description, maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.textMuted60, fontSize: 10.5)),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textMuted60, size: 11),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// PANTALLA DETALLE: Todos los ejercicios
// ─────────────────────────────────────────────
class MuscleDetailScreen extends StatefulWidget {
  final String title;
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
  List<Map<String, dynamic>> _ejercicios = [];
  Set<String> favoriteIds = {};
  final Set<String> _expandedIds = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final jsonString = await rootBundle.loadString('assets/data/ejercicios.json');
      final jsonList = json.decode(jsonString) as List<dynamic>;

      final filtrados = jsonList
          .map((e) => Map<String, dynamic>.from(e as Map))
          .where((e) => (e['musculo'] ?? '').toString() == widget.title)
          .toList();

      filtrados.sort((a, b) {
        final ambA = (a['ambiente'] ?? '') as String;
        final ambB = (b['ambiente'] ?? '') as String;
        if (ambA != ambB) return ambA.compareTo(ambB);
        return (a['orden'] as int? ?? 0).compareTo(b['orden'] as int? ?? 0);
      });

      final favs = await FavoritesManager.load(widget.userId);
      setState(() {
        _ejercicios = filtrados;
        favoriteIds = favs;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error cargando ejercicios: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> _toggleFavorite(String exerciseId, String exerciseName) async {
    await FavoritesManager.toggle(widget.userId, exerciseId);
    final favs = await FavoritesManager.load(widget.userId);
    setState(() => favoriteIds = favs);
    if (!mounted) return;
    final isFav = favoriteIds.contains(exerciseId);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(isFav ? "$exerciseName añadido a tu rutina" : "Eliminado de tu rutina"),
      duration: const Duration(milliseconds: 700),
    ));
  }

  void _toggleExpand(String exerciseId) {
    setState(() {
      if (_expandedIds.contains(exerciseId)) {
        _expandedIds.remove(exerciseId);
      } else {
        _expandedIds.add(exerciseId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Hero header ──
          Stack(
            children: [
              Hero(
                tag: 'muscle-pic-${widget.title}',
                child: SizedBox(
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
                      colors: [Colors.black.withOpacity(0.45), Colors.transparent],
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

          // ── Título + contador ──
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 14, bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.title,
                          style: const TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 3),
                      Text(widget.description,
                          style: const TextStyle(color: AppColors.textMuted60, fontSize: 12)),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.accent.withOpacity(0.3), width: 1),
                  ),
                  child: Text('${_ejercicios.length} ejercicios',
                      style: const TextStyle(color: AppColors.accent, fontSize: 11, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(color: AppColors.divider.withOpacity(0.5), height: 1),
          ),
          const SizedBox(height: 6),

          // ── Lista ──
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
                : _ejercicios.isEmpty
                ? const Center(child: Text("Sin ejercicios disponibles",
                style: TextStyle(color: AppColors.textMuted60)))
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              itemCount: _ejercicios.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _exerciseCard(_ejercicios[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _exerciseCard(Map<String, dynamic> item) {
    final exerciseId = '${item["nombre"]}_${item["ambiente"]}';
    final isFavorite = favoriteIds.contains(exerciseId);
    final isExpanded = _expandedIds.contains(exerciseId);
    final videoPath = item['videoFile']?.toString() ?? '';
    final descripcion = item['descripcion']?.toString() ?? '';
    final rutina = item['rutina']?.toString() ?? '';
    final tieneContenido = descripcion.isNotEmpty || rutina.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.textPrimary.withOpacity(0.05), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ── Fila principal: [ ▶ ] Nombre  |  Leer más  |  ★ ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                // Botón play
                GestureDetector(
                  onTap: () {
                    if (videoPath.isNotEmpty) {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (_) => ExerciseVideoScreen(
                          exerciseName: item['nombre'] ?? '',
                          videoAssetPath: videoPath,
                        ),
                      ));
                    }
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.play_arrow_rounded, color: AppColors.accent, size: 22),
                  ),
                ),
                const SizedBox(width: 10),

                // Nombre (ocupa todo el espacio disponible)
                Expanded(
                  child: Text(
                    item['nombre'] ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Leer más / menos
                if (tieneContenido)
                  GestureDetector(
                    onTap: () => _toggleExpand(exerciseId),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isExpanded
                            ? AppColors.accent.withOpacity(0.18)
                            : AppColors.accent.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.accent.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            isExpanded ? 'Menos' : 'Leer más',
                            style: const TextStyle(
                              color: AppColors.accent,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Icon(
                            isExpanded
                                ? Icons.keyboard_arrow_up_rounded
                                : Icons.keyboard_arrow_down_rounded,
                            size: 14,
                            color: AppColors.accent,
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(width: 4),

                // Estrella favorito
                GestureDetector(
                  onTap: () => _toggleFavorite(exerciseId, item['nombre'] ?? ''),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
                      color: isFavorite ? Colors.amber : AppColors.textMuted60,
                      size: 22,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Contenido expandible ──
          if (isExpanded && tieneContenido) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Divider(color: AppColors.divider.withOpacity(0.4), height: 1),
            ),

            // Descripción
            if (descripcion.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 6),
                child: Text(
                  descripcion,
                  style: const TextStyle(
                    color: AppColors.textMuted60,
                    fontSize: 12.5,
                    height: 1.6,
                  ),
                ),
              ),

            // Rutina destacada
            if (rutina.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 14, top: 4, bottom: 12),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.accent.withOpacity(0.3), width: 1),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.repeat_rounded, size: 16, color: AppColors.accent),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'RUTINA RECOMENDADA',
                              style: TextStyle(
                                color: AppColors.accent,
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              rutina,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// PANTALLA DE VIDEO: Sin audio, con loop
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
    debugPrint('Cargando video: ${widget.videoAssetPath}');
    _controller = VideoPlayerController.asset(widget.videoAssetPath)
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() => _initialized = true);
        _controller.setVolume(0.0);
        _controller.setLooping(true);
        _controller.play();
      }).catchError((e) {
        debugPrint('Error cargando video: $e');
        if (!mounted) return;
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
        title: Text(widget.exerciseName,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      ),
      body: Center(
        child: _hasError
            ? Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.white54, size: 48),
            const SizedBox(height: 12),
            const Text("Error al cargar el video.", style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 6),
            Text(widget.videoAssetPath,
                style: const TextStyle(color: Colors.white38, fontSize: 11),
                textAlign: TextAlign.center),
          ],
        )
            : !_initialized
            ? const CircularProgressIndicator(color: Colors.white)
            : GestureDetector(
          onTap: () => setState(() {
            _controller.value.isPlaying ? _controller.pause() : _controller.play();
          }),
          child: Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
              if (!_controller.value.isPlaying)
                const Icon(Icons.play_circle_fill, color: Colors.white54, size: 64),
            ],
          ),
        ),
      ),
    );
  }
}