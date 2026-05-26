import 'dart:io';

import 'package:path_provider/path_provider.dart';

class LocalImageService {

  static Future<String> guardarImagen(

      File imagen,
      String uid,
      ) async {

    final directory =
    await getApplicationDocumentsDirectory();

    final path =
        "${directory.path}/$uid.jpg";

    final nuevaImagen =
    await imagen.copy(path);

    return nuevaImagen.path;
  }
}