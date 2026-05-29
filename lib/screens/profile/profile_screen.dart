import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? data;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    cargar();
  }

  Future<void> cargar() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final doc = await FirebaseFirestore.instance
          .collection("usuarios")
          .doc(uid)
          .get();
      if (!mounted) return;
      setState(() {
        data = doc.data();
        loading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> abrirEditarPerfil() async {
    final actualizado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EditProfileScreen()),
    );
    if (actualizado == true) await cargar();
  }

  Widget _statCard(String titulo, String valor, IconData icono) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.cyan.withOpacity(0.15),
              Colors.blue.withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.cyan.withOpacity(0.2), width: 1),
        ),
        child: Column(
          children: [
            Icon(icono, color: Colors.cyan, size: 18),
            const SizedBox(height: 6),
            Text(
              valor,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              titulo,
              style: const TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String titulo, String valor, IconData icono) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.06), width: 1),
      ),
      child: Row(
        children: [
          Icon(icono, color: Colors.cyan, size: 18),
          const SizedBox(width: 12),
          Text(
            titulo,
            style: const TextStyle(color: Colors.white54, fontSize: 14),
          ),
          const Spacer(),
          Text(
            valor,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
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

    final fotoPath = data?["fotoPerfil"]?.toString() ?? "";
    final tieneFoto = fotoPath.isNotEmpty && File(fotoPath).existsSync();

    return Scaffold(
      backgroundColor: const Color(0xFF050B18),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Perfil",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        actions: [
          TextButton.icon(
            onPressed: abrirEditarPerfil,
            icon: const Icon(Icons.edit_outlined, color: Colors.cyan, size: 16),
            label: const Text(
              "Editar",
              style: TextStyle(color: Colors.cyan, fontSize: 13),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Foto de perfil
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
                key: UniqueKey(),
                radius: 52,
                backgroundColor: Colors.white12,
                backgroundImage: tieneFoto
                    ? MemoryImage(File(fotoPath).readAsBytesSync())
                    : null,
                child: !tieneFoto
                    ? const Icon(Icons.person, size: 48, color: Colors.white)
                    : null,
              ),
            ),

            const SizedBox(height: 12),

            // Nombre y apodo
            Text(
              data?["apodo"] ?? "Sin apodo",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              "${data?["nombre"] ?? ""} ${data?["apellido"] ?? ""}".trim(),
              style: const TextStyle(color: Colors.white60, fontSize: 14),
            ),
            const SizedBox(height: 2),
            Text(
              FirebaseAuth.instance.currentUser?.email ?? "",
              style: const TextStyle(color: Colors.white30, fontSize: 12),
            ),

            const SizedBox(height: 20),

            // Stats: Peso y Altura
            Row(
              children: [
                _statCard(
                  "Peso",
                  "${data?["peso"] ?? "0"} KG",
                  Icons.monitor_weight_outlined,
                ),
                const SizedBox(width: 10),
                _statCard(
                  "Altura",
                  "${data?["altura"] ?? "0"} CM",
                  Icons.height,
                ),
                const SizedBox(width: 10),
                _statCard(
                  "Objetivo",
                  data?["objetivo"] ?? "—",
                  Icons.flag_outlined,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Info rows
            _infoRow(
              "Experiencia",
              data?["experiencia"] ?? "Principiante",
              Icons.fitness_center,
            ),
            _infoRow(
              "Frecuencia",
              data?["frecuencia"] ?? "1-2 días",
              Icons.calendar_today_outlined,
            ),

            const SizedBox(height: 20),

            // Botón editar
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                    side: const BorderSide(color: Colors.cyan, width: 1.5),
                  ),
                ),
                onPressed: abrirEditarPerfil,
                icon: const Icon(Icons.edit_outlined, color: Colors.cyan, size: 18),
                label: const Text(
                  "Editar Perfil",
                  style: TextStyle(
                    color: Colors.cyan,
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
}