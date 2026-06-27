import 'package:flutter/material.dart';
import '../../app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../profile/complete_profile_screen.dart';
import '../legal/terms_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nombreController    = TextEditingController();
  final TextEditingController apellidoController  = TextEditingController();
  final TextEditingController apodoController     = TextEditingController();
  final TextEditingController correoController    = TextEditingController();
  final TextEditingController passwordController  = TextEditingController();

  bool loading         = false;
  bool ocultarPassword = true;
  bool aceptoTerminos  = false;

  Future<void> register() async {
    if (!aceptoTerminos) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: AppColors.error,
          content: Text("Debes aceptar los términos y condiciones"),
        ),
      );
      return;
    }

    try {
      setState(() => loading = true);

      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email:    correoController.text.trim(),
        password: passwordController.text.trim(),
      );

      await FirebaseFirestore.instance
          .collection("usuarios")
          .doc(credential.user!.uid)
          .set({
        "nombre":   nombreController.text.trim(),
        "apellido": apellidoController.text.trim(),
        "correo":   correoController.text.trim(),
        "fotoPerfil": "",
        "peso":     "",
        "altura":   "",
        "objetivo": "",
        "experiencia": "",
        "frecuencia":  "",
        "apodo": apodoController.text.trim().isEmpty
            ? nombreController.text.trim()
            : apodoController.text.trim(),
        "perfilCompleto":    false,
        "termsAccepted":     true,
        "termsAcceptedDate": Timestamp.now(),
      });

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CompleteProfileScreen()),
      );
    } on FirebaseAuthException catch (e) {
      String mensaje = "Error al crear cuenta";
      if (e.code == "email-already-in-use") {
        mensaje = "El correo ya está registrado";
      } else if (e.code == "invalid-email") {
        mensaje = "Correo inválido";
      } else if (e.code == "weak-password") {
        mensaje = "La contraseña es muy débil";
      } else if (e.code == "network-request-failed") {
        mensaje = "Error de conexión";
      }
      _showErrorDialog("Error", mensaje);
    } catch (e) {
      _showErrorDialog("Error", e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.bgSecondary,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title:   Text(title,   style: const TextStyle(color: AppColors.textPrimary)),
        content: Text(message, style: const TextStyle(color: AppColors.textMuted)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Aceptar",
                style: TextStyle(color: AppColors.accent)),
          ),
        ],
      ),
    );
  }

  InputDecoration _fieldDecoration(String label, IconData icon,
      {Widget? suffix}) {
    return InputDecoration(
      labelText:  label,
      labelStyle: const TextStyle(color: AppColors.textSubtle),
      prefixIcon: Icon(icon, color: AppColors.accent, size: 20),
      suffixIcon: suffix,
      filled:     true,
      fillColor:  AppColors.bgBubble,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              // ── HEADER ─────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Logo / back
                    Row(
                      children: [
                        const Icon(Icons.chevron_left,
                            color: AppColors.accent, size: 28),
                        const SizedBox(width: 4),
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                            children: [
                              TextSpan(
                                  text: "EvoYou.",
                                  style: TextStyle(color: AppColors.textPrimary)),
                              TextSpan(
                                  text: "AI",
                                  style: TextStyle(color: AppColors.accent)),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Avatar izquierda + burbuja derecha
                    // El avatar "se apoya" en la burbuja de saludo
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [

                        // ── Avatar a la izquierda, apoyado en la burbuja ──
                        SizedBox(
                          width: 130,
                          height: 210,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              // Imagen del avatar alineada al fondo
                              Positioned(
                                bottom: 0,
                                left: 0,
                                child: Image.asset(
                                  'assets/imagenes/avatar/register_avatar.png',
                                  height: 210,
                                  fit: BoxFit.contain,
                                  alignment: Alignment.bottomLeft,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 110,
                                    height: 210,
                                    decoration: BoxDecoration(
                                      color: AppColors.bgBubble,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                          color: AppColors.accent.withOpacity(0.3)),
                                    ),
                                    child: const Icon(Icons.person,
                                        color: AppColors.accent, size: 60),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 10),

                        // ── Burbuja de saludo a la derecha ────────────────
                        Expanded(
                          child: Container(
                            // Alineada al fondo para que el avatar "apoye" en ella
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.bgBubble,
                              borderRadius: const BorderRadius.only(
                                topLeft:    Radius.circular(18),
                                topRight:   Radius.circular(18),
                                bottomRight: Radius.circular(18),
                                // Esquina inferior izquierda en punta
                                // apuntando al avatar
                                bottomLeft: Radius.circular(4),
                              ),
                              border: Border.all(
                                  color: AppColors.accent.withOpacity(0.4)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text(
                                  "¡Hola! 👋",
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Soy ",
                                        style: TextStyle(
                                            color: AppColors.textPrimary,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                        text: "Evo.",
                                        style: TextStyle(
                                            color: AppColors.accent,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Primero vamos a crear tu cuenta para comenzar juntos tu transformación.",
                                  style: TextStyle(
                                      color: AppColors.textMuted, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // ── FIN HEADER ─────────────────────────────────────────────

              // ── FORMULARIO ─────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
                child: Column(
                  children: [

                    // Nombre
                    TextField(
                      controller: nombreController,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration:
                      _fieldDecoration("Nombre", Icons.person_outline),
                    ),
                    const SizedBox(height: 14),

                    // Apellido
                    TextField(
                      controller: apellidoController,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration:
                      _fieldDecoration("Apellido", Icons.badge_outlined),
                    ),
                    const SizedBox(height: 14),

                    // Apodo
                    TextField(
                      controller: apodoController,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration:
                      _fieldDecoration("Apodo", Icons.label_outline),
                    ),
                    const SizedBox(height: 14),

                    // Correo
                    TextField(
                      controller: correoController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: _fieldDecoration(
                          "Correo electrónico", Icons.mail_outline),
                    ),
                    const SizedBox(height: 14),

                    // Contraseña
                    TextField(
                      controller: passwordController,
                      obscureText: ocultarPassword,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: _fieldDecoration(
                        "Contraseña",
                        Icons.lock_outline,
                        suffix: IconButton(
                          onPressed: () => setState(
                                  () => ocultarPassword = !ocultarPassword),
                          icon: Icon(
                            ocultarPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.textSubtle60,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Términos y condiciones
                    GestureDetector(
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const TermsScreen()),
                        );
                        if (result == true) {
                          setState(() => aceptoTerminos = true);
                        }
                      },
                      child: Row(
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: aceptoTerminos,
                              activeColor: AppColors.accent,
                              side: const BorderSide(color: AppColors.textSubtle60),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                              onChanged: null,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text("Acepto los ",
                              style: TextStyle(color: AppColors.textMuted)),
                          const Text(
                            "términos y condiciones",
                            style: TextStyle(
                              color: AppColors.accent,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.accent,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Botón Continuar
                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          elevation: 0,
                        ),
                        onPressed: loading ? null : register,
                        child: loading
                            ? const CircularProgressIndicator(
                            color: AppColors.textPrimary)
                            : const Text(
                          "Continuar",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Link iniciar sesión
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "¿Ya tienes una cuenta? ",
                          style: TextStyle(color: AppColors.textSubtle),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Text(
                            "Iniciar sesión",
                            style: TextStyle(
                              color: AppColors.accent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}