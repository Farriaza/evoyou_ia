import 'package:flutter/material.dart';

import 'nutrition_menu_screen.dart';
import 'evoyou_plan_screen.dart';
import 'shopping_list_screen.dart';
import 'nutrition_calendar_screen.dart';

class NutritionScreen extends StatefulWidget {

  const NutritionScreen({super.key});

  @override
  State<NutritionScreen> createState() =>
      _NutritionScreenState();
}

class _NutritionScreenState
    extends State<NutritionScreen> {

  int selectedTab = 0;

  final List<Widget> pages = const [

    NutritionMenuScreen(),

    EvoYouPlanScreen(),

    ShoppingListScreen(),

    NutritionCalendarScreen(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFF071120),

      appBar: AppBar(

        backgroundColor: const Color(0xFF071120),

        elevation: 0,

        centerTitle: true,

        title: const Text(

          "Nutrición",

          style: TextStyle(

            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Column(

        children: [

          Container(

            margin: const EdgeInsets.all(16),

            padding: const EdgeInsets.all(6),

            decoration: BoxDecoration(

              color: const Color(0xFF111C30),

              borderRadius:
              BorderRadius.circular(20),
            ),

            child: Row(

              children: [

                _tabButton(
                  index: 0,
                  title: "Menú",
                  icon: Icons.restaurant_menu,
                ),

                _tabButton(
                  index: 1,
                  title: "Plan",
                  icon: Icons.auto_awesome,
                ),

                _tabButton(
                  index: 2,
                  title: "Compras",
                  icon: Icons.shopping_cart,
                ),

                _tabButton(
                  index: 3,
                  title: "Calendario",
                  icon: Icons.calendar_month,
                ),
              ],
            ),
          ),

          Expanded(
            child: pages[selectedTab],
          ),
        ],
      ),
    );
  }

  Widget _tabButton({

    required int index,

    required String title,

    required IconData icon,
  }) {

    final selected =
        selectedTab == index;

    return Expanded(

      child: GestureDetector(

        onTap: () {

          setState(() {

            selectedTab = index;
          });
        },

        child: AnimatedContainer(

          duration:
          const Duration(milliseconds: 250),

          padding:
          const EdgeInsets.symmetric(
            vertical: 12,
          ),

          decoration: BoxDecoration(

            color: selected
                ? const Color(0xFF00C6FF)
                : Colors.transparent,

            borderRadius:
            BorderRadius.circular(16),
          ),

          child: Column(

            mainAxisSize:
            MainAxisSize.min,

            children: [

              Icon(

                icon,

                color: Colors.white,

                size: 22,
              ),

              const SizedBox(height: 4),

              Text(

                title,

                style: const TextStyle(

                  color: Colors.white,

                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}