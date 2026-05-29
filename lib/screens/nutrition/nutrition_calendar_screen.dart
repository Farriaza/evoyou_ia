import 'package:flutter/material.dart';

class NutritionCalendarScreen
    extends StatelessWidget {

  const NutritionCalendarScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return ListView(

      padding: const EdgeInsets.all(20),

      children: const [

        _MealTimeCard(
          "08:00",
          "Desayuno",
        ),

        _MealTimeCard(
          "13:00",
          "Almuerzo",
        ),

        _MealTimeCard(
          "17:00",
          "Snack",
        ),

        _MealTimeCard(
          "21:00",
          "Cena",
        ),
      ],
    );
  }
}

class _MealTimeCard
    extends StatelessWidget {

  final String hour;
  final String title;

  const _MealTimeCard(
      this.hour,
      this.title,
      );

  @override
  Widget build(BuildContext context) {

    return Container(

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
        BorderRadius.circular(22),
      ),

      child: Row(

        children: [

          Text(

            hour,

            style:
            const TextStyle(

              color:
              Color(0xFF00C6FF),

              fontWeight:
              FontWeight.bold,

              fontSize: 18,
            ),
          ),

          const SizedBox(width: 20),

          Text(

            title,

            style:
            const TextStyle(

              color: Colors.white,

              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}