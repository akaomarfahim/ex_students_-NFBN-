import 'dart:developer';
import 'package:base/architecture/notificationservice/notification_sender.dart';
import 'package:base/architecture/root/root.dart';
import 'package:base/architecture/widget_default/__appbar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';
import '../architecture/__default.dart';
import '../architecture/__time.dart';
import '../architecture/dialog/__loading_dialog.dart';
import '../architecture/backend/firebase_storage_api.dart';
import '../architecture/file/w_image_upload.dart';
import '../architecture/navigation_drawer/__route.dart';
import '../architecture/providers/upload_provider.dart';
import '../architecture/widget_default/__button.dart';
import '../architecture/widget_default/__loadings.dart';
import '../architecture/widget_default/__textbox.dart';
import '../architecture/widget_default/__toast.dart';
import '../architecture/pages/item_details.dart';
import '../main.dart';
import '../models/photo_model.dart';

class PhotoSliderEdit extends StatefulWidget {
  final String address;
  final String photoUploadDestination;
  final bool imageRequired;
  final bool imageOnly;
  const PhotoSliderEdit({
    Key? key,
    this.address = 'photo_slider',
    this.photoUploadDestination = '',
    this.imageRequired = true,
    this.imageOnly = false,
  }) : super(key: key);

  @override
  State<PhotoSliderEdit> createState() => _PhotoSliderEditState();
}

