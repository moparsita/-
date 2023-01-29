import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:red_leaf/Models/Reports/total_order_model.dart';
import 'package:red_leaf/Models/Reports/total_product_model.dart';
import 'package:red_leaf/Models/Reports/total_sales_model.dart';
import 'package:red_leaf/Models/Reports/total_top_seller_model.dart';
import 'package:red_leaf/Models/customer_model.dart';
import 'package:red_leaf/Plugins/get/get.dart';
import 'package:red_leaf/Utils/WooCommerceApi/woocommerce_request_util.dart';

import '../../Models/data_model.dart';
import '../../Models/order_model.dart';
import '../../Models/product_model.dart';
import '../../Plugins/get/get_core/src/get_main.dart';
import '../../Plugins/get/get_rx/src/rx_types/rx_types.dart';
import '../../Plugins/get/get_state_manager/src/simple/get_controllers.dart';
import '../../Plugins/refresher/pull_to_refresh.dart';
import '../../Utils/Api/project_request_utils.dart';
import '../../Views/Home/Widgets/pagination_widget.dart';
import '../../Views/Home/Widgets/sort_widget.dart';


class HomeController extends GetxController {
  final RxBool isLoading = true.obs;

  final RxBool productsIsLoading = false.obs;
  final RxBool customersIsLoading = false.obs;
  final RxBool ordersIsLoading = false.obs;
  final RefreshController refreshController = RefreshController();

  final RxString sortType = 'ارزانترین'.obs;
  final List<String> sortTypes = [
    'ارزانترین',
    'گرانترین',
    'جدید ترین',
    'قدیمی ترین',
    'محبوب ترین',
    'پرامتیاز ترین',
  ];

  final RxString perPage = '10'.obs;
  final List<String> perPages = [
    '10',
    '20',
    '50',
    '100',
  ];

  StreamSubscription<String?>? sortStream;
  StreamSubscription<String?>? pageStream;
  List<ProductModel> products = [];
  List<TopSellerReport> topSeller = [];
  List<TotalSalesReport> todaySaleReport = [];
  List<TotalSalesReport> lastYearSaleReport = [];
  List<TotalOrderReport> orderReport = [];
  List<TotalProductReport> productReport = [];
  DataModel? DrawerData;
  int allProductsCount = 0;
  int allOrdersCount = 0;




  Future<void> fetchProducts(String per_page, String order, String orderBy) async {
    productsIsLoading.value = true;
    wApiResult result = await WooCommerceUtil.instance.data.products(per_page, order, orderBy);
    if(result.isDone) {
      products = ProductModel.listFromJson(result.data);
      productsIsLoading.value = false;
    }

  }





  Future<void> fetchTodaySaleReport() async {
    isLoading.value = true;
    wApiResult result = await WooCommerceUtil.instance.data.salesReport();
    if(result.isDone) {
      todaySaleReport = TotalSalesReport.listFromJson(result.data);
      isLoading.value = false;
    }

  }

  Future<void> fetchLastYearSaleReport() async {
    isLoading.value = true;
    wApiResult result = await WooCommerceUtil.instance.data.salesReportRange('year');
    if(result.isDone) {
      lastYearSaleReport = TotalSalesReport.listFromJson(result.data);
      isLoading.value = false;
    }

  }

  Future<void> fetchTopSellerReport() async {
    isLoading.value = true;
    wApiResult result = await WooCommerceUtil.instance.data.topSellerReport('month');
    if(result.isDone) {
      topSeller = TopSellerReport.listFromJson(result.data);
      isLoading.value = false;
    }

  }

  Future<void> fetchOrderReport() async {
    isLoading.value = true;
    wApiResult result = await WooCommerceUtil.instance.data.orderReport();
    if(result.isDone) {
      orderReport = TotalOrderReport.listFromJson(result.data);
      isLoading.value = false;
    }

  }

  Future<void> fetchProductReport() async {
    isLoading.value = true;
    wApiResult result = await WooCommerceUtil.instance.data.productsReport();
    if(result.isDone) {
      productReport = TotalProductReport.listFromJson(result.data);
      isLoading.value = false;
    }

  }

  int fetchAllProductCounts() {
    return productReport.map((e) => e.total).reduce((value, element) => value + element);
  }

  int fetchAllOrdersCounts() {
    return orderReport.map((e) => e.total).reduce((value, element) => value + element);return 15;
  }



  @override
  void onInit() {

    init();
    super.onInit();
  }

  Future<void> init() async {

    isLoading.value = true;
    // await fetchTopSellerReport();
    await fetchTodaySaleReport();
    await fetchLastYearSaleReport();
    await fetchOrderReport();
    await fetchProductReport();
    if(productReport.length > 0) {
      allProductsCount = fetchAllProductCounts();
    } else {
      allProductsCount = 0;
    }

    if(orderReport.length > 0) {
      allOrdersCount = fetchAllOrdersCounts();
    } else {
      allOrdersCount = 0;
    }

    isLoading.value = false;
  }

  void onRefresh() async {
    await init();
    refreshController.refreshCompleted();
  }

  void showSort() async {
    String myOrder = "desc";
    String myOrderBy = "title";
    String str = sortType.value;
    sortStream?.cancel();
    sortStream = sortType.stream.listen((event) {
      Get.close(1);
    });
    await Get.bottomSheet(
      SortWidget(),
    );
    switch (str) {
      case 'ارزانترین' :
        myOrder = "asc";
        myOrderBy = "price";
        break;
      case 'گرانترین' :
        myOrder = "desc";
        myOrderBy = "price";
        break;
      case 'جدید ترین' :
        myOrder = "desc";
        myOrderBy = "date";
        break;
      case 'قدیمی ترین' :
        myOrder = "asc";
        myOrderBy = "date";
        break;
      case 'محبوب ترین' :
        myOrder = "desc";
        myOrderBy = "popularity";
        break;
      case 'پرامتیاز ترین' :
        myOrder = "desc";
        myOrderBy = "rating";
        break;

    }
    productsIsLoading.value = true;
    await fetchProducts(perPage.value, myOrder, myOrderBy);
    productsIsLoading.value = false;
  }

  void showPage() async {
    String str = perPage.value;
    pageStream?.cancel();
    pageStream = perPage.stream.listen((event) {
      Get.close(1);
    });
    await Get.bottomSheet(
      PaginationWidget(),
    );

  }


}