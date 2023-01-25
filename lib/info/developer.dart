import '../main.dart';
import 'package:flutter/material.dart';
import '../models/developer_model.dart';
import 'package:url_launcher/url_launcher.dart';
import '../architecture/widget_default/__text.dart';
import '../architecture/navigation_drawer/__route.dart';
import '../architecture/widget_default/__loadings.dart';
import 'package:firebase_database/firebase_database.dart';
import '../architecture/backend/firebase_storage_api.dart';
import '../architecture/widget_default/__social_icon.dart';
import 'package:base/architecture/widget_default/__appbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../architecture/widget_default/__network_image_view.dart';

class Developer extends StatefulWidget {
  const Developer({Key? key}) : super(key: key);

  @override
  State<Developer> createState() => _DeveloperState();
}

class _DeveloperState extends State<Developer> {
  bool isLoadingComplete = false;
  DeveloperModel saifulIslam = DeveloperModel();
  DeveloperModel omarfahim = DeveloperModel();
  double gap = 12;
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    DatabaseReference ref = FirebaseApi.connect.child('developer');
    final snapshot = await ref.child('0').get();
    if (snapshot.value != null) {
      saifulIslam = DeveloperModel.fromMap(Map<String, dynamic>.from(snapshot.value as Map));
    }
    final omarSnap = await ref.child('1').get();
    if (omarSnap.value != null) {
      omarfahim = DeveloperModel.fromMap(Map<String, dynamic>.from(omarSnap.value as Map));
    }
    isLoadingComplete = true;
    mounted ? setState(() {}) : null;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        NavigationRoute.currentPage = MyRoutes.home;
        return true;
      },
      child: Scaffold(
          appBar: myAppBar(context: context, title: 'Developer', systemNavigationBarColor: Colors.blueGrey),
          // appBar: AppBar(
          //   systemOverlayStyle: SystemUiOverlayStyle(systemNavigationBarColor: Colors.amber, statusBarColor: Colors.pink),
          // ),
          backgroundColor: Colors.blueGrey,
          body: (!isLoadingComplete)
              ? myCircularLoader()
              : Container(
                  alignment: Alignment.topCenter,
                  padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 60),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        developerCard(saifulIslam),
                        developerCard(omarfahim),
                      ],
                    ),
                  ))),
    );
  }

  developerCard(DeveloperModel item) => Card(
      child: SizedBox(
          width: 350,
          child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            myText(label: 'Developer', fontWeight: FontWeight.bold, fontsize: 16, padding: const EdgeInsets.symmetric(vertical: 15)),
            GestureDetector(
              onTap: () async => launchUrl(Uri.parse('https://www.facebook.com/omarfahimofficial/'), mode: LaunchMode.externalApplication),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: (item.imageurl != null)
                      ? myNetworkImage(imageurl: item.imageurl ?? '', fit: BoxFit.cover, height: 80, width: 80)
                      : const Icon(Icons.verified_user, size: 60)),
            ),
            myText(label: item.name, fontWeight: FontWeight.bold, fontsize: 14, padding: const EdgeInsets.only(bottom: 5, top: 10)),
            myText(label: item.bio),
            myText(label: item.content),
            myText(label: item.title),
            myText(label: item.copywrite),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              socialIcon(icon: FontAwesomeIcons.squareFacebook, link: item.facebook),
              socialIcon(icon: FontAwesomeIcons.squareInstagram, link: item.instagram),
              socialIcon(icon: FontAwesomeIcons.linkedin, link: item.linkdin),
              socialIcon(icon: Icons.link_rounded, link: item.website),
              socialIcon(icon: FontAwesomeIcons.youtube, link: item.youtube),
            ]),
            const SizedBox(height: 10)
          ])));
}
