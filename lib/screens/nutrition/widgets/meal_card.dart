import 'package:flutter/material.dart';

class MealCard extends StatelessWidget {

  final String title;

  final String subtitle;

  final int calories;

  final IconData icon;

  final VoidCallback onTap;

  const MealCard({

    super.key,

    required this.title,

    required this.subtitle,

    required this.calories,

    required this.icon,

    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      margin:
      const EdgeInsets.only(
        bottom: 16,
      ),

      child: InkWell(

        borderRadius:
        BorderRadius.circular(22),

        onTap: onTap,

        child: Container(

          padding:
          const EdgeInsets.all(18),

          decoration: BoxDecoration(

            color:
            const Color(0xFF111C30),

            borderRadius:
            BorderRadius.circular(22),
          ),

          child: Row(

            children: [

              Container(

                width: 60,

                height: 60,

                decoration: BoxDecoration(

                  color:
                  const Color(
                      0x2200C6FF),

                  borderRadius:
                  BorderRadius.circular(
                      16),
                ),

                child: Icon(

                  icon,

                  color:
                  const Color(
                      0xFF00C6FF),

                  size: 30,
                ),
              ),

              const SizedBox(width: 15),

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

                        fontSize: 18,

                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                        height: 4),

                    Text(

                      subtitle,

                      style:
                      const TextStyle(

                        color:
                        Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),

              Column(

                children: [

                  Text(

                    "$calories",

                    style:
                    const TextStyle(

                      color:
                      Color(0xFF00C6FF),

                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const Text(

                    "kcal",

                    style:
                    TextStyle(

                      color:
                      Colors.white54,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}