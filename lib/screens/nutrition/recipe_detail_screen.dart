import 'package:flutter/material.dart';

class RecipeDetailScreen extends StatelessWidget {

  const RecipeDetailScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
      const Color(0xFF071120),

      appBar: AppBar(

        backgroundColor:
        const Color(0xFF071120),
      ),

      body: const Center(

        child: Text(

          "Detalle de Receta",

          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}