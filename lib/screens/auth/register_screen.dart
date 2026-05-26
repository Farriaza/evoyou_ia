import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../profile/complete_profile_screen.dart';

import '../legal/terms_screen.dart';

class RegisterScreen extends StatefulWidget {

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState
    extends State<RegisterScreen> {

  final TextEditingController nombreController =
  TextEditingController();

  final TextEditingController apellidoController =
  TextEditingController();

  final TextEditingController correoController =
  TextEditingController();

  final TextEditingController passwordController =
  TextEditingController();

  bool loading = false;

  bool ocultarPassword = true;

  bool aceptoTerminos = false;

  Future<void> register() async {

    if(!aceptoTerminos){

      ScaffoldMessenger.of(context)

          .showSnackBar(

        const SnackBar(

          backgroundColor:
          Colors.red,

          content: Text(

            "Debes aceptar los términos y condiciones",
          ),
        ),
      );

      return;
    }

    try {

      setState(() {

        loading = true;
      });

      final credential =
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(

        email:
        correoController.text.trim(),

        password:
        passwordController.text.trim(),
      );

      await FirebaseFirestore.instance

          .collection("usuarios")

          .doc(credential.user!.uid)

          .set({

        "nombre":
        nombreController.text.trim(),

        "apellido":
        apellidoController.text.trim(),

        "correo":
        correoController.text.trim(),

        "fotoPerfil": "",

        "peso": "",

        "altura": "",

        "objetivo": "",

        "experiencia": "",

        "frecuencia": "",

        "apodo":
        nombreController.text.trim(),

        "perfilCompleto": false,

        "termsAccepted": true,

        "termsAcceptedDate":
        Timestamp.now(),
      });

      if (!mounted) return;

      Navigator.pushReplacement(

        context,

        MaterialPageRoute(

          builder: (_) =>
          const CompleteProfileScreen(),
        ),
      );

    } on FirebaseAuthException catch (e) {

      String mensaje =
          "Error al crear cuenta";

      if (e.code ==
          "email-already-in-use") {

        mensaje =
        "El correo ya está registrado";

      } else if (e.code ==
          "invalid-email") {

        mensaje =
        "Correo inválido";

      } else if (e.code ==
          "weak-password") {

        mensaje =
        "La contraseña es muy débil";

      } else if (e.code ==
          "network-request-failed") {

        mensaje =
        "Error de conexión";
      }

      showDialog(

        context: context,

        builder: (_) {

          return AlertDialog(

            backgroundColor:
            const Color(0xFF162033),

            shape:
            RoundedRectangleBorder(

              borderRadius:
              BorderRadius.circular(20),
            ),

            title: const Text(

              "Error",

              style: TextStyle(
                color: Colors.white,
              ),
            ),

            content: Text(

              mensaje,

              style: const TextStyle(
                color: Colors.white70,
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
                    color: Colors.cyan,
                  ),
                ),
              ),
            ],
          );
        },
      );

    } catch (e) {

      showDialog(

        context: context,

        builder: (_) {

          return AlertDialog(

            backgroundColor:
            const Color(0xFF162033),

            shape:
            RoundedRectangleBorder(

              borderRadius:
              BorderRadius.circular(20),
            ),

            title: const Text(

              "Firebase Error",

              style: TextStyle(
                color: Colors.white,
              ),
            ),

            content: Text(

              e.toString(),

              style: const TextStyle(
                color: Colors.white70,
              ),
            ),

            actions: [

              TextButton(

                onPressed: () {

                  Navigator.pop(context);
                },

                child: const Text(

                  "Cerrar",

                  style: TextStyle(
                    color: Colors.cyan,
                  ),
                ),
              ),
            ],
          );
        },
      );

    } finally {

      if (mounted) {

        setState(() {

          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xFF071120),

      appBar: AppBar(

        backgroundColor:
        const Color(0xFF071120),

        elevation: 0,
      ),

      body: SafeArea(

        child: SingleChildScrollView(

          padding:
          const EdgeInsets.all(30),

          child: Column(

            mainAxisAlignment:
            MainAxisAlignment.center,

            children: [

              const Icon(

                Icons.person_add,

                size: 90,

                color: Colors.cyan,
              ),

              const SizedBox(height: 25),

              const Text(

                "Crear Cuenta",

                style: TextStyle(

                  color: Colors.white,

                  fontSize: 35,

                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(height: 45),

              TextField(

                controller:
                nombreController,

                style: const TextStyle(
                  color: Colors.white,
                ),

                decoration:
                InputDecoration(

                  labelText: "Nombre",

                  labelStyle:
                  const TextStyle(
                    color:
                    Colors.white70,
                  ),

                  prefixIcon:
                  const Icon(

                    Icons.person,

                    color:
                    Colors.cyan,
                  ),

                  filled: true,

                  fillColor:
                  const Color(
                    0xFF111C30,
                  ),

                  border:
                  OutlineInputBorder(

                    borderRadius:
                    BorderRadius.circular(
                      18,
                    ),

                    borderSide:
                    BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              TextField(

                controller:
                apellidoController,

                style: const TextStyle(
                  color: Colors.white,
                ),

                decoration:
                InputDecoration(

                  labelText: "Apellido",

                  labelStyle:
                  const TextStyle(
                    color:
                    Colors.white70,
                  ),

                  prefixIcon:
                  const Icon(

                    Icons.badge,

                    color:
                    Colors.cyan,
                  ),

                  filled: true,

                  fillColor:
                  const Color(
                    0xFF111C30,
                  ),

                  border:
                  OutlineInputBorder(

                    borderRadius:
                    BorderRadius.circular(
                      18,
                    ),

                    borderSide:
                    BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              TextField(

                controller:
                correoController,

                keyboardType:
                TextInputType
                    .emailAddress,

                style: const TextStyle(
                  color: Colors.white,
                ),

                decoration:
                InputDecoration(

                  labelText: "Correo",

                  labelStyle:
                  const TextStyle(
                    color:
                    Colors.white70,
                  ),

                  prefixIcon:
                  const Icon(

                    Icons.email,

                    color:
                    Colors.cyan,
                  ),

                  filled: true,

                  fillColor:
                  const Color(
                    0xFF111C30,
                  ),

                  border:
                  OutlineInputBorder(

                    borderRadius:
                    BorderRadius.circular(
                      18,
                    ),

                    borderSide:
                    BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              TextField(

                controller:
                passwordController,

                obscureText:
                ocultarPassword,

                style: const TextStyle(
                  color: Colors.white,
                ),

                decoration:
                InputDecoration(

                  labelText:
                  "Contraseña",

                  labelStyle:
                  const TextStyle(
                    color:
                    Colors.white70,
                  ),

                  prefixIcon:
                  const Icon(

                    Icons.lock,

                    color:
                    Colors.cyan,
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
                      Colors.white54,
                    ),
                  ),

                  filled: true,

                  fillColor:
                  const Color(
                    0xFF111C30,
                  ),

                  border:
                  OutlineInputBorder(

                    borderRadius:
                    BorderRadius.circular(
                      18,
                    ),

                    borderSide:
                    BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              Container(

                padding:
                const EdgeInsets.all(15),

                decoration: BoxDecoration(

                  color:
                  Colors.white
                      .withOpacity(0.05),

                  borderRadius:
                  BorderRadius.circular(
                    18,
                  ),
                ),

                child: Row(

                  children: [

                    Checkbox(

                      value:
                      aceptoTerminos,

                      activeColor:
                      Colors.cyan,

                      onChanged: null,
                    ),

                    Expanded(

                      child:
                      GestureDetector(

                        onTap: () async {

                          final result =
                          await Navigator.push(

                            context,

                            MaterialPageRoute(

                              builder: (_) =>
                              const TermsScreen(),
                            ),
                          );

                          if(result == true){

                            setState(() {

                              aceptoTerminos =
                              true;
                            });
                          }
                        },

                        child: const Text(

                          "Leer y aceptar términos y condiciones",

                          style: TextStyle(

                            color:
                            Colors.white70,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              SizedBox(

                width: double.infinity,

                height: 60,

                child: ElevatedButton(

                  style:
                  ElevatedButton
                      .styleFrom(

                    backgroundColor:
                    Colors.cyan,

                    shape:
                    RoundedRectangleBorder(

                      borderRadius:
                      BorderRadius.circular(
                        18,
                      ),
                    ),
                  ),

                  onPressed:

                  loading

                      ? null

                      : register,

                  child:

                  loading

                      ? const CircularProgressIndicator(
                    color:
                    Colors.white,
                  )

                      : const Text(

                    "Continuar",

                    style: TextStyle(

                      fontSize: 20,

                      color:
                      Colors.white,

                      fontWeight:
                      FontWeight.bold,
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