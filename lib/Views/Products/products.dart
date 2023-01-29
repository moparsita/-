import 'dart:convert';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:red_leaf/Plugins/get/get.dart';

import '../../Controllers/Home/home_controller.dart';
import '../../Controllers/Products/product_controller.dart';
import '../../Models/product_model.dart';
import '../../Utils/color_utils.dart';
import '../../Utils/image_utils.dart';
import '../../Utils/routing_utils.dart';
import '../../Utils/shimmer_widget.dart';
import '../../Utils/view_utils.dart';
import '../../Utils/widget_utils.dart';
import '../../Widgets/my_app_bar.dart';


class ProductsScreen extends StatelessWidget {
  final MainGetxController appBarController = Get.find<MainGetxController>();
  final ProductController controller = Get.put(ProductController());
  final bool mainPage;
  ProductsScreen({
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
                      Iconsax.tag,
                      color: Colors.red,
                    ),
                    SizedBox(width: 8.0,),

                        Text(
                          "محصولات",
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
                        // perPageMenu(),


                  ],
                ),
              ),

              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 150),
                  child: controller.productsIsLoading.isTrue
                      ? productsLoading()
                      :  controller.products.length >0 ?
                  products()
                  : Container(child: Text('محصولی وجود ندارد و یا خطایی در دریافت اطلاعات بوجود آمده است'),),
                ),
              ),

            ],
          ),
    );
  }

  Widget productCard(int index) {
    ProductModel product = controller.products[index];
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(10.0),
                topLeft: Radius.circular(10.0),
              ),
              child: FadeInImage(
                fit: BoxFit.cover,
                width: Get.width,
                height: Get.width / 2,
                placeholder: ImageUtils.placeholder,
                image: NetworkImage(

                  product.images.first.src,
                ),

              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 12.0
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: Get.width,
                    child: Text(
                      product.name,
                      maxLines:2,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 6.0),
                  Row(
                    children: [
                      Text(
                        'قیمت: ',
                        style: TextStyle(
                          color: ColorUtils.textBlack,
                          fontSize: 13
                        ),
                      ),
                      Text(
                        product.price.toString().seRagham(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        "تومان",
                        style: TextStyle(
                          color: ColorUtils.textGray,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Text(
                        'دسته بندی: ',
                        style: TextStyle(
                          color: ColorUtils.textBlack,
                          fontSize: 13
                        ),
                      ),
                      Text(
                        product.categories.first.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.0),
                  Row(
                    children: [
                      Text(
                        'تعداد فروش: ',
                        style: TextStyle(
                          color: ColorUtils.textBlack,
                          fontSize: 13
                        ),
                      ),
                      Text(
                        product.total_sales.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                            fontSize: 13
                        ),
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
  Widget productCardLoadin(int index) {
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
                width: Get.width / 3 - 20,
                height: Get.width /3 + 100,
              )
            ),
            const SizedBox(
              width: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 1.0,
                vertical: 12.0
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
  Widget buildProduct(int index) {
    ProductModel product = controller.products[index];
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          Get.toNamed(RoutingUtils.product.name, parameters: {
            'productId': jsonEncode([product.id]),
          });
        },
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: FadeInImage(
                placeholder: ImageUtils.placeholder,
                image: NetworkImage(
                  product.images.first.src,
                ),
                width: Get.width / 5.5,
                fit: BoxFit.cover,
                height: Get.width / 5.5,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 8,
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
  Widget perPageMenu() {
    return Obx(
          () => Container(
            width: Get.width / 3 - 20,
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
            onTap: () => controller.showPage(),
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
                    'تعداد نمایش',
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

  Widget products() {
    return LazyLoadScrollView(
      scrollOffset: 300,
      onEndOfPage: () { controller.fetchProducts((int.parse(controller.perPage.value) + int.parse(controller.perPage.value)).toString(), controller.myOrder, controller.myOrderBy); },
      child: GridView.builder(
        scrollDirection: Axis.vertical,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisSpacing: 10,
          crossAxisSpacing: 1,
          mainAxisExtent:370,
        ),
        itemCount: controller.products.length,
        itemBuilder: (BuildContext context, int index) {
          return productCard(index);
        },
      ),
    );
  }
  Widget productsLoading() {
    return GridView.builder(
      scrollDirection: Axis.vertical,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
        mainAxisExtent:200,
      ),
      itemCount: 5,
      itemBuilder: (BuildContext context, int index) {
        return productCardLoadin(index);
      },
    );
  }

}