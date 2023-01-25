import 'package:flutter/material.dart';
import 'package:base/architecture/widget_default/__appbar.dart';
import 'package:base/architecture/backend/firebase_storage_api.dart';
import 'package:base/architecture/widget_default/__network_image_view.dart';

class ImagePage extends StatelessWidget {
  final FirebaseFile? file;
  const ImagePage({
    Key? key,
    required this.file,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(context: context, title: file!.name ?? '', actions: [
        // IconButton(
        //     onPressed: () async {
        //       // File? file = await fileDonwload(url: attachmentLink, context: context);
        //       // Open File
        //       // if (file != null) fileOpen(file: file);

        //       if (file != null) {
        //         Utils.downloadFile(file!.url ?? '', file!.name ?? '');
        //       } else {
        //         myToast(msg: 'Error! Downloading Image');
        //       }
        //     },
        //     icon: const Icon(CupertinoIcons.download_circle))
      ]),
      backgroundColor: Colors.transparent,
      body: (file != null)
          ? Center(child: myNetworkImage(imageurl: file!.url ?? '', filter: FilterQuality.high, fit: BoxFit.fitHeight, showloading: false))
          : const Center(child: Text('error! loading image')),
    );
  }
}
