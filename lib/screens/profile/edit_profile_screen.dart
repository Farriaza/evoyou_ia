import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import '../../services/local_image_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final nombreController = TextEditingController();
  final apellidoController = TextEditingController();
  final apodoController = TextEditingController();
  final pesoController = TextEditingController();
  final alturaController = TextEditingController();

  String objetivo = "Perder peso";
  String experiencia = "Principiante";
  String frecuencia = "1-2 días";
  String fotoActual = ""; // ← guarda el path actual de Firestore
  File? imagen;
  bool imagenModificada = false;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final doc = await FirebaseFirestore.instance
          .collection("usuarios")
          .doc(uid)
          .get();
      final data = doc.data();

      if (data != null) {
        nombreController.text = data["nombre"] ?? "";
        apellidoController.text = data["apellido"] ?? "";
        apodoController.text = data["apodo"] ?? "";
        pesoController.text = data["peso"]?.toString() ?? "";
        alturaController.text = data["altura"]?.toString() ?? "";
        objetivo = data["objetivo"] ?? "Perder peso";
        experiencia = data["experiencia"] ?? "Principiante";
        frecuencia = data["frecuencia"] ?? "1-2 días";

        // Guardar el path actual para no perderlo si no se cambia la foto
        fotoActual = data["fotoPerfil"] ?? "";

        if (fotoActual.isNotEmpty) {
          final file = File(fotoActual);
          if (await file.exists()) imagen = file;
        }
      }

      if (!mounted) return;
      setState(() => loading = false);
    } catch (e) {
      print(e);
    }
  }

  Future<void> seleccionarImagen() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 40,
        maxWidth: 600,
      );
      if (picked == null) return;
      if (!mounted) return;
      setState(() {
        imagen = File(picked.path);
        imagenModificada = true; // ← marcar que el usuario eligió nueva foto
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> guardarPerfil() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      // FIX: solo guardar nueva foto si fue modificada, si no conservar fotoActual
      String fotoPath = fotoActual;

      if (imagenModificada && imagen != null) {
        fotoPath = await LocalImageService.guardarImagen(imagen!, uid);
      }

      await FirebaseFirestore.instance
          .collection("usuarios")
          .doc(uid)
          .update({
        "nombre": nombreController.text.trim(),
        "apellido": apellidoController.text.trim(),
        "apodo": apodoController.text.trim(),
        "peso": pesoController.text.trim(),
        "altura": alturaController.text.trim(),
        "objetivo": objetivo,
        "experiencia": experiencia,
        "frecuencia": frecuencia,
        "fotoPerfil": fotoPath, // ← ahora nunca se borra si no hubo cambio
      });

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e")));
    }
  }

  // Campo de texto compacto con ícono
  Widget _campo({
    required String hint,
    required TextEditingController controller,
    required IconData icono,
    TextInputType teclado = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        keyboardType: teclado,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
          prefixIcon: Icon(icono, color: Colors.cyan, size: 18),
          filled: true,
          fillColor: Colors.white.withOpacity(0.04),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.06)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.06)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.cyan, width: 1.5),
          ),
        ),
      ),
    );
  }

  // Dropdown compacto con ícono
  Widget _dropdown<T>({
    required String hint,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required void Function(T?) onChanged,
    required IconData icono,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: DropdownButtonFormField<T>(
        value: value,
        isExpanded: true,
        dropdownColor: const Color(0xFF111827),
        style: const TextStyle(color: Colors.white, fontSize: 14),
        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.cyan),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white38, fontSize: 14),
          prefixIcon: Icon(icono, color: Colors.cyan, size: 18),
          filled: true,
          fillColor: Colors.white.withOpacity(0.04),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.06)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.06)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.cyan, width: 1.5),
          ),
        ),
        items: items,
        onChanged: onChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        backgroundColor: Color(0xFF050B18),
        body: Center(child: CircularProgressIndicator(color: Colors.cyan)),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF050B18),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Editar Perfil",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: Colors.white, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto de perfil
            Center(
              child: GestureDetector(
                onTap: seleccionarImagen,
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Colors.cyan, Colors.blue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 48,
                        backgroundColor: Colors.white12,
                        backgroundImage:
                        imagen != null ? FileImage(imagen!) : null,
                        child: imagen == null
                            ? const Icon(Icons.person,
                            size: 44, color: Colors.white)
                            : null,
                      ),
                    ),
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.cyan,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt,
                            color: Colors.white, size: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Sección: Información personal
            _seccionLabel("Información personal", Icons.person_outline),
            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: _campo(
                    hint: "Nombre",
                    controller: nombreController,
                    icono: Icons.badge_outlined,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _campo(
                    hint: "Apellido",
                    controller: apellidoController,
                    icono: Icons.badge_outlined,
                  ),
                ),
              ],
            ),

            _campo(
              hint: "Apodo",
              controller: apodoController,
              icono: Icons.alternate_email,
            ),

            // Sección: Físico
            _seccionLabel("Físico", Icons.monitor_weight_outlined),
            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: _campo(
                    hint: "Peso (KG)",
                    controller: pesoController,
                    icono: Icons.monitor_weight_outlined,
                    teclado: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _campo(
                    hint: "Altura (CM)",
                    controller: alturaController,
                    icono: Icons.height,
                    teclado: TextInputType.number,
                  ),
                ),
              ],
            ),

            // Sección: Entrenamiento
            _seccionLabel("Entrenamiento", Icons.fitness_center),
            const SizedBox(height: 8),

            _dropdown<String>(
              hint: "Objetivo",
              value: objetivo,
              icono: Icons.flag_outlined,
              items: const [
                DropdownMenuItem(
                    value: "Ganar masa muscular", child: Text("Ganar músculo")),
                DropdownMenuItem(value: "Definir", child: Text("Definir")),
                DropdownMenuItem(
                    value: "Perder peso", child: Text("Perder peso")),
              ],
              onChanged: (v) => setState(() => objetivo = v!),
            ),

            _dropdown<String>(
              hint: "Experiencia",
              value: experiencia,
              icono: Icons.military_tech_outlined,
              items: const [
                DropdownMenuItem(
                    value: "Principiante", child: Text("Principiante")),
                DropdownMenuItem(
                    value: "Intermedio", child: Text("Intermedio")),
                DropdownMenuItem(value: "Avanzado", child: Text("Avanzado")),
              ],
              onChanged: (v) => setState(() => experiencia = v.toString()),
            ),

            _dropdown<String>(
              hint: "Frecuencia semanal",
              value: frecuencia,
              icono: Icons.calendar_today_outlined,
              items: const [
                DropdownMenuItem(value: "1-2 días", child: Text("1-2 días")),
                DropdownMenuItem(value: "3-4 días", child: Text("3-4 días")),
                DropdownMenuItem(value: "5-6 días", child: Text("5-6 días")),
              ],
              onChanged: (v) => setState(() => frecuencia = v.toString()),
            ),

            const SizedBox(height: 20),

            // Botón guardar
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                onPressed: guardarPerfil,
                icon: const Icon(Icons.save_outlined,
                    color: Colors.white, size: 18),
                label: const Text(
                  "Guardar Cambios",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _seccionLabel(String texto, IconData icono) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 2),
      child: Row(
        children: [
          Icon(icono, color: Colors.cyan, size: 15),
          const SizedBox(width: 6),
          Text(
            texto,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
