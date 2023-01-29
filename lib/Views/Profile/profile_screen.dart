import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:red_leaf/Controllers/Profile/profile_controller.dart';
import 'package:red_leaf/Globals/Globals.dart';
import 'package:red_leaf/Plugins/datepicker/persian_datetime_picker.dart';
import 'package:red_leaf/Utils/color_utils.dart';
import 'package:red_leaf/Utils/view_utils.dart';
import 'package:red_leaf/Utils/widget_utils.dart';
import 'package:red_leaf/Widgets/form_utils.dart';
import 'package:iconsax/iconsax.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import '../../Plugins/get/get.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());

  ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: StreamBuilder(
          stream: Globals.userStream.getStream,
          builder: (context, snapshot) {
            print(Globals.userStream.user!.avatar);
            return Scaffold(
              appBar: buildAppBar(),
              body: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: Get.width,
                    height: Get.height,
                    decoration: BoxDecoration(
                      color: ColorUtils.red.withOpacity(0.6),
                    ),
                    child: Column(
                      children: [
                        SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/img/pattern.svg',
                                color: ColorUtils.gray.withOpacity(0.3),
                                height: Get.height / 11,
                              ),
                              SvgPicture.asset(
                                'assets/img/pattern.svg',
                                color: ColorUtils.gray.withOpacity(0.3),
                                height: Get.height / 11,
                              ),
                              SvgPicture.asset(
                                'assets/img/pattern.svg',
                                color: ColorUtils.gray.withOpacity(0.3),
                                height: Get.height / 11,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Obx(
                    () => AnimatedPositioned(
                      duration: const Duration(milliseconds: 50),
                      top: Get.height / 12 - controller.scrollOffset.value,
                      child: Container(
                        width: Get.width,
                        height: Get.height * 2,
                        decoration: BoxDecoration(
                          color: ColorUtils.white,
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                  ),
                  buildForm(),
                  Obx(
                    () => AnimatedSwitcher(
                      duration: const Duration(milliseconds: 150),
                      child: controller.scrollOffset.value >=
                              (controller.scrollController.hasClients &&
                                          controller.scrollOffset.value != -0.1
                                      ? controller.scrollController.position
                                          .maxScrollExtent
                                      : 0) -
                                  Get.height / 24 -
                                  Get.height / 48
                          ? Container()
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                WidgetUtils.softButton(
                                  title: "ذخیره تغییرات پروفایل",
                                  onTap: () => controller.save(),
                                  widthFactor: 1.5,
                                  color: ColorUtils.green,
                                ),
                                ViewUtils.sizedBox(48),
                              ],
                            ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  PreferredSizeWidget buildAppBar() {
    return AppBar(
      elevation: 0,
      toolbarHeight: 50,
      shadowColor: ColorUtils.red,
      backgroundColor: ColorUtils.white,
      foregroundColor: ColorUtils.textBlack,
      leadingWidth: 40,
      actions: [
        IconButton(
          splashRadius: 20,
          onPressed: () => Globals.toggleDarkMode(),
          icon: Icon(
            Globals.darkModeStream.darkMode ? Iconsax.moon : Iconsax.moon5,
            size: 26,
            color: ColorUtils.black,
          ),
        ),
      ],
      title: Text(
        "حساب کاربری",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: ColorUtils.black,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget buildAvatar() {
    return GestureDetector(
      onTap: () => controller.changeProfile(),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Obx(
            () => AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: Get.width / 3,
              height: Get.width / 3,
              decoration: BoxDecoration(
                color: ColorUtils.white,
                image: Globals.userStream.user!.avatar.isNotEmpty &&
                        controller.isImageLoading.isFalse
                    ? DecorationImage(
                        image: NetworkImage(
                          "${Globals.userStream.user!.avatar}?t=${DateTime.now()}",
                        ),
                        fit: BoxFit.cover,
                      )
                    : null,
                border: Border.all(
                  color: ColorUtils.gray,
                  width: 5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: ColorUtils.gray.withOpacity(0.5),
                    spreadRadius: 3.0,
                    blurRadius: 12.0,
                  ),
                ],
                shape: BoxShape.circle,
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                child: controller.isImageLoading.isTrue
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Globals.userStream.user!.avatar.isNotEmpty
                        ? Container()
                        : Icon(
                            Iconsax.user,
                            color: ColorUtils.purple,
                            size: Get.width / 5,
                          ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: ColorUtils.red,
              boxShadow: [
                BoxShadow(
                  color: ColorUtils.gray.withOpacity(0.5),
                  spreadRadius: 3.0,
                  blurRadius: 12.0,
                ),
              ],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Iconsax.edit,
                color: ColorUtils.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildForm() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SingleChildScrollView(
        controller: controller.scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ViewUtils.sizedBox(24),
            buildAvatar(),


            ViewUtils.sizedBox(48),
            FormUtils.input(
              title: "نام",
              hint: "نام خود را وارد کنید",
              controller: controller.firstNameController,
              errorText: "لطفا نام خود را وارد کنید",
              onChange: (String name) {
                controller.firstNameController.hasError.value = name.length <= 3;
              },
            ),
            FormUtils.input(
              title: "نام خانوادگی",
              hint: "نام خانوادگی خود را وارد کنید",
              controller: controller.lastNameController,
              errorText: "لطفا نام خانوادگی خود را وارد کنید",
              onChange: (String lastName) {
                controller.lastNameController.hasError.value =
                    lastName.length <= 3;
              },
            ),


            FormUtils.input(
              title: "آدرس سایت",
              hint: "https://",
              info: "آدرس سایت خود را کامل و همراه با پروتکل سایت بصورت http://yoursite.ext یا https://yoursite.ext وارد کنید.",
              controller: controller.webSiteController,
              errorText: "لطفا آدرس سایت خود را وارد کنید",
              onChange: (String value) {
                controller.webSiteController.hasError.value = value.length <= 3;
              },
            ),
            FormUtils.input(
              title: "کلید اتصال",
              hint: 'ck_',
              info: "کلید اتصال یا consumer key را از فروشگاه خود دریافت کنید",
              controller: controller.consumerKeyController,
              errorText: "لطفا شماره اضطراری خود را وارد کنید",
              onChange: (String value) {
                controller.consumerKeyController.hasError.value = value.length < 40;
              },
            ),
            FormUtils.input(
              title: "رمز اتصال",
              hint: "cs_",
              info: "کلید اتصال یا consumer secret را از فروشگاه خود دریافت کنید",
              controller: controller.consumerSecretController,
              errorText: "لطفا شماره ثابت خود را وارد کنید",
              onChange: (String value) {
                controller.consumerSecretController.hasError.value =
                    value.length < 40;
              },
            ),


            ViewUtils.sizedBox(48),
            WidgetUtils.softButton(
              title: "ذخیره تغییرات پروفایل",
              onTap: () => controller.save(),
              widthFactor: 1.5,
              color: ColorUtils.green,
            ),
            ViewUtils.sizedBox(48),
          ],
        ),
      ),
    );
  }


}
