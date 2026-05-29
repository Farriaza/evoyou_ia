import 'package:flutter/material.dart';

class ShoppingListScreen extends StatelessWidget {

  const ShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return ListView(

      padding: const EdgeInsets.all(20),

      children: [

        _section(

          "Proteínas",

          [

            "Pechuga de pollo",

            "Atún",

            "Huevos",

            "Yogurt griego",
          ],
        ),

        _section(

          "Verduras",

          [

            "Lechuga",

            "Tomate",

            "Brócoli",

            "Espinaca",
          ],
        ),

        _section(

          "Carbohidratos",

          [

            "Arroz",

            "Avena",

            "Quinoa",
          ],
        ),
      ],
    );
  }

  Widget _section(

      String title,

      List<String> items,
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
        const Color(0xFF111C30),

        borderRadius:
        BorderRadius.circular(22),
      ),

      child: Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Text(

            title,

            style:
            const TextStyle(

              color: Colors.white,

              fontSize: 20,

              fontWeight:
              FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          ...items.map(

                (item) => Padding(

              padding:
              const EdgeInsets.only(
                bottom: 10,
              ),

              child: Row(

                children: [

                  const Icon(

                    Icons.check_circle,

                    color:
                    Color(0xFF00C6FF),

                    size: 18,
                  ),

                  const SizedBox(width: 10),

                  Text(

                    item,

                    style:
                    const TextStyle(
                      color:
                      Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}