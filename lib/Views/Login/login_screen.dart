import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:red_leaf/Controllers/Login/login_controller.dart';
import 'package:red_leaf/Plugins/get/get.dart';
import 'package:red_leaf/Utils/color_utils.dart';
import 'package:red_leaf/Utils/view_utils.dart';
import 'package:red_leaf/Utils/widget_utils.dart';
import 'package:red_leaf/Widgets/Components/bezier_container.dart';
import 'package:red_leaf/Widgets/Components/circles.dart';
import 'package:red_leaf/Widgets/my_app_bar.dart';
import 'package:ionicons/ionicons.dart';

class LoginScreen extends StatelessWidget {
  final LoginController controller = Get.put(
    LoginController(),
  );

  LoginScreen({Key? key}) : super(key: key);

  List backGroundItems() {
    return [
      Positioned(
        right: Get.width / 1.4,
        top: Get.height / 2,
        child: Transform.rotate(
          angle: 3,
          child: BezierContainer(
            color: ColorUtils.red.shade800,
          ),
        ),
      ),
      Positioned(
        top: Get.height / 1.4,
        left: Get.width / 2,
        child: Transform.rotate(
          angle: 8,
          child: BezierContainer(
            color: ColorUtils.white.shade50,
          ),
        ),
      ),
      Positioned(
        right: Get.width / 0.85,
        top: Get.height / 6,
        child: CustomPaint(
          painter: CircleOne(
            ColorUtils.white.withOpacity(0.5),
          ),
        ),
      ),
      Positioned(
        right: Get.width / 1.2,
        top: Get.height / 4.5,
        child: CustomPaint(
          painter: CircleTwo(
            ColorUtils.red.withOpacity(0.5),
          ),
        ),
      ),
      Positioned(
        left: Get.width / 1,
        top: Get.height / 1.2,
        child: CustomPaint(
          painter: CircleTwo(
            ColorUtils.red.withOpacity(0.5),
          ),
        ),
      ),
      Positioned(
        left: Get.width / 0.95,
        top: Get.height / 4,
        child: CustomPaint(
          painter: CircleOne(
            ColorUtils.red.withOpacity(
              0.2,
            ),
          ),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Scaffold(
            backgroundColor: ColorUtils.white,
          ),
          ...backGroundItems(),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: buildBody(),
          ),
        ],
      ),
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          ViewUtils.sizedBox(8),
          Image.asset(
            'assets/img/logo.png',
            width: Get.width / 1.2,
            fit: BoxFit.fill,
          ),
          ViewUtils.sizedBox(6),
          AutoSizeText(
            "ورود / ثبت نام",
            style: TextStyle(
              fontSize: 21.0,
              color: ColorUtils.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          ViewUtils.sizedBox(48),
          mobileInput(),
          SizedBox(
            height: Get.height / 36,
          ),
          Obx(() {
            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return SizeTransition(
                  sizeFactor: animation,
                  child: child,
                );
              },
              child: controller.isLogin.isTrue
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Center(
                        child: Column(
                          children: [
                            passwordInput(),
                            SizedBox(
                              height: Get.height / 96,
                            ),
                            SizedBox(
                              width: Get.width / 1,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    child: Text(
                                      "رمز عبور خود را فرموش کرده ام",
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        color: ColorUtils.blue,
                                      ),
                                    ),
                                    onTap: () => controller.forgotPassword(),
                                  ),
                                ],
                              ),
                            ),
                            ViewUtils.sizedBox(48),
                          ],
                        ),
                      ),
                    )
                  : Container(),
            );
          }),
          Obx(
            () => AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return SizeTransition(
                  sizeFactor: animation,
                  child: child,
                );
              },
              child: controller.isRegister.isTrue || controller.isForgot.isTrue
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Center(
                        child: Column(
                          children: [
                            codeInput(),
                            ViewUtils.sizedBox(96),
                            SizedBox(
                              width: Get.width / 1,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 150),
                                    child: controller.canSendAgain.isFalse
                                        ? Text(
                                            "${controller.sendAgainTimer} ثانیه تا ارسال مجدد",
                                            textDirection: TextDirection.rtl,
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              color: ColorUtils.black
                                                  .withOpacity(0.5),
                                            ),
                                          )
                                        : GestureDetector(
                                            child: Text(
                                              "ارسال مجدد",
                                              textDirection: TextDirection.rtl,
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                color: ColorUtils.blue,
                                              ),
                                            ),
                                            onTap: () => controller.sendAgain(),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: Get.height / 48,
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
            ),
          ),
          Obx(
                () => button(),
          ),
        ],
      ),
    );
  }

  Widget mobileInput() {
    return Obx(
      () => controller.isLogin.value == true ||
              controller.isRegister.value == true ||
              controller.isForgot.value == true
          ? Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: ColorUtils.white,
                  boxShadow: [
                    BoxShadow(
                      color: ColorUtils.gray.withOpacity(0.5),
                      spreadRadius: 1.0,
                      blurRadius: 12.0,
                    ),
                  ]),
              child: Material(
                type: MaterialType.transparency,
                child: InkWell(
                  onTap: () {
                    controller.isLogin.value = false;
                    controller.isRegister.value = false;
                    controller.isForgot.value = false;
                    controller.passwordController.clear();
                    controller.codeController.clear();
                    controller.mobileFocusNode.requestFocus();
                  },
                  borderRadius: BorderRadius.circular(10.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: ColorUtils.purple,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Icon(
                              Ionicons.pencil_outline,
                              size: 17.0,
                              color: ColorUtils.purple,
                            ),
                          ),
                        ),
                        Text(
                          controller.mobileController.value.text,
                          style: TextStyle(
                            color: ColorUtils.black,
                            letterSpacing: 1.5,
                            fontSize: 17.0,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.transparent,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(6.0),
                            child: Icon(
                              Icons.edit,
                              size: 17.0,
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: WidgetUtils.textField(
                focusNode: controller.mobileFocusNode,
                controller: controller.mobileController,
                onChanged: controller.onChange,
                textAlign: TextAlign.center,
                letterSpacing: 1.5,
                formatter: [
                  LengthLimitingTextInputFormatter(11),
                ],
                keyboardType: TextInputType.phone,
                title: "شماره موبایل",
              ),
            ),
    );
  }

  Widget passwordInput() {
    return WidgetUtils.textField(
      focusNode: controller.passwordNode,
      controller: controller.passwordController,
      letterSpacing: 0,
      textAlign: TextAlign.center,
      keyboardType: TextInputType.visiblePassword,
      title: "رمز عبور",
    );
  }

  Widget codeInput() {
    return WidgetUtils.textField(
      focusNode: controller.codeFocusNode,
      controller: controller.codeController,
      letterSpacing: 0,
      textAlign: TextAlign.center,
      formatter: [
        LengthLimitingTextInputFormatter(4),
      ],
      onChanged: (String string) {
        if (string.length > 3) {
          controller.submit();
        }
      },
      keyboardType: TextInputType.number,
      title: "کد تایید",
    );
  }

  Widget button() {
    return WidgetUtils.softButton(
      enabled: controller.mobileController.value.text.length == 11,
      title: controller.isLogin.value == true ? "ورود" : "مرحله بعد",
      onTap: () => controller.submit(),
    );
  }
}
