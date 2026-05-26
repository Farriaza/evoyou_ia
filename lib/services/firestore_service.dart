import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {

  static Future<bool> usuarioExiste(String uid) async {

    final doc = await FirebaseFirestore.instance
        .collection("usuarios")
        .doc(uid)
        .get();

    return doc.exists;
  }
}