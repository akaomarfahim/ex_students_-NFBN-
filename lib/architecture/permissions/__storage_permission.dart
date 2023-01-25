// Get Storage Permission.
import 'package:permission_handler/permission_handler.dart';

Future<bool> getStoragePermission() async {
  if (await Permission.storage.request().isGranted) {
    return true;
  } else {
    return false;
  }
}
