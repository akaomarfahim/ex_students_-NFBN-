import '../main.dart';
import 'package:flutter/material.dart';
import '../architecture/navigation_drawer/__route.dart';
import 'package:base/architecture/widget_default/__appbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../architecture/navigation_drawer/navigation_drawer.dart';

class AdminMenu extends StatelessWidget {
  const AdminMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        NavigationRoute.currentPage = MyRoutes.home;
        return true;
      },
      child: Scaffold(
        appBar: myAppBar(context: context, title: 'admin menu:', foreground: Colors.black),
        drawer: const MyNavigationDrawer(),
        backgroundColor: Colors.grey.shade200,
        body: Container(
          margin: const EdgeInsets.only(top: 20, bottom: 2, right: 30, left: 30),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // ----------- [Notice - Scrolling Notice - Routine]
                // appDrawerMenu(context: context, label: 'নটিফিকেশান', drawerRoute: MyRoutes.sendNotifications, iconImageAddress: "assets/icons/notice_sender.png"),
                appDrawerMenu(context: context, label: 'ফটো স্লাইডারে নতুন ছবি যুক্ত', drawerRoute: MyRoutes.editPhotoSlider, iconImageAddress: "assets/icons/photo_slider.png"),
                appDrawerMenu(context: context, label: 'নতুন বন্ধু যুক্ত ও সংশোধন', drawerRoute: MyRoutes.editFriendList, iconData: FontAwesomeIcons.addressBook),
                appDrawerMenu(
                    context: context, label: 'স্ক্রোলিং নোটিশ পরিবর্তন', drawerRoute: MyRoutes.editScrollingNotice, iconImageAddress: "assets/icons/scrolling_notice.png"),
                appDrawerMenu(context: context, label: 'নতুন নিউজ যুক্ত ও সংশোধন', drawerRoute: MyRoutes.editNews, iconImageAddress: 'assets/icons/news.png'),
                appDrawerMenu(context: context, label: 'ফটো গ্যালারীতে -নতুন ছবি যুক্ত', drawerRoute: MyRoutes.photoGalleryAddPhoto, iconData: FontAwesomeIcons.photoFilm),
                appDrawerMenu(context: context, label: 'ফটো গ্যালারীতে -ছবি ডিলিট', drawerRoute: MyRoutes.photoGalleryDeletePhoto, iconData: FontAwesomeIcons.deleteLeft),
                // appDrawerMenu(context: context, label: 'নতুন বন্ধু যুক্ত ও সংশোধন', drawerRoute: MyRoutes.editEvents, iconImageAddress: 'assets/icons/events.png'),

                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
