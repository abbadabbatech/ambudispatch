// Automatic FlutterFlow imports
import '../../auth/auth_util.dart';

import '../../backend/backend.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import 'package:flutter/material.dart';
// Begin custom action code
//import 'package:hail_repair/auth/auth_util.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
//import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mime_type/mime_type.dart';

Future<String> pdfUpload() async {
  String pdfUploadedFileUrl = '';
  final FilePickerResult result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf'],
  );
  if (result != null) {

    //File file = File(result.files.single.path);
    final fileBytes = result.files.single.bytes;
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    final downloadUrl =
        await uploadData('estimates/uploads/$timestamp.pdf', fileBytes);


    if (downloadUrl != null) {
      return downloadUrl;
    } else {
      return 'failed';
    }
  }
}

Future<String> uploadData(String path, Uint8List data) async {
  final storageRef = FirebaseStorage.instance.ref().child(path);
  final metadata = SettableMetadata(contentType: mime(path));
  final result = await storageRef.putData(data, metadata);
  return result.state == TaskState.success ? result.ref.getDownloadURL() : null;
}
