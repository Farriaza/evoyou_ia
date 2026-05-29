import 'package:flutter/material.dart';

class RutinaScreen extends StatefulWidget {
  const RutinaScreen({super.key});

  @override
  State<RutinaScreen> createState() => _RutinaScreenState();
}

class _RutinaScreenState extends State<RutinaScreen> {
  int seleccionado = 0;
  String tipoRutina = "GYM";
  late List<DateTime> semanaActual;
  late ScrollController _scrollController;

  final List<String> dias = [
    "LUN", "MAR", "MIÉ", "JUE", "VIE", "SÁB", "DOM",
  ];

  final List<String> meses = [
    "enero", "febrero", "marzo", "abril", "mayo", "junio",
    "julio", "agosto", "septiembre", "octubre", "noviembre", "diciembre",
  ];

  // Ancho de cada card + gap
  static const double _cardW = 68;
  static const double _cardGap = 12;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    generarSemanaActual();
    // Centrar en hoy después del primer frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _centrarDia(seleccionado);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void generarSemanaActual() {
    final hoy = DateTime.now();
    final diffLunes = hoy.weekday - 1;
    final lunes = hoy.subtract(Duration(days: diffLunes));
    semanaActual = List.generate(7, (i) => lunes.add(Duration(days: i)));
    seleccionado = hoy.weekday - 1; // 0=lun … 6=dom
  }

  void _centrarDia(int index) {
    if (!_scrollController.hasClients) return;
    final viewportWidth = _scrollController.position.viewportDimension;
    // Posición del centro de la card seleccionada
    final cardCenter = index * (_cardW + _cardGap) + _cardW / 2;
    // Offset para que quede en el centro del viewport
    final offset = cardCenter - viewportWidth / 2;
    final maxExtent = _scrollController.position.maxScrollExtent;
    final target = offset.clamp(0.0, maxExtent);

    _scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  bool get esHoy => seleccionado == DateTime.now().weekday - 1;

  String get subtituloFecha {
    final fecha = semanaActual[seleccionado];
    final mes = meses[fecha.month - 1];
    final anio = fecha.year;
    return esHoy ? "hoy · $mes $anio" : "$mes $anio";
  }

  @override
  Widget build(BuildContext context) {
    final fechaSeleccionada = semanaActual[seleccionado];
    final isGym = tipoRutina == "GYM";
    final accentColor = isGym ? Colors.cyan : Colors.purpleAccent;

    return Scaffold(
      backgroundColor: const Color(0xFF071120),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Rutinas",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Selector de días ──────────────────────────────────────
              SizedBox(
                height: 92,
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: semanaActual.length,
                  itemBuilder: (context, index) {
                    final fecha = semanaActual[index];
                    final activo = seleccionado == index;
                    final esHoyIndex = index == DateTime.now().weekday - 1;

                    return GestureDetector(
                      onTap: () {
                        setState(() => seleccionado = index);
                        _centrarDia(index);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: _cardW,
                        margin: const EdgeInsets.only(right: _cardGap),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          gradient: activo
                              ? LinearGradient(colors: [
                            Colors.cyan.withOpacity(0.18),
                            Colors.blue.withOpacity(0.07),
                          ])
                              : null,
                          color: activo ? null : const Color(0xFF0D1A2D),
                          border: Border.all(
                            color: activo
                                ? Colors.cyan
                                : Colors.white.withOpacity(0.07),
                            width: activo ? 2 : 1,
                          ),
                          boxShadow: activo
                              ? [BoxShadow(
                            color: Colors.cyan.withOpacity(0.12),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          )]
                              : null,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  dias[index],
                                  style: TextStyle(
                                    color: activo
                                        ? Colors.cyan
                                        : esHoyIndex
                                        ? Colors.cyan.withOpacity(0.5)
                                        : Colors.white54,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  fecha.day.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                            if (esHoyIndex && !activo)
                              Positioned(
                                bottom: 10,
                                child: Container(
                                  width: 5,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.cyan.withOpacity(0.5),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 32),

              const Text(
                "Tu rutina",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 27,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 18),

              // ── Toggle GYM / CASA ─────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => tipoRutina = "GYM"),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        height: 64,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: tipoRutina == "GYM"
                                ? Colors.cyan
                                : Colors.white.withOpacity(0.07),
                          ),
                          gradient: tipoRutina == "GYM"
                              ? LinearGradient(colors: [
                            Colors.cyan.withOpacity(0.22),
                            Colors.blue.withOpacity(0.07),
                          ])
                              : null,
                          color: tipoRutina == "GYM"
                              ? null
                              : const Color(0xFF0D1A2D),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.fitness_center, color: Colors.cyan, size: 26),
                            SizedBox(width: 10),
                            Text("GYM", style: TextStyle(
                              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800,
                            )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => tipoRutina = "CASA"),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        height: 64,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: tipoRutina == "CASA"
                                ? Colors.purpleAccent
                                : Colors.white.withOpacity(0.07),
                          ),
                          gradient: tipoRutina == "CASA"
                              ? LinearGradient(colors: [
                            Colors.purpleAccent.withOpacity(0.22),
                            Colors.pink.withOpacity(0.07),
                          ])
                              : null,
                          color: tipoRutina == "CASA"
                              ? null
                              : const Color(0xFF0D1A2D),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.home, color: Colors.purpleAccent, size: 26),
                            SizedBox(width: 10),
                            Text("CASA", style: TextStyle(
                              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800,
                            )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // ── Card principal ────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: const Color(0xFF0D1A2D),
                  border: Border.all(
                    color: accentColor.withOpacity(0.15),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withOpacity(0.06),
                      blurRadius: 20,
                      spreadRadius: 1,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: isGym
                              ? [Colors.cyan.withOpacity(0.28), Colors.blue.withOpacity(0.10)]
                              : [Colors.purpleAccent.withOpacity(0.28), Colors.pink.withOpacity(0.10)],
                        ),
                      ),
                      child: Icon(
                        isGym ? Icons.fitness_center : Icons.home,
                        color: accentColor,
                        size: 42,
                      ),
                    ),

                    const SizedBox(height: 22),

                    Text(
                      "${dias[seleccionado]} ${fechaSeleccionada.day}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 38,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      subtituloFecha,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.3),
                        fontSize: 13,
                        letterSpacing: 0.4,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      isGym ? "Rutina de gimnasio" : "Rutina en casa",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.4),
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 40),

                    Icon(
                      Icons.fact_check_outlined,
                      color: Colors.white.withOpacity(0.12),
                      size: 100,
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      "Aún no tienes ejercicios",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "Los ejercicios generados aparecerán aquí.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.35),
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),

                    const SizedBox(height: 36),

                    Container(
                      width: double.infinity,
                      height: 62,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: accentColor, width: 1.5),
                      ),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, color: accentColor, size: 30),
                            const SizedBox(width: 10),
                            Text(
                              "Agregar ejercicios",
                              style: TextStyle(
                                color: accentColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
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