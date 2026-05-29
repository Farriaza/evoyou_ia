import 'package:flutter/material.dart';

class EvoYouPlanScreen extends StatelessWidget {

  const EvoYouPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(

      padding: const EdgeInsets.all(20),

      child: Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Container(

            width: double.infinity,

            padding: const EdgeInsets.all(25),

            decoration: BoxDecoration(

              color: const Color(0xFF111C30),

              borderRadius:
              BorderRadius.circular(30),
            ),

            child: const Column(

              children: [

                Icon(

                  Icons.auto_awesome,

                  color: Color(0xFF00C6FF),

                  size: 50,
                ),

                SizedBox(height: 15),

                Text(

                  "Plan EvoYou",

                  style: TextStyle(

                    color: Colors.white,

                    fontSize: 28,

                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                SizedBox(height: 10),

                Text(

                  "Plan personalizado generado según tu perfil.",

                  textAlign:
                  TextAlign.center,

                  style: TextStyle(

                    color:
                    Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          _dayCard("Lunes"),
          _dayCard("Martes"),
          _dayCard("Miércoles"),
          _dayCard("Jueves"),
          _dayCard("Viernes"),
          _dayCard("Sábado"),
          _dayCard("Domingo"),
        ],
      ),
    );
  }

  Widget _dayCard(String day) {

    return Container(

      margin:
      const EdgeInsets.only(
        bottom: 15,
      ),

      padding:
      const EdgeInsets.all(18),

      decoration: BoxDecoration(

        color:
        const Color(0xFF111C30),

        borderRadius:
        BorderRadius.circular(20),
      ),

      child: Row(

        children: [

          const Icon(

            Icons.calendar_today,

            color: Color(0xFF00C6FF),
          ),

          const SizedBox(width: 12),

          Expanded(

            child: Text(

              day,

              style:
              const TextStyle(

                color: Colors.white,

                fontWeight:
                FontWeight.bold,

                fontSize: 18,
              ),
            ),
          ),

          const Icon(

            Icons.arrow_forward_ios,

            color: Colors.white54,
          ),
        ],
      ),
    );
  }
}