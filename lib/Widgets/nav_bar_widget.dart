import 'package:flutter/material.dart';
import 'package:red_leaf/Controllers/Login/login_controller.dart';
import 'package:red_leaf/Globals/Globals.dart';
import 'package:red_leaf/Models/user_model.dart';
import 'package:red_leaf/Utils/color_utils.dart';
import 'package:red_leaf/Utils/routing_utils.dart';
import 'package:red_leaf/Utils/stacks.dart';
import 'package:red_leaf/Utils/view_utils.dart';
import 'package:red_leaf/Widgets/my_app_bar.dart';
import 'package:iconsax/iconsax.dart';

import '../Plugins/get/get.dart';

class NavBar extends StatelessWidget {
  final MainGetxController controller = Get.find<MainGetxController>();

  NavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 12,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: GetBuilder(
            init: controller,
            builder: (context) {
              return Container(
                width: Get.width / 1.1,
                height: Get.height / 16,
                decoration: BoxDecoration(
                  // color: ColorUtils.white,

                  boxShadow: [
                    BoxShadow(
                      color: ColorUtils.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 12,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildIcon(
                      index: 0,
                      title: "صفحه اصلی",
                      icon: Iconsax.home_1,
                    ),
                    buildIcon(
                      index: 1,
                      title: "محصولات",
                      icon: Iconsax.tag,
                    ),
                    // buildButton(),
                    buildIcon(
                      index: 2,
                      title: "مشتریان",
                      icon: Iconsax.people,
                    ),

                      buildIcon(
                        index: 3,
                        title: "سفارشات",
                        icon: Iconsax.activity,
                      ),
                  ],
                ),
              );
            }),
      ),
    );
  }

  Widget buildIcon({
    required int index,
    required IconData icon,
    required String title,
  }) {
    bool isSelected = index == controller.currentIndex;
    return ClipRRect(
      borderRadius: index == 0
          ? const BorderRadius.only(
              bottomRight: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            )
          : index == 3
              ? const BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  topLeft: Radius.circular(10.0),
                )
              : BorderRadius.zero,
      child: Material(
        color: ColorUtils.white,
        child: InkWell(
          onTap: () {
            if (index != controller.currentIndex) {

                controller.currentIndex = index;
                controller.update();

            }
            if (controller.currentIndex == 0){
              Get.delete<LoginController>();
            }
          },
          child: Container(
            width: ((Get.width / 1) / 5) + 6 - 0.25,
            height: Get.height / 16,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isSelected ? ColorUtils.red : Colors.transparent,
                  width: 3,
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  icon,
                  color: isSelected ? ColorUtils.red : ColorUtils.textGray,
                  size: 20,
                ),
                Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? ColorUtils.red : ColorUtils.textGray,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButton() {
    return GestureDetector(
      onTap: () => {},
      child: Container(
        width: ((Get.width / 1.1) / 5) - 24,
        height: Get.height / 16,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            stops: const [
              0.98,
              0.99,
              0,
            ],
            center: const Alignment(0, -1),
            colors: [
              Colors.transparent,
              ColorUtils.gray.shade100.withOpacity(0.1),
              ColorUtils.white,
            ],
          ),
        ),
      ),
    );
  }
}
