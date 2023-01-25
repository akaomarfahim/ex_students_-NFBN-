import 'dart:developer';

import '../architecture/backend/firebase_storage_api.dart';
import '../models/photo_model.dart';
import 'package:flutter/material.dart';
import '../architecture/__colors.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../architecture/widget_default/__loadings.dart';
import '../architecture/pages/item_details.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PhotoSlider extends StatefulWidget {
  final String address;
  const PhotoSlider({Key? key, required this.address}) : super(key: key);

  @override
  State<PhotoSlider> createState() => _PhotoSliderState();
}

class _PhotoSliderState extends State<PhotoSlider> {
  int activeIndex = 0;
  bool isLoadComplete = false;
  List<PhotoModel> items = [];

  @override
  void initState() {
    super.initState();
    isLoadComplete = false;
    loadData();
  }

  Future<void> loadData() async {
    setState(() => isLoadComplete = false);
    items = await FirebaseApi.getPhotos(address: widget.address);
    log(items.length.toString());
    if (mounted) setState(() => isLoadComplete = true);
  }

  @override
  Widget build(BuildContext context) {
    return (items.isEmpty)
        ? Container()
        : !isLoadComplete
            ? SizedBox(height: 200, child: Center(child: myCircularLoader()))
            : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                CarouselSlider.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index, realindex) => buildImage(item: items[index]),
                    options: CarouselOptions(
                        height: 200,
                        clipBehavior: Clip.none,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 3),
                        autoPlayAnimationDuration: const Duration(milliseconds: 1000),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
                        onPageChanged: (index, reason) => setState(() => activeIndex = index),
                        enlargeStrategy: CenterPageEnlargeStrategy.scale)),
                buildIndicator(count: items.length),
              ]);
  }

  Widget buildImage({required PhotoModel item}) => InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ItemDetails(item: item))),
      child: Card(
          elevation: 5,
          shadowColor: Colors.black,
          margin: const EdgeInsets.symmetric(horizontal: 0),
          color: Colors.transparent,
          child: Stack(alignment: Alignment.bottomLeft, children: [
            Container(
                foregroundDecoration: BoxDecoration(color: Colors.black.withOpacity(0.20)),
                child: CachedNetworkImage(
                    imageUrl: item.imageLink ?? '',
                    width: double.infinity,
                    height: 230,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(alignment: Alignment.center, child: myCircularLoader()),
                    errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)))).cornerRadius(10),
            Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              // Title
              (item.title ?? '').text.size(18).fontFamily('TiroBangla').bold.white.shadow(2, 2, 3, Vx.black).maxLines(1).make().pLTRB(8, 4, 8, 2),
              // Description
              // Text(description,
              //     maxLines: 3,
              //     overflow: TextOverflow.ellipsis,
              //     softWrap: true,
              //     style: TextStyle(
              //       fontFamily: 'TiroBangla',
              //       fontSize: 12,
              //       color: Colors.white,
              //     )),
              (item.description ?? '').text.caption(context).size(12).fontFamily('TiroBangla').white.shadow(1, 1, 4, Vx.black).maxLines(3).make().pLTRB(8, 4, 8, 6)
            ]),
          ])));

  buildIndicator({int count = 0}) => Container(
        padding: const EdgeInsets.only(top: 10),
        color: Colors.transparent,
        child: AnimatedSmoothIndicator(
          activeIndex: activeIndex,
          count: count,
          effect: ExpandingDotsEffect(activeDotColor: MyColors.homePagePhotoSliderActiveDotColor, dotColor: MyColors.homePagePhotoSliderDotColor, dotHeight: 3, dotWidth: 20),
        ),
      );
}
