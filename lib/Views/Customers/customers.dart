import 'dart:convert';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:red_leaf/Controllers/Customers/customer_controller.dart';
import 'package:red_leaf/Controllers/Customers/customer_controller.dart';
import 'package:red_leaf/Models/customer_model.dart';
import 'package:red_leaf/Plugins/get/get.dart';

import '../../Controllers/Home/home_controller.dart';
import '../../Models/customer_billing_model.dart';
import '../../Models/product_model.dart';
import '../../Utils/color_utils.dart';
import '../../Utils/image_utils.dart';
import '../../Utils/routing_utils.dart';
import '../../Utils/shimmer_widget.dart';
import '../../Utils/view_utils.dart';
import '../../Widgets/my_app_bar.dart';


class CustomersScreen extends StatelessWidget {
  final MainGetxController appBarController = Get.find<MainGetxController>();
  final CustomerController controller = Get.put(CustomerController());
  final bool mainPage;
  CustomersScreen({
    Key? key,
    this.mainPage = false,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {

        return true;
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: buildBody(),
          resizeToAvoidBottomInset: false,
          backgroundColor: ColorUtils.white,
        ),
      ),
    );
  }

  Widget buildBody() {
    // controller.fetchCustomers("10");
    return Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildBackGround(),
              SizedBox(height: 16,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(
                      Iconsax.user,
                      color: Colors.red,
                    ),
                    SizedBox(width: 8.0,),

                        Text(
                          "مشتریان",
                          style: TextStyle(
                            color: ColorUtils.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                          ),
                        ),
                    Spacer(),

                    filterMenu("page"),


                  ],
                ),
              ),

              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 150),
                  child: controller.customersIsLoading.isTrue
                      ? customersLoading()
                      :  controller.customers.length >0 ?
                  customers()
                  : Container(),
                ),
              ),
              SizedBox(height: 64),
            ],
          ),
    );
  }

  Widget filterMenu(String type) {
    return Obx(
          () => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: ColorUtils.red,
          ),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: BorderRadius.circular(5),
            onTap: () => type == "sort" ? controller.showSort() : controller.showPage(),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 2.0,
                horizontal: 8.0,
              ),
              child: Row(
                children: [
                  Icon(
                    Iconsax.sort,
                    color: ColorUtils.red,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    type == "sort" ? controller.sortType.value : controller.perPage.value,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget customerCard(int index) {
    CustomerModel customer = controller.customers[index];
    return InkWell(
      onTap: () =>
      {
        controller.customer = customer,
        Get.toNamed(RoutingUtils.customer.name,
            parameters: {'customerId': customer.id.toString()}
        )
      },
      child: Container(

        margin: const EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 0,
        ),
        decoration: BoxDecoration(
          color: ColorUtils.white,
          border: Border.all(
            color: ColorUtils.gray,
          ),
          boxShadow: [
            BoxShadow(
              color: ColorUtils.gray,
              spreadRadius: 5,
              blurRadius: 12,
            ),
          ],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
              ),
              child: FadeInImage(
                placeholder: ImageUtils.placeholder,
                image: NetworkImage(
                  customer.avatarUrl,
                ),

                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 1.0,
                vertical: 6.0
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [

                      Text(
                        customer.firstName + ' ' + customer.lastName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.0),
                  Row(
                    children: [
                      Text(
                        'تاریخ عضویت: ',
                        style: TextStyle(
                          color: ColorUtils.textBlack,
                          fontSize: 13
                        ),
                      ),
                      Text(
                        customer.dateCreated.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.0),
                  Row(
                    children: [
                      Text(
                        'ایمیل: ',
                        style: TextStyle(
                          color: ColorUtils.textBlack,
                          fontSize: 13
                        ),
                      ),
                      Text(
                        customer.email,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.0),
                  Row(
                    children: [
                      Text(
                        'مشتری خرید داشته؟: ',
                        style: TextStyle(
                          color: ColorUtils.textBlack,
                          fontSize: 13
                        ),
                      ),
                      Text(
                        customer.isPayingCustomer ? 'بله' : 'خیر',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
  Widget customerCardLoading(int index) {
    return InkWell(
      child: Container(

        margin: const EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: ColorUtils.white,
          border: Border.all(
            color: ColorUtils.gray,
          ),
          boxShadow: [
            BoxShadow(
              color: ColorUtils.gray,
              spreadRadius: 5,
              blurRadius: 12,
            ),
          ],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
              ),
              child: ShimmerWidget(
                width: Get.width / 4 - 20,
                height: Get.width /4 ,
              )
            ),
            const SizedBox(
              width: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 1.0,
                vertical: 6.0
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [

                      ShimmerWidget(
                        height: 15,
                        width: 80,
                      ),
                    ],
                  ),
                  SizedBox(height: 6.0),
                  Row(
                    children: [
                      ShimmerWidget(
                        height: 10,
                        width: 30,
                      ),
                      ShimmerWidget(
                        height: 10,
                        width: 100,
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      ShimmerWidget(
                        height: 10,
                        width: 30,
                      ),
                      ShimmerWidget(
                        height: 10,
                        width: 100,
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
  Widget buildBackGround() {
    return Container(
      height: Get.height / 6,
      width: Get.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            ImageUtils.banner,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 5,
          sigmaY: 5,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
          ),
          child: Column(
            children: [
              buildAppBar(),
              ViewUtils.sizedBox(56),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAppBar() {
    return MyAppBar();
  }


  Widget customers() {
    return LazyLoadScrollView(
      scrollOffset: 300,
      onEndOfPage: () { controller.fetchCustomers((int.parse(controller.perPage.value) + int.parse(controller.perPage.value)).toString()); },
      child: GridView.builder(
        scrollDirection: Axis.vertical,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisSpacing: 10,
          crossAxisSpacing: 1,
          mainAxisExtent:100,
        ),
        itemCount: controller.customers.length,
        itemBuilder: (BuildContext context, int index) {
          return customerCard(index);
        },
      ),
    );
  }
  Widget customersLoading() {
    return GridView.builder(
      scrollDirection: Axis.vertical,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
        mainAxisExtent:100,
      ),
      itemCount: 5,
      itemBuilder: (BuildContext context, int index) {
        return customerCardLoading(index);
      },
    );
  }

}