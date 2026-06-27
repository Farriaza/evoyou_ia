// lib/screens/edit_profile_screen.dart
import 'dart:io';

import 'package:flutter/material.dart';
import '../../app_theme.dart';
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
  String frecuencia = "3-4 días";
  String lugarEntrenamiento = "Gimnasio";
  String fotoActual = "";
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

        String objDb = data["objetivo"] ?? "Perder peso";
        if (objDb == "Ganar musculo" || objDb == "Ganar masa muscular") {
          objetivo = "Ganar musculo";
        } else if (objDb == "Mantener la forma" || objDb == "Mantener físico") {
          objetivo = "Mantener la forma";
        } else {
          objetivo = "Perder peso";
        }

        experiencia = data["experiencia"] ?? "Principiante";
        frecuencia = data["frecuencia"] ?? "3-4 días";
        lugarEntrenamiento = data["lugarEntrenamiento"] ?? "Gimnasio";
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
        imagenModificada = true;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> guardarPerfil() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
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
        "lugarEntrenamiento": lugarEntrenamiento,
        "fotoPerfil": fotoPath,
      });

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("$e")));
    }
  }

  Widget _campo({
    required String hint,
    required TextEditingController controller,
    required IconData icono,
    TextInputType teclado = TextInputType.text,
    String? sufijo, // Permite añadir KG o CM de forma elegante
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        keyboardType: teclado,
        style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.textSubtle60, fontSize: 14),
          prefixIcon: Icon(icono, color: AppColors.accent, size: 18),
          suffixText: sufijo,
          suffixStyle: const TextStyle(color: AppColors.accent, fontSize: 14, fontWeight: FontWeight.bold),
          filled: true,
          fillColor: const Color(0x0AF6FAFD),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: const Color(0x0FF6FAFD)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: const Color(0x0FF6FAFD)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
          ),
        ),
      ),
    );
  }

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
        dropdownColor: AppColors.bgBubble,
        style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
        icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.accent),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: AppColors.textSubtle60, fontSize: 14),
          prefixIcon: Icon(icono, color: AppColors.accent, size: 18),
          filled: true,
          fillColor: const Color(0x0AF6FAFD),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: const Color(0x0FF6FAFD)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: const Color(0x0FF6FAFD)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
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
        backgroundColor: AppColors.bgPrimary,
        body: Center(child: CircularProgressIndicator(color: AppColors.accent)),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Editar Perfil",
          style: TextStyle(color: AppColors.textPrimary, fontSize: 16),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 18),
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
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [AppColors.accent, AppColors.steel],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 48,
                        backgroundColor: AppColors.divider,
                        backgroundImage: imagen != null ? FileImage(imagen!) : null,
                        child: imagen == null
                            ? const Icon(Icons.person, size: 44, color: AppColors.textPrimary)
                            : null,
                      ),
                    ),
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: AppColors.accent,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt, color: AppColors.textPrimary, size: 14),
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
                    hint: "Ejemplo: 74.5",
                    controller: pesoController,
                    icono: Icons.monitor_weight_outlined,
                    teclado: const TextInputType.numberWithOptions(decimal: true),
                    sufijo: "KG", // Indicación clara de Kilogramos
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _campo(
                    hint: "Ejemplo: 175",
                    controller: alturaController,
                    icono: Icons.height,
                    teclado: TextInputType.number,
                    sufijo: "CM", // Indicación clara de Centímetros
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
                DropdownMenuItem(value: "Perder peso", child: Text("Perder peso")),
                DropdownMenuItem(value: "Ganar musculo", child: Text("Ganar musculo")),
                DropdownMenuItem(value: "Mantener la forma", child: Text("Mantener la forma")),
              ],
              onChanged: (v) => setState(() => objetivo = v!),
            ),

            _dropdown<String>(
              hint: "Lugar de entrenamiento",
              value: lugarEntrenamiento,
              icono: Icons.business_center_outlined,
              items: const [
                DropdownMenuItem(value: "Gimnasio", child: Text("Gimnasio")),
                DropdownMenuItem(value: "En Casa", child: Text("En Casa")),
                DropdownMenuItem(value: "Hibrido", child: Text("Hibrido")),
              ],
              onChanged: (v) => setState(() => lugarEntrenamiento = v!),
            ),

            _dropdown<String>(
              hint: "Experiencia",
              value: experiencia,
              icono: Icons.military_tech_outlined,
              items: const [
                DropdownMenuItem(value: "Principiante", child: Text("Principiante")),
                DropdownMenuItem(value: "Intermedio", child: Text("Intermedio")),
                DropdownMenuItem(value: "Avanzado", child: Text("Avanzado")),
              ],
              onChanged: (v) => setState(() => experiencia = v!),
            ),

            const SizedBox(height: 20),

            // Botón guardar
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                onPressed: guardarPerfil,
                icon: const Icon(Icons.save_outlined, color: AppColors.textPrimary, size: 18),
                label: const Text(
                  "Guardar Cambios",
                  style: TextStyle(color: AppColors.textPrimary, fontSize: 15, fontWeight: FontWeight.w600),
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
          Icon(icono, color: AppColors.accent, size: 15),
          const SizedBox(width: 6),
          Text(
            texto,
            style: const TextStyle(
              color: AppColors.textSubtle,
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