import 'package:flutter/material.dart';

class NutritionTab extends StatelessWidget {

  final String title;

  final IconData icon;

  final bool selected;

  final VoidCallback onTap;

  const NutritionTab({

    super.key,

    required this.title,

    required this.icon,

    required this.selected,

    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return Expanded(

      child: GestureDetector(

        onTap: onTap,

        child: AnimatedContainer(

          duration:
          const Duration(
            milliseconds: 250,
          ),

          padding:
          const EdgeInsets.symmetric(
            vertical: 12,
          ),

          decoration: BoxDecoration(

            color: selected
                ? const Color(0xFF00C6FF)
                : Colors.transparent,

            borderRadius:
            BorderRadius.circular(
              16,
            ),
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

              const SizedBox(
                height: 4,
              ),

              Text(

                title,

                textAlign:
                TextAlign.center,

                style: const TextStyle(

                  color: Colors.white,

                  fontSize: 11,

                  fontWeight:
                  FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}