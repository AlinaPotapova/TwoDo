import 'dart:io';

import 'package:flutter/widgets.dart';

ImageProvider? localFileImageProvider(String path) {
  final file = File(path);
  if (!file.existsSync()) return null;

  final provider = FileImage(file);
  provider.evict(); // Clear cached version to force reload
  return provider;
}
