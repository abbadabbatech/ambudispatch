// Automatic FlutterFlow imports
import '../../backend/backend.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
// Begin custom widget code
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//import 'package:hail_repair/backend/firebase_storage/storage.dart';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
//import '../../backend/firebase_storage/storage.dart';
import 'package:mime_type/mime_type.dart';
//import '../../flutter_flow/flutter_flow_icon_button.dart';
//import '../../flutter_flow/flutter_flow_theme.dart';
//import '../../flutter_flow/upload_media.dart';

class PdfUpload extends StatefulWidget {
  const PdfUpload({
    Key key,
    this.width,
    this.height,
  }) : super(key: key);

  final double width;
  final double height;

  @override
  _PdfUploadState createState() => _PdfUploadState();
}

class _PdfUploadState extends State<PdfUpload> {
  String pdfUploadedFileUrl = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlutterFlowIconButton(
        borderColor: Colors.transparent,
        borderRadius: 30,
        buttonSize: 48,
        icon: FaIcon(
          FontAwesomeIcons.filePdf,
          color: Colors.blue,
          size: 30,
        ),
        onPressed: () async {
          final FilePickerResult result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['pdf'],
          );
          if (result != null) {
            File file = File(result.files.single.path);
            showUploadMessage(
              context,
              'Uploading file...',
              showLoading: true,
            );
            final downloadUrl =
                await uploadData(file.path, file.readAsBytesSync());
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            if (downloadUrl != null) {
              setState(() => pdfUploadedFileUrl = downloadUrl);
              showUploadMessage(
                context,
                'Success!',
              );
            } else {
              showUploadMessage(
                context,
                'Failed to upload media',
              );
              return;
            }
          }
        },
      ),
    );
  }
}

class FlutterFlowIconButton extends StatelessWidget {
  const FlutterFlowIconButton(
      {Key key,
      this.borderColor,
      this.borderRadius,
      this.borderWidth,
      this.buttonSize,
      this.fillColor,
      this.icon,
      this.onPressed})
      : super(key: key);

  final double borderRadius;
  final double buttonSize;
  final Color fillColor;
  final Color borderColor;
  final double borderWidth;
  final Widget icon;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) => Material(
        borderRadius:
            borderRadius != null ? BorderRadius.circular(borderRadius) : null,
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        child: Ink(
          width: buttonSize,
          height: buttonSize,
          decoration: BoxDecoration(
            color: fillColor,
            border: Border.all(
              color: borderColor ?? Colors.transparent,
              width: borderWidth ?? 0,
            ),
            borderRadius: borderRadius != null
                ? BorderRadius.circular(borderRadius)
                : null,
          ),
          child: IconButton(
            icon: icon,
            onPressed: onPressed,
            splashRadius: buttonSize,
          ),
        ),
      );
}

void showUploadMessage(BuildContext context, String message,
    {bool showLoading = false}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (showLoading)
              Padding(
                padding: EdgeInsetsDirectional.only(end: 10.0),
                child: CircularProgressIndicator(),
              ),
            Text(message),
          ],
        ),
      ),
    );
}

Future<String> uploadData(String path, Uint8List data) async {
  final storageRef = FirebaseStorage.instance.ref().child(path);
  final metadata = SettableMetadata(contentType: mime(path));
  final result = await storageRef.putData(data, metadata);
  return result.state == TaskState.success ? result.ref.getDownloadURL() : null;
}
