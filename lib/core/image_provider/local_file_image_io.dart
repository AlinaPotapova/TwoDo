import 'dart:io';

import 'package:flutter/widgets.dart';

/// Returns an [ImageProvider] for a local file if it exists.
///
/// Does not evict the cache—the image will be cached after first load.
ImageProvider? localFileImageProvider(String path) {
  final file = File(path);
  if (!file.existsSync()) return null;
  return FileImage(file);
}

/// Evicts a local file image from Flutter's image cache.
///
/// Call this after caching a new file to force the next load from disk.
Future<bool> evictLocalFileImage(String path) {
  final file = File(path);
  final provider = FileImage(file);
  return provider.evict();
}
