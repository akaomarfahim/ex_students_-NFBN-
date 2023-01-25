import 'package:base/architecture/widget_default/__appbar.dart';
import 'package:base/architecture/widget_default/__text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../main.dart';
import '../../models/photo_model.dart';
import '../__colors.dart';
import '../__default.dart';
import '../__text_styles.dart';
import '../__time.dart';
import '../backend/firebase_storage_api.dart';
import '../file/w_image_upload.dart';
import '../navigation_drawer/__route.dart';
import '../providers/upload_provider.dart';
import '../widget_default/__button.dart';
import '../widget_default/__loadings.dart';
import '../widget_default/__toast.dart';

class ItemDetails extends StatefulWidget {
  final PhotoModel? item;
  final bool isEditMood;
  final String dataUpdateDestination;
  final String photoUploadDestination;
  final String? photoRenameTo;
  const ItemDetails({
    Key? key,
    this.item,
    this.isEditMood = false,
    this.dataUpdateDestination = '',
    this.photoUploadDestination = '',
    this.photoRenameTo,
  }) : super(key: key);

  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  PhotoModel item = PhotoModel();
  final _title = TextEditingController();
  final _description = TextEditingController();
  bool isLoadingComplete = true;
  bool isUploadComplete = true;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      item = widget.item ?? PhotoModel();
      _title.text = item.title ?? '';
      _description.text = item.description ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    _imageUrl = context.watch<Upload>().imageURL;
    isUploadComplete = context.watch<Upload>().isImageUploadComplete;

    return WillPopScope(
      onWillPop: () async {
        NavigationRoute.currentPage = MyRoutes.home;
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: MyColors.itemDetailsBackground,
        appBar: myAppBar(
            context: context,
            title: item.title ?? "Item update: ${widget.photoRenameTo ?? ''}",
            foreground: Colors.black,
            systemNavigationBarColor: MyColors.itemDetailsBackground),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: CustomScrollView(slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                      width: double.infinity,
                      color: Colors.transparent,
                      child: Stack(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(Def.circularRadius),
                          child: Center(
                              child: ((item.imageLink ?? '').isNotBlank && _imageUrl.isEmptyOrNull)
                                  ? InteractiveViewer(
                                      child: CachedNetworkImage(
                                          imageUrl: item.imageLink ?? '',
                                          fit: BoxFit.fitHeight,
                                          alignment: Alignment.center,
                                          width: double.infinity,
                                          placeholder: (context, url) => myCircularLoader(height: 200),
                                          errorWidget: (context, url, error) => const Icon(Icons.error)),
                                    )
                                  : const SizedBox(width: double.infinity, height: 400)),
                        ),
                        if (widget.isEditMood) Positioned.fill(child: imageUpload(context: context, destination: widget.photoUploadDestination, renameTo: widget.photoRenameTo))
                      ])),
                  // myText(label: widget.item!.date, height: 30),

                  if (widget.isEditMood)
                    myButton(
                        label: 'Update Details',
                        background: Colors.white,
                        foreground: Colors.black,
                        icon: CupertinoIcons.upload_circle,
                        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                        isLoadingComplete: isUploadComplete && isLoadingComplete,
                        borderRadius: 6,
                        action: isLoadingComplete
                            ? () async {
                                setState(() => isLoadingComplete = false);
                                PhotoModel newItem = PhotoModel(title: _title.text, description: _description.text, imageLink: item.imageLink, date: MyTime.getDateTime());
                                if (_imageUrl != null) newItem.imageLink = _imageUrl;
                                DatabaseReference ref = FirebaseApi.connect.child(widget.dataUpdateDestination);
                                try {
                                  await ref.update(newItem.toMap());
                                  if (mounted) context.read<Upload>().reset();
                                  // await Upload.updateData(
                                  //     context: context,
                                  //     item: ItemModel(title: _title.text, description: _description.text, link: link, index: widget.item.key ?? -1),
                                  //     updateLocation: widget.updateDestination);
                                } catch (e) {
                                  myToast(msg: 'error! updating data');
                                  if (mounted) setState(() => isUploadComplete = true);
                                  return;
                                }
                                if (mounted) Navigator.pop(context);
                              }
                            : null),
                  const SizedBox(height: 10),
                  Text("${widget.item!.date}", style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 10)),

                  // Title
                  TextFormField(
                      enabled: widget.isEditMood ? true : false,
                      readOnly: widget.isEditMood ? false : true,
                      controller: _title,
                      minLines: 1,
                      maxLines: 3,
                      textAlign: TextAlign.left,
                      decoration: const InputDecoration(border: InputBorder.none),
                      style: TextStyleFor.itemDetailsTitle),
                  // Divider
                  const Divider(height: 1, thickness: 1, endIndent: 0, indent: 0, color: Colors.black26),
                  // myText(label: widget.item!.date, height: 30),
                  // Description
                  Expanded(
                      child: TextFormField(
                          enabled: widget.isEditMood ? true : false,
                          readOnly: widget.isEditMood ? false : true,
                          controller: _description,
                          textAlign: TextAlign.left,
                          maxLines: widget.isEditMood ? 40 : null,
                          decoration: const InputDecoration(border: InputBorder.none),
                          style: TextStyleFor.itemDetailsDescription)),
                  const SizedBox(height: 200)
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
