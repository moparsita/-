import 'package:red_leaf/Plugins/get/get.dart';

class ProductImageModel {
  ProductImageModel({
    required this.id,
    required this.name,
    required this.src,
  });

  final int id;
  final String name;
  final String src;



  factory ProductImageModel.fromJson(Map<String, dynamic> json) => ProductImageModel(
        id: json["id"],
        name: json["name"],
        src: json["src"],


      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "src": src,

      };

  static List<ProductImageModel> listFromJson(List data) {
    return data.map((e) => ProductImageModel.fromJson(e)).toList();
  }
}
