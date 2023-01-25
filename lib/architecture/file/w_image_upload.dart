import 'dart:io';


import '../backend/firebase_storage_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widget_default/__loadings.dart';
import '../providers/upload_provider.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:file_picker/file_picker.dart';


imageUpload({required BuildContext context, String destination = 'notice', String? renameTo}) => Stack(alignment: Alignment.center, fit: StackFit.expand, children: [
      // Center(child: Image.asset('assets/images/reg_bg.jpg', fit: BoxFit.cover)),
      Center(
          // if picked file and image url both are null then show noting.
          child: (context.watch<Upload>().pickedFile == null && context.watch<Upload>().imageURL.isEmptyOrNull)
              ? null
              // Have picked file and Image url is empty or null show the image from file.
              : (context.watch<Upload>().pickedFile != null && context.watch<Upload>().imageURL.isEmptyOrNull)
                  ? Image.file(
                      File(context.watch<Upload>().pickedFile!.path!),
                      fit: BoxFit.fitHeight,
                      width: double.infinity,
                    )
                  // Bring here when [imageURL and picked file both are not null];
                  // Have Image URL Show  from the url
                  : Image.network(context.watch<Upload>().imageURL ?? '',
                      width: double.infinity, fit: BoxFit.fitHeight, loadingBuilder: (context, child, loadingProgress) => (loadingProgress == null) ? child : myCircularLoader())),
      // Selector Icon and Section
      Positioned.fill(
          child: GestureDetector(
              onTap: () => FirebaseApi.uploadFilewithSelection(context: context, fileType: FileType.image, destination: destination, renameTo: renameTo),
              child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), color: Colors.black38),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.file_upload_rounded, size: 60, color: Colors.white),
                      if (context.watch<Upload>().pickedFile != null)
                        Text(context.watch<Upload>().fileName, style: const TextStyle(fontFamily: 'Ubuntu', color: Colors.white, fontWeight: FontWeight.normal, fontSize: 12)),
                      if (context.watch<Upload>().isStart == true) myLinearLoader(value: context.watch<Upload>().value, showPercentage: true, percentageColor: Colors.white)
                    ],
                  )))),
    ]);
