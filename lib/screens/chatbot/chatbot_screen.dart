// lib/screens/chatbot_screen.dart
import 'package:flutter/material.dart';
import '../../app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String text;
  final bool esUsuario;
  final DateTime hora;
  ChatMessage({
    required this.text,
    required this.esUsuario,
    required this.hora,
  });
}

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen>
    with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _mensajes = [];
  late AnimationController _typingAnimController;

  bool _enviando = false;
  String apodo = "Usuario";
  Map<String, List<String>> _diccionario = {};

  // ── Paleta de colores consistente con el entorno ──────────────────────────
  // AppColors.bgPrimary → usa AppColors.bgPrimary directamente
  // AppColors.bgSecondary → usa AppColors.bgSecondary directamente
  // AppColors.bgBubble → usa AppColors.bgBubble directamente
  // AppColors.accent → usa AppColors.accent directamente
  // AppColors.accentGlow → usa AppColors.accentGlow directamente
  // AppColors.bgBubble → usa AppColors.bgBubble directamente // navy oscuro (sin morado)
  // AppColors.accent → usa AppColors.accent directamente // borde cyan
  // ──────────────────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _typingAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
    _inicializar();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _typingAnimController.dispose();
    super.dispose();
  }

  // ── Inicialización ────────────────────────────────────────────────────────

  Future<void> _inicializar() async {
    await Future.wait([_cargarApodo(), _cargarDiccionario()]);
    _mensajeInicial();
  }

  Future<void> _cargarApodo() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;
      final doc = await FirebaseFirestore.instance
          .collection("usuarios")
          .doc(uid)
          .get();
      if (doc.exists) {
        final d = doc.data()!;
        apodo = (d["apodo"] ?? d["nombre"] ?? "Usuario").toString();
      }
    } catch (_) {}
  }

  Future<void> _cargarDiccionario() async {
    try {
      final snap =
      await FirebaseFirestore.instance.collection("chat_dictionary").get();
      for (final doc in snap.docs) {
        _diccionario[doc.id] =
        List<String>.from(doc.data()["keywords"] ?? []);
      }
    } catch (e) {
      debugPrint("Error diccionario: $e");
    }
  }

  void _mensajeInicial() {
    _agregar(
      "Saludos $apodo 👋\n\nSoy EvoYou, tu asistente personal.\n\n¿En qué puedo ayudarte?",
      false,
    );
  }

  // ── Lógica de mensajes ───────────────────────────────────────────────────

  void _agregar(String texto, bool esUsuario) {
    setState(() {
      _mensajes.add(
        ChatMessage(text: texto, esUsuario: esUsuario, hora: DateTime.now()),
      );
    });
  }

  String? _detectarCategoria(String texto) {
    final t = texto.toLowerCase();
    for (final entry in _diccionario.entries) {
      for (final kw in entry.value) {
        if (t.contains(kw)) return entry.key;
      }
    }
    return null;
  }

  String _responder(String categoria) {
    switch (categoria) {
      case "saludo":
        return "¡Hola de nuevo $apodo! 😊 ¿En qué puedo ayudarte hoy?";

      case "ayuda":
        return "Estoy aquí para acompañarte en tu proceso.\n\n"
            "Pronto tendrás acceso a rutinas, alimentación y seguimiento de progreso.\n\n"
            "¿Hay algo más en lo que pueda orientarte?";

      case "entrenamiento":
        return "La sección de rutinas y entrenamientos está en desarrollo.\n\n"
            "Muy pronto podrás acceder a planes personalizados según tu nivel y objetivo.\n\n"
            "¡Estamos trabajando duro para ti, $apodo! 💪";

      case "nutricion":
        return "La sección de nutrición y alimentación está próximamente disponible.\n\n"
            "Podrás ver planes de comida adaptados a tus metas.\n\n"
            "¡Pronto, $apodo! 🥗";

      case "running":
        return "Los planes de running y cardio estarán disponibles muy pronto.\n\n"
            "¡Sigue pendiente, $apodo! 🏃";

      case "progreso":
        return "El seguimiento de tu progreso estará disponible próximamente.\n\n"
            "Podrás registrar peso, medidas y ver tu evolución.\n\n"
            "¡Lo estamos preparando para ti! 📊";

      case "objetivo":
        return "Me alegra que tengas clara tu meta.\n\n"
            "Muy pronto tendrás herramientas dentro de la app para trabajar en ella.\n\n"
            "¿Hay algo más en lo que pueda ayudarte hoy?";

      default:
        return "Entiendo, $apodo. Estamos trabajando para ofrecerte la mejor experiencia.\n\n"
            "¿Hay algo más en lo que pueda orientarte?";
    }
  }

  Future<void> _enviarMensaje() async {
    final texto = _controller.text.trim();
    if (texto.isEmpty || _enviando) return;
    _controller.clear();

    _agregar(texto, true);
    setState(() => _enviando = true);
    _scrollAbajo();

    await Future.delayed(const Duration(milliseconds: 900));

    final categoria = _detectarCategoria(texto) ?? "default";
    _agregar(_responder(categoria), false);

    setState(() => _enviando = false);
    _scrollAbajo();
  }

  void _scrollAbajo() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ── Helpers de UI ─────────────────────────────────────────────────────────

  String _horaTexto(DateTime h) =>
      "${h.hour.toString().padLeft(2, '0')}:${h.minute.toString().padLeft(2, '0')}";

  // Avatar circular con paleta navy + borde cyan (sin morado)
  Widget _avatarEvoYou({double size = 40}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.bgBubble,
        border: Border.all(color: AppColors.accent, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withOpacity(0.25),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/imagenes/avatar/chat.png',
          fit: BoxFit.cover,
          // Si la imagen falla, muestra ícono genérico acorde a la paleta
          errorBuilder: (_, __, ___) => Icon(
            Icons.smart_toy_rounded,
            color: AppColors.accent,
            size: size * 0.55,
          ),
        ),
      ),
    );
  }

  // Indicador de "escribiendo…" con 3 puntos animados
  Widget _indicadorEscribiendo() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Row(
        children: [
          _avatarEvoYou(size: 28),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.bgBubble,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
              ),
            ),
            child: AnimatedBuilder(
              animation: _typingAnimController,
              builder: (_, __) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (i) {
                    final offset = ((_typingAnimController.value * 3) - i).clamp(0.0, 1.0);
                    final bounce = (offset < 0.5 ? offset : 1.0 - offset) * 2;
                    return Transform.translate(
                      offset: Offset(0, -4 * bounce),
                      child: Container(
                        width: 7,
                        height: 7,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.6 + 0.4 * bounce),
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

  // Burbuja de mensaje
  Widget _burbuja(ChatMessage msg) {
    final esUsuario = msg.esUsuario;
    return Align(
      alignment: esUsuario ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Avatar EvoYou al lado izquierdo de su burbuja
            if (!esUsuario) ...[
              _avatarEvoYou(size: 28),
              const SizedBox(width: 6),
            ],
            Flexible(
              child: Column(
                crossAxisAlignment: esUsuario
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: esUsuario
                          ? const LinearGradient(
                        colors: [AppColors.accentGlow, AppColors.steel],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                          : null,
                      color: esUsuario ? null : AppColors.bgBubble,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(18),
                        topRight: const Radius.circular(18),
                        bottomLeft: Radius.circular(esUsuario ? 18 : 4),
                        bottomRight: Radius.circular(esUsuario ? 4 : 18),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: esUsuario
                              ? AppColors.accent.withOpacity(0.15)
                              : Colors.black.withOpacity(0.2),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      msg.text,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        height: 1.45,
                        fontSize: 14.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      _horaTexto(msg.hora),
                      style: const TextStyle(
                        color: AppColors.textSubtle50,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Espaciado derecho si es EvoYou (para simetría)
            if (!esUsuario) const SizedBox(width: 2),
          ],
        ),
      ),
    );
  }

  // Campo de texto + botón enviar
  Widget _inputBar() {
    return Container(
      padding: EdgeInsets.only(
        left: 12,
        right: 12,
        top: 10,
        // Respeta la barra de navegación del sistema Android
        bottom: MediaQuery.of(context).padding.bottom + 10,
      ),
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        border: Border(
          top: BorderSide(color: AppColors.accent.withOpacity(0.15), width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 14.5),
              maxLines: null,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _enviarMensaje(),
              decoration: InputDecoration(
                hintText: "Escribe tu mensaje...",
                hintStyle: const TextStyle(color: AppColors.textSubtle50, fontSize: 14),
                filled: true,
                fillColor: AppColors.textPrimary.withOpacity(0.06),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18, vertical: 11),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(26),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(26),
                  borderSide:
                  BorderSide(color: AppColors.accent.withOpacity(0.5), width: 1),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Botón enviar con gradiente cyan
          GestureDetector(
            onTap: _enviarMensaje,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppColors.accent, AppColors.steel],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withOpacity(0.35),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: const Icon(Icons.send_rounded, color: AppColors.textPrimary, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppColors.bgSecondary,
        elevation: 0,
        shadowColor: Colors.transparent,
        // Línea inferior sutil cyan
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: AppColors.accent.withOpacity(0.18),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textMuted, size: 18),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            _avatarEvoYou(size: 42),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "EvoYou",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: AppColors.textPrimary,
                    letterSpacing: 0.4,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      "En línea",
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSubtle,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert_rounded,
                color: AppColors.textSubtle, size: 22),
            onPressed: () {},
          ),
        ],
      ),
      // SafeArea garantiza que el contenido no quede debajo de la barra del sistema
      body: SafeArea(
        bottom: false, // el _inputBar maneja el padding inferior manualmente
        child: Column(
          children: [
            // Lista de mensajes
            Expanded(
              child: _mensajes.isEmpty
                  ? const Center(
                child: CircularProgressIndicator(
                  color: AppColors.accent,
                  strokeWidth: 2,
                ),
              )
                  : ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(vertical: 12),
                itemCount: _mensajes.length,
                itemBuilder: (_, i) => _burbuja(_mensajes[i]),
              ),
            ),

            // Indicador "escribiendo..."
            if (_enviando) _indicadorEscribiendo(),

            // Barra de input
            _inputBar(),
          ],
        ),
      ),
    );
  }
}