class _PhotoSliderEditState extends State<PhotoSliderEdit> {
  final _title = TextEditingController();
  final _description = TextEditingController();
  String? _imageUrl;
  bool isLoadingComplete = false;
  bool isDeleteComplete = true;
  bool isUploadComplete = true;
  List<PhotoModel> items = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    // Loading Photo Slider Datas'
    items = await FirebaseApi.getPhotos(address: widget.address);
    isDeleteComplete = true;
    isLoadingComplete = true;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _imageUrl = context.watch<Upload>().imageURL;
    isUploadComplete = context.watch<Upload>().isImageUploadComplete;
    return WillPopScope(
      onWillPop: () async {
        NavigationRoute.currentPage = MyRoutes.adminMenu;
        return true;
      },
      child: Container(
          decoration: const BoxDecoration(image: DecorationImage(image: AssetImage("assets/images/ps_bg.png"), fit: BoxFit.fitHeight)),
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.blueGrey.withOpacity(0.1),
              appBar: myAppBar(context: context, title: 'Item Uploader', foreground: Colors.black87),
              body: Container(
                  width: double.infinity,
                  height: double.infinity,
                  padding: const EdgeInsets.all(8),
                  child: SingleChildScrollView(
                      child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                    SizedBox(height: 200, child: imageUpload(context: context, destination: widget.photoUploadDestination)),
                    const SizedBox(height: 8),
                    if (!widget.imageOnly) myTextBox(controller: _title, backgroundColor: Colors.white70, hint: 'title', maxLine: 2, minLines: 1),
                    // const SizedBox(height: 8),
                    if (!widget.imageOnly) myTextBox(controller: _description, backgroundColor: Colors.white70, hint: 'Description', maxLine: 14, minLines: 8),
                    // const SizedBox(height: 8),
                    myButton(
                        label: 'POST',
                        icon: Icons.post_add,
                        isLoadingComplete: isUploadComplete && isLoadingComplete,
                        background: Colors.blueGrey,
                        borderRadius: Def.circularRadius,
                        elevation: 0,
                        splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory,
                        foreground: Colors.white,
                        action: isLoadingComplete
                            ? (!widget.imageOnly)
                                ? () async {
                                    setState(() => isLoadingComplete = false);
                                    myLoadingDialog(context);
                                    PhotoModel newItem =
                                        PhotoModel(title: _title.text.trim(), description: _description.text.trim(), imageLink: _imageUrl, date: MyTime.getDateTime());
                                    if (_imageUrl == null && widget.imageRequired) {
                                      myToast(msg: 'an image is required.');
                                      Navigator.pop(context);
                                      setState(() => isLoadingComplete = true);
                                      return;
                                    }
                                    DatabaseReference ref = FirebaseApi.connect.child(widget.address);
                                    int key = -1;
                                    final snapshot = await ref.get();
                                    if (snapshot.exists) {
                                      key = int.tryParse(snapshot.children.last.key.toString()) ?? -1;
                                    }
                                    key++;
                                    try {
                                      await ref.child(key.toString()).update(newItem.toMap());
                                      await sendNotification(
                                          title: _title.text.trim(), description: _description.text.trim(), imageUrl: _imageUrl, recipient: ROOT.defaultNoticeSubscriber);
                                      // Clearing data fields.
                                      if (mounted) context.read<Upload>().reset();
                                      _title.clear();
                                      _description.clear();
                                      // loadData;
                                      if (mounted) Navigator.pop(context);
                                      if (mounted) await loadData();
                                    } catch (e) {
                                      myToast(msg: 'error! updating data');
                                      if (mounted) Navigator.pop(context);

                                      return;
                                    }
                                  }
                                : () {
                                    if (mounted) context.read<Upload>().reset();
                                    NavigationRoute.currentPage = MyRoutes.home;
                                    myToast(msg: 'uploaded!');
                                    if (mounted) Navigator.pop(context);
                                  }
                            : null),
                    !isLoadingComplete
                        ? SizedBox(width: double.infinity, height: 100, child: myCircularLoader(strock: 2.4))
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              int reversedIndex = (items.length - 1) - index;
                              return photoTile(items[reversedIndex]);
                            },
                          )
                  ]))))),
    );
  }

  photoTile(PhotoModel item) => Card(
        margin: const EdgeInsets.only(top: 8),
        child: InkWell(
          onTap: isDeleteComplete
              ? () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ItemDetails(
                              item: item, isEditMood: true, photoUploadDestination: widget.photoUploadDestination, dataUpdateDestination: '${widget.address}/${item.key}')));
                  loadData();
                }
              : () => myToast(msg: 'please wait! until deletion is complete.'),
          child: Container(
            height: 65,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
            alignment: Alignment.center,
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              minLeadingWidth: 0,
              minVerticalPadding: 0,
              horizontalTitleGap: 10,
              dense: true,
              leading: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: SizedBox(
                      width: 100,
                      height: 100,
                      child: Image.network(item.imageLink ?? '',
                          fit: BoxFit.fitWidth,
                          loadingBuilder: (context, child, loadingProgress) => (loadingProgress == null)
                              ? child
                              : myCircularLoader(
                                  value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                                  showPercentage: true,
                                  bakcground: Colors.white,
                                  color: Colors.blueGrey),
                          errorBuilder: (BuildContext? context, Object? exception, StackTrace? stackTrace) => const Center(child: Icon(Icons.error, color: Colors.red))))),
              title: Text(item.title ?? '',
                  softWrap: true, maxLines: 1, style: const TextStyle(fontFamily: 'RobotoSlab', fontSize: 12, fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis)),
              subtitle: item.description!.text.caption(context).align(TextAlign.start).maxLines(2).overflow(TextOverflow.ellipsis).fontFamily('Nunito').size(9).make(),
              trailing: IconButton(
                onPressed: isDeleteComplete
                    ? () async {
                        if (mounted) setState(() => isDeleteComplete = false);
                        bool isRemoved = await FirebaseApi.remove(address: widget.address, key: item.key);
                        if (isRemoved) myToast(msg: 'item removed...');
                        await loadData();
                      }
                    : () => myToast(msg: 'please wait! until deletion is complete.'),
                icon: !isDeleteComplete
                    ? myCircularLoader(color: Colors.red, bakcground: Colors.transparent, strock: 2, padding: const EdgeInsets.all(16))
                    : const Icon(Icons.delete, color: Colors.redAccent),
                alignment: Alignment.center,
                padding: EdgeInsets.zero,
                iconSize: 20,
              ),
            ),
          ),
        ),
      ).cornerRadius(Def.circularRadius);
}
