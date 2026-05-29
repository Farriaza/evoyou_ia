import 'package:flutter/material.dart';

class NutritionSummaryCard extends StatelessWidget {

  final String objective;

  final int calories;

  final int protein;

  const NutritionSummaryCard({

    super.key,

    required this.objective,

    required this.calories,

    required this.protein,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      width: double.infinity,

      padding: const EdgeInsets.all(25),

      decoration: BoxDecoration(

        color: const Color(0xFF111C30),

        borderRadius:
        BorderRadius.circular(30),
      ),

      child: Column(

        children: [

          const CircleAvatar(

            radius: 40,

            backgroundColor:
            Color(0x2200C6FF),

            child: Icon(

              Icons.restaurant,

              color: Color(0xFF00C6FF),

              size: 40,
            ),
          ),

          const SizedBox(height: 25),

          const Text(

            "Plan del Día",

            style: TextStyle(

              color: Colors.white,

              fontSize: 32,

              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Text(

            objective,

            style: const TextStyle(

              color: Colors.white70,

              fontSize: 18,
            ),
          ),

          const SizedBox(height: 30),

          Row(

            mainAxisAlignment:
            MainAxisAlignment.spaceEvenly,

            children: [

              _item(
                "$calories",
                "Kcal",
              ),

              _item(
                "$protein g",
                "Proteína",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _item(
      String value,
      String title,
      ) {

    return Column(

      children: [

        Text(

          value,

          style: const TextStyle(

            color: Colors.white,

            fontSize: 24,

            fontWeight: FontWeight.bold,
          ),
        ),

        Text(

          title,

          style: const TextStyle(

            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}