import 'dart:convert';

import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

import 'package:http/http.dart' as http;

class LookScreen extends StatefulWidget {

  const LookScreen({super.key});

  @override
  State<LookScreen> createState() =>
      _LookScreenState();
}

class _LookScreenState
    extends State<LookScreen> {

  File? selfie;

  bool loading = false;

  String corte = "";

  String barba = "";

  String descripcion = "";

  String frontal = "";

  String lateral = "";

  String trasero = "";

  final String geminiApiKey =

      "AIzaSyDvJP--3ENEqYF8NttKa8TiS93f_2Uze88";

  Future<void> tomarSelfie() async {

    final picker = ImagePicker();

    final picked =
    await picker.pickImage(

      source: ImageSource.camera,

      imageQuality: 90,
    );

    if (picked == null) return;

    setState(() {

      selfie = File(picked.path);

      corte = "";

      barba = "";

      descripcion = "";

      frontal = "";

      lateral = "";

      trasero = "";
    });
  }

  Future<void> analizarLook() async {

    if (selfie == null) return;

    setState(() {

      loading = true;
    });

    try {

      final bytes =
      await selfie!.readAsBytes();

      final base64Image =
      base64Encode(bytes);

      final url = Uri.parse(

        "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$geminiApiKey",
      );

      final response =
      await http.post(

        url,

        headers: {

          "Content-Type":
          "application/json",
        },

        body: jsonEncode({

          "contents": [

            {

              "parts": [

                {

                  "text":

                  """
Eres un estilista profesional masculino experto en imagen personal.

Analiza este rostro y recomienda el mejor look.

Responde SOLO JSON válido.

{
"corte":"",
"barba":"",
"descripcion":"",
"frontal":"",
"lateral":"",
"trasero":""
}

descripcion:
explica por qué el estilo favorece el rostro.

frontal:
describe cómo se vería frontalmente.

lateral:
describe cómo se vería de costado.

trasero:
describe cómo se vería desde atrás.

NO uses markdown.
NO uses ```json.
NO expliques fuera del JSON.
"""
                },

                {

                  "inline_data": {

                    "mime_type":
                    "image/jpeg",

                    "data":
                    base64Image,
                  }
                }
              ]
            }
          ]
        }),
      );

      print(response.body);

      final data =
      jsonDecode(response.body);

      if (data["error"] != null) {

        throw Exception(

          data["error"]["message"],
        );
      }

      if (data["candidates"] == null) {

        throw Exception(

          "Gemini no devolvió resultados",
        );
      }

      final text = data

      ["candidates"][0]

      ["content"]["parts"][0]

      ["text"];

      final clean = text

          .replaceAll(
        "```json",
        "",
      )

          .replaceAll(
        "```",
        "",
      )

          .trim();

      print(clean);

      final result =
      jsonDecode(clean);

      setState(() {

        corte =
            result["corte"] ?? "";

        barba =
            result["barba"] ?? "";

        descripcion =
            result["descripcion"] ?? "";

        frontal =
            result["frontal"] ?? "";

        lateral =
            result["lateral"] ?? "";

        trasero =
            result["trasero"] ?? "";
      });

    } catch (e) {

      print(e);

      ScaffoldMessenger.of(context)

          .showSnackBar(

        SnackBar(

          backgroundColor:
          Colors.red,

          content:
          Text(e.toString()),
        ),
      );

    } finally {

      setState(() {

        loading = false;
      });
    }
  }

  Widget card({

    required String title,

    required String value,
  }) {

    return Container(

      width: double.infinity,

      margin:
      const EdgeInsets.only(
        bottom: 15,
      ),

      padding:
      const EdgeInsets.all(20),

      decoration: BoxDecoration(

        color:
        const Color(0xFF111C30),

        borderRadius:
        BorderRadius.circular(25),
      ),

      child: Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Text(

            title,

            style: const TextStyle(

              color: Colors.cyan,

              fontSize: 18,

              fontWeight:
              FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Text(

            value,

            style: const TextStyle(

              color: Colors.white,

              fontSize: 15,

              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xFF071120),

      appBar: AppBar(

        backgroundColor:
        Colors.transparent,

        elevation: 0,

        title: const Text(
          "Look IA",
        ),
      ),

      body: SafeArea(

        child: SingleChildScrollView(

          padding:
          const EdgeInsets.all(20),

          child: Column(

            children: [

              Container(

                height: 350,

                width: double.infinity,

                decoration: BoxDecoration(

                  color:
                  const Color(
                    0xFF111C30,
                  ),

                  borderRadius:
                  BorderRadius.circular(
                    30,
                  ),
                ),

                child:

                selfie == null

                    ? Column(

                  mainAxisAlignment:
                  MainAxisAlignment.center,

                  children: [

                    const Icon(

                      Icons.face,

                      size: 90,

                      color:
                      Colors.white24,
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    ElevatedButton.icon(

                      style:
                      ElevatedButton
                          .styleFrom(

                        backgroundColor:
                        Colors.cyan,
                      ),

                      onPressed:
                      tomarSelfie,

                      icon: const Icon(

                        Icons.camera_alt,

                        color:
                        Colors.white,
                      ),

                      label: const Text(

                        "Tomar selfie",

                        style:
                        TextStyle(
                          color:
                          Colors.white,
                        ),
                      ),
                    ),
                  ],
                )

                    : ClipRRect(

                  borderRadius:
                  BorderRadius.circular(
                    30,
                  ),

                  child: Image.file(

                    selfie!,

                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              if (selfie != null)

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
                        BorderRadius.circular(
                          18,
                        ),
                      ),
                    ),

                    onPressed:

                    loading
                        ? null
                        : analizarLook,

                    child:

                    loading

                        ? const CircularProgressIndicator(
                      color:
                      Colors.white,
                    )

                        : const Text(

                      "Analizar look",

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

              const SizedBox(height: 25),

              if (corte.isNotEmpty)

                card(

                  title:
                  "Corte recomendado",

                  value: corte,
                ),

              if (barba.isNotEmpty)

                card(

                  title:
                  "Barba recomendada",

                  value: barba,
                ),

              if (descripcion.isNotEmpty)

                card(

                  title:
                  "Descripción IA",

                  value: descripcion,
                ),

              if (frontal.isNotEmpty)

                card(

                  title:
                  "Vista frontal",

                  value: frontal,
                ),

              if (lateral.isNotEmpty)

                card(

                  title:
                  "Vista lateral",

                  value: lateral,
                ),

              if (trasero.isNotEmpty)

                card(

                  title:
                  "Vista trasera",

                  value: trasero,
                ),
            ],
          ),
        ),
      ),
    );
  }
}