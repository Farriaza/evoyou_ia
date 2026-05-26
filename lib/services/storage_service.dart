import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {

  static Future<String?> subirFoto(

      File imagen,

      String uid,
      ) async {

    try {

      final ref = FirebaseStorage.instance

          .ref()

          .child("perfil")

          .child("$uid.jpg");

      await ref.putFile(imagen);

      final url =
      await ref.getDownloadURL();

      return url;

    } catch (e) {

      print("ERROR STORAGE:");

      print(e);

      return null;
    }
  }
}