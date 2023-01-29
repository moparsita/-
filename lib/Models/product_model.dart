import 'package:red_leaf/Models/product_category_model.dart';
import 'package:red_leaf/Models/product_image_model.dart';
import 'package:red_leaf/Plugins/get/get.dart';

class ProductModel {
  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.regular_price,
    required this.sale_price,
    required this.total_sales,
    required this.images,
    required this.categories,

  });

  final int id;
  final String name;
  final String price;
  final String regular_price;
  final String sale_price;
  final int total_sales;
  final List<ProductImageModel> images;
  final List<CategoryModel> categories;


  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        name: json["name"],
        price: json["price"],
        regular_price: json["regular_price"],
        sale_price: json["sale_price"],
        total_sales: json["total_sales"],
        images: List.from(json["images"]).map((e) => ProductImageModel.fromJson(e)).toList(),
        categories: List.from(json['categories']).map((e) => CategoryModel.fromJson(e)).toList(),

      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "price": price,
        "regular_price": regular_price,
        "sale_price": sale_price,
        "total_sales": total_sales,
        "images": images,
        "categories": categories,

      };

  static List<ProductModel> listFromJson(List data) {
    return data.map((e) => ProductModel.fromJson(e)).toList();
  }
}
