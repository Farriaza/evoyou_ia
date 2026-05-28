

import 'package:flutter/material.dart';

class RutinaScreen extends StatefulWidget {

const RutinaScreen({super.key});

@override
State<RutinaScreen> createState() =>
_RutinaScreenState();
}

class _RutinaScreenState
extends State<RutinaScreen> {

int seleccionado = 3;

String tipoRutina = "GYM";

late List<DateTime> semanaActual;

final List<String> dias = [

"LUN",
"MAR",
"MIÉ",
"JUE",
"VIE",
"SÁB",
"DOM",
];

@override
void initState() {

super.initState();

generarSemanaActual();
}

void generarSemanaActual() {

final hoy = DateTime.now();

semanaActual = List.generate(

7,

(index) =>

hoy.add(
Duration(
days: index - 3,
),
),
);

seleccionado = 3;
}

@override
Widget build(BuildContext context) {

final fechaSeleccionada =
semanaActual[seleccionado];

return Scaffold(

backgroundColor:
const Color(0xFF020B1C),

appBar: AppBar(

backgroundColor:
Colors.transparent,

elevation: 0,

centerTitle: true,

title: const Text(

"Rutinas",

style: TextStyle(

color: Colors.white,

fontSize: 24,

fontWeight:
FontWeight.bold,
),
),
),

body: SafeArea(

child: SingleChildScrollView(

padding:
const EdgeInsets.symmetric(

horizontal: 22,
vertical: 10,
),

child: Column(

crossAxisAlignment:
CrossAxisAlignment.start,

children: [

SizedBox(

height: 92,

child: ListView.builder(

scrollDirection:
Axis.horizontal,

itemCount:
semanaActual.length,

itemBuilder:
(context, index) {

final fecha =
semanaActual[index];

final activo =
seleccionado ==
index;

return GestureDetector(

onTap: () {

setState(() {

seleccionado =
index;
});
},

child: AnimatedContainer(

duration:
const Duration(
milliseconds: 250,
),

width: 72,

margin:
const EdgeInsets.only(
right: 14,
),

decoration: BoxDecoration(

borderRadius:
BorderRadius.circular(
26,
),

gradient:

activo

? LinearGradient(

colors: [

Colors.cyan
    .withOpacity(
0.20,
),

Colors.blue
    .withOpacity(
0.05,
),
],
)

    : null,

color:

activo

? null

    : const Color(
0xFF111C30,
),

border: Border.all(

color:

activo

? Colors.cyan

    : Colors.white10,

width:
activo
? 2
    : 1,
),
),

child: Column(

mainAxisAlignment:
MainAxisAlignment.center,

children: [

Text(

dias[index],

style: TextStyle(

color:

activo

? Colors.cyan

    : Colors.white54,

fontSize: 13,

fontWeight:
FontWeight.bold,
),
),

const SizedBox(
height: 8,
),

Text(

fecha.day
    .toString(),

style:
const TextStyle(

color:
Colors.white,

fontSize: 28,

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
),

const SizedBox(height: 38),

const Text(

"Tu rutina",

style: TextStyle(

color:
Colors.white,

fontSize: 30,

fontWeight:
FontWeight.bold,
),
),

const SizedBox(height: 20),

Row(

children: [

Expanded(

child: GestureDetector(

onTap: () {

setState(() {

tipoRutina =
"GYM";
});
},

child: AnimatedContainer(

duration:
const Duration(
milliseconds: 250,
),

height: 70,

decoration: BoxDecoration(

borderRadius:
BorderRadius.circular(
24,
),

border: Border.all(

color:

tipoRutina ==
"GYM"

? Colors.cyan

    : Colors.white10,
),

gradient:

tipoRutina ==
"GYM"

? LinearGradient(

colors: [

Colors.cyan
    .withOpacity(
0.25,
),

Colors.blue
    .withOpacity(
0.08,
),
],
)

    : null,

color:

tipoRutina ==
"GYM"

? null

    : const Color(
0xFF111C30,
),
),

child: const Row(

mainAxisAlignment:
MainAxisAlignment.center,

children: [

Icon(

Icons
    .fitness_center,

color:
Colors.cyan,

size: 28,
),

SizedBox(width: 12),

Text(

"GYM",

style: TextStyle(

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
),
),

const SizedBox(width: 18),

Expanded(

child: GestureDetector(

onTap: () {

setState(() {

tipoRutina =
"CASA";
});
},

child: AnimatedContainer(

duration:
const Duration(
milliseconds: 250,
),

height: 70,

decoration: BoxDecoration(

borderRadius:
BorderRadius.circular(
24,
),

border: Border.all(

color:

tipoRutina ==
"CASA"

? Colors.purpleAccent

    : Colors.white10,
),

gradient:

tipoRutina ==
"CASA"

? LinearGradient(

colors: [

Colors.purpleAccent
    .withOpacity(
0.25,
),

Colors.pink
    .withOpacity(
0.08,
),
],
)

    : null,

color:

tipoRutina ==
"CASA"

? null

    : const Color(
0xFF111C30,
),
),

child: const Row(

mainAxisAlignment:
MainAxisAlignment.center,

children: [

Icon(

Icons.home,

color:
Colors.purpleAccent,

size: 28,
),

SizedBox(width: 12),

Text(

"CASA",

style: TextStyle(

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
),
),
],
),

const SizedBox(height: 35),

Container(

width: double.infinity,

padding:
const EdgeInsets.all(30),

decoration: BoxDecoration(

borderRadius:
BorderRadius.circular(
34,
),

color:
const Color(
0xFF111C30,
),

border: Border.all(
color: Colors.white10,
),
),

child: Column(

children: [

Container(

width: 100,

height: 100,

decoration: BoxDecoration(

shape:
BoxShape.circle,

gradient:

tipoRutina ==
"GYM"

? LinearGradient(

colors: [

Colors.cyan
    .withOpacity(
0.30,
),

Colors.blue
    .withOpacity(
0.10,
),
],
)

    : LinearGradient(

colors: [

Colors.purpleAccent
    .withOpacity(
0.30,
),

Colors.pink
    .withOpacity(
0.10,
),
],
),
),

child: Icon(

tipoRutina ==
"GYM"

? Icons
    .fitness_center

    : Icons.home,

color:

tipoRutina ==
"GYM"

? Colors.cyan

    : Colors.purpleAccent,

size: 46,
),
),

const SizedBox(height: 30),

Text(

"${dias[seleccionado]} ${fechaSeleccionada.day}",

style: const TextStyle(

color:
Colors.white,

fontSize: 40,

fontWeight:
FontWeight.bold,
),
),

const SizedBox(height: 10),

Text(

tipoRutina == "GYM"

? "Rutina de gimnasio"

    : "Rutina en casa",

style: const TextStyle(

color:
Colors.white54,

fontSize: 18,
),
),

const SizedBox(height: 45),

Icon(

Icons.fact_check_outlined,

color:
Colors.white24,

size: 110,
),

const SizedBox(height: 28),

const Text(

"Aún no tienes ejercicios",

textAlign:
TextAlign.center,

style: TextStyle(

color:
Colors.white,

fontSize: 28,

fontWeight:
FontWeight.bold,
),
),

const SizedBox(height: 15),

const Text(

"Los ejercicios generados aparecerán aquí.",

textAlign:
TextAlign.center,

style: TextStyle(

color:
Colors.white54,

fontSize: 16,

height: 1.5,
),
),

const SizedBox(height: 40),

Container(

width: double.infinity,

height: 68,

decoration: BoxDecoration(

borderRadius:
BorderRadius.circular(
22,
),

border: Border.all(

color:

tipoRutina ==
"GYM"

? Colors.cyan

    : Colors.purpleAccent,
),
),

child: Center(

child: Row(

mainAxisAlignment:
MainAxisAlignment.center,

children: [

Icon(

Icons.add,

color:

tipoRutina ==
"GYM"

? Colors.cyan

    : Colors.purpleAccent,

size: 34,
),

const SizedBox(
width: 12,
),

Text(

"Agregar ejercicios",

style: TextStyle(

color:

tipoRutina ==
"GYM"

? Colors.cyan

    : Colors.purpleAccent,

fontSize: 22,

fontWeight:
FontWeight.bold,
),
),
],
),
),
),
],
),
),

const SizedBox(height: 40),
],
),
),
),
);
}
}
