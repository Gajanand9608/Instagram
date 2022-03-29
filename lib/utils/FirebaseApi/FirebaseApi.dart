import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseApi{
  static UploadTask? uploadFile(String destination, File file) {
    try{
      final metadata = SettableMetadata(
        contentType: 'video/mp4',
        customMetadata: {'picked-file-path': file.path});
      final ref = FirebaseStorage.instance.ref(destination);
      print("Here--- goga");
      return ref.putFile((file), metadata);
    } on FirebaseException catch(e) {
      print(e);
      return null;
    }
  }
}