// running_history_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../app_theme.dart';

class RunningHistoryScreen extends StatelessWidget {
  const RunningHistoryScreen({super.key});

  String _formatearFechaHora(dynamic fecha) {
    if (fecha == null) return "";
    final DateTime date = (fecha as Timestamp).toDate();
    final dia = date.day.toString().padLeft(2, '0');
    final mes = date.month.toString().padLeft(2, '0');
    final hora = date.hour.toString().padLeft(2, '0');
    final min = date.minute.toString().padLeft(2, '0');
    return "$dia/$mes/${date.year} · $hora:$min";
  }

  Future<void> _eliminarSesion(BuildContext context, String docId) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF111C30),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text("Eliminar sesión", style: TextStyle(color: AppColors.textPrimary)),
        content: const Text(
          "Esta acción no se puede deshacer. ¿Eliminar esta carrera del historial?",
          style: TextStyle(color: AppColors.textSubtle),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar", style: TextStyle(color: AppColors.textSubtle)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Eliminar", style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await FirebaseFirestore.instance.collection("running_sessions").doc(docId).delete();
    }
  }

  Widget _metricaIcono({
    required IconData icono,
    required String titulo,
    required String valor,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icono, color: color, size: 14),
            const SizedBox(width: 5),
            Text(
              titulo,
              style: const TextStyle(color: AppColors.textSubtle, fontSize: 11),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          valor,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  Widget _tarjetaSesion(BuildContext context, String docId, Map<String, dynamic> data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF111C30),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.accent.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accent.withOpacity(0.12),
                ),
                child: const Icon(Icons.directions_run_rounded, color: AppColors.accent, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Sesión de Running",
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _formatearFechaHora(data["creado"]),
                      style: const TextStyle(color: AppColors.textSubtle, fontSize: 12),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _eliminarSesion(context, docId),
                icon: const Icon(Icons.delete_outline_rounded, color: AppColors.textSubtle, size: 20),
                tooltip: "Eliminar",
              ),
            ],
          ),

          const SizedBox(height: 16),
          Divider(color: AppColors.divider.withOpacity(0.5), height: 1),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _metricaIcono(
                icono: Icons.timer_outlined,
                titulo: "Tiempo",
                valor: data["tiempoTexto"] ?? "--:--",
                color: AppColors.accentLight,
              ),
              _metricaIcono(
                icono: Icons.route_rounded,
                titulo: "Distancia",
                valor: "${(data["distanciaKm"] ?? 0).toStringAsFixed(2)} km",
                color: AppColors.accent,
              ),
              _metricaIcono(
                icono: Icons.local_fire_department_rounded,
                titulo: "Calorías",
                valor: "${(data["calorias"] ?? 0).toStringAsFixed(0)} kcal",
                color: AppColors.warning,
              ),
              _metricaIcono(
                icono: Icons.speed_rounded,
                titulo: "Ritmo",
                valor: "${(data["ritmo"] ?? 0).toStringAsFixed(1)} km/h",
                color: AppColors.success,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Historial Running",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: user == null
          ? const Center(
        child: Text(
          "Inicia sesión para ver tu historial",
          style: TextStyle(color: AppColors.textMuted, fontSize: 15),
        ),
      )
          : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("running_sessions")
            .where("uid", isEqualTo: user.uid)
            .orderBy("creado", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Error cargando historial",
                style: TextStyle(color: AppColors.error),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.accent),
            );
          }

          final carreras = snapshot.data?.docs ?? [];

          if (carreras.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.directions_run_rounded,
                    size: 48,
                    color: AppColors.textMuted.withOpacity(0.4),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "No hay carreras registradas",
                    style: TextStyle(color: AppColors.textMuted, fontSize: 15),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Tu próximo recorrido aparecerá aquí",
                    style: TextStyle(color: AppColors.textSubtle, fontSize: 12),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(18),
            itemCount: carreras.length,
            itemBuilder: (context, index) {
              final doc = carreras[index];
              return _tarjetaSesion(context, doc.id, doc.data());
            },
          );
        },
      ),
    );
  }
}