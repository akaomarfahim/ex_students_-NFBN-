import 'package:base/architecture/__colors.dart';
import 'package:base/architecture/__text_styles.dart';
import 'package:base/architecture/navigation_drawer/__route.dart';
import 'package:base/architecture/widget_default/__loadings.dart';
import 'package:base/home/image_page.dart';
import 'package:base/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:base/architecture/widget_default/__appbar.dart';
import 'package:base/architecture/backend/firebase_storage_api.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import '../architecture/widget_default/__network_image_view.dart';

class PhotoGallery extends StatefulWidget {
  final bool isEditMood;
  const PhotoGallery({super.key, this.isEditMood = false});

  @override
  State<PhotoGallery> createState() => _PhotoGalleryState();
}

class _PhotoGalleryState extends State<PhotoGallery> {
  bool isLoadingComplete = false;
  List<FirebaseFile> items = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    if (mounted) setState(() => isLoadingComplete = false);
    items.clear();
    ListResult snapshot = await FirebaseApi.getFilesasList(path: 'NFBN/gallery');
    for (var element in snapshot.items) {
      items.add(FirebaseFile(name: element.name, url: await element.getDownloadURL()));
      if (mounted) setState(() => isLoadingComplete = true);
    }
    if (mounted) setState(() => isLoadingComplete = true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        NavigationRoute.currentPage = MyRoutes.home;
        return true;
      },
      child: Scaffold(
        appBar: myAppBar(context: context, title: 'Photo Gallery'),
        backgroundColor: MyColors.appDefaultBG,
        body: !isLoadingComplete
            ? Center(child: myCircularLoader())
            : (isLoadingComplete && items.isEmpty)
                ? Center(child: Text('No image to show', style: TextStyleFor.nothingToShow))
                : Container(
                    padding: const EdgeInsets.all(2),
                    child: GridView.builder(
                        cacheExtent: 2000,
                        shrinkWrap: false,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                        addAutomaticKeepAlives: true,
                        itemCount: items.length,
                        itemBuilder: (context, index) => FocusedMenuHolder(
                              menuItems: [
                                if (widget.isEditMood)
                                  FocusedMenuItem(
                                      title: const Text('Delete Photo'),
                                      trailingIcon: const Icon(Icons.delete_forever),
                                      onPressed: () async {
                                        final ref = FirebaseStorage.instance.ref('NFBN/gallery');
                                        await ref.child(items[index].name ?? '').delete();
                                        loadData();
                                        // Show loading dialogue
                                        // myLoadingDialog(context);
                                        // ========= removing notice
                                        // DatabaseReference ref = FirebaseConnection.connect.child('notice').child(widget.noticeReciver);
                                        // ref.child('${notice.id}').remove();

                                        // bool isDelete = await Firebase.remove(id: notice.id, address: 'notice/${widget.noticeReciver}');
                                        // await Future.delayed(const Duration(seconds: 1));
                                        // await loadData();
                                        // if (mounted) Navigator.pop(context);
                                        // isDelete ? myToast(msg: 'notice removed.') : myToast(msg: 'couldn\'t remove the notice.');
                                      })
                              ],
                              animateMenuItems: true,
                              menuOffset: 4,
                              // onPressed: () {},
                              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ImagePage(file: items[index]))),
                              child: myNetworkImage(
                                  imageurl: items[index].url ?? '', showloading: false, fit: BoxFit.cover, margin: const EdgeInsets.all(1.3), filter: FilterQuality.medium),
                            ))),
      ),
    );
  }
}
