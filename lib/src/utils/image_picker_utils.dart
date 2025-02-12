import 'dart:io';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

getImageFromGallery(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);
  if (file != null) {
    Uint8List uint8List = await file.readAsBytes();
    return uint8ListToFile(uint8List, "image.jpg");
  }
}

Future<File> uint8ListToFile(Uint8List data, String filename) async {
  // Get temporary directory
  Directory tempDir = await getTemporaryDirectory();
  String filePath = '${tempDir.path}/$filename';

  File file = File(filePath);
  await file.writeAsBytes(data);

  return file;
}
