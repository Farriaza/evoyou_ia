
// running_history_screen.dart

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class RunningHistoryScreen
extends StatelessWidget {

const RunningHistoryScreen({
super.key,
});

@override
Widget build(BuildContext context) {

final user =
FirebaseAuth.instance.currentUser;

return Scaffold(

backgroundColor:
const Color(0xFF071120),

appBar: AppBar(

backgroundColor:
Colors.transparent,

elevation: 0,

title:
const Text(
"Historial Running",
),
),

body: StreamBuilder<

QuerySnapshot<
Map<String, dynamic>>>(

stream:

FirebaseFirestore.instance

    .collection(
"running_sessions")

    .where(
"uid",
isEqualTo:
user?.uid,
)

    .orderBy(
"creado",
descending: true,
)

    .snapshots(),

builder: (context, snapshot) {

if(snapshot.hasError){

return const Center(

child: Text(

"Error cargando historial",

style: TextStyle(
color: Colors.red,
),
),
);
}

if(snapshot.connectionState ==
ConnectionState.waiting){

return const Center(

child:
CircularProgressIndicator(
color: Colors.cyan,
),
);
}

if(!snapshot.hasData ||
snapshot.data!.docs.isEmpty){

return const Center(

child: Text(

"No hay carreras registradas",

style: TextStyle(
color: Colors.white70,
fontSize: 16,
),
),
);
}

final carreras =
snapshot.data!.docs;

return ListView.builder(

padding:
const EdgeInsets.all(20),

itemCount:
carreras.length,

itemBuilder:
(context, index){

final data =
carreras[index].data();

return Container(

margin:
const EdgeInsets.only(
bottom: 20,
),

padding:
const EdgeInsets.all(22),

decoration: BoxDecoration(

color:
const Color(
0xFF111C30,
),

borderRadius:
BorderRadius.circular(
28,
),

border: Border.all(

color:
Colors.cyan
    .withOpacity(0.15),
),
),

child: Column(

crossAxisAlignment:
CrossAxisAlignment.start,

children: [

Row(

children: [

Container(

padding:
const EdgeInsets.all(14),

decoration: BoxDecoration(

shape:
BoxShape.circle,

color:
Colors.cyan
    .withOpacity(
0.12,
),
),

child: const Icon(

Icons
    .directions_run,

color:
Colors.cyan,

size: 28,
),
),

const SizedBox(
width: 16,
),

Expanded(

child: Column(

crossAxisAlignment:
CrossAxisAlignment
    .start,

children: [

const Text(

"Sesión Running",

style: TextStyle(

color:
Colors.white,

fontSize: 20,

fontWeight:
FontWeight.bold,
),
),

const SizedBox(
height: 5,
),

Text(

formatearFechaHora(
data["creado"],
),

style:
const TextStyle(

color:
Colors.white54,
),
),
],
),
),
],
),

const SizedBox(height: 25),

info(

"Tiempo",

data["tiempoTexto"]
?? "--:--",
),

info(

"Distancia",

"${(data["distanciaKm"] ?? 0).toStringAsFixed(2)} km",
),

info(

"Calorías",

"${(data["calorias"] ?? 0).toStringAsFixed(0)} kcal",
),

info(

"Ritmo",

"${(data["ritmo"] ?? 0).toStringAsFixed(1)} km/h",
),
],
),
);
},
);
},
),
);
}

Widget info(
String titulo,
String valor,
){

return Padding(

padding:
const EdgeInsets.only(
bottom: 14,
),

child: Row(

mainAxisAlignment:
MainAxisAlignment
    .spaceBetween,

children: [

Text(

titulo,

style: const TextStyle(

color: Colors.white54,

fontSize: 15,
),
),

Text(

valor,

style: const TextStyle(

color: Colors.white,

fontWeight:
FontWeight.bold,

fontSize: 16,
),
),
],
),
);
}

String formatearFechaHora(
dynamic fecha){

if(fecha == null)
return "";

final date =
fecha.toDate();

return
"${date.day}/${date.month}/${date.year} "
"${date.hour.toString().padLeft(2, '0')}:"
"${date.minute.toString().padLeft(2, '0')}";
}
}