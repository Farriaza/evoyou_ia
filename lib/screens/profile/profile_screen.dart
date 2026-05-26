// profile_screen.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {

  Map<String, dynamic>? data;

  bool loading = true;

  @override
  void initState() {

    super.initState();

    cargar();
  }

  Future<void> cargar() async {

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

      if (!mounted) return;

      setState(() {

        data = doc.data();

        loading = false;
      });

    } catch (e) {

      print(e);
    }
  }

  Widget info(
      String titulo,
      String valor,
      ) {

    return Container(

      margin:
      const EdgeInsets.only(
        bottom: 20,
      ),

      padding:
      const EdgeInsets.all(20),

      decoration: BoxDecoration(

        color:
        Colors.white.withOpacity(0.05),

        borderRadius:
        BorderRadius.circular(20),
      ),

      child: Row(

        mainAxisAlignment:
        MainAxisAlignment
            .spaceBetween,

        children: [

          Text(

            titulo,

            style: const TextStyle(

              color:
              Colors.white70,

              fontSize: 18,
            ),
          ),

          Flexible(

            child: Text(

              valor,

              textAlign:
              TextAlign.end,

              style: const TextStyle(

                color:
                Colors.white,

                fontWeight:
                FontWeight.bold,

                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void>
  abrirEditarPerfil() async {

    final actualizado =
    await Navigator.push(

      context,

      MaterialPageRoute(

        builder: (_) =>
        const EditProfileScreen(),
      ),
    );

    if (actualizado == true) {

      await cargar();
    }
  }

  @override
  Widget build(BuildContext context) {

    if (loading) {

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

          "Perfil",

          style: TextStyle(
            color: Colors.white,
          ),
        ),

        actions: [

          IconButton(

            onPressed:
            abrirEditarPerfil,

            icon: const Icon(

              Icons.edit,

              color: Colors.cyan,
            ),
          ),
        ],
      ),

      body: SingleChildScrollView(

        padding:
        const EdgeInsets.all(25),

        child: Column(

          children: [

            Container(

              padding:
              const EdgeInsets.all(4),

              decoration: BoxDecoration(

                shape:
                BoxShape.circle,

                border: Border.all(

                  color:
                  Colors.cyan,

                  width: 3,
                ),
              ),

              child: CircleAvatar(

                key: UniqueKey(),

                radius: 75,

                backgroundColor:
                Colors.white12,

                backgroundImage:

                data?["fotoPerfil"] !=
                    null &&
                    data!["fotoPerfil"]
                        .toString()
                        .isNotEmpty &&
                    File(
                      data!["fotoPerfil"],
                    ).existsSync()

                    ? MemoryImage(

                  File(
                    data!["fotoPerfil"],
                  ).readAsBytesSync(),
                )

                    : null,

                child:

                data?["fotoPerfil"] ==
                    null ||

                    data!["fotoPerfil"]
                        .toString()
                        .isEmpty ||

                    !File(
                      data!["fotoPerfil"],
                    ).existsSync()

                    ? const Icon(

                  Icons.person,

                  size: 70,

                  color:
                  Colors.white,
                )

                    : null,
              ),
            ),

            const SizedBox(height: 20),

            Text(

              data?["apodo"] ??
                  "Sin apodo",

              style: const TextStyle(

                color: Colors.white,

                fontSize: 32,

                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(

              "${data?["nombre"] ?? ""} ${data?["apellido"] ?? ""}",

              style: const TextStyle(

                color:
                Colors.white70,

                fontSize: 18,
              ),
            ),

            const SizedBox(height: 10),

            Text(

              FirebaseAuth
                  .instance
                  .currentUser
                  ?.email ??
                  "",

              style: const TextStyle(

                color:
                Colors.white38,

                fontSize: 14,
              ),
            ),

            const SizedBox(height: 40),

            info(

              "Objetivo",

              data?["objetivo"] ??
                  "No definido",
            ),

            info(

              "Peso",

              "${data?["peso"] ?? "0"} KG",
            ),

            info(

              "Altura",

              "${data?["altura"] ?? "0"} CM",
            ),

            info(

              "Experiencia",

              data?["experiencia"] ??
                  "Principiante",
            ),

            info(

              "Frecuencia",

              data?["frecuencia"] ??
                  "1-2 días",
            ),

            const SizedBox(height: 25),

            SizedBox(

              width: double.infinity,

              height: 55,

              child:
              ElevatedButton.icon(

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
                abrirEditarPerfil,

                icon: const Icon(

                  Icons.edit,

                  color: Colors.white,
                ),

                label: const Text(

                  "Editar Perfil",

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
    );
  }
}