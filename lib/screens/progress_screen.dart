import 'package:flutter/material.dart';

class ProgressScreen extends StatefulWidget {

  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() =>
      _ProgressScreenState();
}

class _ProgressScreenState
    extends State<ProgressScreen> {

  // DATOS EJEMPLO

  final double pesoInicial = 92;

  final double pesoActual = 82;

  final double grasaInicial = 28;

  final double grasaActual = 18;

  final double masaInicial = 34;

  final double masaActual = 41;

  double calcularCambio(
      double inicial,
      double actual,
      ) {

    return actual - inicial;
  }

  Widget progressCard({

    required String title,

    required IconData icon,

    required Color color,

    required String initial,

    required String current,

    required String result,
  }) {

    return Container(

      margin: const EdgeInsets.only(
        bottom: 18,
      ),

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(

        color: const Color(0xFF111C30),

        borderRadius:
        BorderRadius.circular(25),

        border: Border.all(
          color: Colors.white10,
        ),
      ),

      child: Column(

        children: [

          Row(

            children: [

              Container(

                width: 65,

                height: 65,

                decoration: BoxDecoration(

                  color:
                  color.withOpacity(0.15),

                  borderRadius:
                  BorderRadius.circular(
                    18,
                  ),
                ),

                child: Icon(

                  icon,

                  color: color,

                  size: 34,
                ),
              ),

              const SizedBox(width: 18),

              Expanded(

                child: Column(

                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    Text(

                      title,

                      style:
                      const TextStyle(

                        color:
                        Colors.white,

                        fontSize: 20,

                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(

                      "Antes vs Actual",

                      style:
                      TextStyle(

                        color:
                        Colors.white
                            .withOpacity(0.6),

                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          Row(

            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

            children: [

              progressInfo(
                "Inicio",
                initial,
              ),

              const Icon(

                Icons.arrow_forward,

                color: Colors.white38,
              ),

              progressInfo(
                "Actual",
                current,
              ),

              const Icon(

                Icons.trending_up,

                color: Colors.greenAccent,
              ),

              progressInfo(
                "Cambio",
                result,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget progressInfo(
      String label,
      String value,
      ) {

    return Column(

      children: [

        Text(

          label,

          style: const TextStyle(
            color: Colors.white54,
            fontSize: 13,
          ),
        ),

        const SizedBox(height: 5),

        Text(

          value,

          style: const TextStyle(

            color: Colors.white,

            fontSize: 18,

            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    final pesoCambio =
    calcularCambio(
      pesoInicial,
      pesoActual,
    );

    final grasaCambio =
    calcularCambio(
      grasaInicial,
      grasaActual,
    );

    final masaCambio =
    calcularCambio(
      masaInicial,
      masaActual,
    );

    return Scaffold(

      backgroundColor:
      const Color(0xFF071120),

      appBar: AppBar(

        backgroundColor: Colors.transparent,

        elevation: 0,

        centerTitle: true,

        title: const Text(

          "Progreso",

          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(18),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            // HEADER

            Container(

              width: double.infinity,

              padding: const EdgeInsets.all(25),

              decoration: BoxDecoration(

                borderRadius:
                BorderRadius.circular(28),

                gradient: const LinearGradient(

                  colors: [
                    Color(0xFF00C6FF),
                    Color(0xFF0072FF),
                  ],
                ),
              ),

              child: const Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  Icon(

                    Icons.insights,

                    color: Colors.white,

                    size: 50,
                  ),

                  SizedBox(height: 15),

                  Text(

                    "Tu Evolución",

                    style: TextStyle(

                      color: Colors.white,

                      fontSize: 32,

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 8),

                  Text(

                    "Compara cómo comenzaste y cómo vas actualmente.",

                    style: TextStyle(

                      color: Colors.white70,

                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // PESO

            progressCard(

              title: "Peso",

              icon: Icons.monitor_weight,

              color: Colors.orange,

              initial:
              "${pesoInicial.toStringAsFixed(1)} KG",

              current:
              "${pesoActual.toStringAsFixed(1)} KG",

              result:
              "${pesoCambio.toStringAsFixed(1)} KG",
            ),

            // GRASA

            progressCard(

              title: "Grasa Corporal",

              icon: Icons.local_fire_department,

              color: Colors.redAccent,

              initial:
              "${grasaInicial.toStringAsFixed(1)}%",

              current:
              "${grasaActual.toStringAsFixed(1)}%",

              result:
              "${grasaCambio.toStringAsFixed(1)}%",
            ),

            // MASA MUSCULAR

            progressCard(

              title: "Masa Muscular",

              icon: Icons.fitness_center,

              color: Colors.cyan,

              initial:
              "${masaInicial.toStringAsFixed(1)} KG",

              current:
              "${masaActual.toStringAsFixed(1)} KG",

              result:
              "+${masaCambio.toStringAsFixed(1)} KG",
            ),
          ],
        ),
      ),
    );
  }
}