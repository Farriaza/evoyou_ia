// lib/screens/complete_profile_screen.dart
import 'package:flutter/material.dart';
import '../../app_theme.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../home/home_screen.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen>
    with TickerProviderStateMixin {

  // ── Paleta de Colores ──────────────────────────────────────────────────────
  // AppColors.bgPrimary → AppColors.bgPrimary
  // AppColors.bgCard → AppColors.bgCard
  // AppColors.bgBubble → AppColors.bgBubble
  // AppColors.accent → AppColors.accent
  // AppColors.bgBubble → AppColors.bgBubble
  // AppColors.accent → AppColors.accent
  // ──────────────────────────────────────────────────────────────────────────

  final ScrollController scrollController = ScrollController();
  final TextEditingController chatInputController = TextEditingController();

  late AnimationController _typingCtrl;
  bool _mostrarTyping = false;

  String nombre              = "";
  String apellido            = "";
  String apodo               = "";
  String correo              = "";
  String fotoPerfil          = "";

  int paso                   = 0;
  bool loading               = false;

  String lugarEntrenamiento  = "";
  String frecuencia          = "";
  String tiempoEntrenamiento = "";
  String experiencia         = "";
  String objetivo            = "";
  String lesion              = "";
  String altura              = "";
  String peso                = "";

  final List<Map<String, String>> mensajes = [];

  @override
  void initState() {
    super.initState();
    _typingCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
    cargarUsuario();
  }

  @override
  void dispose() {
    scrollController.dispose();
    chatInputController.dispose();
    _typingCtrl.dispose();
    super.dispose();
  }

  // ── Datos Firebase ────────────────────────────────────────────────────────

  Future<void> cargarUsuario() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc = await FirebaseFirestore.instance
        .collection("usuarios")
        .doc(user.uid)
        .get();

    final data = doc.data();
    if (data == null) return;

    setState(() {
      nombre              = data["nombre"]            ?? "";
      apellido            = data["apellido"]          ?? "";
      apodo               = data["apodo"]             ?? "";
      correo              = data["correo"]            ?? user.email ?? "";
      fotoPerfil          = data["fotoPerfil"]        ?? "";
    });

    _mostrarMensajeConDelay(
      "Hola, $nombreMostrar. Soy Evo, tu asistente virtual de entrenamiento. "
          "Te guiare paso a paso para configurar tu perfil de manera correcta.\n\n"
          "Primero, ¿donde vas a entrenar principalmente?",
    );
  }

  // ── Helpers de UI ─────────────────────────────────────────────────────────

  String get nombreMostrar {
    if (apodo.trim().isNotEmpty) return apodo.trim();
    if (nombre.trim().isNotEmpty) return nombre.trim();
    return "usuario";
  }

  void _scrollAbajo() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _mostrarMensajeConDelay(String texto, {int delayMs = 1000}) async {
    setState(() {
      _mostrarTyping = true;
    });
    _scrollAbajo();

    await Future.delayed(Duration(milliseconds: delayMs));

    if (!mounted) return;
    setState(() {
      _mostrarTyping = false;
      mensajes.add({"tipo": "evo", "texto": texto});
    });
    _scrollAbajo();
  }

  void agregarMensajeUsuario(String texto) {
    setState(() {
      mensajes.add({"tipo": "usuario", "texto": texto});
    });
    _scrollAbajo();
  }

  // ── Flujo de Preguntas y Respuestas Ordenadas ─────────────────────────────

  void avanzarFlujo(String respuesta) {
    if (respuesta.trim().isEmpty) return;
    agregarMensajeUsuario(respuesta);

    setState(() {
      switch (paso) {
        case 0:
          lugarEntrenamiento = respuesta;
          paso++;
          _mostrarMensajeConDelay("Entendido. ¿Cuantos dias a la semana tienes disponibles para entrenar? Escribe solo el numero.");
          break;

        case 1:
          frecuencia = respuesta;
          paso++;
          _mostrarMensajeConDelay("Perfecto. ¿Cuanto tiempo suele durar tu sesion de entrenamiento?");
          break;

        case 2:
          tiempoEntrenamiento = respuesta;
          paso++;
          _mostrarMensajeConDelay("Bien. ¿Cual es tu nivel de experiencia actual en el entrenamiento?");
          break;

        case 3:
          experiencia = respuesta;
          paso++;
          _mostrarMensajeConDelay("Anotado. ¿Cual es tu objetivo principal en este momento?");
          break;

        case 4:
          objetivo = respuesta;
          paso++;
          _mostrarMensajeConDelay("Excelente. ¿Tienes alguna lesion o limitacion fisica que deba considerar?");
          break;

        case 5:
          lesion = respuesta;
          paso++;
          _mostrarMensajeConDelay("De acuerdo, lo tomare en cuenta. Ahora pasemos a tus datos basicos. ¿Cual es tu altura en centimetros (cm)? Escribe solo el numero.");
          break;

        case 6:
          altura = respuesta;
          paso++;
          _mostrarMensajeConDelay("Por ultimo, ¿cual es tu peso actual en kilogramos (kg)? Escribe solo el numero.");
          break;

        case 7:
          peso = respuesta;
          paso++;
          _mostrarMensajeConDelay(
            "Perfil completado con exito, $nombreMostrar. Aqui tienes el resumen de tu configuracion:\n\n"
                "• Lugar: $lugarEntrenamiento\n"
                "• Frecuencia: $frecuencia dias por semana\n"
                "• Duracion: $tiempoEntrenamiento\n"
                "• Experiencia: $experiencia\n"
                "• Objetivo: $objetivo\n"
                "• Lesiones: $lesion\n"
                "• Altura: $altura cm\n"
                "• Peso registrado: $peso kg\n\n"
                "Presiona el boton de abajo para guardar tu perfil de entrenamiento y comenzar.",
            delayMs: 1200,
          );
          break;
      }
    });
  }

  // Determina si el paso actual requiere alternativas o teclado de texto libre
  bool _esPasoDeAlternativas() {
    return paso == 0 || paso == 2 || paso == 3 || paso == 4 || paso == 5;
  }

  List<String> _obtenerAlternativas() {
    switch (paso) {
      case 0: return ["Gimnasio", "En Casa", "Hibrido"];
      case 2: return ["30 a 45 minutos", "1 hora", "Mas de 1 hora"];
      case 3: return ["Principiante", "Intermedio", "Avanzado"];
      case 4: return ["Perder peso", "Ganar musculo", "Mantener la forma"];
      case 5: return ["Ninguna", "Hombros", "Espalda", "Rodillas", "Otra"];
      default: return [];
    }
  }

  TextInputType _obtenerTipoTeclado() {
    if (paso == 1 || paso == 6 || paso == 7) {
      return TextInputType.number;
    }
    return TextInputType.text;
  }

  List<TextInputFormatter>? _obtenerFiltrosTeclado() {
    if (paso == 1 || paso == 6) {
      return [FilteringTextInputFormatter.digitsOnly];
    }
    if (paso == 7) {
      return [FilteringTextInputFormatter.allow(RegExp(r'^\d[\d.]*'))];
    }
    return null;
  }

  String _obtenerHintTexto() {
    switch (paso) {
      case 1: return "Ejemplo: 4";
      case 6: return "Ejemplo: 175";
      case 7: return "Ejemplo: 70.5";
      default: return "Escribe aqui...";
    }
  }

  // ── Guardar Datos Directamente en Firebase ─────────────────────────────────

  Future<void> guardarPerfil() async {
    try {
      setState(() => loading = true);
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      await FirebaseFirestore.instance
          .collection("usuarios")
          .doc(user.uid)
          .update({
        "nombre": nombre,
        "apellido": apellido,
        "apodo": apodo,
        "correo": user.email,
        "lugarEntrenamiento": lugarEntrenamiento,
        "frecuencia": frecuencia,
        "tiempoEntrenamiento": tiempoEntrenamiento,
        "experiencia": experiencia,
        "objetivo": objetivo,
        "lesion": lesion,
        "altura": altura,
        "peso": peso,
        "pesoInicial": peso,
        "fotoPerfil": fotoPerfil,
        "perfilCompleto": true,
        "creado": DateTime.now(),
      });

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: AppColors.error, content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  // ── Componentes de Interfaz (Widgets) ──────────────────────────────────────

  Widget _avatarEvo({double radius = 26}) {
    final size = radius * 2;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.bgBubble,
        border: Border.all(color: AppColors.accent, width: 2),
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/imagenes/avatar/chat.png',
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Icon(
            Icons.smart_toy_rounded,
            color: AppColors.accent,
            size: size * 0.55,
          ),
        ),
      ),
    );
  }

  Widget _burbujaTyping() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18, left: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _avatarEvo(radius: 20),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: AppColors.bgBubble,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(18),
                bottomRight: Radius.circular(18),
              ),
            ),
            child: AnimatedBuilder(
              animation: _typingCtrl,
              builder: (_, __) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (i) {
                    final v = ((_typingCtrl.value * 3) - i).clamp(0.0, 1.0);
                    final bounce = (v < 0.5 ? v : 1.0 - v) * 2;
                    return Transform.translate(
                      offset: Offset(0, -5 * bounce),
                      child: Container(
                        width: 7,
                        height: 7,
                        margin: const EdgeInsets.symmetric(horizontal: 2.5),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.55 + 0.45 * bounce),
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _burbujaEvo(String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18, left: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _avatarEvo(radius: 20),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
              decoration: const BoxDecoration(
                color: AppColors.bgBubble,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
              ),
              child: Text(
                texto,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15.5,
                  height: 1.45,
                ),
              ),
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _burbujaUsuario(String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18, right: 4),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.72,
          ),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.accent, AppColors.steel],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(4),
              bottomLeft: Radius.circular(18),
              bottomRight: Radius.circular(18),
            ),
          ),
          child: Text(
            texto,
            style: const TextStyle(
              color: AppColors.bgBubble,
              fontSize: 15.5,
              fontWeight: FontWeight.w600,
              height: 1.35,
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    final progreso = paso > 8 ? 1.0 : (paso + 1) / 9;
    final porcentaje = (progreso * 100).round();

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        border: Border(
          bottom: BorderSide(color: AppColors.accent.withOpacity(0.15), width: 1),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _avatarEvo(radius: 26),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Evo",
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.3,
                      ),
                    ),
                    Text(
                      "Asistente de Perfil",
                      style: TextStyle(color: AppColors.textSubtle, fontSize: 12.5),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.accent.withOpacity(0.3), width: 1),
                ),
                child: Text(
                  "$porcentaje%",
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progreso,
              backgroundColor: AppColors.divider40,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
              minHeight: 4,
            ),
          ),
          const SizedBox(height: 14),
        ],
      ),
    );
  }

  // Panel inferior dinámico para preguntas de alternativas (A prueba de tontos)
  Widget _selectorAlternativas(List<String> opciones) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 14,
      ),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        border: Border(top: BorderSide(color: AppColors.accent.withOpacity(0.15), width: 1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: opciones.map((opcion) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () => avanzarFlujo(opcion),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.bgBubble,
                  foregroundColor: AppColors.textPrimary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: AppColors.accent.withOpacity(0.3), width: 1),
                  ),
                ),
                child: Text(
                  opcion,
                  style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // Input de barra de chat tradicional para pasos numéricos
  Widget _chatInputBar() {
    return Container(
      padding: EdgeInsets.only(
        left: 12,
        right: 12,
        top: 10,
        bottom: MediaQuery.of(context).padding.bottom + 10,
      ),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        border: Border(top: BorderSide(color: AppColors.accent.withOpacity(0.15), width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              key: ValueKey("paso_$paso"),
              controller: chatInputController,
              keyboardType: _obtenerTipoTeclado(),
              inputFormatters: _obtenerFiltrosTeclado(),
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
              textInputAction: TextInputAction.send,
              onSubmitted: (_) {
                final t = chatInputController.text.trim();
                chatInputController.clear();
                avanzarFlujo(t);
              },
              decoration: InputDecoration(
                hintText: _obtenerHintTexto(),
                hintStyle: const TextStyle(color: AppColors.textSubtle50, fontSize: 14.5),
                filled: true,
                fillColor: AppColors.textPrimary.withOpacity(0.06),
                contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide(color: AppColors.accent.withOpacity(0.5), width: 1),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              final t = chatInputController.text.trim();
              chatInputController.clear();
              avanzarFlujo(t);
            },
            child: Container(
              width: 46,
              height: 46,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [AppColors.accent, AppColors.steel],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Icon(Icons.send_rounded, color: AppColors.textPrimary, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _botonFinal() {
    return Container(
      padding: EdgeInsets.only(
        left: 18,
        right: 18,
        top: 14,
        bottom: MediaQuery.of(context).padding.bottom + 14,
      ),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        border: Border(top: BorderSide(color: AppColors.accent.withOpacity(0.15), width: 1)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: loading ? null : guardarPerfil,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.accent,
            foregroundColor: AppColors.bgBubble,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          ),
          child: loading
              ? const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(color: AppColors.bgBubble, strokeWidth: 2.5),
          )
              : const Text(
            "Finalizar y Guardar Perfil",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.3),
          ),
        ),
      ),
    );
  }

  // ── Build principal ────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _header(),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(14, 16, 14, 8),
                itemCount: mensajes.length + (_mostrarTyping ? 1 : 0),
                itemBuilder: (context, index) {
                  if (_mostrarTyping && index == mensajes.length) {
                    return _burbujaTyping();
                  }
                  final msg = mensajes[index];
                  if (msg["tipo"] == "usuario") {
                    return _burbujaUsuario(msg["texto"]!);
                  }
                  return _burbujaEvo(msg["texto"]!);
                },
              ),
            ),

            // Control de acciones según el tipo de paso
            if (paso <= 7 && !_mostrarTyping)
              _esPasoDeAlternativas()
                  ? _selectorAlternativas(_obtenerAlternativas())
                  : _chatInputBar(),
            if (paso > 7) _botonFinal(),
          ],
        ),
      ),
    );
  }
}