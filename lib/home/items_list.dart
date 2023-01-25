import 'package:base/architecture/widget_default/__appbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import '../architecture/__colors.dart';
import '../architecture/__text_styles.dart';
import '../architecture/backend/firebase_storage_api.dart';
import '../architecture/navigation_drawer/__route.dart';
import '../architecture/pages/item_details.dart';
import '../architecture/widget_default/__loadings.dart';
import '../main.dart';
import '../models/photo_model.dart';

class ItemsList extends StatefulWidget {
  final String address;
  final String title;
  final bool showItemTile;
  const ItemsList({
    Key? key,
    required this.address,
    required this.title,
    this.showItemTile = false,
  }) : super(key: key);

  @override
  State<ItemsList> createState() => _NewsState();
}

class _NewsState extends State<ItemsList> {
  bool isLoadingComplete = false;
  List<PhotoModel> list = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    if (mounted) setState(() => isLoadingComplete = false);
    list = await FirebaseApi.getPhotos(address: widget.address);
    if (mounted) setState(() => isLoadingComplete = true);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        NavigationRoute.currentPage = MyRoutes.home;
        return true;
      },
      child: Scaffold(
          appBar: myAppBar(context: context, title: widget.title),
          backgroundColor: MyColors.appDefaultBG,
          body: (list.isNotEmpty)
              ? ListView.builder(itemCount: list.length, itemBuilder: (context, index) => widget.showItemTile ? itemTile(item: list[index]) : newsTile(item: list[index]))
              : (isLoadingComplete)
                  ? Center(child: Text('Nothing to show', style: TextStyleFor.nothingToShow))
                  : Center(child: myCircularLoader())),
    );
  }

  newsTile({required PhotoModel item, double radius = 6}) => ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Card(
          borderOnForeground: false,
          margin: const EdgeInsets.all(6),
          color: MyColors.newsPaper,
          child: Container(
              height: 200,
              margin: const EdgeInsets.all(2),
              child: InkWell(
                splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ItemDetails(isEditMood: false, item: item))),
                child: Column(children: [
                  if (item.imageLink!.isNotEmptyAndNotNull)
                    Expanded(
                        flex: 70,
                        child: ClipRRect(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(radius), topRight: Radius.circular(radius)),
                            child: CachedNetworkImage(
                                imageUrl: item.imageLink ?? '',
                                width: double.infinity,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(alignment: Alignment.center, child: myCircularLoader()),
                                errorWidget: (context, url, error) => const Center(child: Icon(Icons.error))))),
                  Expanded(
                      flex: 30,
                      child: ClipRRect(
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(radius), bottomRight: Radius.circular(radius)),
                          child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              // color: Colors.white70,
                              padding: const EdgeInsets.fromLTRB(6, 4, 6, 2),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(item.title ?? '',
                                    style: const TextStyle(fontFamily: 'RobotoSlab', fontSize: 15, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 2),
                                Text(item.description ?? '',
                                    style: const TextStyle(fontFamily: 'Ubuntu', height: 1.2, fontSize: 10, fontWeight: FontWeight.w400),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis)
                              ]))))
                ]),
              )),
        ),
      );

  itemTile({required PhotoModel item, double radius = 6}) => ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Card(
          borderOnForeground: false,
          margin: const EdgeInsets.all(4),
          color: MyColors.newsPaper,
          elevation: 4,
          child: Container(
              height: 120,
              margin: const EdgeInsets.all(2),
              padding: const EdgeInsets.all(1),
              child: InkWell(
                splashFactory: InkSparkle.constantTurbulenceSeedSplashFactory,
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ItemDetails(isEditMood: false, item: item))),
                child: Row(children: [
                  if (item.imageLink.isNotEmptyAndNotNull)
                    Expanded(
                        flex: 30,
                        child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(radius)),
                            child: CachedNetworkImage(
                                imageUrl: item.imageLink ?? '',
                                width: double.infinity,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(alignment: Alignment.center, child: myCircularLoader()),
                                errorWidget: (context, url, error) => const Center(child: Icon(Icons.error))))),
                  Expanded(
                      flex: 70,
                      child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          // color: Colors.white70,
                          padding: const EdgeInsets.fromLTRB(6, 4, 6, 2),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(item.title ?? '',
                                style: const TextStyle(fontFamily: 'RobotoSlab', fontSize: 14, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
                            if (item.data1 != null) const SizedBox(height: 2),
                            if (item.data1 != null)
                              Text(item.data1 ?? '',
                                  style: const TextStyle(fontFamily: 'RobotoSlab', color: Colors.blueGrey, fontSize: 11, fontWeight: FontWeight.w500),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 2),
                            Text(item.description ?? '',
                                style: const TextStyle(fontFamily: 'Ubuntu', height: 1.2, color: Colors.black54, fontSize: 10, fontWeight: FontWeight.w400),
                                maxLines: 5,
                                softWrap: true,
                                overflow: TextOverflow.ellipsis)
                          ])))
                ]),
              )),
        ),
      );
}
