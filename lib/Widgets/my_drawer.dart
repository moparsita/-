import 'package:flutter/material.dart';
import 'package:red_leaf/Globals/Globals.dart';
import 'package:red_leaf/Utils/color_utils.dart';
import 'package:red_leaf/Utils/routing_utils.dart';
import 'package:red_leaf/Utils/storage_utils.dart';
import 'package:red_leaf/Utils/view_utils.dart';
import 'package:red_leaf/Utils/widget_utils.dart';
import 'package:red_leaf/Widgets/get_confirmation_dialog.dart';
import 'package:red_leaf/Widgets/my_app_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ionicons/ionicons.dart';

import '../Plugins/get/get.dart';

class MyDrawer extends StatelessWidget {
  final MainGetxController controller = Get.find<MainGetxController>();

  MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        backgroundColor: Colors.transparent,
        elevation: 0,
        width: Get.width / 1.1,
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: ColorUtils.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
                ),
                child: Column(
                  children: [
                    ViewUtils.sizedBox(48),
                    buildProfile(),
                    ViewUtils.sizedBox(48),
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          buildListTile(
                            title: "پشتیبانی",
                            icon: Iconsax.headphone,
                            route: RoutingUtils.support,
                          ),
                          buildListTile(
                            title: "سوالات متداول",
                            icon: Iconsax.messages_14,
                            route: RoutingUtils.faq,
                          ),
                          buildListTile(
                            title: "راهنما",
                            icon: Iconsax.message_question4,
                            route: RoutingUtils.guide,
                          ),

                          Divider(
                            color: ColorUtils.red.withOpacity(0.5),
                          ),
                          buildListTile(
                            title: "دعوت از دوستان",
                            icon: Iconsax.gift,
                            route: RoutingUtils.main,
                            control: "share"
                          ),
                          buildListTile(
                            title: "درباره ما",
                            icon: Iconsax.info_circle,
                            route: RoutingUtils.about,
                          ),
                          buildListTile(
                            title: "خروج",
                            icon: Iconsax.logout,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),

                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Column(
              children: [
                ViewUtils.sizedBox(48),
                IconButton(
                  onPressed: () {
                    controller.closeDrawer();
                  },
                  splashRadius: 15,
                  icon:  Icon(
                    Ionicons.close,
                    color: ColorUtils.red,
                    size: 30,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProfile() {
    return StreamBuilder(
      stream: Globals.userStream.getStream,
      builder: (context, snapshot) {
        return Container(
          height: Get.height / 10,
          decoration: BoxDecoration(
            color: ColorUtils.white,
          ),
          child: GestureDetector(
            onTap: () {
              Get.toNamed(
                RoutingUtils.profile.name,
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(
                top: 12,
                right: 12,
                left: 12,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Globals.userStream.user?.avatar.isNotEmpty ?? false
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(500),
                              child: Image.network(
                                Globals.userStream.user!.avatar,
                                height: Get.height / 12,
                                width: Get.height / 12,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Icon(
                              Ionicons.person_circle_outline,
                              color: ColorUtils.gray,
                              size: Get.height / 12,
                            ),
                      const SizedBox(
                        width: 12,
                      ),
                      if (!Globals.userStream.isLoggedIn()) ...[
                        WidgetUtils.softButton(
                          title: "ورود / ثبت نام",
                          widthFactor: 4,
                          onTap: () {
                            Get.offAllNamed(
                              RoutingUtils.login.name,
                            );
                          },
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                      if (Globals.userStream.isLoggedIn()) ...[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Globals.userStream.user!.fullName,
                              style: TextStyle(
                                color: ColorUtils.textBlack,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            WidgetUtils.softButton(
                              title: "ویرایش حساب کاربری",
                              widthFactor: 5,
                              height: 24,
                              radius: 25,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        )
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildListTile({
    required String title,
    required IconData icon,
    GetPage<dynamic>? route,
    String? control,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 6,
        horizontal: 24,
      ),
      decoration: BoxDecoration(
        color: ColorUtils.white,
        border: Border.all(
          color: ColorUtils.red.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: ColorUtils.gray,
            spreadRadius: 1,
            blurRadius: 12,
          ),
        ],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(10.0),
          onTap: () async {
            if(control == "share"){
                  controller.share();
            } else {
              if (route is GetPage) {
                print(route);
                Get.toNamed(
                  route.name,
                );
              } else {
                bool? exit = await GetConfirmationDialog.show(
                  text: "آیا مطمئن هستید که از حساب کاربری خود خارج شوید؟",
                  maxFontSize: 16,
                );
                if (exit == true) {
                  await StorageUtils.removeToken();
                  Get.offAllNamed(RoutingUtils.login.name);
                  Globals.userStream.changeUser(null);
                }
              }
            }

          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  icon,
                  size: 25,
                  color: ColorUtils.red.shade900.withOpacity(0.5),
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: ColorUtils.black.withOpacity(0.7),
                  ),
                ),
                const Spacer(),
                Icon(
                  Iconsax.arrow_left_2,
                  size: 15,
                  color: ColorUtils.black.withOpacity(0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
