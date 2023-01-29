import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ionicons/ionicons.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:red_leaf/Models/Reports/total_sales_model.dart';
import 'package:red_leaf/Models/Reports/total_top_seller_model.dart';
import 'package:red_leaf/Plugins/get/get.dart';

import '../../Controllers/Home/home_controller.dart';
import '../../Controllers/Profile/profile_controller.dart';
import '../../Globals/Globals.dart';
import '../../Models/Reports/total_order_model.dart';
import '../../Models/product_model.dart';
import '../../Plugins/get/get_core/src/get_main.dart';
import '../../Plugins/refresher/src/indicator/custom_indicator.dart';
import '../../Plugins/refresher/src/smart_refresher.dart';
import '../../Utils/color_utils.dart';
import '../../Utils/image_utils.dart';
import '../../Utils/routing_utils.dart';
import '../../Utils/shimmer_widget.dart';
import '../../Utils/view_utils.dart';
import '../../Utils/widget_utils.dart';
import '../../Widgets/my_app_bar.dart';

class HomeScreen extends StatelessWidget {
  final MainGetxController appBarController = Get.find<MainGetxController>();
  final HomeController controller = Get.put(HomeController());
  final ProfileController profileController = Get.put(ProfileController());
  HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Obx(
            () =>  Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
              children: [
                MyAppBar(
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ViewUtils.sizedBox(14),
                        buildProfile(),
                        ViewUtils.sizedBox(48),
                        buildBody(),
                        ViewUtils.sizedBox(48),

                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

    );
  }

  Widget buildProfile() {
    return Container(
      height: Get.height / 6,
      width: Get.width,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: ColorUtils.white,
        boxShadow: [
          BoxShadow(
            color: ColorUtils.gray.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 12,
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [

          Obx(
                () => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: Get.height / 6 - 46,
                        width: Get.width / 4,
                        child:
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'کل محصولات:',
                                style: TextStyle(
                                  color: ColorUtils.black,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 150),
                                child: controller.isLoading.isTrue
                                    ? Center(
                                  child: SizedBox(width: 30.0, height:10.0, child: Center(child: ShimmerWidget(
                                    height: 25,
                                    width: Get.width / 4,
                                  ),)),
                                )
                                    :   Text(
                                  controller.allProductsCount.toString(),
                                  style: TextStyle(
                                    color: ColorUtils.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),

                              const SizedBox(
                                height: 4,
                              ),
                              WidgetUtils.outlineButton(
                                height: 21,
                                title: "مشاهده محصولات",
                                fontSize: 10,
                                onTap: () => Get.toNamed(
                                  RoutingUtils.products.name,
                                ),
                              ),
                            ],
                          ),


                      ),
                      Expanded(
                        child: SizedBox(
                          height: Get.height / 6 - 54,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                Globals.userStream.user!.fullName,
                                style: TextStyle(
                                  color: ColorUtils.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                Globals.userStream.user!.website,
                                style: TextStyle(
                                  color: ColorUtils.black,
                                  letterSpacing: 1.5,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: Get.height / 6 - 46,
                        width: Get.width / 4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'کل سفارشات:',
                              style: TextStyle(
                                color: ColorUtils.black,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 150),
                              child: controller.isLoading.isTrue
                                  ? Center(
                                child: SizedBox(width: 30.0, height:10.0, child: Center(child: ShimmerWidget(
                                  height: 15,
                                  width: Get.width / 4,
                                ),)),
                              )
                                  : Text(
                                controller.allOrdersCount.toString(),
                                style: TextStyle(
                                  color: ColorUtils.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            WidgetUtils.outlineButton(
                              height: 21,
                              onTap: () => Get.toNamed(
                                RoutingUtils.orders.name,
                              ),
                              title:
                              "مشاهده سفارشات",
                              fontSize: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  WidgetUtils.softButton(
                    widthFactor: 1,
                    title: "ویرایش پروفایل",
                    icon: Iconsax.edit,
                    reverse: true,
                    iconSize: 15,
                    fontSize: 12,
                    radius: 25,
                    fontWeight: FontWeight.bold,
                    height: 30,
                    onTap: () => Get.toNamed(
                      RoutingUtils.profile.name,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: -Get.height / 15,
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: ColorUtils.white,
                    width: 5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: ColorUtils.gray.withOpacity(0.5),
                      blurRadius: 12,
                      spreadRadius: 3,
                    ),
                  ],
                  shape: BoxShape.circle),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(500),
                child: Image.network(
                  Globals.userStream.user!.avatar,
                  width: Get.height / 8.5,
                  fit: BoxFit.cover,
                  height: Get.height / 8.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget buildBody() {

    return Column(
      children: [

        SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [


                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    buildCard(
                      title: 'لیست مشتریان',
                      icon: Iconsax.receipt ,
                      width: 0.3,
                      height: 0.3,
                      onTap: () => Get.toNamed(
                        RoutingUtils.customers.name,
                      ),
                    ),
                    buildCard(
                        title: 'لیست محصولات',
                        icon: Iconsax.gift ,
                        width: 0.3,
                        height: 0.3,
                        onTap: () => Get.toNamed(
                          RoutingUtils.products.name,
                        ),
                    ),
                    buildCard(title: 'کوپن ها', icon: Iconsax.ticket , width: 0.3, height: 0.3),


                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    buildCard2(title: 'سفارش های امروز', subtitle: (controller.todaySaleReport.isNotEmpty  ) ? controller.todaySaleReport.first.total_orders.toString() : '0' +' عدد', icon: Iconsax.shopping_bag , width: 0.44, height: 0.25),
                    buildCard2(title: 'کل سفارشات', subtitle: (controller.allOrdersCount.toString().isNotEmpty  ) ? controller.allOrdersCount.toString() : '0' +' عدد', icon: Iconsax.shopping_cart , width: 0.44, height: 0.25),
                  ],
                ),
                OrderCard(),
                // TopSellerCard(),
                SizedBox(height: Get.height / 6),

              ]
          ),
        ),
      ],
    );
  }

  Widget buildCard({
    void Function()? onTap,
    double width = 0.45,
    double height = 0.45,
    required String title,
    required IconData icon,
  }
      ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: Get.width * width,
        height: Get.width * height,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              icon,
              color: ColorUtils.red,
              size: 30,
            ),

            Text(
              title,
              style: TextStyle(
                  color: ColorUtils.textBlack,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),),
          ],
        ),
      ),
    );
  }

  Widget buildCard2({
    void Function()? onTap,
    double width = 0.45,
    double height = 0.45,
    required String title,
    required String subtitle,
    required IconData icon,
  }
      ) {
    return InkWell(
      child: Container(
        width: Get.width * width,
        height: Get.width * height,
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
          // image: DecorationImage(
          //   image: AssetImage('assets/img/pattern.svg'),
          //   fit: BoxFit.cover
          // )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              icon,
              color: ColorUtils.red,
              size: 25,
            ),

            Text(
              title,
              style: TextStyle(
                  color: ColorUtils.textBlack,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              child: controller.isLoading.isTrue
                  ? Center(
                child: SizedBox(width: 30.0, height:10.0, child: Center(child: ShimmerWidget(
                  height: 25,
                  width: Get.width / 4,
                ),)),
              )
                  : Text(
                subtitle,
                style: TextStyle(
                    color: ColorUtils.red.shade500,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),),
            ),
          ],
        ),
      ),
    );
  }
  Widget OrderCard() {
    return Container(
      width: Get.width,
      height: Get.width * 0.75,
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
        // image: DecorationImage(
        //   image: AssetImage('assets/img/pattern.svg'),
        //   fit: BoxFit.cover
        // )
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text("آمار وضعیت سفارشات",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: ColorUtils.red
            ),),
            SizedBox(height: 12.0,),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                child: controller.isLoading.isTrue
                    ? Center(
                  child: OrderReportsLoading(),
                )
                    :  GridView.builder(
                  scrollDirection: Axis.vertical,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 1,
                    mainAxisExtent: 30,
                  ),
                  itemCount: controller.orderReport.length,
                  itemBuilder: (BuildContext context, int index) {
                    return OrderReports(index);
                  },
                ),
              ),
            ),
        ]

        ),
      ),
    );
  }
  Widget TopSellerCard() {
    return Container(
      width: Get.width,
      height: Get.width * 0.75,
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
        // image: DecorationImage(
        //   image: AssetImage('assets/img/pattern.svg'),
        //   fit: BoxFit.cover
        // )
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text("پرفروش ترین محصولات هفته گذشته",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: ColorUtils.red
            ),),
            SizedBox(height: 12.0,),
            SizedBox(
              width: Get.width * 0.8,
              height: Get.width * 0.6,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                child: controller.isLoading.isTrue || controller.topSeller.length == 0
                    ? Center(
                  child: OrderReportsLoading(),
                )
                    :  GridView.builder(
                  scrollDirection: Axis.vertical,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 1,
                    mainAxisExtent: 30,
                  ),
                  itemCount: controller.topSeller.length,
                  itemBuilder: (BuildContext context, int index) {
                    return TopSellerReports(index);
                  },
                ),
              ),
            ),
        ]

        ),
      ),
    );
  }

   buildBackGround() {
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

  Widget TopSellerReports(int index) {
    TopSellerReport order = controller.topSeller[index];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(Iconsax.activity, size: 15, color: ColorUtils.red,),
        SizedBox(width: 8.0),
        Text(order.title ?? '',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ColorUtils.textBlack)),
        SizedBox(width: 8.0),
        Expanded(child: Text('.' * 100, maxLines: 1, style: TextStyle(color: ColorUtils.red.shade100),)),
        SizedBox(width: 8.0),
        Text(order.quantity.toString() + " عدد",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ColorUtils.textBlack))
      ],
    );
  }
  Widget OrderReports(int index) {
    TotalOrderReport order = controller.orderReport[index];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(Iconsax.activity, size: 15, color: ColorUtils.red,),
        SizedBox(width: 8.0),
        Text(order.name,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ColorUtils.textBlack)),
        SizedBox(width: 8.0),
        Expanded(child: Text('.' * 100, maxLines: 1, style: TextStyle(color: ColorUtils.red.shade100),)),
        SizedBox(width: 8.0),
        Text(order.total.toString() + " عدد",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ColorUtils.textBlack))
      ],
    );
  }
  Widget OrderReportsLoading() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ShimmerWidget(
              height: 10,
              width: 10,
            ),
            SizedBox(width: 8.0),
            ShimmerWidget(
              height: 10,
              width: 80,
            ),
            SizedBox(width: 8.0),
            Expanded(child: Text('.' * 100, maxLines: 1, style: TextStyle(color: ColorUtils.red.shade100),)),
            SizedBox(width: 8.0),
            ShimmerWidget(
              height: 10,
              width: 30,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ShimmerWidget(
              height: 10,
              width: 10,
            ),
            SizedBox(width: 8.0),
            ShimmerWidget(
              height: 10,
              width: 80,
            ),
            SizedBox(width: 8.0),
            Expanded(child: Text('.' * 100, maxLines: 1, style: TextStyle(color: ColorUtils.red.shade100),)),
            SizedBox(width: 8.0),
            ShimmerWidget(
              height: 10,
              width: 30,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ShimmerWidget(
              height: 10,
              width: 10,
            ),
            SizedBox(width: 8.0),
            ShimmerWidget(
              height: 10,
              width: 80,
            ),
            SizedBox(width: 8.0),
            Expanded(child: Text('.' * 100, maxLines: 1, style: TextStyle(color: ColorUtils.red.shade100),)),
            SizedBox(width: 8.0),
            ShimmerWidget(
              height: 10,
              width: 30,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ShimmerWidget(
              height: 10,
              width: 10,
            ),
            SizedBox(width: 8.0),
            ShimmerWidget(
              height: 10,
              width: 80,
            ),
            SizedBox(width: 8.0),
            Expanded(child: Text('.' * 100, maxLines: 1, style: TextStyle(color: ColorUtils.red.shade100),)),
            SizedBox(width: 8.0),
            ShimmerWidget(
              height: 10,
              width: 30,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ShimmerWidget(
              height: 10,
              width: 10,
            ),
            SizedBox(width: 8.0),
            ShimmerWidget(
              height: 10,
              width: 80,
            ),
            SizedBox(width: 8.0),
            Expanded(child: Text('.' * 100, maxLines: 1, style: TextStyle(color: ColorUtils.red.shade100),)),
            SizedBox(width: 8.0),
            ShimmerWidget(
              height: 10,
              width: 30,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ShimmerWidget(
              height: 10,
              width: 10,
            ),
            SizedBox(width: 8.0),
            ShimmerWidget(
              height: 10,
              width: 80,
            ),
            SizedBox(width: 8.0),
            Expanded(child: Text('.' * 100, maxLines: 1, style: TextStyle(color: ColorUtils.red.shade100),)),
            SizedBox(width: 8.0),
            ShimmerWidget(
              height: 10,
              width: 30,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ShimmerWidget(
              height: 10,
              width: 10,
            ),
            SizedBox(width: 8.0),
            ShimmerWidget(
              height: 10,
              width: 80,
            ),
            SizedBox(width: 8.0),
            Expanded(child: Text('.' * 100, maxLines: 1, style: TextStyle(color: ColorUtils.red.shade100),)),
            SizedBox(width: 8.0),
            ShimmerWidget(
              height: 10,
              width: 30,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ShimmerWidget(
              height: 10,
              width: 10,
            ),
            SizedBox(width: 8.0),
            ShimmerWidget(
              height: 10,
              width: 80,
            ),
            SizedBox(width: 8.0),
            Expanded(child: Text('.' * 100, maxLines: 1, style: TextStyle(color: ColorUtils.red.shade100),)),
            SizedBox(width: 8.0),
            ShimmerWidget(
              height: 10,
              width: 30,
            ),
          ],
        ),
      ],
    );
  }

}

