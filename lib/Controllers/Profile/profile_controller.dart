import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:red_leaf/Globals/Globals.dart';
import 'package:red_leaf/Models/user_model.dart';
import 'package:red_leaf/Plugins/get/get.dart';
import 'package:red_leaf/Plugins/my_dropdown/dropdown_controller.dart';
import 'package:red_leaf/Utils/Api/project_request_utils.dart';
import 'package:red_leaf/Utils/color_utils.dart';
import 'package:red_leaf/Widgets/Components/choose_source_alert.dart';
import 'package:red_leaf/Widgets/form_utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class ProfileController extends GetxController {
  final MyTextController firstNameController = MyTextController();
  final MyTextController lastNameController = MyTextController();
  final MyTextController webSiteController = MyTextController();
  final MyTextController consumerKeyController = MyTextController();
  final MyTextController consumerSecretController = MyTextController();


  final ScrollController scrollController = ScrollController();
  final RxDouble scrollOffset = (-0.1).obs;

  final RxBool isImageLoading = false.obs;
  final RxBool isNationalCardLoading = false.obs;



  @override
  void onInit() {
    init();
    super.onInit();
  }

  void save() async {
    double offsetToScroll = 0;


    consumerSecretController.hasError.value =
        consumerSecretController.text.trim().length < 3;
    if (consumerSecretController.hasError.isTrue) {
      consumerSecretController.hasError.value = true;
      offsetToScroll = Get.height / 2.7 + (Get.height / 9) * 5;
    }
    consumerKeyController.hasError.value =
        consumerKeyController.text.trim().length < 3;
    if (consumerKeyController.hasError.isTrue) {
      consumerKeyController.hasError.value = true;
      offsetToScroll = Get.height / 2.7 + (Get.height / 9) * 5;
    }

    webSiteController.hasError.value = webSiteController.text.trim().length < 3;
    if (webSiteController.hasError.isTrue) {
      webSiteController.hasError.value = true;
      offsetToScroll = Get.height / 2.7 + (Get.height / 9) * 5;
    }

    lastNameController.hasError.value =
        lastNameController.text.trim().length < 3;
    if (lastNameController.hasError.isTrue) {
      offsetToScroll = Get.height / 2.7 + Get.height / 10;
    }
    firstNameController.hasError.value = firstNameController.text.trim().length < 3;
    if (firstNameController.hasError.isTrue) {
      firstNameController.hasError.value = true;
      offsetToScroll = Get.height / 2.7;
    }

    if (offsetToScroll > 0) {
      scrollController.animateTo(
        offsetToScroll.toDouble(),
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeIn,
      );
    } else {
      EasyLoading.show();
      ApiResult result = await RequestsUtil.instance.auth.updateProfile(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        website: webSiteController.text.trim(),
        consumerKey: consumerKeyController.text.trim(),
        consumerSecret: consumerSecretController.text.trim(),
      );
      EasyLoading.dismiss();
      if (result.isDone) {
        UserModel userModel = UserModel.fromJson(
          result.data['user'],
        );
        Globals.userStream.changeUser(userModel);
        fillUserInfo();
      }
    }
  }

  void changeProfile() async {
    XFile? file = await Get.dialog(
      const ChooseSourceAlert(
        y: 4,
        x: 4,
        lockAspectRatio: true,
      ),
      barrierColor: ColorUtils.black.withOpacity(0.5),
    );
    if (file is XFile) {
      isImageLoading.value = true;
      ApiResult result = await RequestsUtil.instance.auth.updateImage(file);
      isImageLoading.value = false;
      if (result.isDone) {
        Globals.userStream.user!.avatar = result.data['path'];
        Globals.userStream.sync();
      }
    }
  }

  Future<void> fillUserInfo() async {
    UserModel user = Globals.userStream.user!;
    firstNameController.text = user.firstName;
    lastNameController.text = user.lastName;
    webSiteController.text = user.website;
    consumerKeyController.text = user.consumerKey;
    consumerSecretController.text = user.consumerSecret;

  }

  void init() async {
    await fillUserInfo();
    scrollController.addListener(() {
      scrollOffset.value = scrollController.offset;
    });
  }


}
