import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';

Future<List<String>> filesInDirectory(Directory dir) async {
  List<String> files = <String>[];

  await for (FileSystemEntity entity in dir.list(
    recursive: false,
    followLinks: false,
  )) {
    FileSystemEntityType type = await FileSystemEntity.type(entity.path);
    if (type == FileSystemEntityType.file) files.add(basename(entity.path));
  }

  return files;
}
