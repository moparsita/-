import 'dart:convert';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:red_leaf/Models/customer_model.dart';
import 'package:red_leaf/Models/order_model.dart';
import 'package:red_leaf/Plugins/get/get.dart';

import '../../Controllers/Home/home_controller.dart';
import '../../Controllers/Order/order_controller.dart';
import '../../Models/customer_billing_model.dart';
import '../../Models/product_model.dart';
import '../../Utils/color_utils.dart';
import '../../Utils/image_utils.dart';
import '../../Utils/routing_utils.dart';
import '../../Utils/shimmer_widget.dart';
import '../../Utils/view_utils.dart';
import '../../Utils/widget_utils.dart';
import '../../Widgets/my_app_bar.dart';


class OrdersScreen extends StatelessWidget {
  final MainGetxController appBarController = Get.find<MainGetxController>();
  final OrderController controller = Get.put(OrderController());
  final bool mainPage;
  OrdersScreen({
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
    // controller.fetchOrders(controller.perPage.value, controller.status);
    // controller.fetchOrders("10", "");

    return Column(
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
                    "سفارشات",
                    style: TextStyle(
                      color: ColorUtils.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                    ),
                  ),
              Spacer(),
              filterMenu("sort"),
              SizedBox(width: 6.0),
              filterMenu("page"),



            ],
          ),
        ),

        OrderCards(),
        SizedBox(height: 64),
      ],
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
  Widget OrderCards() {
    return Obx(() => Expanded(

        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 150),
          child: controller.ordersIsLoading.isTrue
              ? Center(
            child: OrdersLoading(),
          )
              :
          controller.orders.length > 0 ?
          LazyLoadScrollView(
            scrollOffset: 300,
            onEndOfPage: () { controller.fetchOrders((int.parse(controller.perPage.value) + int.parse(controller.perPage.value)).toString(), controller.status); },
            child: GridView.builder(
              scrollDirection: Axis.vertical,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisSpacing: 1,
                crossAxisSpacing: 1,
                mainAxisExtent: 290,
              ),
              itemCount: controller.orders.length,
              itemBuilder: (BuildContext context, int index) {
                return Orders(index);
              },
            ),
          )
              :  Center(child: Text('سفارشی برای نمایش وجود ندارد')),
        ),
      ),
    );
  }
  Widget Orders(int index) {
    OrderModel order = controller.orders[index];
    return Container(
      width: Get.width,
      height: 320,
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("سفارش شماره " + order.id.toString(),
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: ColorUtils.red
                  ),),
                orderStatusBadge(order.status),
              ],
            ),
            SizedBox(height: 12.0,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Iconsax.activity, size: 15, color: ColorUtils.red,),
                SizedBox(width: 8.0),
                Text('شناسه سفارش',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ColorUtils.textBlack)),
                SizedBox(width: 8.0),
                Expanded(child: Text('.' * 100, maxLines: 1, style: TextStyle(color: ColorUtils.red.shade100),)),
                SizedBox(width: 8.0),
                Text(order.id.toString(),
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ColorUtils.textBlack))
              ],
            ),
            SizedBox(height: 8.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Iconsax.activity, size: 15, color: ColorUtils.red,),
                SizedBox(width: 8.0),
                Text('تاریخ ثبت سفارش',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ColorUtils.textBlack)),
                SizedBox(width: 8.0),
                Expanded(child: Text('.' * 100, maxLines: 1, style: TextStyle(color: ColorUtils.red.shade100),)),
                SizedBox(width: 8.0),
                Text(order.dateCreatedGmt.toPersianDateStr(),
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ColorUtils.textBlack))
              ],
            ),
            SizedBox(height: 8.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Iconsax.activity, size: 15, color: ColorUtils.red,),
                SizedBox(width: 8.0),
                Text('سفارش دهنده',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ColorUtils.textBlack)),
                SizedBox(width: 8.0),
                Expanded(child: Text('.' * 100, maxLines: 1, style: TextStyle(color: ColorUtils.red.shade100),)),
                SizedBox(width: 8.0),
                Text(order.billing.firstName + ' ' + order.billing.lastName,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ColorUtils.textBlack))
              ],
            ),
            SizedBox(height: 8.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Iconsax.activity, size: 15, color: ColorUtils.red,),
                SizedBox(width: 8.0),
                Text('جمع سفارش',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ColorUtils.textBlack)),
                SizedBox(width: 8.0),
                Expanded(child: Text('.' * 100, maxLines: 1, style: TextStyle(color: ColorUtils.red.shade100),)),
                SizedBox(width: 8.0),
                Text(order.total.seRagham() + order.currency,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ColorUtils.textBlack))
              ],
            ),
            SizedBox(height: 8.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Iconsax.activity, size: 15, color: ColorUtils.red,),
                SizedBox(width: 8.0),
                Text('روش پرداخت',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ColorUtils.textBlack)),
                SizedBox(width: 8.0),
                Expanded(child: Text('.' * 100, maxLines: 1, style: TextStyle(color: ColorUtils.red.shade100),)),
                SizedBox(width: 8.0),
                Text(order.paymentMethodTitle,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ColorUtils.textBlack))
              ],
            ),
            SizedBox(height: 8.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Iconsax.activity, size: 15, color: ColorUtils.red,),
                SizedBox(width: 8.0),
                Text('تعداد اقلام',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ColorUtils.textBlack)),
                SizedBox(width: 8.0),
                Expanded(child: Text('.' * 100, maxLines: 1, style: TextStyle(color: ColorUtils.red.shade100),)),
                SizedBox(width: 8.0),
                Text(order.lineItems.length.toString() + " عدد",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ColorUtils.textBlack))
              ],
            ),
            SizedBox(height: 25,),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                WidgetUtils.softButton(
                  widthFactor: 1.12,
                  title: "مشاهده اطلاعات",
                  icon: Iconsax.search_favorite,
                  reverse: true,
                  iconSize: 15,
                  fontSize: 15,
                  radius: 25,
                  fontWeight: FontWeight.bold,
                  height: 40,
                  onTap: () =>
                  { controller.order = order,
                    Get.toNamed(RoutingUtils.order.name,
                        parameters: {'orderId': order.id.toString()})
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget OrdersLoading() {
    return Container(
      width: Get.width,
      height: 300,
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

  Widget orderStatusBadge(String status) {
    String title;
    Color bgColor = ColorUtils.gray;
    switch (status) {
      case 'pending' :
        status = "درانتظار پرداخت";
        bgColor = ColorUtils.orange;
        break;
      case 'processing' :
        status = "در حال انجام";
        bgColor = ColorUtils.green.shade600;
        break;
      case 'on-hold' :
        status = "در انتظار بررسی";
        bgColor = ColorUtils.red;
        break;
      case 'completed' :
        status = "تکمیل شده";
        bgColor = ColorUtils.green;
        break;
      case 'cancelled' :
        status = "لغو شده";
        bgColor = ColorUtils.purple;
        break;
      case 'refunded' :
        status = "مسترد شده";
        bgColor = ColorUtils.yellow;
        break;
      case 'failed' :
        status = "ناموفق";
        bgColor = ColorUtils.red;
        break;
      case 'checkout-draft' :
        status = "پیش نویس";
        bgColor = ColorUtils.gray;
        break;
      default:
        status = "نامشخص";

    }
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
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
        padding: const EdgeInsets.all(8.0),
        child: Text('#'+status,
        style: TextStyle(
          color: ColorUtils.white,
          fontSize: 10.0,
          fontWeight: FontWeight.bold
        ),),
      ),
    );
  }




}