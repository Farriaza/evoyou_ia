import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../auth/login_screen.dart';

class SettingsScreen extends StatefulWidget {

  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState
    extends State<SettingsScreen> {

  bool notificaciones = true;

  bool modoOscuro = true;

  Future<void> cerrarSesion() async {

    await FirebaseAuth.instance.signOut();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(

      context,

      MaterialPageRoute(
        builder: (_) =>
        const LoginScreen(),
      ),

          (route) => false,
    );
  }

  Widget opcion({

    required IconData icono,

    required String titulo,

    required Color color,

    VoidCallback? onTap,

    Widget? trailing,
  }) {

    return Container(

      margin:
      const EdgeInsets.only(bottom: 18),

      decoration: BoxDecoration(

        color:
        const Color(0xFF111C30),

        borderRadius:
        BorderRadius.circular(22),
      ),

      child: ListTile(

        contentPadding:
        const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),

        leading: CircleAvatar(

          backgroundColor:
          color.withOpacity(0.15),

          child: Icon(
            icono,
            color: color,
          ),
        ),

        title: Text(

          titulo,

          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight:
            FontWeight.w600,
          ),
        ),

        trailing: trailing,

        onTap: onTap,
      ),
    );
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

        title: const Text(

          "Configuración",

          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      body: SafeArea(

        child: Padding(

          padding: const EdgeInsets.all(22),

          child: Column(

            children: [

              opcion(

                icono:
                Icons.notifications,

                titulo:
                "Notificaciones",

                color: Colors.orange,

                trailing: Switch(

                  value: notificaciones,

                  activeColor:
                  Colors.cyan,

                  onChanged: (value) {

                    setState(() {

                      notificaciones =
                          value;
                    });
                  },
                ),
              ),

              opcion(

                icono:
                Icons.dark_mode,

                titulo:
                "Modo oscuro",

                color: Colors.purpleAccent,

                trailing: Switch(

                  value: modoOscuro,

                  activeColor:
                  Colors.cyan,

                  onChanged: (value) {

                    setState(() {

                      modoOscuro =
                          value;
                    });
                  },
                ),
              ),

              opcion(

                icono:
                Icons.lock_outline,

                titulo:
                "Privacidad",

                color: Colors.green,

                onTap: () {

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(

                    const SnackBar(

                      content: Text(
                        "Próximamente",
                      ),
                    ),
                  );
                },
              ),

              opcion(

                icono:
                Icons.help_outline,

                titulo:
                "Ayuda y soporte",

                color: Colors.cyan,

                onTap: () {

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(

                    const SnackBar(

                      content: Text(
                        "Próximamente",
                      ),
                    ),
                  );
                },
              ),

              opcion(

                icono:
                Icons.info_outline,

                titulo:
                "Acerca de EvoYou AI",

                color: Colors.blueAccent,

                onTap: () {

                  showAboutDialog(

                    context: context,

                    applicationName:
                    "EvoYou AI",

                    applicationVersion:
                    "1.0.0",

                    applicationLegalese:
                    "© EvoYou AI",
                  );
                },
              ),

              const Spacer(),

              SizedBox(

                width: double.infinity,

                height: 58,

                child: ElevatedButton.icon(

                  style:
                  ElevatedButton
                      .styleFrom(

                    backgroundColor:
                    Colors.redAccent,

                    shape:
                    RoundedRectangleBorder(

                      borderRadius:
                      BorderRadius
                          .circular(18),
                    ),
                  ),

                  onPressed: cerrarSesion,

                  icon: const Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),

                  label: const Text(

                    "Cerrar sesión",

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}