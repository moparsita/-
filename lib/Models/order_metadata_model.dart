import 'package:red_leaf/Plugins/get/get.dart';

class ProductMetaDataModel {
  ProductMetaDataModel({
    required this.id,
    required this.key,
    required this.value,
  });

  final int id;
  final String key;
  final String value;



  factory ProductMetaDataModel.fromJson(Map<String, dynamic> json) => ProductMetaDataModel(
        id: json["id"],
        key: json["key"],
        value: json["value"],


      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "key": key,
        "value": value,

      };

  static List<ProductMetaDataModel> listFromJson(List data) {
    return data.map((e) => ProductMetaDataModel.fromJson(e)).toList();
  }
}
