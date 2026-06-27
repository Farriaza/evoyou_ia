// running_screen.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

import '../../app_theme.dart';
import '../home/home_screen.dart';
import '../profile/profile_screen.dart';
import '../settings/settings_screen.dart';
import '../chatbot/chatbot_screen.dart';
import 'running_history_screen.dart';

enum _EstadoCarrera { detenida, enCurso, pausada }

class RunningScreen extends StatefulWidget {
  const RunningScreen({super.key});

  @override
  State<RunningScreen> createState() => _RunningScreenState();
}

class _RunningScreenState extends State<RunningScreen> {
  _EstadoCarrera estado = _EstadoCarrera.detenida;

  int segundos = 0;
  double distanciaKm = 0;
  double calorias = 0;

  Timer? timer;
  Position? ultimaPosicion;
  StreamSubscription<Position>? posicionStream;

  // Para detectar inactividad y auto-pausar a los 15 min sin movimiento.
  DateTime? ultimoMovimiento;
  static const Duration _tiempoMaxSinMovimiento = Duration(minutes: 15);
  static const double _umbralMovimientoMetros = 8; // ruido GPS típico

  int currentIndex = 0;

  bool get running => estado == _EstadoCarrera.enCurso;
  bool get pausada => estado == _EstadoCarrera.pausada;
  bool get detenida => estado == _EstadoCarrera.detenida;

  Future<void> iniciarCarrera() async {
    final bool servicioHabilitado = await Geolocator.isLocationServiceEnabled();
    if (!servicioHabilitado) {
      _mostrarMensaje("Activa el GPS para comenzar", error: true);
      return;
    }

    LocationPermission permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
    }

    if (permiso == LocationPermission.denied ||
        permiso == LocationPermission.deniedForever) {
      _mostrarMensaje("Permiso de ubicación denegado", error: true);
      return;
    }

    setState(() {
      estado = _EstadoCarrera.enCurso;
      segundos = 0;
      distanciaKm = 0;
      calorias = 0;
      ultimaPosicion = null;
      ultimoMovimiento = DateTime.now();
    });

