// edit_profile_screen.dart

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:image_picker/image_picker.dart';

import '../../services/local_image_service.dart';

class EditProfileScreen extends StatefulWidget {

  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState
    extends State<EditProfileScreen> {

  final nombreController =
  TextEditingController();

  final apellidoController =
  TextEditingController();

  final apodoController =
  TextEditingController();

  final pesoController =
  TextEditingController();

  final alturaController =
  TextEditingController();

  final objetivoController =
  TextEditingController();

  String experiencia =
      "Principiante";

  String frecuencia =
      "1-2 días";

  File? imagen;

  bool loading = true;

  @override
  void initState() {

    super.initState();

    cargarDatos();
  }

  Future<void> cargarDatos() async {

    try {

      final uid =
          FirebaseAuth
              .instance
              .currentUser!
              .uid;

      final doc =
      await FirebaseFirestore
          .instance
          .collection("usuarios")
          .doc(uid)
          .get();

      final data = doc.data();

      if(data != null){

        nombreController.text =
            data["nombre"] ?? "";

        apellidoController.text =
            data["apellido"] ?? "";

        apodoController.text =
            data["apodo"] ?? "";

        pesoController.text =
            data["peso"]?.toString() ?? "";

        alturaController.text =
            data["altura"]?.toString() ?? "";

        objetivoController.text =
            data["objetivo"] ?? "";

        experiencia =
            data["experiencia"] ??
                "Principiante";

        frecuencia =
            data["frecuencia"] ??
                "1-2 días";

        if(data["fotoPerfil"] != null){

          final file =
          File(data["fotoPerfil"]);

          if(await file.exists()){

            imagen = file;
          }
        }
      }

      if(!mounted) return;

      setState(() {

        loading = false;
      });

    } catch(e){

      print(e);
    }
  }
  Future<void> seleccionarImagen() async {

    try {

      final picker = ImagePicker();

      final picked =
      await picker.pickImage(

        source: ImageSource.gallery,

        imageQuality: 40,

        maxWidth: 600,
      );

      if (picked == null) return;

      final file =
      File(picked.path);

      if (!mounted) return;

      setState(() {

        imagen = file;
      });

    } catch (e) {

      print(e);
    }
  }


  Future<void> guardarPerfil() async {

    try {

      final uid =
          FirebaseAuth
              .instance
              .currentUser!
              .uid;

      String fotoPath = "";

      if(imagen != null){

        fotoPath =
        await LocalImageService
            .guardarImagen(

          imagen!,
          uid,
        );
      }

      await FirebaseFirestore
          .instance
          .collection("usuarios")
          .doc(uid)
          .update({

        "nombre":
        nombreController.text.trim(),

        "apellido":
        apellidoController.text.trim(),

        "apodo":
        apodoController.text.trim(),

        "peso":
        pesoController.text.trim(),

        "altura":
        alturaController.text.trim(),

        "objetivo":
        objetivoController.text.trim(),

        "experiencia":
        experiencia,

        "frecuencia":
        frecuencia,

        "fotoPerfil":
        fotoPath,
      });

      if(!mounted) return;

      Navigator.pop(
        context,
        true,
      );

    } catch(e){

      print(e);

      ScaffoldMessenger.of(context)

          .showSnackBar(

        SnackBar(
          content: Text("$e"),
        ),
      );
    }
  }

  Widget campo({

    required String hint,

    required TextEditingController controller,
  }) {

    return Padding(

      padding:
      const EdgeInsets.only(
        bottom: 18,
      ),

      child: TextField(

        controller: controller,

        style: const TextStyle(
          color: Colors.white,
        ),

        decoration: InputDecoration(

          hintText: hint,

          hintStyle: const TextStyle(
            color: Colors.white38,
          ),

          filled: true,

          fillColor:
          Colors.white.withOpacity(0.05),

          border:
          OutlineInputBorder(

            borderRadius:
            BorderRadius.circular(18),

            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    if(loading){

      return const Scaffold(

        backgroundColor:
        Color(0xFF050B18),

        body: Center(

          child:
          CircularProgressIndicator(
            color: Colors.cyan,
          ),
        ),
      );
    }

    return Scaffold(

      backgroundColor:
      const Color(0xFF050B18),

      appBar: AppBar(

        backgroundColor:
        Colors.transparent,

        elevation: 0,

        title: const Text(

          "Editar Perfil",

          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      body: SingleChildScrollView(

        padding:
        const EdgeInsets.all(20),

        child: Column(

          children: [

            GestureDetector(

              onTap:
              seleccionarImagen,

              child: CircleAvatar(

                radius: 70,

                backgroundColor:
                Colors.white12,

                backgroundImage:

                imagen != null

                    ? MemoryImage(
                  imagen!
                      .readAsBytesSync(),
                )

                    : null,

                child:

                imagen == null
                    ? const Icon(

                  Icons.camera_alt,

                  size: 40,

                  color:
                  Colors.white,
                )

                    : null,
              ),
            ),

            const SizedBox(height: 25),

            campo(
              hint: "Nombre",
              controller:
              nombreController,
            ),

            campo(
              hint: "Apellido",
              controller:
              apellidoController,
            ),

            campo(
              hint: "Apodo",
              controller:
              apodoController,
            ),

            campo(
              hint: "Peso",
              controller:
              pesoController,
            ),

            campo(
              hint: "Altura",
              controller:
              alturaController,
            ),

            campo(
              hint: "Objetivo",
              controller:
              objetivoController,
            ),

            DropdownButtonFormField(

              value: experiencia,

              dropdownColor:
              const Color(0xFF111827),

              style: const TextStyle(
                color: Colors.white,
              ),

              decoration: InputDecoration(

                filled: true,

                fillColor:
                Colors.white.withOpacity(0.05),

                border:
                OutlineInputBorder(

                  borderRadius:
                  BorderRadius.circular(18),

                  borderSide:
                  BorderSide.none,
                ),
              ),

              items: const [

                DropdownMenuItem(
                  value: "Principiante",
                  child:
                  Text("Principiante"),
                ),

                DropdownMenuItem(
                  value: "Intermedio",
                  child:
                  Text("Intermedio"),
                ),

                DropdownMenuItem(
                  value: "Avanzado",
                  child:
                  Text("Avanzado"),
                ),
              ],

              onChanged: (v){

                setState(() {

                  experiencia =
                      v.toString();
                });
              },
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField(

              value: frecuencia,

              dropdownColor:
              const Color(0xFF111827),

              style: const TextStyle(
                color: Colors.white,
              ),

              decoration: InputDecoration(

                filled: true,

                fillColor:
                Colors.white.withOpacity(0.05),

                border:
                OutlineInputBorder(

                  borderRadius:
                  BorderRadius.circular(18),

                  borderSide:
                  BorderSide.none,
                ),
              ),

              items: const [

                DropdownMenuItem(
                  value: "1-2 días",
                  child:
                  Text("1-2 días"),
                ),

                DropdownMenuItem(
                  value: "3-4 días",
                  child:
                  Text("3-4 días"),
                ),

                DropdownMenuItem(
                  value: "5-6 días",
                  child:
                  Text("5-6 días"),
                ),
              ],

              onChanged: (v){

                setState(() {

                  frecuencia =
                      v.toString();
                });
              },
            ),

            const SizedBox(height: 30),

            SizedBox(

              width: double.infinity,

              height: 55,

              child: ElevatedButton(

                style:
                ElevatedButton.styleFrom(

                  backgroundColor:
                  Colors.cyan,
                ),

                onPressed:
                guardarPerfil,

                child: const Text(

                  "Guardar Cambios",

                  style: TextStyle(

                    color: Colors.white,

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
    );
  }
}