import 'dart:async';
import '../main.dart';
import 'dart:developer';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:base/architecture/backend/firebase_storage_api.dart';
import 'package:base/architecture/navigation_drawer/navigation_drawer.dart';
import 'package:base/architecture/widget_default/__appbar.dart';
import 'package:base/architecture/widget_default/__social_icon.dart';
import 'package:base/home/w__photo_slider.dart';
import 'package:base/models/developer_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:marquee/marquee.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';
import '../architecture/__colors.dart';
import '../architecture/__text_styles.dart';
import '../architecture/__time.dart';
import '../architecture/dialog/__show_dialog.dart';
import '../architecture/navigation_drawer/__route.dart';
import '../architecture/root/root.dart';
import '../architecture/widget_default/__button.dart';
import '../architecture/widget_default/__homebox.dart';
import '../architecture/widget_default/__loadings.dart';
import '../architecture/pages/item_details.dart';
import '../architecture/widget_default/__text.dart';
import '../models/photo_model.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _time = '', _date = '';
  bool isDraswerOpen = false;
  String? scrollingNotice;
  List<PhotoModel> newsList = [];
  List<PhotoModel> eventsList = [];
  DeveloperModel? saifulIslam = DeveloperModel();

  @override
  void initState() {
    super.initState();
    // Timmer and date -Refresh in every seconds.
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() => {_time = MyTime.getTime(), _date = MyTime.getDate()});
    });
    loadData();
  }

  loadData() async {
    DatabaseReference ref = FirebaseApi.connect.child('home');
    final snapshot = await ref.get();
    scrollingNotice = snapshot.child('scrolling_notice').value.toString();
    newsList = await FirebaseApi.getPhotos(address: 'home/news');
    eventsList = await FirebaseApi.getPhotos(address: 'home/events');
    saifulIslam = await getDeveloperData();

    if (mounted) setState(() {});
    appVersionCheck();
  }

  appVersionCheck() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;

    DatabaseReference ref = FirebaseApi.connect.child('version');
    final snapshot = await ref.get();
    String? newVersion = snapshot.child('version').value.toString();
    String? link = snapshot.child('link').value.toString();
    bool? forceUpdate = snapshot.child('force_update').value as bool;
    log(newVersion);
    log(link);
    log(forceUpdate.toString());

    if (newVersion != version) {
      if (mounted) {
        bool confirm = await showConfirmationDialog(
                context: context,
                barrierDismissible: !forceUpdate,
                title: 'UPDATE',
                data1: 'please update your application.',
                buttonLabel2: 'DOWNLOAD',
                hideCancelButton: forceUpdate) ??
            false;
        if (confirm) {
          try {
            launchUrl(Uri.parse(link), mode: LaunchMode.externalApplication);
          } catch (e) {
            log('error! downloading update');
          }
        }
      }
    }
  }

  getDeveloperData() async {
    try {
      DatabaseReference ref = FirebaseApi.connect.child('developer/0');
      final snapshot = await ref.get();
      ref.keepSynced(true);
      if (snapshot.value != null) {
        return DeveloperModel.fromMap(Map<String, dynamic>.from(snapshot.value as Map));
      }
    } catch (e) {
      return DeveloperModel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (isDraswerOpen) {
            Navigator.pop(context);
          } else {
            await homeExitDialog(context);
          }
          return false;
        },
        child: Scaffold(
            backgroundColor: MyColors.appDefaultBG,
            appBar: myAppBar(context: context, title: 'Home'),
            drawer: const MyNavigationDrawer(),
            onDrawerChanged: (isOpened) => isDraswerOpen = isOpened,
            body: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              // Time and Date Header.
              homePageTimeHeader(context: context, date: _date, time: _time),
              // Scrolling Notice.
              if (scrollingNotice != null) homePageScrollingNotice(context: context, notice: scrollingNotice ?? ''),

              /// ----------->
              Expanded(
                  child: RefreshIndicator(
                onRefresh: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home())),
                child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(children: [
                      Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                            const Image(image: AssetImage('assets/logo/logo.png'), height: 80),
                            myText(label: 'NF&BN\'92 Batch (আলোক শিক্ষা)', fontsize: 16, maxFontsize: 16, fontWeight: FontWeight.bold, color: Colors.white)
                          ])),
                      // Photo Slider.
                      const PhotoSlider(address: 'home/photo_slider').py8(),
                      // Leaders Board
                      // const LeadersBoard(),

                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Expanded(
                              flex: 1,
                              child: myButton(
                                  height: 60,
                                  width: 20,
                                  label: 'বন্ধুদের তালিকা',
                                  fontSize: 16,
                                  fontfamily: 'AdorNoirrit',
                                  fontWeight: FontWeight.normal,
                                  action: () => Navigator.pushNamed(context, MyRoutes.friendList))),
                          const SizedBox(width: 5),
                          Expanded(
                              flex: 1,
                              child: myButton(
                                  height: 60,
                                  width: 20,
                                  label: 'ফটো গ্যালারী',
                                  fontSize: 16,
                                  fontfamily: 'AdorNoirrit',
                                  fontWeight: FontWeight.normal,
                                  action: () => Navigator.pushNamed(context, MyRoutes.photoGallery))),
                        ]),
                      ),

                      if (newsList.isNotEmpty)
                        HomeBox(
                            action: () => route(context, MyRoutes.news),
                            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            backgroundColors: Colors.white38,
                            container:
                                const Center(child: Text('LATEST NEWS & UPCOMING EVENTS', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)))),
                      newsSlider(items: newsList),

                      HomeBox(
                          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                          backgroundColors: Colors.white.withOpacity(0.8),
                          container: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                            const Center(
                                child: Text('অ্যাপস তৈরি কারি', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontFamily: 'TiroBangla', fontSize: 14))),
                            const Divider(height: 10, thickness: 0.5, endIndent: 70, indent: 70, color: Colors.black),
                            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              // if (saifulIslam != null && saifulIslam!.imageurl != null)
                              if (saifulIslam!.imageurl != null)
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: CachedNetworkImage(
                                        height: 100,
                                        imageUrl: saifulIslam!.imageurl ?? '',
                                        fadeOutDuration: const Duration(seconds: 2),
                                        fit: BoxFit.fitWidth,
                                        placeholder: (context, url) => myCircularLoader(),
                                        errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red, size: 18))),
                              const SizedBox(width: 6),
                              Expanded(
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                const SizedBox(height: 4),
                                myText(label: saifulIslam!.name ?? 'মোহাম্মাদ সাইফুল ইসলাম', fontFamily: 'TiroBangla', fontsize: 14, fontWeight: FontWeight.bold),
                                myText(label: saifulIslam!.bio ?? 'সহকারী শিক্ষক', fontFamily: 'TiroBangla', fontsize: 13),
                                myText(label: saifulIslam!.content ?? 'বাতাখালী সরকারি প্রাথমিক বিদ্যালয়, লাকসাম', fontFamily: 'TiroBangla', fontsize: 13),
                                myText(label: saifulIslam!.title ?? '+880 171 573 6319, +880 168 437 9696', fontFamily: 'TiroBangla', fontsize: 13),
                                myText(label: saifulIslam!.copywrite ?? 'saifkhaonbd@gmail.com', fontFamily: 'TiroBangla', fontsize: 13),
                              ]))
                            ]),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                socialIcon(icon: FontAwesomeIcons.squareFacebook, link: saifulIslam!.facebook ?? 'https://www.facebook.com/saifulislamitc'),
                                socialIcon(icon: FontAwesomeIcons.twitter, link: 'https://twitter.com/Teachersaiful/'),
                                socialIcon(icon: FontAwesomeIcons.instagram, link: saifulIslam!.instagram ?? 'https://www.instagram.com/saifkhaonbd/'),
                                socialIcon(icon: FontAwesomeIcons.linkedin, link: saifulIslam!.linkdin ?? 'https://www.linkedin.com/in/mohammad-saiful-islam-20aa3298/'),
                                socialIcon(icon: FontAwesomeIcons.youtube, link: saifulIslam!.youtube ?? 'https://www.youtube.com/channel/UCQU6eBpn-TP_fpj_kWvkuzw'),
                              ],
                            )
                          ]))
                    ])),
              ))
            ])));
  }

  // -------------- News Slider --------------
  newsSlider({List<PhotoModel> items = const [], Axis axis = Axis.vertical}) => items.isEmpty
      ? Container()
      : SizedBox(
          height: 100,
          width: double.infinity,
          child: CarouselSlider.builder(
              itemCount: items.length,
              itemBuilder: (context, index, realindex) => InkWell(child: newsBox(item: items[index])),
              options: CarouselOptions(
                  viewportFraction: 1,
                  clipBehavior: Clip.antiAlias,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 2),
                  autoPlayAnimationDuration: const Duration(milliseconds: 200),
                  autoPlayCurve: Curves.linear,
                  scrollDirection: axis,
                  enlargeStrategy: CenterPageEnlargeStrategy.scale)));

  newsBox({required PhotoModel item}) => InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ItemDetails(isEditMood: false, item: item))),
        child: HomeBox(
            margin: const EdgeInsets.only(top: 3, left: 3, right: 3, bottom: 3),
            padding: const EdgeInsets.all(4),
            backgroundColors: Colors.white60,
            container: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (item.imageLink.isNotEmptyAndNotNull)
                  ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: CachedNetworkImage(
                          imageUrl: item.imageLink ?? '',
                          height: 82,
                          fadeOutDuration: const Duration(seconds: 2),
                          fit: BoxFit.fitHeight,
                          placeholder: (context, url) => myCircularLoader(),
                          errorWidget: (context, url, error) => const Icon(Icons.error, color: Colors.red, size: 18))),
                if (item.imageLink.isNotEmptyAndNotNull) const SizedBox(width: 6),
                Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
                  Text(item.title ?? '', softWrap: true, textScaleFactor: 1, maxLines: 2, style: TextStyleFor.newsBoxTitle),
                  Text(item.description ?? '', softWrap: true, textScaleFactor: 1, maxLines: 4, overflow: TextOverflow.ellipsis, style: TextStyleFor.newsBoxDescription)
                ]))
              ],
            )),
      );
}

