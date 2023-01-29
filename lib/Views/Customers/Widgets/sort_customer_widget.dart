import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:red_leaf/Controllers/Customers/customer_controller.dart';
import 'package:red_leaf/Controllers/Customers/customer_controller.dart';
import 'package:red_leaf/Controllers/Home/home_controller.dart';
import 'package:red_leaf/Controllers/Order/order_controller.dart';
import 'package:red_leaf/Controllers/Order/order_controller.dart';
import 'package:red_leaf/Controllers/Products/product_controller.dart';
import 'package:red_leaf/Controllers/Products/product_controller.dart';
import 'package:red_leaf/Utils/color_utils.dart';
import 'package:red_leaf/Utils/view_utils.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ionicons/ionicons.dart';

import '../../../Plugins/get/get.dart';

class SortCustomerWidget extends StatelessWidget {
  final CustomerController controller = Get.find<CustomerController>();

  SortCustomerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(25.0),
        topRight: Radius.circular(25.0),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "مرتب سازی بر اساس",
                      style: TextStyle(
                        fontSize: 16,
                        color: ColorUtils.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Get.close(1);
                      },
                      child: Icon(
                        Iconsax.close_circle,
                        color: ColorUtils.red,
                      ),
                    )
                  ],
                ),
                const Divider(),
                ViewUtils.sizedBox(96),
                Expanded(
                  child: ListView.separated(
                    itemCount: controller.sortTypes.length,
                    separatorBuilder: (BuildContext context, int index) {
                      return const Padding(
                        padding: EdgeInsets.zero,
                        child: Divider(height: 1,),
                      );
                    },
                    itemBuilder: (BuildContext context, int index) {
                      return buildItem(index);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildItem(int index) {
    String str = controller.sortTypes[index];
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        onTap: () {
          controller.sortType.value = str;
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 8,
          ),
          child: Row(
            children: [
              buildCheckbox(str),
              const SizedBox(
                width: 8,
              ),
              Text(
                str,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCheckbox(String str) {
    return Obx(
      () => AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          color: controller.sortType.value == str
              ? ColorUtils.blue
              : Colors.transparent,
          border: Border.all(
            color: ColorUtils.blue,
          ),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(50.0),
            onTap: () {
              str = controller.sortType.value = str;
            },
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                child: controller.sortType.value == str
                    ? const Icon(
                        Ionicons.checkmark_outline,
                        color: Colors.white,
                        size: 15,
                      )
                    : const Center(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
