import 'dart:developer';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class Upload with ChangeNotifier {
  PlatformFile? _pickedFile;
  String? _imageURL;
  String _fileName = '';
  double? _value;
  bool? _isStart;
  bool _isImageUploadComplete = true;

  PlatformFile? get pickedFile => _pickedFile;
  String? get imageURL => _imageURL;
  String get fileName => _fileName;
  double? get value => _value;
  bool? get isStart => _isStart;
  bool get isImageUploadComplete => _isImageUploadComplete;

  void setFile(PlatformFile? pickedFile, String? filename) {
    _pickedFile = pickedFile;
    if (_pickedFile != null) {
      // _file = File(pickedFile!.path!);
      _fileName = filename ?? '';
      _isImageUploadComplete = false;
    }
    notifyListeners();
  }

  void setImageURL(String? downloadURL) {
    _imageURL = downloadURL;
    _isImageUploadComplete = true;
    log('inside');
    notifyListeners();
  }

  void updateValue(double? value, bool? isStart) {
    _value = value;
    _isStart = isStart;
    // if (_downlodPercentage + 0.01 >= 1) reset();
    notifyListeners();
  }

  void reset() {
    _pickedFile = _imageURL = _value = _isStart = null;
    _fileName = '';
    _isImageUploadComplete = true;
    notifyListeners();
  }
}



// class Upload with ChangeNotifier {
//   int _id = 0;

//   var _pickedFile = List<PlatformFile?>.filled(10, null);
//   var _imageURL = List<String?>.filled(10, '');
//   var _fileName = List<String>.filled(10, '');
//   var _value = List<double?>.filled(10, 0);
//   var _isStart = List<bool?>.filled(10, false);

//   PlatformFile? get pickedFile => _pickedFile[_id];
//   String get imageURL => _imageURL[_id] ?? '';
//   String get fileName => _fileName[_id];
//   double? get value => _value[_id];
//   bool? get isStart => _isStart[_id];

//   void setId(int id) {
//     _id = id;
//   }

//   void setFile(PlatformFile? pickedFile) {
//     _pickedFile[_id] = pickedFile;
//     if (_pickedFile[_id] != null) {
//       // _file = File(pickedFile!.path!);
//       // _fileName.insert(4, _pickedFile!.name);
//       _fileName[_id] = _pickedFile[_id]!.name;
//     }
//     notifyListeners();
//   }

//   void setImageURL(String downloadURL) {
//     _imageURL[_id] = downloadURL;
//     notifyListeners();
//   }

//   void updateValue(double? value, bool? isStart) {
//     _value[_id] = value;
//     _isStart[_id] = isStart;
//     // if (_downlodPercentage + 0.01 >= 1) reset();
//     notifyListeners();
//   }
// }
