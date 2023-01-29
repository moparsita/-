import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../Plugins/get/get.dart';
import '../Plugins/highlight_text.dart';
import '../Utils/color_utils.dart';
import '../Utils/routing_utils.dart';
import '../Utils/widget_utils.dart';
import 'my_app_bar.dart';

class LoginDialog extends StatelessWidget {
  String? refer = Get.currentRoute;

  LoginDialog({
    Key? key,
    this.refer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Center(
        child: Container(
          height: Get.height / 2,
          width: Get.width / 1.1,
          decoration: BoxDecoration(
            color: ColorUtils.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: Get.height / 2,
                width: Get.width / 1.1,
              ),
              Positioned(
                top: -50,
                child: Lottie.asset(
                  'assets/animations/login.json',
                  width: Get.width / 1,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: Get.height / 3,
                child: SizedBox(
                  width: Get.width / 1.1,
                  child: Column(
                    children: [
                      HighlightText(
                        text: "برای استفاده از امکانات کامل برنامه"
                            " لطفا وارد حساب کاربری خود شوید",
                        highlight: 'برگ سرخ',
                        textAlign: TextAlign.center,
                        highlightStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          const SizedBox(
                            width: 12,
                          ),
                          Expanded(
                            child: WidgetUtils.softButton(
                              title: "ورود به حساب",
                              onTap: () {
                                Get.delete<MainGetxController>();
                                Get.offAllNamed(
                                  RoutingUtils.login.name,
                                  parameters: {
                                    'refer': refer ?? Get.currentRoute,
                                  },
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 12,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.back(
                                result: false,
                              );
                            },
                            child: Text(
                              "بعدا",
                              style: TextStyle(
                                color: ColorUtils.textGray,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
