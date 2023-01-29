import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:red_leaf/Controllers/Login/login_controller.dart';
import 'package:red_leaf/Controllers/Login/login_controller.dart';
import 'package:red_leaf/Globals/Globals.dart';
import 'package:red_leaf/Models/user_model.dart';
import 'package:red_leaf/Plugins/get/get.dart';
import 'package:red_leaf/Utils/Api/project_request_utils.dart';
import 'package:red_leaf/Utils/color_utils.dart';
import 'package:red_leaf/Utils/routing_utils.dart';
import 'package:red_leaf/Utils/storage_utils.dart';
import 'package:red_leaf/Utils/view_utils.dart';
import 'package:red_leaf/Utils/widget_utils.dart';

class CompleteRegister extends StatefulWidget {
  final String mobile;
  final String code;
  final LoginController controller;

  const CompleteRegister({
    super.key,
    required this.mobile,
    required this.code,
    required this.controller,
  });

  @override
  _CompleteRegisterState createState() => _CompleteRegisterState();
}

class _CompleteRegisterState extends State<CompleteRegister> {
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordConfirmController = TextEditingController();

  TextEditingController webSiteController = TextEditingController();
  TextEditingController consumerKeyController = TextEditingController();
  TextEditingController consumerSecretController = TextEditingController();

  FocusNode nameFocusNode = FocusNode();
  FocusNode lastNameFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();
  FocusNode passwordConfirmFocusNode = FocusNode();
  FocusNode webSiteFocusNode = FocusNode();
  FocusNode consumerKeyFocusNode = FocusNode();
  FocusNode consumerSecretFocusNode = FocusNode();

  Widget header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'تکمیل اطلاعات',
          style: TextStyle(
            fontSize: 15.0,
            color: ColorUtils.black,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: Get.height / 1.4,
        width: Get.width / 1.2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Material(
          color: ColorUtils.white,
          borderRadius: BorderRadius.circular(10.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Column(
              children: [
                SizedBox(
                  height: Get.height / 48,
                ),
                header(),
                SizedBox(
                  height: Get.height / 48,
                ),
                Expanded(
                  child: body(),
                ),
                SizedBox(
                  height: Get.height / 48,
                ),
                finalBtn(),
                SizedBox(
                  height: Get.height / 48,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget finalBtn() {
    return WidgetUtils.softButton(
      title: "ثبت نام",
      onTap: () => finalize(),
      enabled: true,
      widthFactor: 1,
    );
  }

  Widget body() {
    return Column(
      children: [
        name(),
        const SizedBox(
          height: 8,
        ),
        lastName(),
        const SizedBox(
          height: 8,
        ),
        password(),
        const SizedBox(
          height: 8,
        ),
        passwordConfirm(),
        const SizedBox(
          height: 8,
        ),
        website(),
        const SizedBox(
          height: 8,
        ),
        consumerKey(),
        const SizedBox(
          height: 8,
        ),
        consumerSecret(),
      ],
    );
  }

  Widget _textInput({
    required TextEditingController controller,
    required String name,
    void Function(String)? onChange,
    required FocusNode focusNode,
    bool password = false,
    int maxLen = 9999,
    TextAlign align = TextAlign.right,
  }) {
    return WidgetUtils.input(
      title: name,
      controller: controller,
      letterSpacing: 0,
      password: password,
      focusNode: focusNode,
      textAlign: align,
      onChanged: onChange,
    );
  }

  Widget name() {
    return _textInput(
      controller: nameController,
      focusNode: nameFocusNode,
      name: "نام",
    );
  }


  Widget lastName() {
    return _textInput(
      controller: lastNameController,
      focusNode: lastNameFocusNode,
      name: "نام خانوادگی",
    );
  }

  Widget password() {
    return _textInput(
      controller: passwordController,
      focusNode: passwordFocusNode,
      password: true,
      name: "رمز عبور",
    );
  }

  Widget passwordConfirm() {
    return _textInput(
      controller: passwordConfirmController,
      focusNode: passwordConfirmFocusNode,
      name: "تایید رمز عبور",
      password: true,
    );
  }

  Widget website() {
    return _textInput(
      controller: webSiteController,
      focusNode: webSiteFocusNode,
      name: "آدرس وبسایت",
    );
  }

  Widget consumerKey() {
    return _textInput(
      controller: consumerKeyController,
      focusNode: consumerKeyFocusNode,
      name: "کلید اتصال",
    );
  }

  Widget consumerSecret() {
    return _textInput(
      controller: consumerSecretController,
      focusNode: consumerSecretFocusNode,
      name: "رمز اتصال",
    );
  }


  void finalize() async {
    EasyLoading.show();
    ApiResult result = await RequestsUtil.instance.auth.completeRegister(
      name: nameController.text,
      lastName: lastNameController.text,
      password: passwordController.text,
      passwordConfirm: passwordConfirmController.text,
      code: widget.code,
      mobile: widget.mobile,
      website: webSiteController.text,
      consumerKey: consumerKeyController.text,
      consumerSecret: consumerSecretController.text,
    );
    EasyLoading.dismiss();
    if (result.isDone) {
      await StorageUtils.setToken(result.data['token']);
      Globals.userStream.changeUser(UserModel.fromJson(
        result.data['user'],
      ));
      Get.offAllNamed(
        RoutingUtils.main.name,
      );
    } else {
      ViewUtils.showErrorDialog(
        result.data,
      );
    }
  }
}
