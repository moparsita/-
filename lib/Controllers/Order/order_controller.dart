import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:red_leaf/Models/Reports/total_order_model.dart';
import 'package:red_leaf/Models/Reports/total_product_model.dart';
import 'package:red_leaf/Models/Reports/total_sales_model.dart';
import 'package:red_leaf/Models/Reports/total_top_seller_model.dart';
import 'package:red_leaf/Models/customer_model.dart';
import 'package:red_leaf/Plugins/get/get.dart';
import 'package:red_leaf/Utils/WooCommerceApi/woocommerce_request_util.dart';

import '../../Models/order_model.dart';
import '../../Models/product_model.dart';
import '../../Plugins/get/get_core/src/get_main.dart';
import '../../Plugins/get/get_rx/src/rx_types/rx_types.dart';
import '../../Plugins/get/get_state_manager/src/simple/get_controllers.dart';
import '../../Plugins/refresher/pull_to_refresh.dart';
import '../../Utils/view_utils.dart';
import '../../Views/Home/Widgets/pagination_widget.dart';
import '../../Views/Home/Widgets/sort_widget.dart';
import '../../Views/Order/Widgets/change_status_widget.dart';
import '../../Views/Order/Widgets/order_pagination_widget.dart';
import '../../Views/Order/Widgets/sort_order_widget.dart';


class OrderController extends GetxController {

  final RxBool ordersIsLoading = false.obs;
  final RefreshController refreshController = RefreshController();
  final RxString statusType = 'تکمیل شده'.obs;
  final List<String> statusTypes = [
    'تکمیل شده',
    'لغو شده',
    'ناموفق',
    'در انتظار پرداخت',
    'در حال انجام',
    'در انتظار بررسی',
    'مسترد شده',
    'پیش نویس',
  ];
  final RxString sortType = 'همه سفارشات'.obs;
  final List<String> sortTypes = [
    'همه سفارشات',
    'تکمیل شده',
    'لغو شده',
    'ناموفق',
    'در انتظار پرداخت',
    'در حال انجام',
    'در انتظار بررسی',
    'مسترد شده',
    'پیش نویس',
  ];
  String status = "all";
  final RxString perPage = '10'.obs;
  final List<String> perPages = [
    '10',
    '20',
    '50',
    '100',
  ];
  StreamSubscription<String?>? sortStream;
  StreamSubscription<String?>? pageStream;
  StreamSubscription<String?>? statusStream;
  late OrderModel order;
  late CustomerModel customer;
  late ProductModel product;
  List<OrderModel> orders = [];
  int orderId = int.tryParse(Get.currentRoute.split('=').last) ?? 0;

  Future<void> changeOrderStatus(String orderId, String str) async{
    ordersIsLoading.value = true;
    wApiResult result = await WooCommerceUtil.instance.data.changeOrderStatus(orderId, str);
    if(result.isDone) {
      order = OrderModel.fromJson(result.data);
    }
    ordersIsLoading.value = false;
    Future.delayed(const Duration(milliseconds: 150), () {
      Get.back();
    });
  }
  Future<void> fetchSingleOrder(String orderId) async {
    ordersIsLoading.value = true;
    wApiResult result = await WooCommerceUtil.instance.data.singleOrder(orderId);

    if(result.isDone) {
      order = OrderModel.fromJson(result.data);
    }
    ordersIsLoading.value = false;
  }

  Future<void> fetchOrders(String per_page, String status) async {
    ordersIsLoading.value = true;
    wApiResult result = await WooCommerceUtil.instance.data.orders(per_page, status);
    // wApiResult result = await WooCommerceUtil.instance.data.myOrders();
    if(result.isDone) {
      orders = OrderModel.listFromJson(result.data);
    } else {
      ViewUtils.showErrorDialog(
        "خطایی در اتصال به بانک اطلاعاتی بوجود آمده است",
      );
    }
    ordersIsLoading.value = false;
  }

  @override
  void onInit() {
    orderId = int.tryParse(Get.currentRoute.split('=').last) ?? 0;
    if(orderId > 0) {
      init();
    }
      fetchOrders("10", "all");

    super.onInit();
  }

  Future<void> init() async {

    orderId = int.tryParse(Get.currentRoute.split('=').last) ?? 0;
    if (orderId > 0) {
      fetchSingleOrder(orderId.toString());
    } else {
      Future.delayed(const Duration(milliseconds: 150), () {
        Get.back();
      });
    }
  }

  void onRefresh() async {
    await init();
    refreshController.refreshCompleted();
  }


  void showSort() async {
    String str = sortType.value;
    sortStream?.cancel();
    sortStream = sortType.stream.listen((event) {
      Get.close(1);
    });
    await Get.bottomSheet(
      OrderSortWidget(),
    );
    if(str != sortType.value) {
      switch (sortType.value) {
        case 'همه سفارشات' :
          status = "all";
          break;
        case 'درانتظار پرداخت' :
          status = "pending";
          break;
        case 'در حال انجام' :
          status = "processing";
          break;
        case 'در انتظار بررسی' :
          status = "on-hold";
          break;
        case 'تکمیل شده' :
          status = "completed";
          break;
        case 'لغو شده' :
          status = "cancelled";
          break;
        case 'مسترد شده' :
          status = "refunded";
          break;
        case 'ناموفق' :
          status = "failed";
          break;
        case 'پیش نویس' :
          status = "checkout-draft";
          break;
        default:
          status = "all";
      }
      ordersIsLoading.value = true;
      await fetchOrders(perPage.value, status);
      ordersIsLoading.value = false;
    }
  }

  void showPage() async {
    String str = perPage.value;
    pageStream?.cancel();
    pageStream = perPage.stream.listen((event) {
      Get.close(1);
    });
    await Get.bottomSheet(
      OrderPaginationWidget(),
    );
    if(str != perPage.value) {
      ordersIsLoading.value = true;
      await fetchOrders(perPage.value, status);
      ordersIsLoading.value = false;
    }
  }

  showStatus(int id) async {

    String str = statusType.value;
    statusStream?.cancel();
    statusStream = statusType.stream.listen((event) {
      Get.close(1);
    });
    await Get.bottomSheet(
      ChangeStatusWidget(),
    );
    if(str != statusType.value) {
      switch (statusType.value) {
        case 'درانتظار پرداخت' :
          status = "pending";
          break;
        case 'در حال انجام' :
          status = "processing";
          break;
        case 'در انتظار بررسی' :
          status = "on-hold";
          break;
        case 'تکمیل شده' :
          status = "completed";
          break;
        case 'لغو شده' :
          status = "cancelled";
          break;
        case 'مسترد شده' :
          status = "refunded";
          break;
        case 'ناموفق' :
          status = "failed";
          break;
        case 'پیش نویس' :
          status = "checkout-draft";
          break;
        default:
          status = "";
      }
      ordersIsLoading.value = true;
      await changeOrderStatus(id.toString(), status);

      ordersIsLoading.value = false;
    }
  }





}