    _iniciarTimer();
    _iniciarStreamGps();
  }

  void _iniciarTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      // El Timer sigue corriendo aunque se bloquee la pantalla; solo se
      // detiene si el usuario pausa, detiene la carrera, o cierra la app.
      setState(() => segundos++);
      _revisarInactividad();
    });
  }

  void _iniciarStreamGps() {
    posicionStream?.cancel();
    posicionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    ).listen((Position position) {
      if (ultimaPosicion != null) {
        final double metros = Geolocator.distanceBetween(
          ultimaPosicion!.latitude,
          ultimaPosicion!.longitude,
          position.latitude,
          position.longitude,
        );

        if (metros > _umbralMovimientoMetros) {
          ultimoMovimiento = DateTime.now();
        }

        setState(() {
          distanciaKm += metros / 1000;
          calorias = distanciaKm * 60;
        });
      }
      ultimaPosicion = position;
    });
  }

  // Si el usuario lleva más de 15 minutos sin moverse, se pausa solo.
  void _revisarInactividad() {
    if (!running || ultimoMovimiento == null) return;
    final inactivo = DateTime.now().difference(ultimoMovimiento!);
    if (inactivo >= _tiempoMaxSinMovimiento) {
      pausarCarrera(automatico: true);
    }
  }

  void pausarCarrera({bool automatico = false}) {
    if (!running) return;
    timer?.cancel();
    posicionStream?.cancel();
    setState(() => estado = _EstadoCarrera.pausada);

    if (automatico) {
      _mostrarMensaje("Pausado automáticamente: 15 min sin movimiento", error: false);
    }
  }

  void reanudarCarrera() {
    if (!pausada) return;
    setState(() => estado = _EstadoCarrera.enCurso);
    ultimoMovimiento = DateTime.now();
    ultimaPosicion = null; // evita saltos de distancia al reanudar
    _iniciarTimer();
    _iniciarStreamGps();
  }

  Future<void> detenerCarrera() async {
    timer?.cancel();
    posicionStream?.cancel();

    setState(() => estado = _EstadoCarrera.detenida);

    if (segundos > 0) {
      await guardarSesion();
      if (!mounted) return;
      _mostrarMensaje("Sesión guardada", error: false);
    }
  }

  void _mostrarMensaje(String texto, {required bool error}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: error ? AppColors.error : AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Text(texto),
      ),
    );
  }

  Future<void> guardarSesion() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final ahora = DateTime.now();

      await FirebaseFirestore.instance.collection("running_sessions").add({
        "uid": user.uid,
        "fecha": "${ahora.day}/${ahora.month}/${ahora.year}",
        "hora": "${ahora.hour.toString().padLeft(2, '0')}:"
            "${ahora.minute.toString().padLeft(2, '0')}",
        "tiempoSegundos": segundos,
        "tiempoTexto": formatearTiempo(),
        "distanciaKm": distanciaKm,
        "calorias": calorias,
        "ritmo": _velocidadKmH(),
        "creado": Timestamp.now(),
      });
    } catch (e) {
      debugPrint("Error al guardar sesión de running: $e");
    }
  }

  double _velocidadKmH() {
    if (segundos == 0) return 0;
    return distanciaKm / (segundos / 3600);
  }

  String formatearTiempo() {
    final horas = (segundos ~/ 3600).toString().padLeft(2, '0');
    final minutos = ((segundos % 3600) ~/ 60).toString().padLeft(2, '0');
    final seg = (segundos % 60).toString().padLeft(2, '0');
    return "$horas:$minutos:$seg";
  }

  Widget _cardInfo({
    required String titulo,
    required String valor,
    required IconData icono,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.12),
            ),
            child: Icon(icono, color: color, size: 16),
          ),
          const SizedBox(height: 8),
          Text(
            valor,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            titulo,
            style: const TextStyle(
              color: AppColors.textSubtle,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _onNavTap(int index) {
    if (index == currentIndex) return;
    setState(() => currentIndex = index);

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ChatbotScreen()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProfileScreen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SettingsScreen()),
        );
        break;
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    posicionStream?.cancel();
    super.dispose();
  }

  String _textoEstado() {
    switch (estado) {
      case _EstadoCarrera.enCurso:
        return "EN CURSO";
      case _EstadoCarrera.pausada:
        return "EN PAUSA";
      case _EstadoCarrera.detenida:
        return "LISTO PARA EMPEZAR";
    }
  }

  Color _colorEstado() {
    switch (estado) {
      case _EstadoCarrera.enCurso:
        return AppColors.success;
      case _EstadoCarrera.pausada:
        return AppColors.warning;
      case _EstadoCarrera.detenida:
        return AppColors.textSubtle;
    }
  }

  // --- Construye los botones según el estado actual ---
  Widget _botonesAccion() {
    if (detenida) {
      return SizedBox(
        width: double.infinity,
        height: 58,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          ),
          onPressed: iniciarCarrera,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.play_arrow_rounded, color: AppColors.textPrimary),
              SizedBox(width: 8),
              Text(
                "INICIAR",
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // En curso o en pausa: dos botones, Pausar/Reanudar + Detener
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 58,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: pausada ? AppColors.accent : AppColors.warning,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              ),
              onPressed: pausada ? reanudarCarrera : pausarCarrera,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    pausada ? Icons.play_arrow_rounded : Icons.pause_rounded,
                    color: AppColors.textPrimary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    pausada ? "REANUDAR" : "PAUSAR",
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            height: 58,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              ),
              onPressed: detenerCarrera,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.stop_rounded, color: AppColors.textPrimary),
                  SizedBox(width: 6),
                  Text(
                    "DETENER",
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Running",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: "Historial",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RunningHistoryScreen()),
              );
            },
            icon: const Icon(Icons.history_rounded),
          ),
        ],
      ),

      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.bgSecondary,
          border: Border(top: BorderSide(color: AppColors.divider, width: 0.8)),
        ),
        child: SafeArea(
          top: false,
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            backgroundColor: Colors.transparent,
            selectedItemColor: AppColors.accentLight,
            unselectedItemColor: AppColors.textSubtle50,
            selectedFontSize: 11,
            unselectedFontSize: 11,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            onTap: _onNavTap,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.insights_rounded), label: "Progreso"),
              BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_rounded), label: "Chat IA"),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
              BottomNavigationBarItem(icon: Icon(Icons.tune_rounded), label: "Config"),
            ],
          ),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
          child: Column(
            children: [
              // --- TARJETA DE TIEMPO ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.accent.withOpacity(0.18),
                      AppColors.steel.withOpacity(0.06),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(color: AppColors.accent.withOpacity(0.15)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _colorEstado(),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _textoEstado(),
                          style: const TextStyle(
                            color: AppColors.textSubtle,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      formatearTiempo(),
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // --- GRID DE MÉTRICAS ---
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.05, // más alto -> sin overflow
                  children: [
                    _cardInfo(
                      titulo: "Distancia",
                      valor: "${distanciaKm.toStringAsFixed(2)} km",
                      icono: Icons.route_rounded,
                      color: AppColors.accent,
                    ),
                    _cardInfo(
                      titulo: "Calorías",
                      valor: calorias.toStringAsFixed(0),
                      icono: Icons.local_fire_department_rounded,
                      color: AppColors.warning,
                    ),
                    _cardInfo(
                      titulo: "Velocidad",
                      valor: "${_velocidadKmH().toStringAsFixed(1)} km/h",
                      icono: Icons.speed_rounded,
                      color: AppColors.success,
                    ),
                    _cardInfo(
                      titulo: "GPS",
                      valor: running ? "Activo" : (pausada ? "Pausado" : "Inactivo"),
                      icono: Icons.location_on_rounded,
                      color: AppColors.accentLight,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // --- BOTONES DE ACCIÓN ---
              _botonesAccion(),
            ],
          ),
        ),
      ),
    );
  }
}