import 'package:flutter/material.dart';

class Download with ChangeNotifier {
  double _downlodPercentage = 0;
  bool _isDownloading = false;
  int _noticeIndex = 0;

  double get percentage => _downlodPercentage;
  bool get isDownloading => _isDownloading;
  int get noticeIndex => _noticeIndex;

  // updating the percentage or the download.
  void update(double percentage) {
    _downlodPercentage = percentage;
    if (_downlodPercentage + 0.01 >= 1) reset();
    notifyListeners();
  }

  // reset the download percentage to 0;
  void reset() => {_downlodPercentage = 0, notifyListeners()};

  // set true, when start  download.
  void startDownload(int index) => {_isDownloading = true, _noticeIndex = index, notifyListeners()};
  // set false, when download complete.
  void restDownload() => {_isDownloading = false, notifyListeners()};
}
