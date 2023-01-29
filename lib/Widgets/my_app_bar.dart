import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:red_leaf/Globals/Globals.dart';
import 'package:red_leaf/Models/invite_model.dart';
import 'package:red_leaf/Plugins/bottomNavBar/persistent-tab-view.dart';
import 'package:red_leaf/Plugins/drawer/config.dart';
import 'package:red_leaf/Plugins/drawer/flutter_zoom_drawer.dart';
import 'package:red_leaf/Plugins/get/get.dart';
import 'package:red_leaf/Utils/color_utils.dart';
import 'package:red_leaf/Utils/image_utils.dart';
import 'package:red_leaf/Utils/routing_utils.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ionicons/ionicons.dart';

import '../Models/data_model.dart';
import '../Utils/Api/project_request_utils.dart';

class MainGetxController extends GetxController {
  final RxString mobile = "".obs;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final RxBool isPackageLoaded = false.obs;
  final RxBool dataIsLoading = false.obs;
  PersistentTabController tabviewController = PersistentTabController();
  PersistentTabController controller = PersistentTabController(initialIndex: 0);
  late InviteModel inviteModel;
  late DataModel DrawerData;
  Future<void> share() async {

    await FlutterShare.share(
        title: inviteModel.title,
        text: inviteModel.text,
        linkUrl: inviteModel.link,
        chooserTitle: inviteModel.chooser);
  }

  int currentIndex = 0;

  void openDrawer() {
    // Scaffold.of(context).openDrawer();

    scaffoldKey.currentState?.openDrawer();
  }

  void closeDrawer() {
    // Scaffold.of(context).openEndDrawer();
    scaffoldKey.currentState?.openEndDrawer();
  }

  void toggleDrawer() {

    if (scaffoldKey.currentContext?.drawerState == DrawerState.open) {
      closeDrawer();
    } else {
      openDrawer();
    }
  }
  Future<void> fetchDrawerData() async {
    dataIsLoading.value = true;
    ApiResult result = await RequestsUtil.instance.data.drawerData();
    if(result.isDone) {
      DrawerData = DataModel.fromJson(result.data);
    }
    dataIsLoading.value = false;
  }

  @override
  Future<void> onInit() async {
    ApiResult result = await RequestsUtil.instance.data.invite();
    if(result.isDone) {
      inviteModel = InviteModel.fromJson(result.data);
    }

    fetchDrawerData();
    super.onInit();
  }



  void setScaffoldKey(GlobalKey<ScaffoldState> globalKey) {
    scaffoldKey = globalKey;
  }



}

// ignore: must_be_immutable
class MyAppBar extends StatelessWidget {
  final MainGetxController controller = Get.find();
  final bool inner;
  final bool hasBack;
  final String title;
  Color bgColor = Colors.transparent;

  MyAppBar({
    Key? key,
    this.title = "تنظیمات",
    this.inner = false,
    this.hasBack = false,
    this.bgColor = Colors.transparent,
    GlobalKey<ScaffoldState>? globalKey,
  }) {
    print(globalKey);
    if (globalKey != null) {
      controller.setScaffoldKey(globalKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Globals.userStream.getStream,
        builder: (context, snapshot) {
          return !inner ? buildMainAppBar() : buildSingleAppBar();
        });
  }

  Widget buildMainAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        // GestureDetector(
        //   onTap: () => Globals.toggleDarkMode(),
        //   child: Icon(
        //     Globals.darkModeStream.darkMode ? Iconsax.moon : Iconsax.moon5,
        //     size: 26,
        //     color: ColorUtils.white,
        //   ),
        // ),
        // const SizedBox(
        //   width: 12,
        // ),
        Image.asset(
          ImageUtils.logo,
          width: 100,
          height: 100,
        ),
        const SizedBox(
          width: 12,
        ),
      ],
      leadingWidth: 50,
      leading: IconButton(
        splashRadius: 15,
        onPressed: () {
          controller.toggleDrawer();
        },
        icon: Icon(
          Ionicons.menu,
          color: ColorUtils.gray,
          size: 25,
        ),
      ),
    );
  }

  Widget buildSingleAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [

      ],
      title: Text(
        title,
        style: TextStyle(
          color: ColorUtils.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      leadingWidth: 50,
      leading: BackButton(color: ColorUtils.white,),
    );
  }
}
