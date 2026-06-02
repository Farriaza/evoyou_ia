// lib/screens/chatbot_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String text;
  final bool esUsuario;
  final DateTime hora;
  ChatMessage({required this.text, required this.esUsuario, required this.hora});
}

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});
  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _mensajes = [];

  bool _enviando = false;
  String apodo = "Usuario";
  Map<String, List<String>> _diccionario = {};

  @override
  void initState() {
    super.initState();
    _inicializar();
  }

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
      final snap = await FirebaseFirestore.instance
          .collection("chat_dictionary")
          .get();
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

  void _agregar(String texto, bool esUsuario) {
    setState(() {
      _mensajes.add(ChatMessage(
        text: texto,
        esUsuario: esUsuario,
        hora: DateTime.now(),
      ));
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
        return "Estoy aquí para acompañarte en tu proceso. "
            "Por ahora estamos trabajando en las funciones de la app. "
            "Pronto tendrás acceso a rutinas, alimentación y seguimiento de progreso. "
            "¿Hay algo más en lo que pueda orientarte?";

      case "entrenamiento":
        return "La sección de rutinas y entrenamientos está en desarrollo. "
            "Muy pronto podrás acceder a planes personalizados según tu nivel y objetivo. "
            "¡Estamos trabajando duro para ti, $apodo! 💪";

      case "nutricion":
        return "La sección de nutrición y alimentación está próximamente disponible. "
            "Podrás ver planes de comida adaptados a tus metas. "
            "¡Pronto, $apodo! 🥗";

      case "running":
        return "Los planes de running y cardio estarán disponibles muy pronto. "
            "¡Sigue pendiente, $apodo! 🏃";

      case "progreso":
        return "El seguimiento de tu progreso estará disponible próximamente. "
            "Podrás registrar peso, medidas y ver tu evolución. "
            "¡Lo estamos preparando para ti! 📊";

      case "objetivo":
        return "Me alegra que tengas clara tu meta. "
            "Muy pronto tendrás herramientas dentro de la app para trabajar en ella. "
            "¿Hay algo más en lo que pueda ayudarte hoy?";

      default:
        return "Entiendo, $apodo. Estamos trabajando para ofrecerte la mejor experiencia. "
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

    await Future.delayed(const Duration(milliseconds: 700));

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
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _horaTexto(DateTime h) =>
      "${h.hour.toString().padLeft(2, '0')}:${h.minute.toString().padLeft(2, '0')}";

  Widget _burbuja(ChatMessage msg) {
    final esUsuario = msg.esUsuario;
    return Align(
      alignment: esUsuario ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        constraints:
        BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        child: Column(
          crossAxisAlignment:
          esUsuario ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: esUsuario ? Colors.cyan : const Color(0xFF0D1A2D),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(esUsuario ? 18 : 4),
                  bottomRight: Radius.circular(esUsuario ? 4 : 18),
                ),
              ),
              child: Text(
                msg.text,
                style: const TextStyle(color: Colors.white, height: 1.4),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              _horaTexto(msg.hora),
              style: const TextStyle(color: Colors.white38, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF071120),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1A2D),
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage:
              AssetImage('assets/imagenes/avatar/chat.png'),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("EvoYou",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                          color: Colors.green, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 4),
                    const Text("En línea",
                        style: TextStyle(fontSize: 11)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemCount: _mensajes.length,
              itemBuilder: (_, i) => _burbuja(_mensajes[i]),
            ),
          ),
          if (_enviando)
            const Padding(
              padding: EdgeInsets.only(left: 16, bottom: 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "EvoYou está escribiendo...",
                  style: TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ),
            ),
          Container(
            padding: const EdgeInsets.all(10),
            color: const Color(0xFF0D1A2D),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _enviarMensaje(),
                    decoration: InputDecoration(
                      hintText: "Escribe tu mensaje...",
                      hintStyle:
                      const TextStyle(color: Colors.white38),
                      filled: true,
                      fillColor: Colors.white10,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Colors.cyan,
                  child: IconButton(
                    onPressed: _enviarMensaje,
                    icon: const Icon(Icons.send,
                        color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}