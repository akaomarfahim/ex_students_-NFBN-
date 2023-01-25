import 'dart:io';
import 'dart:developer';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../models/photo_model.dart';
import '../root/root.dart';
import '../widget_default/__toast.dart';
import 'package:provider/provider.dart';
import '../providers/upload_provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:file_picker/file_picker.dart';
import '../utils/listtostring_stringtolist.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseFile {
  String? name;
  String? url;

  FirebaseFile({
    this.name,
    this.url,
  });
}

class FirebaseApi {
  // Firebase Connection
  static DatabaseReference connect = FirebaseDatabase.instance.ref(ROOT.firebaseRoot);

  // Firebase Filename From Link
  static firebaseFileNameFromURL(String url) => url.split('/').last.split('%2F').last.split('?').first;
  static firebaseFileExtensionFromURL(String url) => url.split('/').last.split('.').last.split('?').first.toLowerCase();
  // https://firebasestorage.googleapis.com/v0/b/ndub-f55f9.appspot.com/o/image_error.png?alt=media&token=10f7f6f1-f322-4a7a-b473-31ec9378cd03

  // Firebase Data Class Remove
  static Future<bool> remove({String? key, String address = ''}) async {
    try {
      DatabaseReference ref = FirebaseApi.connect.child(address);
      if (key == null) {
        // ! id is not given then the full branch will be removed.
        ref.remove();
      } else {
        ref.child(key).remove();
      }
      return true;
    } catch (e) {
      myToast(msg: 'error! removing item.');
      return false;
    }
  }

  // Storage:

  static Future<List<FirebaseFile>> getFiles({String path = ''}) async {
    List<FirebaseFile> items = [];
    try {
      final ref = FirebaseStorage.instance.ref(path);
      final snapshot = await ref.listAll();
      for (var element in snapshot.items) {
        items.add(FirebaseFile(name: element.name, url: await element.getDownloadURL()));
      }
    } catch (e) {
      myToast(msg: 'error! loading files');
    }
    return items;
  }

  static Future<ListResult> getFilesasList({String path = ''}) async {
    List<FirebaseFile> items = [];
    items.clear();

    final ref = FirebaseStorage.instance.ref(path);
    return await ref.listAll();
  }

  static Future<List<PhotoModel>> getPhotos({String address = ''}) async {
    List<PhotoModel> items = [];
    try {
      DatabaseReference ref = FirebaseApi.connect.child(address);
      final snapshot = await ref.get();
      items.clear();
      for (var element in snapshot.children) {
        PhotoModel item = PhotoModel.fromMap(Map<String, dynamic>.from(element.value as Map));
        item.key = element.key;
        items.add(item);
      }
      return items;
    } catch (e) {
      return items;
    }
  }

  static Future<PhotoModel> getPhoto({String address = ''}) async {
    try {
      DatabaseReference ref = FirebaseApi.connect.child(address);
      final snapshot = await ref.get();
      final item = PhotoModel.fromMap(Map<String, dynamic>.from(snapshot.children.first.value as Map));
      item.key = snapshot.children.first.key;
      return item;
    } catch (e) {
      return PhotoModel();
    }
  }

