import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../home/home_screen.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final ScrollController scrollController = ScrollController();
  final TextEditingController apodoManualController = TextEditingController();

  String nombre = "";
  String apellido = "";
  String correo = "";
  String fotoPerfil = "";

  int paso = 0;
  bool loading = false;
  bool escribiendoApodo = false;

  String apodo = "";
  String altura = "";
  String peso = "";
  String objetivo = "";
  String experiencia = "";
  String frecuencia = "";
  String lugarEntrenamiento = "";
  String tiempoEntrenamiento = "";
  String lesion = "";

  final List<Map<String, String>> mensajes = [];

  @override
  void initState() {
    super.initState();
    cargarUsuario();
  }

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
      nombre = data["nombre"] ?? "";
      apellido = data["apellido"] ?? "";
      correo = data["correo"] ?? user.email ?? "";
      apodo = data["apodo"] ?? "";
      fotoPerfil = data["fotoPerfil"] ?? "";
      altura = data["altura"] ?? "";
      peso = data["peso"] ?? "";
      objetivo = data["objetivo"] ?? "";
      experiencia = data["experiencia"] ?? "";
      frecuencia = data["frecuencia"] ?? "";
      lugarEntrenamiento = data["lugarEntrenamiento"] ?? "";
      tiempoEntrenamiento = data["tiempoEntrenamiento"] ?? "";
      lesion = data["lesion"] ?? "";
    });

    agregarMensajeEvo(
      "Hola ${nombre.isNotEmpty ? nombre : "campeón"} 👋\n\nSoy Evo, tu coach personal.\nVoy a conocerte un poco mejor para preparar tu plan personalizado.",
    );
  }

  String get nombreMostrar {
    if (apodo.trim().isNotEmpty) return apodo.trim();
    if (nombre.trim().isNotEmpty) return nombre.trim();
    return "campeón";
  }

  void agregarMensajeEvo(String texto) {
    mensajes.add({
      "tipo": "evo",
      "texto": texto,
    });

    moverScroll();
  }

  void agregarMensajeUsuario(String texto) {
    mensajes.add({
      "tipo": "usuario",
      "texto": texto,
    });

    moverScroll();
  }

  void moverScroll() {
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

  String limpiarEmoji(String texto) {
    return texto
        .replaceAll("🔥", "")
        .replaceAll("💪", "")
        .replaceAll("⚖️", "")
        .replaceAll("🏃", "")
        .replaceAll("🏠", "")
        .replaceAll("🏋️", "")
        .replaceAll("🔄", "")
        .trim();
  }

  void avanzar(String respuesta) {
    agregarMensajeUsuario(respuesta);

    setState(() {
      switch (paso) {
        case 0:
          apodo = respuesta;
          paso++;
          agregarMensajeEvo(
            "Perfecto $nombreMostrar 💪\n\n¿Cuál es tu altura?",
          );
          break;

        case 1:
          altura = respuesta.replaceAll(" cm", "");
          paso++;
          agregarMensajeEvo(
            "Bien.\n\n¿Cuál es tu peso actual?",
          );
          break;

        case 2:
          peso = respuesta.replaceAll(" kg", "");
          paso++;
          agregarMensajeEvo(
            "Excelente.\n\n¿Cuál es tu objetivo principal?",
          );
          break;

        case 3:
          objetivo = limpiarEmoji(respuesta);
          paso++;
          agregarMensajeEvo(
            "Buen objetivo, $nombreMostrar.\n\n¿Cuál es tu nivel de experiencia?",
          );
          break;

        case 4:
          experiencia = respuesta;
          paso++;
          agregarMensajeEvo(
            "Perfecto.\n\n¿Cuántos días por semana puedes entrenar?",
          );
          break;

        case 5:
          frecuencia = respuesta;
          paso++;
          agregarMensajeEvo(
            "Ahora dime...\n\n¿Dónde entrenarás principalmente?",
          );
          break;

        case 6:
          lugarEntrenamiento = limpiarEmoji(respuesta);
          paso++;
          agregarMensajeEvo(
            "Entendido.\n\n¿Cuánto dura normalmente tu entrenamiento?",
          );
          break;

        case 7:
          tiempoEntrenamiento = respuesta;
          paso++;
          agregarMensajeEvo(
            "Última pregunta, $nombreMostrar.\n\n¿Tienes alguna lesión o limitación física?",
          );
          break;

        case 8:
          lesion = respuesta;
          paso++;
          agregarMensajeEvo(
            "Excelente $nombreMostrar 💪\n\nNuestro programa se basa en planes de transformación de 3, 6, 9 y 12 meses.\n\nDesde los primeros 3 meses podrás comenzar a notar cambios si sigues nuestras indicaciones de entrenamiento, alimentación y seguimiento.\n\nTodo dependerá de tu constancia y de que trabajemos juntos en el plan.\n\nAhora pasaremos a estimar tu porcentaje de grasa corporal para personalizar mejor tu proceso.",
          );
          break;
      }
    });
  }

  List<String> opcionesActuales() {
    switch (paso) {
      case 0:
        return [
          if (nombre.isNotEmpty) nombre,
          if (nombre.isNotEmpty) nombre.split(" ").first,
          "Prefiero escribirlo",
        ];

      case 1:
        return [
          "160 cm",
          "165 cm",
          "170 cm",
          "175 cm",
          "180 cm",
          "185 cm",
          "190 cm",
        ];

      case 2:
        return [
          "60 kg",
          "65 kg",
          "70 kg",
          "75 kg",
          "80 kg",
          "85 kg",
          "90 kg",
          "95 kg",
          "100 kg",
          "110 kg",
          "120 kg",
        ];

      case 3:
        return [
          "🔥 Perder peso",
          "💪 Ganar músculo",
          "⚖️ Recomposición corporal",
          "🏃 Mejorar condición física",
        ];

      case 4:
        return [
          "Principiante",
          "Intermedio",
          "Avanzado",
        ];

      case 5:
        return [
          "2-3 días",
          "3-4 días",
          "4-5 días",
          "6+ días",
        ];

      case 6:
        return [
          "🏠 Casa",
          "🏋️ Gimnasio",
          "🔄 Híbrido",
        ];

      case 7:
        return [
          "30 minutos",
          "45 minutos",
          "60 minutos",
          "90+ minutos",
        ];

      case 8:
        return [
          "Ninguna",
          "Rodilla",
          "Espalda",
          "Hombro",
          "Otra",
        ];

      default:
        return [];
    }
  }

  Future<void> guardarPerfil() async {
    try {
      setState(() {
        loading = true;
      });

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
        "altura": altura,
        "peso": peso,
        "objetivo": objetivo,
        "experiencia": experiencia,
        "frecuencia": frecuencia,
        "lugarEntrenamiento": lugarEntrenamiento,
        "tiempoEntrenamiento": tiempoEntrenamiento,
        "lesion": lesion,
        "fotoPerfil": fotoPerfil,
        "perfilCompleto": true,
        "creado": DateTime.now(),
      });

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(e.toString()),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  void guardarApodoManual() {
    final texto = apodoManualController.text.trim();

    if (texto.isEmpty) return;

    setState(() {
      escribiendoApodo = false;
    });

    avanzar(texto);
  }

  @override
  Widget build(BuildContext context) {
    final opciones = opcionesActuales();

    return Scaffold(
      backgroundColor: const Color(0xFF071120),
      body: SafeArea(
        child: Column(
          children: [
            _header(),

            Expanded(
              child: ListView.builder(
                controller: scrollController,
                padding: const EdgeInsets.all(18),
                itemCount: mensajes.length,
                itemBuilder: (context, index) {
                  final mensaje = mensajes[index];

                  if (mensaje["tipo"] == "usuario") {
                    return _burbujaUsuario(mensaje["texto"]!);
                  }

                  return _burbujaEvo(mensaje["texto"]!);
                },
              ),
            ),

            if (paso <= 8) _opciones(opciones),

            if (paso > 8) _botonFinal(),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 14,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF0B1628),
        border: Border(
          bottom: BorderSide(
            color: Colors.white10,
          ),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white,
            backgroundImage: const AssetImage(
              "assets/imagenes/avatar/chat.png",
            ),
            onBackgroundImageError: (_, __) {},
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Evo",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Coach personal EvoYou AI",
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: Colors.cyan.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "${paso > 8 ? 100 : ((paso + 1) / 9 * 100).round()}%",
              style: const TextStyle(
                color: Colors.cyan,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _burbujaEvo(String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white,
            backgroundImage: const AssetImage(
              "assets/imagenes/avatar/chat.png",
            ),
            onBackgroundImageError: (_, __) {},
          ),

          const SizedBox(width: 10),

          Flexible(
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: const BoxDecoration(
                color: Color(0xFF111C30),
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
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.35,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _burbujaUsuario(String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          padding: const EdgeInsets.all(15),
          constraints: const BoxConstraints(
            maxWidth: 280,
          ),
          decoration: const BoxDecoration(
            color: Color(0xFF00CFFF),
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
              color: Color(0xFF04111F),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _opciones(List<String> opciones) {
    if (escribiendoApodo) {
      return _inputApodo();
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
      decoration: const BoxDecoration(
        color: Color(0xFF071120),
        border: Border(
          top: BorderSide(
            color: Colors.white10,
          ),
        ),
      ),
      child: Column(
        children: opciones.map((opcion) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  if (opcion == "Prefiero escribirlo") {
                    setState(() {
                      escribiendoApodo = true;
                    });
                  } else {
                    avanzar(opcion);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF111C30),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: const BorderSide(
                      color: Colors.cyan,
                      width: 1,
                    ),
                  ),
                ),
                child: Text(
                  opcion,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _inputApodo() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
      decoration: const BoxDecoration(
        color: Color(0xFF071120),
        border: Border(
          top: BorderSide(
            color: Colors.white10,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: apodoManualController,
              style: const TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: "Escribe tu apodo",
                hintStyle: const TextStyle(
                  color: Colors.white54,
                ),
                filled: true,
                fillColor: const Color(0xFF111C30),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.cyan,
            child: IconButton(
              onPressed: guardarApodoManual,
              icon: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _botonFinal() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: const BoxDecoration(
        color: Color(0xFF071120),
        border: Border(
          top: BorderSide(
            color: Colors.white10,
          ),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 58,
        child: ElevatedButton(
          onPressed: loading ? null : guardarPerfil,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.cyan,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: loading
              ? const CircularProgressIndicator(
            color: Colors.white,
          )
              : const Text(
            "Continuar con evaluación física",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}