import 'package:base/architecture/widget_default/__text.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../__text_styles.dart';
import '../root/root.dart';
import '../../main.dart';
import '__route.dart';

class MyNavigationDrawer extends StatefulWidget {
  const MyNavigationDrawer({
    Key? key,
  }) : super(key: key);

  @override
  State<MyNavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<MyNavigationDrawer> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width * 0.70,
        child: Drawer(
            backgroundColor: Colors.white,
            child: Column(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Drawer Header
              const NavigationDrawerHeader(),

              // Drawer Menu
              Expanded(
                  child: ListView(padding: const EdgeInsets.all(0), shrinkWrap: true, children: [
                // Home
                appDrawerMenu(context: context, label: 'Home', drawerRoute: MyRoutes.home, iconData: CupertinoIcons.home),
                appDrawerMenu(context: context, label: 'Admin Login', drawerRoute: MyRoutes.adminLogin, iconData: Icons.verified_user_rounded),
                // appDrawerMenu(context: context, label: 'Admin Menu', drawerRoute: MyRoutes.adminMenu, iconData: CupertinoIcons.settings),
                const MenuListParent(menuParent: 'NFBN'),
                appDrawerMenu(context: context, label: 'বন্ধুদের তালিকা', drawerRoute: MyRoutes.friendList, iconData: FontAwesomeIcons.peopleLine),
                appDrawerMenu(context: context, label: 'ফটো গ্যালারী', drawerRoute: MyRoutes.photoGallery, iconData: FontAwesomeIcons.photoFilm),
                appDrawerMenu(context: context, label: 'খবর', drawerRoute: MyRoutes.news, iconData: FontAwesomeIcons.newspaper),
                // appDrawerMenu(context: context, label: 'Upcomming Events', drawerRoute: MyRoutes.events, iconData: FontAwesomeIcons.evernote),

                // appDrawerDropDownMenu(context, label: 'CLUBS', menuList: [
                //   appDrawerMenu(context: context, label: 'NDUBCC', drawerRoute: MyRoutes.computerClub),
                //   appDrawerMenu(context: context, label: 'NDUBCC', drawerRoute: MyRoutes.culturalClub),
                //   appDrawerMenu(context: context, label: 'NDUBEC', drawerRoute: MyRoutes.englishClub),
                //   appDrawerMenu(context: context, label: 'NDUBDC', drawerRoute: MyRoutes.debatingClub),
                //   appDrawerMenu(context: context, label: 'NDUBBC', drawerRoute: MyRoutes.businessClub),
                //   appDrawerMenu(context: context, label: 'NDUBDFC', drawerRoute: MyRoutes.dramaClub),
                //   appDrawerMenu(context: context, label: 'NDUBLC', drawerRoute: MyRoutes.lawClub),
                // ]),

                // const MenuListParent(menuParent: 'Contacts'),
                // appDrawerMenu(context: context, label: 'Contacts', drawerRoute: MyRoutes.contacts),
                // // appDrawerMenu(context: context, label: 'Social Connections', drawerRoute: MyRoutes.socialConnections, iconImageAddress: "assets/icons/social_icon.png"),

                const MenuListParent(menuParent: 'Developer & Contacts'),
                appDrawerMenu(context: context, label: 'Feedback', drawerRoute: MyRoutes.feedback, iconImageAddress: 'assets/icons/gmail.png'),
                appDrawerMenu(context: context, label: 'Developer', drawerRoute: MyRoutes.developer, iconData: FontAwesomeIcons.dev),

                const AppDrwaerDivider(),
                appDrawerMenu(context: context, label: 'Exit', drawerRoute: MyRoutes.exit, iconImageAddress: "assets/icons/exit.png"),
              ]))
            ])
            // Here
            ));
  }
}

// App Drawer Divider
appDrawerDivider({double thickness = 0.6}) => Divider(endIndent: 6, indent: 6, color: Colors.black26, height: 0, thickness: thickness);

// App Drawer Menu
Widget appDrawerMenu(
        {String label = '',
        String iconImageAddress = '',
        IconData iconData = Icons.menu_rounded,
        String drawerRoute = MyRoutes.home,
        VoidCallback? action,
        bool showCard = false,
        required BuildContext context}) =>
    Card(
        margin: EdgeInsets.symmetric(horizontal: 6, vertical: showCard ? 4 : 2),
        borderOnForeground: true,
        elevation: showCard ? 0.5 : 0,
        clipBehavior: Clip.antiAlias,
        child: ListTile(
            minVerticalPadding: 0,
            minLeadingWidth: 5,
            dense: true,
            enabled: NavigationRoute.currentPage == drawerRoute ? false : true,
            selected: NavigationRoute.currentPage == drawerRoute ? true : false,
            selectedColor: Colors.black,
            selectedTileColor: Colors.black12,
            focusColor: Colors.purple,
            leading: iconImageAddress.isNotEmpty
                ? Image(image: AssetImage(iconImageAddress), fit: BoxFit.contain, height: 20, width: 20)
                : Icon(iconData, size: 18, color: Colors.black.withOpacity(0.7)),
            title: Text(label, maxLines: 1, overflow: TextOverflow.visible, softWrap: true, textAlign: TextAlign.left, style: TextStyleFor.navigationDrawerMenu),
            onTap: () {
              action != null ? action() : null;
              // Navigator.pop(context);
              route(context, drawerRoute);
            }));

