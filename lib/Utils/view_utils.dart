import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:red_leaf/Plugins/get/get.dart';
import 'package:red_leaf/Utils/color_utils.dart';
import 'package:ionicons/ionicons.dart';

class ViewUtils {
  static void showSuccessDialog(
    text, {
    String? title = 'عملیات موفق آمیز بود',
    bool undo = false,
    Function? undoAction,
    int time = 2,
    MaterialColor? color,
  }) {
    color ??= ColorUtils.green;
    Get.snackbar(
      text ?? '',
      title ?? '',
      undo: undo,
      overlayBlur: 10,
      undoAction: undoAction ?? () {},
      overlayColor: ColorUtils.black.withOpacity(0.5),
      colorText: ColorUtils.black.withOpacity(0.7),
      borderColor: color,
      borderWidth: 2,
      backgroundColor: ColorUtils.white,
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 12.0,
      ),
      icon: Icon(
        Ionicons.checkmark_circle_outline,
        color: color.shade100,
        size: Get.height / 28,
      ),
      duration: Duration(seconds: time),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  static void showInfoDialog([
    String? text = "خطایی رخ داد",
    String? title = 'لطفا توجه کنید',
  ]) {
    Get.snackbar(
      title ?? '',
      text ?? '',
      undo: false,
      backgroundColor: ColorUtils.black,
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 12.0,
      ),
      icon: Icon(
        Ionicons.information_circle_outline,
        size: Get.height / 28,
      ),
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  static void showErrorDialog([
    String? title = "خطایی رخ داد",
    SnackPosition position = SnackPosition.BOTTOM,
  ]) {
    Get.snackbar(
      title ?? '',
      '',
      undo: false,
      borderWidth: 2,
      overlayBlur: 10,
      borderColor: ColorUtils.red,
      overlayColor: ColorUtils.black.withOpacity(0.5),
      colorText: ColorUtils.black.withOpacity(0.7),
      backgroundColor: ColorUtils.white,
      padding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 12.0,
      ),
      icon: Icon(
        Ionicons.warning_outline,
        color: ColorUtils.red.shade100,
        size: Get.height / 28,
      ),
      duration: const Duration(seconds: 3),
      snackPosition: position,
    );
    return;
  }

  static SizedBox sizedBox([
    double heightFactor = 24,
  ]) {
    return SizedBox(
      height: Get.height / heightFactor,
    );
  }

  static softUiDivider([
    MaterialColor? color,
  ]) {
    color ??= ColorUtils.yellow;
    return Container(
      height: 1,
      decoration: BoxDecoration(
        color: color,
        gradient: LinearGradient(
          begin: const Alignment(-1.0, -4.0),
          end: const Alignment(1.0, 4.0),
          colors: [
            color,
            color.shade300,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: color.shade700.withOpacity(0.7),
            offset: const Offset(3.0, 3.0),
            blurRadius: 12.0,
            spreadRadius: 1.0,
          ),
          BoxShadow(
            color: color.withOpacity(0.2),
            offset: const Offset(-5.0, -5.0),
            blurRadius: 12.0,
            spreadRadius: 1.0,
          ),
        ],
        borderRadius: BorderRadius.circular(50.0),
      ),
    );
  }

  static Widget blurWidget({
    required Widget child,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: child,
      ),
    );
  }
}
