import 'package:flutter/material.dart';

import 'widgets/day_selector.dart';
import 'widgets/meal_card.dart';
import 'widgets/nutrition_summary_card.dart';

class NutritionMenuScreen extends StatefulWidget {

  const NutritionMenuScreen({super.key});

  @override
  State<NutritionMenuScreen>
  createState() =>
      _NutritionMenuScreenState();
}

class _NutritionMenuScreenState
    extends State<NutritionMenuScreen> {

  int selectedDay = 3;

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(

      padding: const EdgeInsets.all(20),

      child: Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          DaySelector(

            selectedIndex:
            selectedDay,

            onSelected: (value) {

              setState(() {

                selectedDay =
                    value;
              });
            },
          ),

          const SizedBox(height: 20),

          const NutritionSummaryCard(

            objective:
            "Perder peso",

            calories: 1600,

            protein: 120,
          ),

          const SizedBox(height: 30),

          MealCard(

            title:
            "Desayuno",

            subtitle:
            "Huevos con espinaca",

            calories: 320,

            icon:
            Icons.breakfast_dining,

            onTap: () {},
          ),

          MealCard(

            title:
            "Almuerzo",

            subtitle:
            "Pollo con ensalada",

            calories: 480,

            icon:
            Icons.lunch_dining,

            onTap: () {},
          ),

          MealCard(

            title:
            "Snack",

            subtitle:
            "Yogurt griego",

            calories: 120,

            icon:
            Icons.apple,

            onTap: () {},
          ),

          MealCard(

            title:
            "Cena",

            subtitle:
            "Atún con verduras",

            calories: 390,

            icon:
            Icons.dinner_dining,

            onTap: () {},
          ),
        ],
      ),
    );
  }
}