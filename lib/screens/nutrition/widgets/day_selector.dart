import 'package:flutter/material.dart';

class DaySelector extends StatelessWidget {

  final int selectedIndex;

  final Function(int) onSelected;

  const DaySelector({

    super.key,

    required this.selectedIndex,

    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {

    final days = [

      ["LUN", "26"],
      ["MAR", "27"],
      ["MIÉ", "28"],
      ["JUE", "29"],
      ["VIE", "30"],
      ["SÁB", "31"],
      ["DOM", "01"],
    ];

    return SizedBox(

      height: 110,

      child: ListView.builder(

        scrollDirection: Axis.horizontal,

        itemCount: days.length,

        itemBuilder: (_, index) {

          final selected =
              selectedIndex == index;

          return GestureDetector(

            onTap: () {

              onSelected(index);
            },

            child: Container(

              width: 85,

              margin:
              const EdgeInsets.only(
                right: 12,
              ),

              decoration: BoxDecoration(

                color:
                const Color(0xFF111C30),

                borderRadius:
                BorderRadius.circular(
                    25),

                border: Border.all(

                  color: selected
                      ? const Color(
                      0xFF00C6FF)
                      : Colors.white10,

                  width: 2,
                ),
              ),

              child: Column(

                mainAxisAlignment:
                MainAxisAlignment.center,

                children: [

                  Text(

                    days[index][0],

                    style:
                    const TextStyle(

                      color:
                      Colors.white70,

                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                      height: 10),

                  Text(

                    days[index][1],

                    style:
                    const TextStyle(

                      color:
                      Colors.white,

                      fontSize: 22,

                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}