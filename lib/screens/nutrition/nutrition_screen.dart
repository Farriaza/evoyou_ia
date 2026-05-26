import 'package:flutter/material.dart';

class NutritionScreen extends StatelessWidget {

  const NutritionScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final List<Map<String, dynamic>> recommendedFoods = [

      {
        "title": "Pollo",
        "icon": Icons.set_meal,
        "description": "Alto en proteína y bajo en grasa.",
      },

      {
        "title": "Avena",
        "icon": Icons.breakfast_dining,
        "description": "Excelente fuente de energía.",
      },

      {
        "title": "Huevos",
        "icon": Icons.egg,
        "description": "Proteína ideal para músculo.",
      },

      {
        "title": "Frutas",
        "icon": Icons.apple,
        "description": "Vitaminas y antioxidantes.",
      },

      {
        "title": "Agua",
        "icon": Icons.water_drop,
        "description": "Mantiene hidratado el cuerpo.",
      },

      {
        "title": "Arroz",
        "icon": Icons.rice_bowl,
        "description": "Buen carbohidrato para energía.",
      },
    ];

    final List<Map<String, dynamic>> badFoods = [

      {
        "title": "Comida rápida",
        "icon": Icons.fastfood,
        "description": "Alta en grasas y sodio.",
      },

      {
        "title": "Bebidas azucaradas",
        "icon": Icons.local_drink,
        "description": "Exceso de azúcar innecesaria.",
      },

      {
        "title": "Dulces",
        "icon": Icons.cake,
        "description": "Mucho azúcar y pocas proteínas.",
      },

      {
        "title": "Alcohol",
        "icon": Icons.no_drinks,
        "description": "Afecta recuperación muscular.",
      },

      {
        "title": "Papas fritas",
        "icon": Icons.lunch_dining,
        "description": "Altas en calorías y aceite.",
      },

      {
        "title": "Ultra procesados",
        "icon": Icons.warning,
        "description": "Pocos nutrientes reales.",
      },
    ];

    return Scaffold(

      backgroundColor: const Color(0xFF071120),

      appBar: AppBar(

        backgroundColor: Colors.transparent,

        elevation: 0,

        centerTitle: true,

        title: const Text(

          "Alimentación",

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

            Container(

              width: double.infinity,

              padding: const EdgeInsets.all(22),

              decoration: BoxDecoration(

                borderRadius:
                BorderRadius.circular(25),

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
                    Icons.restaurant,
                    color: Colors.white,
                    size: 45,
                  ),

                  SizedBox(height: 15),

                  Text(

                    "Nutrición Inteligente",

                    style: TextStyle(

                      color: Colors.white,

                      fontSize: 28,

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(

                    "Mejora tu físico combinando entrenamiento y buena alimentación.",

                    style: TextStyle(

                      color: Colors.white70,

                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 35),

            const Text(

              "Alimentos Recomendados",

              style: TextStyle(

                color: Colors.greenAccent,

                fontSize: 24,

                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 18),

            ...recommendedFoods.map(

                  (food) => foodCard(

                title: food["title"],

                description:
                food["description"],

                icon: food["icon"],

                color: Colors.greenAccent,
              ),
            ),

            const SizedBox(height: 35),

            const Text(

              "Alimentos No Recomendados",

              style: TextStyle(

                color: Colors.redAccent,

                fontSize: 24,

                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 18),

            ...badFoods.map(

                  (food) => foodCard(

                title: food["title"],

                description:
                food["description"],

                icon: food["icon"],

                color: Colors.redAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget foodCard({

    required String title,

    required String description,

    required IconData icon,

    required Color color,
  }) {

    return Container(

      margin: const EdgeInsets.only(bottom: 16),

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(

        color: const Color(0xFF111C30),

        borderRadius:
        BorderRadius.circular(22),

        border: Border.all(
          color: Colors.white10,
        ),
      ),

      child: Row(

        children: [

          Container(

            width: 60,

            height: 60,

            decoration: BoxDecoration(

              color: color.withOpacity(0.15),

              borderRadius:
              BorderRadius.circular(18),
            ),

            child: Icon(
              icon,
              color: color,
              size: 30,
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

                  style: const TextStyle(

                    color: Colors.white,

                    fontSize: 18,

                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(

                  description,

                  style: const TextStyle(

                    color: Colors.white70,

                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}