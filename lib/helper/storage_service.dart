import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class Storage {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> uploadFile(String filePath, String fileName) async {
    File file = File(filePath);

    try {
      print("fileName: $fileName");
      await storage.ref('profilepic/$fileName').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }

  Future<firebase_storage.ListResult> listfiles() async {
    firebase_storage.ListResult result =
        await storage.ref('profilepic').listAll();

    result.items.forEach((firebase_storage.Reference ref) {
      print('file found: $ref');
    });
    return result;
  }
}
