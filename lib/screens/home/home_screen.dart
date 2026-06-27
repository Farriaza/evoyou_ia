import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../app_theme.dart';
import '../profile/profile_screen.dart';
import '../settings/settings_screen.dart';
import '../look/look_screen.dart';
import '../exercise/exercise_screen.dart';
import '../running/running_screen.dart';
import '../nutrition/nutrition_screen.dart';
import '../rutina/rutina_screen.dart';
import '../chatbot/chatbot_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String apodo = "";
  String foto  = "";
  bool loading = true;
  int currentIndex = 0;
  int nivelUsuario = 12; // Dato dinámico para la insignia

  // Datos de muestra (mockup). Reemplazar por datos reales desde Firestore.
  double caloriasQuemadasHoy = 420;
  double metaCaloriasDiaria = 750;
  String proximaRutinaNombre = "Tren superior - Día 3";
  String proximaRutinaHora = "Hoy, 18:30";

  // Datos de muestra del gráfico mensual (eje X = día del mes, eje Y = % cumplimiento)
  final List<double> _valoresMensuales = const [
    40, 55, 50, 65, 70, 60, 80, 75, 90, 85,
    70, 60, 65, 80, 95, 90, 85, 70, 60, 75,
    80, 85, 90, 95, 100, 90, 80, 70, 75, 85,
  ];

  static const List<String> _frasesMotivadoras = [
    "Hoy es un buen día para superar tu límite de ayer 💪",
    "La constancia vence al talento.",
    "Tu cuerpo escucha todo lo que tu mente dice.",
    "Un poco hoy, mucho con el tiempo.",
    "El único entrenamiento malo es el que no hiciste.",
    "Progreso, no perfección.",
    "Disciplina es elegir entre lo que quieres ahora y lo que quieres más.",
    "No cuentes los días, haz que los días cuenten.",
    "Cada repetición te acerca a tu mejor versión.",
    "El cansancio de hoy es la fuerza de mañana.",
  ];

  String _fraseDelDia() {
    final inicioAnio = DateTime(DateTime.now().year, 1, 1);
    final diaDelAnio = DateTime.now().difference(inicioAnio).inDays;
    return _frasesMotivadoras[diaDelAnio % _frasesMotivadoras.length];
  }

  @override
  void initState() {
    super.initState();
    AppTheme.applySystemUI(navBarColor: AppColors.bgSecondary);
    cargarUsuario();
  }

  Future<void> cargarUsuario() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;
      final doc = await FirebaseFirestore.instance
          .collection("usuarios")
          .doc(user.uid)
          .get();
      if (!mounted) return;
      setState(() {
        apodo = doc.data()?["apodo"] ?? "";
        foto  = doc.data()?["fotoPerfil"] ?? "";
        nivelUsuario = doc.data()?["nivel"] ?? 12;
        loading = false;
      });
    } catch (e) {
      print(e);
      setState(() => loading = false);
    }
  }

  // Generador dinámico de insignias según el nivel del usuario.
  // NOTA: por ahora es solo de muestra visual (mockup), la lógica real
  // de asignación de niveles se definirá más adelante.
  Widget _obtenerInsignia(int nivel) {
    String textoInsignia = "RECLUTA";
    List<Color> coloresInsignia = [Colors.grey.shade600, Colors.grey.shade400];

    if (nivel >= 5 && nivel < 10) {
      textoInsignia = "PRO";
      coloresInsignia = [Colors.cyan.shade700, Colors.cyanAccent];
    } else if (nivel >= 10) {
      textoInsignia = "ÉLITE";
      coloresInsignia = [const Color(0xFFFFD700), const Color(0xFFA98600)];
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: coloresInsignia),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.workspace_premium_rounded, color: Colors.black, size: 12),
          const SizedBox(width: 3),
          Text(
            textoInsignia,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.3,
              backgroundColor: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }

  void _irAPerfil() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfileScreen()),
    ).then((_) async => await cargarUsuario());
  }

  void _irAChatbot() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ChatbotScreen()),
    );
  }

  Widget _moduloHorizontalIcon({
    required String titulo,
    required IconData icono,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.bgCard,
              border: Border.all(color: color.withOpacity(0.3), width: 1.2),
            ),
            child: Icon(icono, color: color, size: 20),
          ),
          const SizedBox(height: 4),
          Text(
            titulo,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 10,
              fontWeight: FontWeight.w500,
              backgroundColor: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bloqueMedidor({
    required String titulo,
    required String valor,
    required String unidad,
    required double porcentaje,
    required List<Color> coloresArco,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
              titulo,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 9,
                fontWeight: FontWeight.bold,
                backgroundColor: Colors.transparent,
              )
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: 70,
            height: 42,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(70, 42),
                  painter: CustomArcPainter(percentage: porcentaje, strokeWidth: 4.5, gradientColors: coloresArco),
                ),
                Positioned(
                  bottom: 0,
                  child: Column(
                    children: [
                      Text(
                          valor,
                          style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.bold, backgroundColor: Colors.transparent)
                      ),
                      Text(
                          unidad,
                          style: const TextStyle(color: AppColors.textSubtle, fontSize: 7, fontWeight: FontWeight.bold, backgroundColor: Colors.transparent)
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Gráfico mensual con ejes X/Y (mockup, sin dependencias externas) ---
  Widget _graficoMensual() {
    return CustomPaint(
      size: const Size(double.infinity, double.infinity),
      painter: _LineChartPainter(valores: _valoresMensuales),
    );
  }

  // --- Tarjeta de espacio libre: próxima rutina programada ---
  Widget _bloqueProximaRutina() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.accentLight.withOpacity(0.12),
            ),
            child: const Icon(Icons.event_available_rounded, color: AppColors.accentLight, size: 18),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "PRÓXIMA RUTINA",
                  style: TextStyle(color: AppColors.textMuted, fontSize: 9, fontWeight: FontWeight.bold, backgroundColor: Colors.transparent),
                ),
                const SizedBox(height: 2),
                Text(
                  proximaRutinaNombre,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.bold, backgroundColor: Colors.transparent),
                ),
                Text(
                  proximaRutinaHora,
                  style: const TextStyle(color: AppColors.textSubtle, fontSize: 9, backgroundColor: Colors.transparent),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RutinaScreen())),
            style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6)),
            child: const Text(
              "Ir",
              style: TextStyle(color: AppColors.accentLight, fontSize: 11, fontWeight: FontWeight.bold, backgroundColor: Colors.transparent),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tieneFoto = foto.isNotEmpty && File(foto).existsSync();
    final porcentajeCalorias = (caloriasQuemadasHoy / metaCaloriasDiaria).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.bgSecondary,
          border: Border(top: BorderSide(color: AppColors.divider, width: 0.8)),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          backgroundColor: Colors.transparent,
          selectedItemColor: AppColors.accentLight,
          unselectedItemColor: AppColors.textSubtle50,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
            switch (index) {
              case 1:
                _irAChatbot();
                break;
              case 2:
                _irAPerfil();
                break;
              case 3:
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
                break;
              default:
                break;
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.insights_rounded), label: "Progreso"),
            BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_rounded), label: "Chat IA"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
            BottomNavigationBarItem(icon: Icon(Icons.tune_rounded), label: "Config"),
          ],
        ),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
          : SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Column(
            children: [
              // --- HEADER ---
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: _irAPerfil,
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: AppColors.bgBubble,
                      backgroundImage: tieneFoto ? FileImage(File(foto)) : null,
                      child: !tieneFoto ? const Icon(Icons.person, size: 20, color: AppColors.textPrimary) : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "Hola, $apodo 👋",
                            style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.bold, backgroundColor: Colors.transparent)
                        ),
                        const SizedBox(height: 4),
                        // Frase motivadora del día (cambia automáticamente cada día)
                        Text(
                          _fraseDelDia(),
                          style: const TextStyle(
                            color: AppColors.textSubtle,
                            fontSize: 9,
                            fontStyle: FontStyle.italic,
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Text("Nivel $nivelUsuario", style: const TextStyle(color: AppColors.textPrimary, fontSize: 10, fontWeight: FontWeight.bold, backgroundColor: Colors.transparent)),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Container(
                                height: 5,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: AppColors.bgCard),
                                child: FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: 0.75,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      gradient: const LinearGradient(colors: [Colors.cyanAccent, Colors.purpleAccent]),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text("75%", style: TextStyle(color: Colors.cyanAccent, fontSize: 10, fontWeight: FontWeight.bold, backgroundColor: Colors.transparent)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  _obtenerInsignia(nivelUsuario),
                ],
              ),

              const SizedBox(height: 14),

              // --- MÓDULOS ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _moduloHorizontalIcon(titulo: "Rutina", icono: Icons.fitness_center, color: AppColors.steel, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RutinaScreen()))),
                  _moduloHorizontalIcon(titulo: "Biblioteca", icono: Icons.sports_gymnastics, color: AppColors.warning, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ExerciseScreen(userId: FirebaseAuth.instance.currentUser?.uid ?? '')))),
                  _moduloHorizontalIcon(titulo: "Running", icono: Icons.directions_run_rounded, color: AppColors.error, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RunningScreen()))),
                  _moduloHorizontalIcon(titulo: "Look", icono: Icons.auto_awesome, color: AppColors.accentGlow, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LookScreen()))),
                  _moduloHorizontalIcon(titulo: "Nutrición", icono: Icons.restaurant_menu, color: AppColors.success, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NutritionScreen()))),
                ],
              ),

              const SizedBox(height: 14),

              // --- BLOQUE CENTRAL ---
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 11,
                    child: Container(
                      height: 150,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(14)),
                      child: Column(
                        children: [
                          const Text("GRÁFICO GENERAL DEL MES", style: TextStyle(color: AppColors.textMuted, fontSize: 10, fontWeight: FontWeight.bold, backgroundColor: Colors.transparent)),
                          const SizedBox(height: 4),
                          // Gráfico con eje X (días) y eje Y (% cumplimiento)
                          Expanded(child: _graficoMensual()),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 9,
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 70,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(14)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("RACHA ACTUAL", style: TextStyle(color: AppColors.textMuted, fontSize: 9, fontWeight: FontWeight.bold, backgroundColor: Colors.transparent)),
                              const SizedBox(height: 1),
                              Row(
                                children: const [
                                  Text("🔥 14 ", style: TextStyle(color: Colors.orangeAccent, fontSize: 15, fontWeight: FontWeight.bold, backgroundColor: Colors.transparent)),
                                  Text("DÍAS", style: TextStyle(color: AppColors.textPrimary, fontSize: 11, fontWeight: FontWeight.bold, backgroundColor: Colors.transparent)),
                                ],
                              ),
                              const Text("Días programados al 100%", style: TextStyle(color: AppColors.textSubtle, fontSize: 8, backgroundColor: Colors.transparent)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          height: 70,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(14)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text("RECUPERACIÓN", style: TextStyle(color: AppColors.textMuted, fontSize: 9, fontWeight: FontWeight.bold, backgroundColor: Colors.transparent)),
                              SizedBox(height: 1),
                              Text("85% Listo", style: TextStyle(color: Color(0xFF2EE56B), fontSize: 14, fontWeight: FontWeight.bold, backgroundColor: Colors.transparent)),
                              Text("Músculos óptimos", style: TextStyle(color: AppColors.textSubtle, fontSize: 8, backgroundColor: Colors.transparent)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // --- BLOQUE INFERIOR: izquierda medidores, derecha calendario (tamaño justo) ---
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 7,
                    child: Column(
                      children: [
                        _bloqueMedidor(
                          titulo: "CALORÍAS NETAS",
                          valor: "-350",
                          unidad: "KCAL DÉFICIT",
                          porcentaje: 0.75,
                          coloresArco: [const Color(0xFFFFD43F), const Color(0xFF2EE56B)],
                        ),
                        const SizedBox(height: 10),
                        // Antes "Registro de agua": no era verificable sin sensor.
                        // Ahora muestra calorías quemadas calculadas desde
                        // los ejercicios/rutina registrados ese día.
                        _bloqueMedidor(
                          titulo: "CALORÍAS QUEMADAS",
                          valor: caloriasQuemadasHoy.toStringAsFixed(0),
                          unidad: "KCAL HOY",
                          porcentaje: porcentajeCalorias,
                          coloresArco: [Colors.deepOrangeAccent, Colors.amberAccent],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 13,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(14)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min, // ya no se estira hacia abajo
                        children: [
                          const Text("CALENDARIO", style: TextStyle(color: AppColors.textPrimary, fontSize: 10, fontWeight: FontWeight.bold, backgroundColor: Colors.transparent)),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              _DiaTexto(t: "Lu"), _DiaTexto(t: "Ma"), _DiaTexto(t: "Mi"),
                              _DiaTexto(t: "Ju"), _DiaTexto(t: "Vi"), _DiaTexto(t: "Sá"), _DiaTexto(t: "Do")
                            ],
                          ),
                          const SizedBox(height: 4),
                          GridView.builder(
                            shrinkWrap: true, // toma solo el alto que necesita
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 7,
                              mainAxisSpacing: 4,
                              crossAxisSpacing: 4,
                              childAspectRatio: 1.1,
                            ),
                            itemCount: 30,
                            itemBuilder: (context, index) {
                              int diaNum = index + 1;
                              bool esActivo = (diaNum == 1 || diaNum == 2 || diaNum == 15 || diaNum == 16 || diaNum == 26 || diaNum == 27);
                              return Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: esActivo ? AppColors.accentLight.withOpacity(0.12) : AppColors.bgBubble.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  "$diaNum",
                                  style: TextStyle(
                                    color: esActivo ? AppColors.accentLight : AppColors.textSubtle,
                                    fontSize: 9,
                                    fontWeight: esActivo ? FontWeight.bold : FontWeight.normal,
                                    backgroundColor: Colors.transparent,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // --- ESPACIO LIBRE: función útil (próxima rutina programada) ---
              _bloqueProximaRutina(),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _DiaTexto extends StatelessWidget {
  final String t;
  const _DiaTexto({required this.t});
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 20, child: Text(t, textAlign: TextAlign.center, style: const TextStyle(color: AppColors.textMuted, fontSize: 8, backgroundColor: Colors.transparent)));
  }
}

class CustomArcPainter extends CustomPainter {
  final double percentage;
  final double strokeWidth;
  final List<Color> gradientColors;

  CustomArcPainter({required this.percentage, required this.strokeWidth, required this.gradientColors});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2 - (strokeWidth / 2);

    final basePaint = Paint()
      ..color = AppColors.bgBubble.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), 3.141592653589793, 3.141592653589793, false, basePaint);

    final progressPaint = Paint()
      ..shader = LinearGradient(colors: gradientColors).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.141592653589793,
      3.141592653589793 * percentage.clamp(0.0, 1.0),
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomArcPainter oldDelegate) {
    return oldDelegate.percentage != percentage || oldDelegate.strokeWidth != strokeWidth || oldDelegate.gradientColors != gradientColors;
  }
}

class _LineChartPainter extends CustomPainter {
  final List<double> valores;
  _LineChartPainter({required this.valores});

  @override
  void paint(Canvas canvas, Size size) {
    const double padLeft = 22;
    const double padBottom = 16;
    const double padTop = 6;
    const double padRight = 4;

    final chartWidth = size.width - padLeft - padRight;
    final chartHeight = size.height - padTop - padBottom;
    final origin = Offset(padLeft, size.height - padBottom);

    final ejePaint = Paint()
      ..color = AppColors.divider.withOpacity(0.5)
      ..strokeWidth = 1;

    final gridPaint = Paint()
      ..color = AppColors.divider.withOpacity(0.18)
      ..strokeWidth = 0.6;

    final textStyle = TextStyle(color: AppColors.textSubtle, fontSize: 7);

    // Líneas de grilla horizontales + etiquetas eje Y (0, 25, 50, 75, 100)
    for (int i = 0; i <= 4; i++) {
      final y = origin.dy - (chartHeight * i / 4);
      canvas.drawLine(Offset(padLeft, y), Offset(size.width - padRight, y), gridPaint);
      final label = (i * 25).toString();
      final tp = TextPainter(
        text: TextSpan(text: label, style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(padLeft - tp.width - 4, y - tp.height / 2));
    }

    // Eje X
    canvas.drawLine(origin, Offset(size.width - padRight, origin.dy), ejePaint);
    // Eje Y
    canvas.drawLine(Offset(padLeft, padTop), origin, ejePaint);

    // Etiquetas eje X (cada 5 días)
    for (int i = 0; i < valores.length; i++) {
      if ((i + 1) % 5 == 0 || i == 0) {
        final x = padLeft + (chartWidth * i / (valores.length - 1));
        final tp = TextPainter(
          text: TextSpan(text: "${i + 1}", style: textStyle),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, Offset(x - tp.width / 2, origin.dy + 3));
      }
    }

    // Línea de datos
    final path = Path();
    final fillPath = Path();
    for (int i = 0; i < valores.length; i++) {
      final x = padLeft + (chartWidth * i / (valores.length - 1));
      final y = origin.dy - (chartHeight * (valores[i] / 100).clamp(0.0, 1.0));
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, origin.dy);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }
    fillPath.lineTo(padLeft + chartWidth, origin.dy);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.accentLight.withOpacity(0.20),
          AppColors.accentLight.withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..shader = const LinearGradient(colors: [Colors.cyanAccent, Colors.purpleAccent])
          .createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) => oldDelegate.valores != valores;
}