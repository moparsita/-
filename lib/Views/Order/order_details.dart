
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:red_leaf/Models/order_model.dart';
import 'package:red_leaf/Plugins/get/get.dart';

import '../../Controllers/Home/home_controller.dart';
import '../../Controllers/Order/order_controller.dart';
import '../../Plugins/get/get_core/src/get_main.dart';
import '../../Utils/color_utils.dart';
import '../../Utils/image_utils.dart';
import '../../Utils/view_utils.dart';
import '../../Widgets/my_app_bar.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderController controller = Get.put(OrderController());
  final bool mainPage;
  Widget? orderId;
  OrderDetailsScreen({
    Key? key,
    this.mainPage = false,
    this.orderId
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
     // controller.init();
    return SingleChildScrollView(
      child: Column(
        children: [
          buildBackGround(),
          SizedBox(height: 16,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Obx(
                  () =>  controller.ordersIsLoading.isFalse ?
            SizedBox(
              height: Get.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                      children: [
                        Icon(
                          Iconsax.user,
                          color: Colors.red,
                        ),
                        SizedBox(width: 8.0,),

                        Text(
                          "سفارش شماره " + controller.order.id.toString(),
                          style: TextStyle(
                              color: ColorUtils.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 18
                          ),
                        ),
                        Spacer(),
                        changeStatus(),

                      ],

                    ),
                  SizedBox(height: 24.0),
                  orderBrief(),
                  customerData(),
                  Products(),

                ],
              ),
            )
              :
              Center(child: CircularProgressIndicator()),
            ),

          ),

        ],
      ),
    );
  }

  Widget changeStatus() {
    String title;
    Color bgColor = ColorUtils.gray;
    switch (controller.order.status) {
      case 'pending' :
        title = "درانتظار پرداخت";
        bgColor = ColorUtils.orange;
        break;
      case 'processing' :
        title = "در حال انجام";
        bgColor = ColorUtils.green.shade600;
        break;
      case 'on-hold' :
        title = "در انتظار بررسی";
        bgColor = ColorUtils.red;
        break;
      case 'completed' :
        title = "تکمیل شده";
        bgColor = ColorUtils.green;
        break;
      case 'cancelled' :
        title = "لغو شده";
        bgColor = ColorUtils.purple;
        break;
      case 'refunded' :
        title = "مسترد شده";
        bgColor = ColorUtils.yellow;
        break;
      case 'failed' :
        title = "ناموفق";
        bgColor = ColorUtils.red;
        break;
      case 'checkout-draft' :
        title = "پیش نویس";
        bgColor = ColorUtils.gray;
        break;
      default:
        title = "نامشخص";

    }
    return Obx(
          () =>
              !controller.ordersIsLoading.value ?
              Container(
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
            onTap: () => controller.showStatus(controller.order.id),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 2.0,
                horizontal: 8.0,
              ),
              child: Row(
                children: [
                  Icon(
                    Iconsax.hashtag,
                    color: ColorUtils.red,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    title,
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
      )
      : Container(),
    );
  }

  Widget orderBrief() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("اطلاعات سفارش ",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: ColorUtils.red,

            ),
          textAlign: TextAlign.right,),
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
              Text(controller.order.id.toString(),
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
              Text(controller.order.dateCreatedGmt.toPersianDateStr(),
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
              Text(controller.order.billing.firstName + ' ' + controller.order.billing.lastName,
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
              Text(controller.order.total.seRagham() + controller.order.currency,
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
              Text(controller.order.paymentMethodTitle,
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
              Text(controller.order.lineItems.length.toString() + " عدد",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ColorUtils.textBlack))
            ],
          ),
          SizedBox(height: 12,),
        ],
      ),
    );
  }
  Widget customerData() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("اطلاعات مشتری ",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: ColorUtils.red,

            ),
          textAlign: TextAlign.right,),
          SizedBox(height: 12.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Iconsax.activity, size: 15, color: ColorUtils.red,),
              SizedBox(width: 8.0),
              Text('نام مشتری',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ColorUtils.textBlack)),
              SizedBox(width: 8.0),
              Expanded(child: Text('.' * 100, maxLines: 1, style: TextStyle(color: ColorUtils.red.shade100),)),
              SizedBox(width: 8.0),
              Text(controller.order.billing.firstName + ' ' + controller.order.billing.lastName,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ColorUtils.textBlack))
            ],
          ),
          SizedBox(height: 8.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Iconsax.activity, size: 15, color: ColorUtils.red,),
              SizedBox(width: 8.0),
              Text('آدرس ایمیل',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ColorUtils.textBlack)),
              SizedBox(width: 8.0),
              Expanded(child: Text('.' * 100, maxLines: 1, style: TextStyle(color: ColorUtils.red.shade100),)),
              SizedBox(width: 8.0),
              Text(controller.order.billing.email!,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ColorUtils.textBlack))
            ],
          ),
          SizedBox(height: 8.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Iconsax.activity, size: 15, color: ColorUtils.red,),
              SizedBox(width: 8.0),
              Text('شماره تلفن',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ColorUtils.textBlack)),
              SizedBox(width: 8.0),
              Expanded(child: Text('.' * 100, maxLines: 1, style: TextStyle(color: ColorUtils.red.shade100),)),
              SizedBox(width: 8.0),
              Text(controller.order.billing.phone!,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ColorUtils.textBlack))
            ],
          ),
          SizedBox(height: 8.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Iconsax.activity, size: 15, color: ColorUtils.red,),
              SizedBox(width: 8.0),
              Text('استان',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ColorUtils.textBlack)),
              SizedBox(width: 8.0),
              Expanded(child: Text('.' * 100, maxLines: 1, style: TextStyle(color: ColorUtils.red.shade100),)),
              SizedBox(width: 8.0),
              Text(controller.order.billing.state,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ColorUtils.textBlack))
            ],
          ),
          SizedBox(height: 8.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Iconsax.activity, size: 15, color: ColorUtils.red,),
              SizedBox(width: 8.0),
              Text('شهر',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ColorUtils.textBlack)),
              SizedBox(width: 8.0),
              Expanded(child: Text('.' * 100, maxLines: 1, style: TextStyle(color: ColorUtils.red.shade100),)),
              SizedBox(width: 8.0),
              Text(controller.order.billing.city,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ColorUtils.textBlack))
            ],
          ),
          SizedBox(height: 8.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Iconsax.activity, size: 15, color: ColorUtils.red,),
              SizedBox(width: 8.0),
              Text('آدرس',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ColorUtils.textBlack)),
              SizedBox(width: 8.0),
              Expanded(child: Text('.' * 100, maxLines: 1, style: TextStyle(color: ColorUtils.red.shade100),)),
              SizedBox(width: 8.0),
              Text(controller.order.billing.address1,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ColorUtils.textBlack))
            ],
          ),
          SizedBox(height: 8.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Iconsax.activity, size: 15, color: ColorUtils.red,),
              SizedBox(width: 8.0),
              Text('ادامه آدرس',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ColorUtils.textBlack)),
              SizedBox(width: 8.0),
              Expanded(child: Text('.' * 100, maxLines: 1, style: TextStyle(color: ColorUtils.red.shade100),)),
              SizedBox(width: 8.0),
              Text(controller.order.billing.address2,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ColorUtils.textBlack))
            ],
          ),
          SizedBox(height: 8.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Iconsax.activity, size: 15, color: ColorUtils.red,),
              SizedBox(width: 8.0),
              Text('کدپستی',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ColorUtils.textBlack)),
              SizedBox(width: 8.0),
              Expanded(child: Text('.' * 100, maxLines: 1, style: TextStyle(color: ColorUtils.red.shade100),)),
              SizedBox(width: 8.0),
              Text(controller.order.billing.postcode,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ColorUtils.textBlack))
            ],
          ),
          SizedBox(height: 12,),
        ],
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
    return MyAppBar(
      title: 'جزئیات سفارش',
      inner: true,
    );
  }

  Widget Products() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("اطلاعات خرید ",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: ColorUtils.red,

            ),
            textAlign: TextAlign.right,),
          SizedBox(
            height: Get.height / 4.5,
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: controller.order.lineItems.length,
                itemBuilder: (BuildContext context, int index) {
                  return productCard(index);
                },
            ),
          ),
        ],
      ),
    );
  }

  Widget productCard(int index) {
    LineItem product = controller.order.lineItems[index];
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          SizedBox(height: 12.0,),
          Row(
            children: [
              Icon(Iconsax.activity, size: 15, color: ColorUtils.red,),
              SizedBox(width: 8.0),
              AutoSizeText(
                product.name,
                style: TextStyle(
                  fontSize: 12.0,
                  color: ColorUtils.textBlack,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Text(product.name,
              //     maxLines: 2,
              //     style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ColorUtils.textBlack))
            ],
          ),
          SizedBox(height: 12.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Iconsax.activity, size: 15, color: ColorUtils.red,),
              SizedBox(width: 8.0),
              Text('کد محصول',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ColorUtils.textBlack)),
              SizedBox(width: 8.0),
              Expanded(child: Text('.' * 100, maxLines: 1, style: TextStyle(color: ColorUtils.red.shade100),)),
              SizedBox(width: 8.0),
              Text(product.id.toString(),
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ColorUtils.textBlack))
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Iconsax.activity, size: 15, color: ColorUtils.red,),
              SizedBox(width: 8.0),
              Text('قمیت واحد',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ColorUtils.textBlack)),
              SizedBox(width: 8.0),
              Expanded(child: Text('.' * 100, maxLines: 1, style: TextStyle(color: ColorUtils.red.shade100),)),
              SizedBox(width: 8.0),
              Text(product.price.toString().seRagham(),
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ColorUtils.textBlack))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Iconsax.activity, size: 15, color: ColorUtils.red,),
              SizedBox(width: 8.0),
              Text('تعداد',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ColorUtils.textBlack)),
              SizedBox(width: 8.0),
              Expanded(child: Text('.' * 100, maxLines: 1, style: TextStyle(color: ColorUtils.red.shade100),)),
              SizedBox(width: 8.0),
              Text(product.quantity.toString(),
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ColorUtils.textBlack))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Iconsax.activity, size: 15, color: ColorUtils.red,),
              SizedBox(width: 8.0),
              Text('قمیت کل',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ColorUtils.textBlack)),
              SizedBox(width: 8.0),
              Expanded(child: Text('.' * 100, maxLines: 1, style: TextStyle(color: ColorUtils.red.shade100),)),
              SizedBox(width: 8.0),
              Text(product.total.toString().seRagham(),
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ColorUtils.textBlack))
            ],
          ),
        ],
      ),
    );
  }
}