// --------------- Home Page Time Header ----------------
homePageTimeHeader({required BuildContext context, required String date, required String time}) => Container(
      color: MyColors.homePageTimeHeaderBackground,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      alignment: Alignment.center,
      height: 25,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AutoSizeText(time, maxLines: 1, stepGranularity: 0.1, minFontSize: 6, softWrap: true, style: TextStyleFor.homePageTimeHeader),
          Row(children: [
            // Institution Logo
            Container(
                height: 22,
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                child: const Image(image: AssetImage(ROOT.institutionLogoAddress), fit: BoxFit.fitHeight)),
            // Institution Abbreviation
            AutoSizeText(ROOT.institutionAbbreviation, maxLines: 1, stepGranularity: 0.1, minFontSize: 6, softWrap: true, style: TextStyleFor.homePageTimeHeader)
          ]),
          AutoSizeText(date, maxLines: 1, stepGranularity: 0.1, minFontSize: 6, softWrap: true, style: TextStyleFor.homePageTimeHeader),
        ],
      ),
    );

// --------------- Home Scrolling Notice ----------------
homePageScrollingNotice({required BuildContext context, String notice = ''}) => notice.isEmpty
    ? Container()
    : Container(
        margin: const EdgeInsets.only(top: 0),
        padding: const EdgeInsets.all(2),
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height * 0.03,
        width: MediaQuery.of(context).size.width,
        color: MyColors.homePageScrollingNoticeBackground,
        child: Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center, children: [
          FittedBox(fit: BoxFit.fitHeight, child: const Text("নোটিশ:", textScaleFactor: 1, style: TextStyleFor.homePageScrollingNotice).p4()),
          Expanded(
              child: Marquee(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  text: notice,
                  style: TextStyleFor.homePageScrollingNotice,
                  textScaleFactor: 1,
                  blankSpace: 220,
                  velocity: 40,
                  scrollAxis: Axis.horizontal))
        ]));