  static uploadFilewithSelection({required BuildContext context, FileType fileType = FileType.any, String? destination = 'notice', String? renameTo}) async {
    // setting id to define differently,
    //  context.read<Upload>().setId(id);
    // select file.
    PlatformFile? pickedFile = await selectFile(fileType: fileType);
    if (pickedFile == null) return;
    if (context.mounted) context.read<Upload>().setFile(pickedFile, pickedFile.name);

    // Confirmation Dialog

    // File
    final file = File(pickedFile.path!);

    // Firebase Saving Destination and FileName.
    var path = '$destination/${pickedFile.name}';

    // Firebase Saving Destination and Renamed file.
    if (renameTo.isNotEmptyAndNotNull) path = '$destination/$renameTo.${pickedFile.extension}';

    // --------------- renaming if exist
    if (renameTo.isEmptyOrNull) {
      log('renaming');
      log('Destinaton:: $destination');
      String? newFileName = pickedFile.name; // new file name for checking.=
      String? extension = pickedFile.extension; // fule extesion
      int i = 1; // count for rename numbering,
      while (await FirebaseApi.isFileExist(address: destination ?? 'junk', filename: newFileName ?? '')) {
        // checking
        log('exist');
        newFileName = removeExtension(pickedFile.name); // removing extension. from the actual file name and assign it.
        newFileName = "$newFileName-($i)"; // adding number.
        newFileName = '$newFileName.$extension'; // adding extension.
        i++; // increading
      }
      if (context.mounted) context.read<Upload>().setFile(pickedFile, newFileName);
      path = '$destination/$newFileName';
    }
    // -------------------------

    try {
      myToast(msg: 'uploading...');
      final ref = FirebaseStorage.instance.ref().child(path);
      UploadTask? uploadTask = ref.putFile(file);

      // Upload Provider: sending uploaded bytes
      uploadTask.snapshotEvents.listen((event) {
        log((event.bytesTransferred.toDouble() / event.totalBytes.toDouble()).toString());
        var value = (event.bytesTransferred.toDouble() / event.totalBytes.toDouble());
        if (context.mounted) context.read<Upload>().updateValue(value, true);
      }).onError((error) {});

      final snapshot = await uploadTask.whenComplete(() => {});
      final downloadURL = await snapshot.ref.getDownloadURL();

      // Upload Provider: sending file download link;
      if (context.mounted) context.read<Upload>().setImageURL(downloadURL);
      log("Download URL : $downloadURL");

      // return null;
    } on FirebaseException catch (e) {
      log(e.toString());
      myToast(msg: 'upload failed!');
      // return null;
    }
  }

  static Future<PlatformFile?> selectFile({FileType fileType = FileType.any, bool multipleFiles = false}) async {
    try {
      final results = await FilePicker.platform.pickFiles(allowMultiple: multipleFiles, type: fileType);
      if (results != null) return results.files.first;
    } catch (e) {
      myToast(msg: 'something went wrong!');
    }
    return null;
  }

  static Future<UploadTask?> uploadFile({required BuildContext context, PlatformFile? pickedFile, String? destination = 'notice/attachments', String? renameTo}) async {
    // select file.
    if (pickedFile == null) return null;

    // Confirmation Dialog

    // File
    final file = File(pickedFile.path!);

    // Firebase Saving Destination and FileName.
    var path = '$destination/${pickedFile.name}';

    // Firebase Saving Destination and Renamed file.
    if (renameTo.isNotEmptyAndNotNull) path = '$destination/$renameTo.${pickedFile.extension}';

    // --------------- renaming if exist
    if (renameTo.isEmptyOrNull) {
      String? newFileName = pickedFile.name; // new file name for checking.=
      String? extension = pickedFile.extension; // fule extesion
      int i = 1; // count for rename numbering,
      while (await FirebaseApi.isFileExist(address: destination ?? 'junk', filename: newFileName ?? '')) {
        // checking
        newFileName = removeExtension(newFileName ?? ''); // removing extension.
        newFileName = "$newFileName-($i)"; // adding number.
        newFileName = '$newFileName.$extension'; // adding extension.
        i++; // increading
      }
    }
    // -------------------------

    try {
      myToast(msg: 'uploading...');
      final ref = FirebaseStorage.instance.ref().child(path);
      // final storagfe = ref.getMetadata()
      UploadTask? uploadTask = ref.putFile(file);

      // final snapshot = await uploadTask.whenComplete(() => {});
      // final downloadURL = await snapshot.ref.getDownloadURL();

      // // Upload Provider: sending file download link;
      // log("Download URL : $downloadURL");

      return uploadTask;
    } on FirebaseException catch (e) {
      log(e.toString());
      myToast(msg: 'upload failed!');
      return null;
    }
  }

  static Future<bool> isFileExist({String address = 'notice/attachments/', required String filename}) async {
    log('FILENAME:: $filename');
    log('Destination:: $address');
    try {
      final storage = FirebaseStorage.instance.ref(address);
      String? link = await storage.child(filename).getDownloadURL();
      log("LINK: $link");
      if (link.isNotEmptyAndNotNull) return true;
    } catch (e) {
      return false;
    }
    return false;
  }
}
