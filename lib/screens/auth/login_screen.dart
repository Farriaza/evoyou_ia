// login_screen.dart

import 'package:flutter/material.dart';
import '../../app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../services/firestore_service.dart';

import '../home/home_screen.dart';
import '../profile/complete_profile_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {

  final emailController =
  TextEditingController();

  final passwordController =
  TextEditingController();

  bool loading = false;

  bool ocultarPassword = true;

  Future<void> login() async {

    try {

      setState(() {
        loading = true;
      });

      await FirebaseAuth.instance
          .signInWithEmailAndPassword(

        email:
        emailController.text.trim(),

        password:
        passwordController.text.trim(),
      );

      final user =
          FirebaseAuth.instance.currentUser;

      final existe =
      await FirestoreService.usuarioExiste(
        user!.uid,
      );

      if (!mounted) return;

      if (existe) {

        Navigator.pushReplacement(

          context,

          MaterialPageRoute(
            builder: (_) =>
            const HomeScreen(),
          ),
        );

      } else {

        Navigator.pushReplacement(

          context,

          MaterialPageRoute(
            builder: (_) =>
            const CompleteProfileScreen(),
          ),
        );
      }

    } on FirebaseAuthException catch (e) {

      String mensaje =
          "Error al iniciar sesión";

      if (e.code == "user-not-found") {

        mensaje = "El correo no existe";

      } else if (e.code ==
          "wrong-password") {

        mensaje =
        "Contraseña incorrecta";

      } else if (e.code ==
          "invalid-email") {

        mensaje = "Correo inválido";

      } else if (e.code ==
          "invalid-credential") {

        mensaje =
        "Correo o contraseña incorrectos";
      }

      showDialog(

        context: context,

        builder: (_) {

          return AlertDialog(

            backgroundColor:
            AppColors.bgSecondary,

            shape:
            RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(22),
            ),

            title: const Text(

              "Error",

              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight:
                FontWeight.bold,
              ),
            ),

            content: Text(

              mensaje,

              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 15,
              ),
            ),

            actions: [

              TextButton(

                onPressed: () {
                  Navigator.pop(context);
                },

                child: const Text(

                  "Aceptar",

                  style: TextStyle(
                    color:
                    AppColors.accent,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      );

    } finally {

      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      resizeToAvoidBottomInset: true,

      backgroundColor:
      AppColors.bgPrimary,

      body: Container(

        width: double.infinity,

        decoration: const BoxDecoration(

          gradient: LinearGradient(

            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,

            colors: [

              AppColors.bgPrimary,
              AppColors.bgPrimary,
              AppColors.bgPrimary,
            ],
          ),
        ),

        child: SafeArea(

          child: SingleChildScrollView(

            padding:
            const EdgeInsets.symmetric(
              horizontal: 28,
              vertical: 18,
            ),

            child: Column(

              children: [

                const SizedBox(height: 25),

                // IMAGEN PRINCIPAL

                Container(

                  width: 210,
                  height: 210,

                  decoration: BoxDecoration(

                    shape: BoxShape.circle,

                    boxShadow: [

                      BoxShadow(

                        color:
                        const Color(
                          0xFF00D9FF,
                        ).withOpacity(0.15),

                        blurRadius: 40,
                        spreadRadius: 4,
                      ),
                    ],
                  ),

                  child: ClipOval(

                    child: Image.asset(

                      "assets/imagenes/ui/logo.png",

                      fit: BoxFit.cover,

                      errorBuilder:
                          (
                          context,
                          error,
                          stackTrace,
                          ) {

                        return Container(

                          color: Colors.black26,

                          child: const Center(

                            child: Text(

                              "LOGO",

                              style: TextStyle(
                                color:
                                AppColors.textPrimary,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // TITULO

                RichText(

                  textAlign:
                  TextAlign.center,

                  text: const TextSpan(

                    children: [

                      TextSpan(

                        text: "EvoYou",

                        style: TextStyle(

                          color:
                          AppColors.textPrimary,

                          fontSize: 44,

                          fontWeight:
                          FontWeight.w900,

                          letterSpacing: -1.5,
                        ),
                      ),

                      TextSpan(

                        text: " AI",

                        style: TextStyle(

                          color:
                          Color(
                            0xFF00D9FF,
                          ),

                          fontSize: 44,

                          fontWeight:
                          FontWeight.w900,

                          letterSpacing: -1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                const Text(

                  "TU MEJOR VERSIÓN,\nPOTENCIADA POR IA",

                  textAlign: TextAlign.center,

                  style: TextStyle(

                    color: AppColors.textSubtle60,

                    fontSize: 11,

                    fontWeight:
                    FontWeight.w600,

                    letterSpacing: 3,

                    height: 1.8,
                  ),
                ),

                const SizedBox(height: 45),

                // EMAIL

                Container(

                  decoration: BoxDecoration(

                    color:
                    const Color(
                      0xFF111C30,
                    ),

                    borderRadius:
                    BorderRadius.circular(
                      24,
                    ),

                    border: Border.all(
                      color:
                      AppColors.divider40,
                    ),
                  ),

                  child: TextField(

                    controller:
                    emailController,

                    keyboardType:
                    TextInputType
                        .emailAddress,

                    style: const TextStyle(
                      color: AppColors.textPrimary,
                    ),

                    decoration:
                    InputDecoration(

                      contentPadding:
                      const EdgeInsets.symmetric(
                        vertical: 24,
                      ),

                      hintText: "Correo",

                      hintStyle:
                      const TextStyle(
                        color:
                        AppColors.textSubtle,
                        fontSize: 17,
                      ),

                      prefixIcon:
                      const Icon(

                        Icons.email_rounded,

                        color:
                        AppColors.accent,

                        size: 30,
                      ),

                      border:
                      OutlineInputBorder(

                        borderRadius:
                        BorderRadius.circular(
                          24,
                        ),

                        borderSide:
                        BorderSide.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // PASSWORD

                Container(

                  decoration: BoxDecoration(

                    color:
                    const Color(
                      0xFF111C30,
                    ),

                    borderRadius:
                    BorderRadius.circular(
                      24,
                    ),

                    border: Border.all(
                      color:
                      AppColors.divider40,
                    ),
                  ),

                  child: TextField(

                    controller:
                    passwordController,

                    obscureText:
                    ocultarPassword,

                    style: const TextStyle(
                      color: AppColors.textPrimary,
                    ),

                    decoration:
                    InputDecoration(

                      contentPadding:
                      const EdgeInsets.symmetric(
                        vertical: 24,
                      ),

                      hintText:
                      "Contraseña",

                      hintStyle:
                      const TextStyle(
                        color:
                        AppColors.textSubtle,
                        fontSize: 17,
                      ),

                      prefixIcon:
                      const Icon(

                        Icons.lock_rounded,

                        color:
                        AppColors.accent,

                        size: 30,
                      ),

                      suffixIcon:
                      IconButton(

                        onPressed: () {

                          setState(() {

                            ocultarPassword =
                            !ocultarPassword;
                          });
                        },

                        icon: Icon(

                          ocultarPassword
                              ? Icons
                              .visibility_off
                              : Icons
                              .visibility,

                          color:
                          AppColors.textSubtle,

                          size: 28,
                        ),
                      ),

                      border:
                      OutlineInputBorder(

                        borderRadius:
                        BorderRadius.circular(
                          24,
                        ),

                        borderSide:
                        BorderSide.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // ── FILA: ¿Olvidaste tu contraseña? ←→ Crear cuenta ──────
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [

                    // ¿Olvidaste tu contraseña?
                    TextButton(

                      onPressed: () {

                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(

                          const SnackBar(

                            backgroundColor:
                            AppColors.bgSecondary,

                            content: Text(

                              "Recuperación próximamente",

                              style: TextStyle(
                                color:
                                AppColors.textPrimary,
                              ),
                            ),
                          ),
                        );
                      },

                      child: const Text(

                        "¿Olvidaste tu contraseña?",

                        style: TextStyle(

                          color:
                          AppColors.accent,

                          fontWeight:
                          FontWeight.w600,

                          fontSize: 14,
                        ),
                      ),
                    ),

                    // Crear cuenta
                    TextButton(

                      onPressed: () {

                        Navigator.push(

                          context,

                          MaterialPageRoute(
                            builder: (_) =>
                            const RegisterScreen(),
                          ),
                        );
                      },

                      child: const Text(

                        "Crear cuenta",

                        style: TextStyle(

                          color:
                          AppColors.textMuted60,

                          fontSize: 14,

                          fontWeight:
                          FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                // ─────────────────────────────────────────────────────────

                const SizedBox(height: 30),

                // BOTON LOGIN

                Container(

                  width: double.infinity,
                  height: 62,

                  decoration: BoxDecoration(

                    borderRadius:
                    BorderRadius.circular(
                      24,
                    ),

                    gradient:
                    const LinearGradient(

                      colors: [

                        AppColors.accent,
                        AppColors.accentGlow,
                      ],
                    ),

                    boxShadow: [

                      BoxShadow(

                        color:
                        AppColors.accent.withOpacity(0.4),

                        blurRadius: 20,

                        offset:
                        Offset(0, 10),
                      ),
                    ],
                  ),

                  child: ElevatedButton(

                    onPressed:
                    loading
                        ? null
                        : login,

                    style:
                    ElevatedButton
                        .styleFrom(

                      backgroundColor:
                      Colors.transparent,

                      shadowColor:
                      Colors.transparent,

                      shape:
                      RoundedRectangleBorder(

                        borderRadius:
                        BorderRadius.circular(
                          24,
                        ),
                      ),
                    ),

                    child: loading

                        ? const CircularProgressIndicator(
                      color:
                      AppColors.textPrimary,
                    )

                        : const Text(

                      "Iniciar sesión",

                      style: TextStyle(

                        fontSize: 21,

                        color:
                        AppColors.textPrimary,

                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}