// App Drawer Menu Parent
appDraswerMenuParent({String label = ''}) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
      Padding(padding: const EdgeInsets.only(left: 10), child: Text(label, maxLines: 1, overflow: TextOverflow.visible, style: TextStyleFor.navigationDrawerMenuParent)),
      Expanded(child: appDrawerDivider())
    ]));

// App Drawer Drop Down Menu
appDrawerDropDownMenu(BuildContext context, {String label = '', String iconImageAddress = '', List<Widget> menuList = const []}) => Card(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      borderOnForeground: true,
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ListTileTheme(
          minLeadingWidth: 5,
          dense: true,
          child: ExpansionTile(
            title: Text(label, maxLines: 1, overflow: TextOverflow.visible, softWrap: true, textAlign: TextAlign.left, style: TextStyleFor.navigationDrawerMenu),
            initiallyExpanded: false,
            iconColor: Colors.blue,
            leading: iconImageAddress.isNotEmpty ? Image(image: AssetImage(iconImageAddress), fit: BoxFit.fitHeight, height: 22) : const Icon(Icons.menu_open_rounded),
            childrenPadding: const EdgeInsets.only(left: 14),
            children: menuList,
          ),
        ),
      ),
    );

class AppDrawerListTile extends StatelessWidget {
  final String title;
  final String icon;
  final VoidCallback action;
  final bool isSelected;
  const AppDrawerListTile({
    Key? key,
    required this.title,
    required this.icon,
    required this.action,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 0,
      title: AutoSizeText(
        title,
        maxFontSize: 14,
        minFontSize: 10,
        style: const TextStyle(fontFamily: 'Gentium', fontWeight: FontWeight.w600, fontSize: 12),
      ),
      dense: true,
      selected: isSelected,
      selectedTileColor: Colors.black12,
      // visualDensity: const VisualDensity(horizontal: -2, vertical: -3),
      // leading: Image(image: AssetImage('assets/images/mmsc.png')),
      leading: icon.isNotEmpty ? Image(image: AssetImage('assets/icons/$icon.png'), fit: BoxFit.fitHeight, height: 22) : const Icon(Icons.arrow_forward_rounded),
      minLeadingWidth: 5,
      onTap: () => action(),
    );
  }
}

// Menu Parent

class MenuListParent extends StatelessWidget {
  final String menuParent;
  const MenuListParent({
    Key? key,
    required this.menuParent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 10),
              child: AutoSizeText(
                menuParent,
                maxFontSize: 14,
                minFontSize: 10,
                maxLines: 1,
                overflow: TextOverflow.clip,
                style: const TextStyle(color: Colors.grey, fontSize: 10, fontFamily: 'RobotoSlab', fontWeight: FontWeight.w500),
              )),
          const Expanded(child: AppDrwaerDivider())
        ],
      ),
    );
  }
}

// divider
class AppDrwaerDivider extends StatelessWidget {
  const AppDrwaerDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Divider(
      endIndent: 6,
      indent: 6,
      color: Colors.black26,
      height: 0,
      thickness: 0.6,
    );
  }
}

// --------------- Header Section ---------------

class NavigationDrawerHeader extends StatelessWidget {
  const NavigationDrawerHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
        padding: const EdgeInsets.all(6.0),
        // Header Background Gradient
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, stops: const [
          0.0,
          0.7
        ], colors: [
          Colors.green,
          Colors.red.shade400,
        ])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Institution Logo
            Expanded(
                child: Padding(
                    padding: const EdgeInsets.only(top: 4, left: 6, bottom: 10),
                    child: Image(
                        fit: BoxFit.fitHeight,
                        image: const AssetImage(ROOT.institutionLogoAddress),
                        alignment: Alignment.topLeft,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error_rounded);
                        }))),
            // Institution Title
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                myText(label: ROOT.institutionAbbreviation, fontsize: 18),
                myText(label: ROOT.institutionName, fontsize: 10),
                myText(label: ROOT.institutionMoto),
                myText(label: ROOT.institutionEstablishmedDate),
                // textLabel(label: ROOT.institutionMoto, textStyle: TextStyleFor.navigationDrawerHeaderSubtitle),
                // textLabel(label: ROOT.institutionEstablishmedDate, textStyle: TextStyleFor.navigationDrawerHeaderSubtitle),
                // textLabel(label: ROOT.institutionEstablishmedEINN, textStyle: TextStyleFor.navigationDrawerHeaderSubtitle),
              ],
            ),
          ],
        ));
  }
}

// textLabel({String label = '', TextStyle textStyle = TextStyleFor.basic}) => AutoSizeText(
//       label,
//       maxLines: 1,
//       stepGranularity: 0.1,
//       maxFontSize: 16,
//       minFontSize: 5,
//       overflow: TextOverflow.fade,
//       wrapWords: false,
//       style: textStyle,
//     );
