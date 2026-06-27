// lib/screens/settings/settings_screen.dart
import 'package:flutter/material.dart';
import '../../app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../auth/login_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool recordarEntrenamiento = true;
  String estiloRespuesta = "Detallado";

  Future<void> cerrarSesion() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
    );
  }

  void _cambiarEstiloRespuesta() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Respuestas de EvoYou AI",
                style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Selecciona cómo prefieres que el asistente responda a tus rutinas.",
                style: TextStyle(color: AppColors.textSubtle, fontSize: 13),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text("Cortas y Directas", style: TextStyle(color: AppColors.textPrimary)),
                leading: Radio<String>(
                  value: "Directo",
                  groupValue: estiloRespuesta,
                  activeColor: AppColors.accent,
                  onChanged: (value) {
                    setState(() => estiloRespuesta = value!);
                    Navigator.pop(context);
                  },
                ),
              ),
              ListTile(
                title: const Text("Explicativas y Detalladas", style: TextStyle(color: AppColors.textPrimary)),
                leading: Radio<String>(
                  value: "Detallado",
                  groupValue: estiloRespuesta,
                  activeColor: AppColors.accent,
                  onChanged: (value) {
                    setState(() => estiloRespuesta = value!);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget opcion({
    required IconData icono,
    required String titulo,
    required Color color,
    String? subtitulo,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.textPrimary.withOpacity(0.03), width: 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.12),
          child: Icon(icono, color: color, size: 22),
        ),
        title: Text(
          titulo,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 15.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: subtitulo != null
            ? Text(subtitulo, style: const TextStyle(color: AppColors.textSubtle60, fontSize: 12))
            : null,
        trailing: trailing ?? const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.textSubtle50, size: 16),
        onTap: onTap,
      ),
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
          "Configuración",
          style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // 1. Alertas / Memoria de entrenamiento
              opcion(
                icono: Icons.alarm_rounded,
                titulo: "Recordatorio de entreno",
                subtitulo: "Recordar días programados",
                color: AppColors.warning,
                trailing: Switch(
                  value: recordarEntrenamiento,
                  activeColor: AppColors.accent,
                  activeTrackColor: AppColors.accent.withOpacity(0.3),
                  inactiveThumbColor: AppColors.textSubtle,
                  inactiveTrackColor: AppColors.divider40,
                  onChanged: (value) {
                    setState(() {
                      recordarEntrenamiento = value;
                    });
                  },
                ),
              ),

              // 2. Comportamiento de la IA
              opcion(
                icono: Icons.chat_bubble_outline_rounded,
                titulo: "Estilo de respuestas IA",
                subtitulo: "Formato: $estiloRespuesta",
                color: AppColors.accentLight,
                onTap: _cambiarEstiloRespuesta,
              ),

              // 3. Limpieza / Privacidad del chat
              opcion(
                icono: Icons.delete_sweep_outlined,
                titulo: "Borrar historial del chat",
                subtitulo: "Reiniciar memoria de EvoYou AI",
                color: AppColors.error.withOpacity(0.7),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Historial de chat restablecido")),
                  );
                },
              ),

              // 4. Info Legal básica de la App
              opcion(
                icono: Icons.info_outline_rounded,
                titulo: "Acerca de EvoYou AI",
                color: AppColors.accentGlow,
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: "EvoYou AI",
                    applicationVersion: "1.0.0",
                    applicationLegalese: "© EvoYou AI",
                  );
                },
              ),

              const Spacer(),

              // Botón Cerrar Sesión
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error.withOpacity(0.9),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: cerrarSesion,
                  icon: const Icon(Icons.logout_rounded, color: AppColors.textPrimary, size: 20),
                  label: const Text(
                    "Cerrar sesión",
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}