import 'dart:io';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:image_picker/image_picker.dart';

import '../../services/local_image_service.dart';

import '../home/home_screen.dart';

class CompleteProfileScreen extends StatefulWidget {

  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() =>
      _CompleteProfileScreenState();
}

class _CompleteProfileScreenState
    extends State<CompleteProfileScreen> {

  final apodoController =
  TextEditingController();

  final pesoController =
  TextEditingController();

  final alturaController =
  TextEditingController();

  String nombre = "";

  String apellido = "";

  String objetivoSeleccionado =
      "Ganar masa muscular";

  String experienciaSeleccionada =
      "Principiante";

  String frecuenciaSeleccionada =
      "1-2 días";

  File? imagen;

  bool loading = false;

  @override
  void initState() {

    super.initState();

    cargarUsuario();
  }

  Future<void> cargarUsuario() async {

    final user =
        FirebaseAuth.instance.currentUser;

    if(user == null) return;

    final doc =
    await FirebaseFirestore.instance
        .collection("usuarios")
        .doc(user.uid)
        .get();

    final data = doc.data();

    if(data == null) return;

    setState(() {

      nombre =
          data["nombre"] ?? "";

      apellido =
          data["apellido"] ?? "";
    });
  }

  Future<void> seleccionarImagen() async {

    final picker = ImagePicker();

    final picked = await picker.pickImage(

      source: ImageSource.gallery,

      imageQuality: 80,
    );

    if (picked == null) return;

    setState(() {

      imagen = File(picked.path);
    });
  }

  Future<void> guardarPerfil() async {

    try {

      setState(() {

        loading = true;
      });

      final user =
          FirebaseAuth.instance.currentUser;

      if (user == null) return;

      String fotoPath = "";

      if (imagen != null) {

        final path =
        await LocalImageService
            .guardarImagen(

          imagen!,

          user.uid,
        );

        fotoPath = path;
      }

      await FirebaseFirestore.instance

          .collection("usuarios")

          .doc(user.uid)

          .update({

        "nombre": nombre,

        "apellido": apellido,

        "apodo":
        apodoController.text.trim(),

        "peso":
        pesoController.text.trim(),

        "altura":
        alturaController.text.trim(),

        "objetivo":
        objetivoSeleccionado,

        "experiencia":
        experienciaSeleccionada,

        "frecuencia":
        frecuenciaSeleccionada,

        "correo": user.email,

        "fotoPerfil": fotoPath,

        "perfilCompleto": true,

        "creado":
        DateTime.now(),
      });

      if (!mounted) return;

      Navigator.pushReplacement(

        context,

        MaterialPageRoute(
          builder: (_) =>
          const HomeScreen(),
        ),
      );

    } catch (e) {

      ScaffoldMessenger.of(context)

          .showSnackBar(

        SnackBar(

          backgroundColor: Colors.red,

          content: Text(
            e.toString(),
          ),
        ),
      );

    } finally {

      setState(() {

        loading = false;
      });
    }
  }

  Widget campo(

      String texto,

      TextEditingController controller, {

        TextInputType tipo =
            TextInputType.text,

        String sufijo = "",
      }) {

    return Padding(

      padding:
      const EdgeInsets.only(bottom: 20),

      child: TextField(

        controller: controller,

        keyboardType: tipo,

        style: const TextStyle(
          color: Colors.white,
        ),

        decoration: InputDecoration(

          labelText: texto,

          suffixText:
          sufijo.isNotEmpty
              ? sufijo
              : null,

          suffixStyle:
          const TextStyle(
            color: Colors.white54,
          ),

          labelStyle:
          const TextStyle(
            color: Colors.white70,
          ),

          filled: true,

          fillColor:
          const Color(0xFF111C30),

          border:
          OutlineInputBorder(

            borderRadius:
            BorderRadius.circular(18),

            borderSide:
            BorderSide.none,
          ),

          enabledBorder:
          OutlineInputBorder(

            borderRadius:
            BorderRadius.circular(18),

            borderSide:
            BorderSide.none,
          ),

          focusedBorder:
          OutlineInputBorder(

            borderRadius:
            BorderRadius.circular(18),

            borderSide:
            const BorderSide(
              color: Colors.cyan,
            ),
          ),
        ),
      ),
    );
  }

  Widget tituloDropdown(String texto) {

    return Padding(

      padding:
      const EdgeInsets.only(
        bottom: 10,
        left: 5,
      ),

      child: Align(

        alignment:
        Alignment.centerLeft,

        child: Text(

          texto,

          style: const TextStyle(

            color: Colors.white70,

            fontSize: 15,

            fontWeight:
            FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget dropdownBox({

    required String value,

    required List<String> items,

    required Function(String?)
    onChanged,
  }) {

    return Container(

      margin:
      const EdgeInsets.only(
        bottom: 20,
      ),

      padding:
      const EdgeInsets.symmetric(
        horizontal: 20,
      ),

      decoration: BoxDecoration(

        color:
        const Color(0xFF111C30),

        borderRadius:
        BorderRadius.circular(18),
      ),

      child:
      DropdownButtonHideUnderline(

        child:
        DropdownButton<String>(

          value: value,

          dropdownColor:
          const Color(
            0xFF111C30,
          ),

          style:
          const TextStyle(
            color: Colors.white,
          ),

          isExpanded: true,

          items:
          items.map((item) {

            return DropdownMenuItem(

              value: item,

              child: Text(item),
            );
          }).toList(),

          onChanged: onChanged,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xFF071120),

      body: SafeArea(

        child: SingleChildScrollView(

          padding:
          const EdgeInsets.all(30),

          child: Column(

            children: [

              const SizedBox(height: 10),

              const Text(

                "Completa tu perfil",

                style: TextStyle(

                  color: Colors.white,

                  fontSize: 34,

                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              Text(

                "$nombre $apellido",

                style: const TextStyle(

                  color: Colors.white70,

                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 35),

              GestureDetector(

                onTap: seleccionarImagen,

                child: Container(

                  padding:
                  const EdgeInsets.all(4),

                  decoration: BoxDecoration(

                    shape:
                    BoxShape.circle,

                    border: Border.all(
                      color: Colors.cyan,
                      width: 3,
                    ),
                  ),

                  child: CircleAvatar(

                    radius: 65,

                    backgroundColor:
                    Colors.white12,

                    backgroundImage:
                    imagen != null

                        ? FileImage(imagen!)

                        : null,

                    child:
                    imagen == null

                        ? const Icon(

                      Icons.camera_alt,

                      color:
                      Colors.white,

                      size: 40,
                    )

                        : null,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              const Text(

                "Agregar foto",

                style: TextStyle(

                  color: Colors.white54,

                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 40),

              campo(
                "Apodo",
                apodoController,
              ),

              campo(

                "Peso",

                pesoController,

                tipo:
                TextInputType.number,

                sufijo: "KG",
              ),

              campo(

                "Altura",

                alturaController,

                tipo:
                TextInputType.number,

                sufijo: "CM",
              ),

              tituloDropdown(
                "Objetivo",
              ),

              dropdownBox(

                value:
                objetivoSeleccionado,

                items: const [

                  "Ganar masa muscular",

                  "Definir",

                  "Perder peso",
                ],

                onChanged: (value) {

                  setState(() {

                    objetivoSeleccionado =
                    value!;
                  });
                },
              ),

              tituloDropdown(
                "Experiencia",
              ),

              dropdownBox(

                value:
                experienciaSeleccionada,

                items: const [

                  "Principiante",

                  "Intermedio",

                  "Avanzado",
                ],

                onChanged: (value) {

                  setState(() {

                    experienciaSeleccionada =
                    value!;
                  });
                },
              ),

              tituloDropdown(
                "Frecuencia semanal",
              ),

              dropdownBox(

                value:
                frecuenciaSeleccionada,

                items: const [

                  "1-2 días",

                  "3-4 días",

                  "5+ días",
                ],

                onChanged: (value) {

                  setState(() {

                    frecuenciaSeleccionada =
                    value!;
                  });
                },
              ),

              const SizedBox(height: 35),

              SizedBox(

                width: double.infinity,

                height: 58,

                child: ElevatedButton(

                  style:
                  ElevatedButton
                      .styleFrom(

                    backgroundColor:
                    Colors.cyan,

                    shape:
                    RoundedRectangleBorder(

                      borderRadius:
                      BorderRadius
                          .circular(18),
                    ),
                  ),

                  onPressed:
                  loading
                      ? null
                      : guardarPerfil,

                  child: loading

                      ? const CircularProgressIndicator(
                    color:
                    Colors.white,
                  )

                      : const Text(

                    "Guardar perfil",

                    style: TextStyle(

                      color:
                      Colors.white,

                      fontSize: 18,

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