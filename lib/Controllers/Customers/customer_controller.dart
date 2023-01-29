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
import '../../Views/Customers/Widgets/customer_pagination_widget.dart';
import '../../Views/Home/Widgets/pagination_widget.dart';
import '../../Views/Home/Widgets/sort_widget.dart';
import '../../Views/Order/Widgets/change_status_widget.dart';
import '../../Views/Order/Widgets/order_pagination_widget.dart';
import '../../Views/Order/Widgets/sort_order_widget.dart';


class CustomerController extends GetxController {

  final RxBool customerIsLoading = false.obs;
  final RxBool customersIsLoading = false.obs;
  final RefreshController refreshController = RefreshController();
  final RxString sortType = 'نام - صعودی'.obs;
  final List<String> sortTypes = [
    'نام - نزولی',
    'تاریخ ثبت',

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
  List<CustomerModel> customers = [];
  late ProductModel product;
  List<OrderModel> orders = [];
  int customerId = int.tryParse(Get.currentRoute.split('=').last) ?? 0;

  Future<void> fetchCustomers(String per_page) async {
    customersIsLoading.value = true;
    wApiResult result = await WooCommerceUtil.instance.data.customers(per_page);
    if(result.isDone) {
      customers = CustomerModel.listFromJson(result.data);
      customersIsLoading.value = false;
    }

  }


  Future<void> fetchCustomerData(String customerId) async {
    customerIsLoading.value = true;
    wApiResult result = await WooCommerceUtil.instance.data.getCustomer(customerId);

    if(result.isDone) {
      order = OrderModel.fromJson(result.data);
    }
    customerIsLoading.value = false;
  }

  Future<void> fetchCustomerOrders(int customerId) async {
    customerIsLoading.value = true;
    wApiResult result = await WooCommerceUtil.instance.data.customerOrders(customerId.toString());
    // wApiResult result = await WooCommerceUtil.instance.data.myOrders();
    if(result.isDone) {
      orders = OrderModel.listFromJson(result.data);

      customerIsLoading.value = false;
    }
    print('orders');
    print(orders);
    customerIsLoading.value = false;
  }

  @override
  void onInit() {
    customerId = int.tryParse(Get.currentRoute.split('=').last) ?? 0;
    print('customerId');
    print(customerId);
    if(customerId > 0) {
      init();
    } else {
      fetchCustomers("10");
    }
    super.onInit();
  }

  Future<void> init() async {

    customerId = int.tryParse(Get.currentRoute.split('=').last) ?? 0;

    if (customerId > 0) {
      fetchCustomerData(customerId.toString());
      fetchCustomerOrders(customerId);
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
    switch (str) {
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
    customerIsLoading.value = true;
    await fetchCustomerOrders(customerId);
    customerIsLoading.value = false;
  }

  void showPage() async {
    String str = perPage.value;
    pageStream?.cancel();
    pageStream = perPage.stream.listen((event) {
      Get.close(1);
    });
    await Get.bottomSheet(
      CustomerPaginationWidget(),
    );
    if(str != perPage.value) {
      customerIsLoading.value = true;
      await fetchCustomers(perPage.value);
      customerIsLoading.value = false;
    }
  }






}