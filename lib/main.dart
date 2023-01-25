import 'package:base/architecture/root/root.dart';
import 'package:base/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:base/info/developer.dart';
import 'package:base/home/admin_menu.dart';
import 'package:base/home/items_list.dart';
import 'package:base/home/admin_login.dart';
import 'package:base/home/photo_gallery.dart';
import 'package:base/home/photo_slider_edit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'architecture/providers/upload_provider.dart';
import 'architecture/providers/download_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:base/architecture/notificationservice/local_notification_service.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  await NotificationApi.showNotification(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  FirebaseMessaging.instance.subscribeToTopic(ROOT.defaultNoticeSubscriber);
  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
  FirebaseDatabase.instance.setPersistenceEnabled(true);
  // FirebaseDatabase.setPersistenceCacheSizeBytes(10000000);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarDividerColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
    systemNavigationBarContrastEnforced: true,
    systemStatusBarContrastEnforced: true,
  ));

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => Download()),
      ChangeNotifierProvider(create: (context) => Upload()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((message) {
      NotificationApi.showNotification(message);
    });

    NotificationApi.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NFBN',
      debugShowCheckedModeBanner: false,

      // *---- Theme Data
      // theme: FlexThemeData.light(
      //     colors: const FlexSchemeColor(
      //         primary: Color(0xff3b5998),
      //         secondary: Color(0xff55acee),
      //         tertiary: Color(0xff4285f4),
      //         tertiaryContainer: Color(0xffd6e2ff),
      //         appBarColor: Color(0xffcbe5ff),
      //         error: Color(0xffb00020)),
      //     // surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      //     // blendLevel: 9,
      //     // subThemesData: const FlexSubThemesData(blendOnLevel: 10, blendOnColors: false),
      //     // visualDensity: FlexColorScheme.comfortablePlatformDensity,
      //     fontFamily: 'RobotSlab'),
      // darkTheme: FlexThemeData.dark(
      //     colors: const FlexSchemeColor(
      //         primary: Color(0xff8b9dc3),
      //         secondary: Color(0xffa0d1f5),
      //         tertiary: Color(0xff88b2f8),
      //         tertiaryContainer: Color(0xff004397),
      //         appBarColor: Color(0xff004b75),
      //         error: Color(0xffcf6679)),
      //     // surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      //     // blendLevel: 15,
      //     // subThemesData: const FlexSubThemesData(blendOnLevel: 20),
      //     // visualDensity: FlexColorScheme.comfortablePlatformDensity,
      //     fontFamily: 'RobotoSlab'),
      themeMode: ThemeMode.system,
      // *---- Theme Data

      initialRoute: MyRoutes.home,
      routes: {
        MyRoutes.home: (context) => const Home(),
        MyRoutes.adminLogin: (context) => const AdminLogin(),
        MyRoutes.adminMenu: (context) => const AdminMenu(),
        MyRoutes.friendList: (context) => const ItemsList(address: 'friends_list', title: 'বন্ধুদের তালিকা', showItemTile: true),
        MyRoutes.photoGallery: (context) => const PhotoGallery(),
        MyRoutes.news: (context) => const ItemsList(address: 'home/news', title: 'News & Upcoming Events'),
        // MyRoutes.events: (context) => const ItemsList(address: 'home/events', title: 'Upcomming Events'),
        MyRoutes.editPhotoSlider: (context) => const PhotoSliderEdit(address: 'home/photo_slider', imageRequired: true, photoUploadDestination: 'NFBN/home/photo_slider'),
        MyRoutes.editFriendList: (context) => const PhotoSliderEdit(address: 'friends_list', photoUploadDestination: 'NFBN/friends_list'),
        MyRoutes.editNews: (context) => const PhotoSliderEdit(address: 'home/news', imageRequired: true, photoUploadDestination: 'NFBN/home/news'),
        MyRoutes.photoGalleryAddPhoto: (context) => const PhotoSliderEdit(address: 'gallery', imageRequired: true, photoUploadDestination: 'NFBN/gallery', imageOnly: true),
        MyRoutes.photoGalleryDeletePhoto: (context) => const PhotoGallery(isEditMood: true),
        // MyRoutes.editEvents: (context) => const PhotoSliderEdit(address: 'home/events', imageRequired: true, photoUploadDestination: 'NFBN/home/events'),
        MyRoutes.developer: (context) => const Developer(),
      },
    );
  }
}

class MyRoutes {
  static const home = '/';
  static const adminMenu = '/admin';
  static const adminLogin = '/admin_login';
  static const photoGalleryAddPhoto = '/photoGalleryAddPhoto';
  static const photoGalleryDeletePhoto = '/photo_gallery_delete';
  static const friendList = '/friend_list';
  static const photoGallery = '/photo_gallery';
  static const news = '/news';
  static const events = '/events';
  static const developer = '/developer';
  static const feedback = '/feedback';
  static const exit = '/exit';

  // admin
  static const editPhotoSlider = '/edit_photo_slider';
  static const editFriendList = '/edit_frined_list';
  static const editScrollingNotice = '/edit_scrolling_notice';
  static const sendNotifications = '/send_notifications';
  static const editHomePhotoSlider = '/edit_home_photo_slider';
  static const editNews = '/edit_news';
  static const editEvents = '/edit_events';
}
