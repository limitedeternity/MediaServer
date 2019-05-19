import 'dart:async';
import 'package:permission_handler/permission_handler.dart';

Future<void> queryPermissions() async {
  List<PermissionGroup> perms = [PermissionGroup.storage];

  while (true) {
    Map<PermissionGroup, PermissionStatus> permRequestResult =
        await PermissionHandler().requestPermissions(perms);

    bool allGranted = permRequestResult.values
        .every((PermissionStatus status) => status == PermissionStatus.granted);

    if (allGranted) {
      break;
    }

    await new Future.delayed(const Duration(milliseconds: 300));
  }
}
