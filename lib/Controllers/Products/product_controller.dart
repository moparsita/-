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
import 'package:red_leaf/Views/Products/Widgets/product_pagination_widget.dart';

import '../../Models/data_model.dart';
import '../../Models/order_model.dart';
import '../../Models/product_model.dart';
import '../../Plugins/get/get_core/src/get_main.dart';
import '../../Plugins/get/get_rx/src/rx_types/rx_types.dart';
import '../../Plugins/get/get_state_manager/src/simple/get_controllers.dart';
import '../../Plugins/refresher/pull_to_refresh.dart';
import '../../Utils/Api/project_request_utils.dart';
import '../../Utils/view_utils.dart';
import '../../Views/Home/Widgets/pagination_widget.dart';
import '../../Views/Products/Widgets/sort_product_widget.dart';
import '../../Views/Home/Widgets/sort_widget.dart';


class ProductController extends GetxController {

  final RxBool productsIsLoading = false.obs;

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

  String myOrder = "desc";
  String myOrderBy = "title";
  StreamSubscription<String?>? sortStream;
  StreamSubscription<String?>? pageStream;
  List<ProductModel> products = [];





  Future<void> fetchProducts(String per_page, String order, String orderBy) async {
    productsIsLoading.value = true;
    wApiResult result = await WooCommerceUtil.instance.data.products(per_page, order, orderBy);
    if(result.isDone) {
      products = ProductModel.listFromJson(result.data);

    } else {
      ViewUtils.showErrorDialog(
        "خطایی در اتصال به بانک اطلاعاتی بوجود آمده است",
      );
    }

    productsIsLoading.value = false;

  }




  @override
  void onInit() {
    init();
    super.onInit();
  }

  Future<void> init() async {

    productsIsLoading.value = true;
    await fetchProducts('10', 'desc', 'title');
    productsIsLoading.value = false;


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
      SortProductWidget(),
    );
    if(str != sortType.value) {
      switch (sortType.value) {
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

  }

  void showPage() async {
    String str = perPage.value;
    pageStream?.cancel();
    pageStream = perPage.stream.listen((event) {
      Get.close(1);
    });
    await Get.bottomSheet(
      ProductPaginationWidget(),
    );

    if(str != perPage.value) {
      productsIsLoading.value = true;
      await fetchProducts(perPage.value, myOrder, myOrderBy);
      productsIsLoading.value = false;
    }

  }


}