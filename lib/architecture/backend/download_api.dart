// import 'dart:developer';
// import 'dart:io';
// import 'package:base/architecture/backend/firebase_storage_api.dart';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';

// import '../permissions/__storage_permission.dart';
// import '../root/root.dart';
// import '../widget_default/__toast.dart';

// class DownloadApi {
//   // Download path
//   Future<String?> getDownloadPath() async {
//     Directory? directory;
//     try {
//       if (Platform.isIOS) {
//         directory = await getApplicationDocumentsDirectory();
//       } else {
//         directory = Directory('/storage/emulated/0/Download/${ROOT.institutionAbbreviation}');
//         // Put file in global download folder, if for an unknown reason it didn't exist,
//         // Create the folder.
//         if (!await directory.exists()) {
//           log('GET DOWNLOAD PATH :: Download Path Does not exist.');
//           log('GET DOWNLOAD PATH :: Creating folder path.');
//           final path = Directory('/storage/emulated/0/Download/${ROOT.institutionAbbreviation}');
//           var status = await Permission.storage.request();
//           if (status.isGranted) {
//             await Permission.storage.request();
//             path.create();
//           }
//           // File().createSync(recursive: true);
//           // directory = await getExternalStorageDirectory();
//         }
//       }
//     } catch (e) {
//       myToast(msg: 'Error! in storage problem.');
//     }
//     return directory!.path;
//   }

//   Future<File?> fileDonwload({BuildContext? context, required String url}) async {
//     myToast(msg: 'Start Downloading...');

//     log('================= DONWLOAD =================');
//     // Getting Storage Permission
//     bool isStoragePermissionGranted = await getStoragePermission();
//     if (!isStoragePermissionGranted) {
//       myToast(msg: 'Error! getting Storage permission');
//       return null;
//     }
//     log('Storage permission granted');

//     // Getting Download Path
//     final appStorage = await getDownloadPath();
//     // Getting File Name
//     String fileName = FirebaseApi.firebaseFileNameFromURL(url);

//     // String fileNameOnly = fileName.split('.').last;
//     // log('FILE NAME ONLY ::  $fileNameOnly');
//     // String extension = url.split('.').last.split('?').first;
//     // log('FILE EXTENSION ::  $extension');'

//     String fileNameOnly = fileName.split('.').first;
//     log('FILE NAME ONLY ::  $fileNameOnly');
//     String extension = fileName.split('.').last;
//     log('FILE EXTENSION ::  $extension');

//     // IF FIle Alerady exist.
//     var file = File('$appStorage/$fileName');

//     int count = 0;

//     while (await file.exists()) {
//       count++;
//       fileName = '$fileNameOnly-($count).$extension';
//       file = File('$appStorage/$fileName');
//     }

//     log('file  $file');
//     try {
//       log('NOW DOWNLOADING -----> ');
//       final response = await Dio().get(url,
//           options: Options(sendTimeout: 200, responseType: ResponseType.bytes, followRedirects: false, receiveTimeout: 0),
//           onReceiveProgress: (actualBytes, totalBytes) => context!.read<Download>().update((actualBytes / totalBytes)));

//       log('after dio');
//       final raf = file.openSync(mode: FileMode.writeOnly);
//       log(raf.toString());
//       raf.writeFromSync(response.data);
//       await raf.close();
//       log(file.toString());
//       return file;
//     } catch (e) {
//       log('ERROR DOWNLOADING  :: $e');
//       myToast(msg: 'Error! Downloading Attachment.');
//       return null;
//     }
//   }

// }