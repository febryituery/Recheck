import 'dart:io';
import 'package:flutter/services.dart';

class FileUtils {
  Future<void> writeToFile(ByteData data, String path) { //digunakan untuk menyimpan file asset ke penyimpanan lokal
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }
}