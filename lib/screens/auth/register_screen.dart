import 'package:flutter/material.dart';
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
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController apellidoController = TextEditingController();
  final TextEditingController apodoController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool loading = false;
  bool ocultarPassword = true;
  bool aceptoTerminos = false;

  Future<void> register() async {
    if (!aceptoTerminos) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Debes aceptar los términos y condiciones"),
        ),
      );
      return;
    }

    try {
      setState(() => loading = true);

      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: correoController.text.trim(),
        password: passwordController.text.trim(),
      );

      await FirebaseFirestore.instance
          .collection("usuarios")
          .doc(credential.user!.uid)
          .set({
        "nombre": nombreController.text.trim(),
        "apellido": apellidoController.text.trim(),
        "correo": correoController.text.trim(),
        "fotoPerfil": "",
        "peso": "",
        "altura": "",
        "objetivo": "",
        "experiencia": "",
        "frecuencia": "",
        "apodo": apodoController.text.trim().isEmpty
            ? nombreController.text.trim()
            : apodoController.text.trim(),
        "perfilCompleto": false,
        "termsAccepted": true,
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
        backgroundColor: const Color(0xFF162033),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: Text(message, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Aceptar", style: TextStyle(color: Colors.cyan)),
          ),
        ],
      ),
    );
  }

  InputDecoration _fieldDecoration(String label, IconData icon, {Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white54),
      prefixIcon: Icon(icon, color: Colors.cyan, size: 20),
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFF0D1B2A),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.white12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.white12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.cyan, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF060E1A),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ── Header con avatar ──────────────────────────────────────
              SizedBox(
                height: 260,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Logo EvoYou.AI
                    Positioned(
                      top: 16,
                      left: 24,
                      child: Row(
                        children: [
                          const Icon(Icons.chevron_left,
                              color: Colors.cyan, size: 28),
                          const SizedBox(width: 4),
                          RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                              children: [
                                TextSpan(
                                    text: "EvoYou.",
                                    style: TextStyle(color: Colors.white)),
                                TextSpan(
                                    text: "AI",
                                    style: TextStyle(color: Colors.cyan)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Burbuja de bienvenida
                    Positioned(
                      top: 60,
                      left: 24,
                      child: Container(
                        width: 200,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D1B2A),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(18),
                            topRight: Radius.circular(18),
                            bottomRight: Radius.circular(18),
                          ),
                          border: Border.all(color: Colors.cyan.withOpacity(0.4)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "¡Hola! 👋",
                              style: TextStyle(
                                color: Colors.white,
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
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text: "Evo.",
                                    style: TextStyle(
                                        color: Colors.cyan,
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
                                  color: Colors.white70, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Avatar flotante a la derecha
                    Positioned(
                      right: 0,
                      bottom: -20,
                      child: SizedBox(
                        height: 240,
                        child: Image.asset(
                          'assets/imagenes/avatar/register_avatar.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Formulario ─────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                child: Column(
                  children: [
                    // Nombre
                    TextField(
                      controller: nombreController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _fieldDecoration("Nombre", Icons.person_outline),
                    ),
                    const SizedBox(height: 14),

                    // Apellido
                    TextField(
                      controller: apellidoController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _fieldDecoration("Apellido", Icons.badge_outlined),
                    ),
                    const SizedBox(height: 14),

                    // Apodo
                    TextField(
                      controller: apodoController,
                      style: const TextStyle(color: Colors.white),
                      decoration: _fieldDecoration("Apodo", Icons.label_outline),
                    ),
                    const SizedBox(height: 14),

                    // Correo
                    TextField(
                      controller: correoController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.white),
                      decoration: _fieldDecoration(
                          "Correo electrónico", Icons.mail_outline),
                    ),
                    const SizedBox(height: 14),

                    // Contraseña
                    TextField(
                      controller: passwordController,
                      obscureText: ocultarPassword,
                      style: const TextStyle(color: Colors.white),
                      decoration: _fieldDecoration(
                        "Contraseña",
                        Icons.lock_outline,
                        suffix: IconButton(
                          onPressed: () =>
                              setState(() => ocultarPassword = !ocultarPassword),
                          icon: Icon(
                            ocultarPassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: Colors.white38,
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
                              activeColor: Colors.cyan,
                              side: const BorderSide(color: Colors.white38),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                              onChanged: null,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text("Acepto los ", style: TextStyle(color: Colors.white70)),
                          const Text(
                            "términos y condiciones",
                            style: TextStyle(
                                color: Colors.cyan,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.cyan),
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
                          backgroundColor: Colors.cyan,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          elevation: 0,
                        ),
                        onPressed: loading ? null : register,
                        child: loading
                            ? const CircularProgressIndicator(color: Colors.white)
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
                          style: TextStyle(color: Colors.white54),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Text(
                            "Iniciar sesión",
                            style: TextStyle(
                              color: Colors.cyan,
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