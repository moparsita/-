import 'dart:async';

import 'package:flutter/material.dart';
import 'package:red_leaf/Models/user_model.dart';
import 'package:red_leaf/Utils/color_utils.dart';
import 'package:red_leaf/Widgets/login_dialog.dart';

import '../Plugins/get/get.dart';

class UserStream {
  // ignore: close_sinks
  final streamController = StreamController<UserModel?>.broadcast();

  /// The [getStream] getter would be used to expose our stream to other classes
  Stream<UserModel?> get getStream => streamController.stream;

  UserModel? user;

  void changeUser(UserModel? user) {
    this.user = user;
    streamController.sink.add(this.user);
  }

  void sync() {
    streamController.sink.add(user);
  }

  bool isLoggedIn() {
    return user is UserModel;
  }
}

class DarkModeStream {
  // ignore: close_sinks
  final streamController = StreamController<bool>.broadcast();

  /// The [getStream] getter would be used to expose our stream to other classes
  Stream<bool> get getStream => streamController.stream;

  bool darkMode = true;

  void changeUser(bool darkMode) {
    this.darkMode = darkMode;
    streamController.sink.add(this.darkMode);
  }

  void sync() {
    streamController.sink.add(darkMode);
  }
}

class UploadStream {
  // ignore: close_sinks
  final streamController = StreamController<double>.broadcast();

  final RxDouble stateOB = 0.0.obs;

  /// The [getStream] getter would be used to expose our stream to other classes
  Stream<double> get getStream => streamController.stream;

  double state = 0;

  void add(double state) {
    this.state = state;
    streamController.sink.add(state);
  }

  void sync() {
    streamController.sink.add(state);
  }
}

class Globals {
  static UserStream userStream = UserStream();
  static DarkModeStream darkModeStream = DarkModeStream();
  static UploadStream uploadStream = UploadStream();
  static double fontSize20 = Get.width > 400 ? 20.0 : 16.0;
  static double fontSize18 = Get.width > 400 ? 18.0 : 14.0;
  static double fontSize16 = Get.width > 400 ? 16.0 : 12.0;
  static double fontSize15 = Get.width > 400 ? 15.0 : 11.0;
  static double fontSize14 = Get.width > 400 ? 14.0 : 10.0;
  static double fontSize12 = Get.width > 400 ? 12.0 : 8.0;
  static double fontSize11 = Get.width > 400 ? 11.0 : 7.0;
  static double fontSize10 = Get.width > 400 ? 10.0 : 6.0;

  static void toggleDarkMode([
    bool? darkMode,
  ]) {
    ColorUtils.black = ColorUtil(Colors.white.value).toMaterial();

    if (darkModeStream.darkMode) {
      ColorUtils.black = ColorUtil(Colors.white.value).toMaterial();
      ColorUtils.white = ColorUtil(0xff070007).toMaterial();
      ColorUtils.white = ColorUtil(0xff08000B).toMaterial();
      ColorUtils.gray = ColorUtil(0xff261C26).toMaterial();
      ColorUtils.yellow = ColorUtil(Colors.deepOrange.value).toMaterial();
      ColorUtils.textGray = Colors.grey.shade300;
      ColorUtils.textBlack = Colors.white.withOpacity(0.7);

    } else {
      ColorUtils.white = ColorUtil(0xffffffff).toMaterial();
      ColorUtils.black = ColorUtil(0xff000000).toMaterial();
      ColorUtils.textColor = ColorUtils.white.withOpacity(0.8);
      ColorUtils.blue = ColorUtil(0xff185ADB).toMaterial();
      ColorUtils.yellow = ColorUtil(0xffFBCB0A).toMaterial();
      ColorUtils.orange = ColorUtil(0xffFF5F00).toMaterial();
      ColorUtils.green = ColorUtil(0xff00C897).toMaterial();
      ColorUtils.red = ColorUtil(0xffcc0001).toMaterial();
      ColorUtils.gray = ColorUtil(0xffDADDDF).toMaterial();
      ColorUtils.purple = ColorUtil(0xff9818D6).toMaterial();
      ColorUtils.pink = ColorUtil(Colors.pinkAccent.value).toMaterial();
      ColorUtils.textGray = ColorUtils.gray.shade800;
      ColorUtils.textBlack = Colors.black.withOpacity(0.7);
    }
    darkModeStream.changeUser(!darkModeStream.darkMode);
  }

  static Future<dynamic> loginDialog([String? refer]) async {
    return await Get.dialog(
      LoginDialog(
        refer: refer,
      ),
      barrierColor: ColorUtils.black.withOpacity(0.5),
    );
  }
}
