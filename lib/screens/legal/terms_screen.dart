import 'package:flutter/material.dart';
import '../../app_theme.dart';

class TermsScreen extends StatelessWidget {

  const TermsScreen({super.key});

  Widget titulo(String text){

    return Padding(

      padding:
      const EdgeInsets.only(
        bottom: 10,
        top: 25,
      ),

      child: Align(

        alignment:
        Alignment.centerLeft,

        child: Text(

          text,

          style: const TextStyle(

            color: AppColors.accent,

            fontSize: 20,

            fontWeight:
            FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget texto(String text){

    return Text(

      text,

      style: const TextStyle(

        color: AppColors.textMuted,

        fontSize: 15,

        height: 1.6,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      AppColors.bgPrimary,

      appBar: AppBar(

        backgroundColor:
        Colors.transparent,

        elevation: 0,

        title:
        const Text(
          "Términos y condiciones",
        ),
      ),

      body: SafeArea(

        child: Column(

          children: [

            Expanded(

              child: SingleChildScrollView(

                padding:
                const EdgeInsets.all(25),

                child: Column(

                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    const Text(

                      "EvoYou AI",

                      style: TextStyle(

                        color: AppColors.textPrimary,

                        fontSize: 34,

                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    texto(

                      "Al utilizar EvoYou AI, el usuario acepta los siguientes términos, condiciones y políticas de uso.",
                    ),

                    titulo(
                      "Uso de la aplicación",
                    ),

                    texto(

                      "EvoYou AI es una aplicación orientada al bienestar físico, entrenamiento, running, recomendaciones fitness y análisis estéticos mediante inteligencia artificial.",
                    ),

                    titulo(
                      "Disclaimer médico",
                    ),

                    texto(

                      "La aplicación NO reemplaza médicos, nutricionistas, entrenadores personales ni profesionales de la salud. Toda recomendación entregada debe considerarse únicamente informativa.",
                    ),

                    titulo(
                      "Inteligencia artificial",
                    ),

                    texto(

                      "Las recomendaciones generadas mediante inteligencia artificial pueden contener errores, imprecisiones o resultados no esperados.",
                    ),

                    titulo(
                      "Responsabilidad del usuario",
                    ),

                    texto(

                      "El uso de la aplicación es responsabilidad exclusiva del usuario. EvoYou AI no garantiza resultados físicos, médicos ni estéticos.",
                    ),

                    titulo(
                      "Privacidad",
                    ),

                    texto(

                      "La aplicación puede almacenar información como fotografías, objetivos fitness, running, ubicación GPS y estadísticas para mejorar la experiencia del usuario.",
                    ),

                    titulo(
                      "Aceptación",
                    ),

                    texto(

                      "Al continuar, el usuario declara haber leído y aceptado los términos y condiciones de EvoYou AI.",
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),

            Padding(

              padding:
              const EdgeInsets.all(25),

              child: SizedBox(

                width: double.infinity,

                height: 58,

                child: ElevatedButton(

                  style:
                  ElevatedButton.styleFrom(

                    backgroundColor:
                    AppColors.accent,

                    shape:
                    RoundedRectangleBorder(

                      borderRadius:
                      BorderRadius.circular(
                        18,
                      ),
                    ),
                  ),

                  onPressed: () {

                    Navigator.pop(
                      context,
                      true,
                    );
                  },

                  child: const Text(

                    "Acepto",

                    style: TextStyle(

                      color: AppColors.textPrimary,

                      fontSize: 18,

                      fontWeight:
                      FontWeight.bold,
                    ),
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