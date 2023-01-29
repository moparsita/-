
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:red_leaf/Controllers/Customers/customer_controller.dart';
import 'package:red_leaf/Controllers/Customers/customer_controller.dart';
import 'package:red_leaf/Models/order_model.dart';
import 'package:red_leaf/Plugins/get/get.dart';

import '../../Controllers/Home/home_controller.dart';
import '../../Controllers/Order/order_controller.dart';
import '../../Plugins/get/get_core/src/get_main.dart';
import '../../Utils/color_utils.dart';
import '../../Utils/image_utils.dart';
import '../../Utils/view_utils.dart';
import '../../Widgets/my_app_bar.dart';

class CustomerDetailsScreen extends StatelessWidget {
  final CustomerController controller = Get.put(CustomerController());
  final bool mainPage;
  Widget? orderId;
  CustomerDetailsScreen({
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
      controller.fetchCustomerOrders(controller.customer.id);
    return Column(
      children: [
        buildBackGround(),
        SizedBox(height: 16,),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Obx(
                () =>  controller.customerIsLoading.isFalse ?
          Column(
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
                      controller.customer.firstName + controller.customer.lastName,
                      style: TextStyle(
                          color: ColorUtils.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                      ),
                    ),
                    Spacer(),

                  ],

                ),
              SizedBox(height: 24.0),
              // orderBrief(),
              customerData(),
              Expanded(
                child: GridView.builder(
                  scrollDirection: Axis.vertical,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 1,
                    mainAxisExtent: 400,
                  ),
                  itemCount: controller.orders.length,
                  itemBuilder: (BuildContext context, int index) {
                    return orderBrief(index);
                  },
                ),
              ),
              // Products(),

            ],
          )
            :
            Center(child: CircularProgressIndicator()),
          ),

        ),

      ],
    );
  }
  changeStatus(status) {
    String title;
    switch (status) {
      case 'pending' :
        title = "درانتظار پرداخت";
        break;
      case 'processing' :
        title = "در حال انجام";
        break;
      case 'on-hold' :
        title = "در انتظار بررسی";
        break;
      case 'completed' :
        title = "تکمیل شده";
        break;
      case 'cancelled' :
        title = "لغو شده";
        break;
      case 'refunded' :
        title = "مسترد شده";
        break;
      case 'failed' :
        title = "ناموفق";
        break;
      case 'checkout-draft' :
        title = "پیش نویس";
        break;
      default:
        title = "نامشخص";
    }
    return title;
  }

  Widget orderBrief(int index) {
    OrderModel order = controller.orders[index];
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("سفارش شماره " + order.number,
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
              Text('وضعیت سفارش',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ColorUtils.textBlack)),
              SizedBox(width: 8.0),
              Expanded(child: Text('.' * 100, maxLines: 1, style: TextStyle(color: ColorUtils.red.shade100),)),
              SizedBox(width: 8.0),
              Text(changeStatus(order.status),
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
              Text('جمع فاکتور',
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
          SizedBox(height: 8.0,),
          SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: order.lineItems.length,
              itemBuilder: (BuildContext context, int index) {
                return productCard(index, order);
              },
            ),
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
              Text(controller.customer.billing.firstName + ' ' + controller.customer.billing.lastName,
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
              Text(controller.customer.billing.email!,
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
              Text(controller.customer.billing.phone!,
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
              Text(controller.customer.billing.state,
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
              Text(controller.customer.billing.city,
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
              Text(controller.customer.billing.address1,
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
              Text(controller.customer.billing.address2!,
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
              Text(controller.customer.billing.postcode,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ColorUtils.textBlack))
            ],
          ),
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
      title: 'مشخصات مشتری',
      inner: true,
    );
  }


  Widget productCard(int index, OrderModel order) {
    LineItem product = order.lineItems[index];
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          SizedBox(height: 12.0,),
          Row(
            children: [
              Icon(Iconsax.tag, size: 15, color: ColorUtils.red,),
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
          SizedBox(height: 8.0,),
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
          SizedBox(height: 8.0,),
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
          SizedBox(height: 8.0,),
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