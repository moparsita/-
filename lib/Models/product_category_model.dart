import 'package:red_leaf/Plugins/get/get.dart';

class CategoryModel {
  CategoryModel({
    required this.id,
    required this.name,
  });

  final int id;
  final String name;



  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json["id"],
        name: json["name"],


      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,

      };

  static List<CategoryModel> listFromJson(List data) {
    return data.map((e) => CategoryModel.fromJson(e)).toList();
  }
}
