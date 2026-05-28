
// running_screen.dart

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:geolocator/geolocator.dart';

import 'running_history_screen.dart';

class RunningScreen extends StatefulWidget {

const RunningScreen({super.key});

@override
State<RunningScreen> createState() =>
_RunningScreenState();
}

class _RunningScreenState
extends State<RunningScreen> {

bool running = false;

int segundos = 0;

double distanciaKm = 0;

double calorias = 0;

Timer? timer;

Position? ultimaPosicion;

StreamSubscription<Position>?
posicionStream;

void iniciarCarrera() async {

bool servicioHabilitado =
await Geolocator
    .isLocationServiceEnabled();

if (!servicioHabilitado) {

ScaffoldMessenger.of(context)

    .showSnackBar(

const SnackBar(

content: Text(
"Activa el GPS",
),
),
);

return;
}

LocationPermission permiso =
await Geolocator.checkPermission();

if (permiso ==
LocationPermission.denied) {

permiso =
await Geolocator
    .requestPermission();
}

if (permiso ==
LocationPermission.denied ||

permiso ==
LocationPermission
    .deniedForever) {

ScaffoldMessenger.of(context)

    .showSnackBar(

const SnackBar(

content: Text(
"Permiso GPS denegado",
),
),
);

return;
}

setState(() {

running = true;

segundos = 0;

distanciaKm = 0;

calorias = 0;
});

timer = Timer.periodic(

const Duration(seconds: 1),

(_) {

setState(() {

segundos++;
});
},
);

posicionStream =

Geolocator.getPositionStream(

locationSettings:
const LocationSettings(

accuracy:
LocationAccuracy.high,

distanceFilter: 5,
),
).listen(

(Position position) {

if (ultimaPosicion != null) {

double metros =

Geolocator.distanceBetween(

ultimaPosicion!.latitude,
ultimaPosicion!.longitude,

position.latitude,
position.longitude,
);

setState(() {

distanciaKm +=
metros / 1000;

calorias =
distanciaKm * 60;
});
}

ultimaPosicion = position;
},
);
}

Future<void> detenerCarrera() async {

timer?.cancel();

posicionStream?.cancel();

setState(() {

running = false;
});

await guardarSesion();

if (!mounted) return;

ScaffoldMessenger.of(context)

    .showSnackBar(

const SnackBar(

backgroundColor: Colors.green,

content: Text(
"Sesión guardada",
),
),
);
}

Future<void> guardarSesion() async {

try {

final user =
FirebaseAuth.instance
    .currentUser;

if (user == null) return;

final ahora = DateTime.now();

await FirebaseFirestore.instance

    .collection(
"running_sessions")

    .add({

"uid": user.uid,

"fecha":
"${ahora.day}/${ahora.month}/${ahora.year}",

"hora":
"${ahora.hour.toString().padLeft(2, '0')}:"
"${ahora.minute.toString().padLeft(2, '0')}",

"tiempoSegundos":
segundos,

"tiempoTexto":
formatearTiempo(),

"distanciaKm":
distanciaKm,

"calorias":
calorias,

"ritmo":

segundos > 0

? distanciaKm /
(segundos / 3600)

    : 0,

"creado":
Timestamp.now(),
});

} catch (e) {

print(e);
}
}

String formatearTiempo() {

final horas =
(segundos ~/ 3600)

    .toString()

    .padLeft(2, '0');

final minutos =
((segundos % 3600) ~/ 60)

    .toString()

    .padLeft(2, '0');

final seg =
(segundos % 60)

    .toString()

    .padLeft(2, '0');

return "$horas:$minutos:$seg";
}

Widget cardInfo({

required String titulo,

required String valor,

required IconData icono,

required Color color,
}) {

return Container(

padding:
const EdgeInsets.all(20),

decoration: BoxDecoration(

color:
const Color(0xFF111C30),

borderRadius:
BorderRadius.circular(28),

border: Border.all(

color:
color.withOpacity(0.18),
),
),

child: Column(

mainAxisAlignment:
MainAxisAlignment.center,

children: [

Icon(

icono,

color: color,

size: 34,
),

const SizedBox(height: 18),

Text(

valor,

style: const TextStyle(

color: Colors.white,

fontSize: 24,

fontWeight:
FontWeight.bold,
),
),

const SizedBox(height: 8),

Text(

titulo,

style: const TextStyle(

color: Colors.white54,

fontSize: 15,
),
),
],
),
);
}

@override
void dispose() {

timer?.cancel();

posicionStream?.cancel();

super.dispose();
}

@override
Widget build(BuildContext context) {

return Scaffold(

backgroundColor:
const Color(0xFF071120),

appBar: AppBar(

backgroundColor:
Colors.transparent,

elevation: 0,

title:
const Text(
"Running",
),

actions: [

IconButton(

onPressed: () {

Navigator.push(

context,

MaterialPageRoute(

builder: (_) =>
const RunningHistoryScreen(),
),
);
},

icon: const Icon(
Icons.history,
),
),
],
),

body: Padding(

padding:
const EdgeInsets.all(22),

child: Column(

children: [

Container(

width: double.infinity,

padding:
const EdgeInsets.all(28),

decoration: BoxDecoration(

gradient: LinearGradient(

colors: [

Colors.cyan
    .withOpacity(0.18),

Colors.blue
    .withOpacity(0.08),
],

begin:
Alignment.topLeft,

end:
Alignment.bottomRight,
),

borderRadius:
BorderRadius.circular(35),

border: Border.all(

color:
Colors.cyan
    .withOpacity(0.15),
),
),

child: Column(

children: [

const Text(

"Tiempo",

style: TextStyle(

color:
Colors.white54,

fontSize: 18,
),
),

const SizedBox(height: 12),

Text(

formatearTiempo(),

style: const TextStyle(

color: Colors.white,

fontSize: 48,

fontWeight:
FontWeight.bold,
),
),
],
),
),

const SizedBox(height: 28),

Expanded(

child: GridView.count(

crossAxisCount: 2,

crossAxisSpacing: 18,

mainAxisSpacing: 18,

childAspectRatio: 1.1,

children: [

cardInfo(

titulo: "Distancia",

valor:
"${distanciaKm.toStringAsFixed(2)} KM",

icono:
Icons.route,

color:
Colors.cyan,
),

cardInfo(

titulo: "Calorías",

valor:
calorias
    .toStringAsFixed(0),

icono:
Icons.local_fire_department,

color:
Colors.orange,
),

cardInfo(

titulo: "Velocidad",

valor:

"${(segundos > 0

? distanciaKm /
(segundos / 3600)

    : 0).toStringAsFixed(1)} km/h",

icono:
Icons.speed,

color:
Colors.green,
),

cardInfo(

titulo: "GPS",

valor:
running
? "Activo"
    : "Inactivo",

icono:
Icons.location_on,

color:
Colors.purple,
),
],
),
),

const SizedBox(height: 20),

SizedBox(

width: double.infinity,

height: 65,

child: ElevatedButton(

style:
ElevatedButton.styleFrom(

backgroundColor:

running

? Colors.red

    : Colors.cyan,

shape:
RoundedRectangleBorder(

borderRadius:
BorderRadius.circular(
22,
),
),
),

onPressed:

running

? detenerCarrera

    : iniciarCarrera,

child: Text(

running

? "DETENER"

    : "INICIAR",

style: const TextStyle(

color: Colors.white,

fontSize: 20,

fontWeight:
FontWeight.bold,
),
),
),
),
],
),
),
);
}
}
