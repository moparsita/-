import 'package:red_leaf/Plugins/get/get.dart';

class OrderTaxesModel {
  OrderTaxesModel({
    required this.id,
    required this.total,
    required this.subtotal,
  });

  final int id;
  final String total;
  final String subtotal;



  factory OrderTaxesModel.fromJson(Map<String, dynamic> json) => OrderTaxesModel(
        id: json["id"],
        total: json["total"],
        subtotal: json["subtotal"],


      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "total": total,
        "subtotal": subtotal,

      };

  static List<OrderTaxesModel> listFromJson(List data) {
    return data.map((e) => OrderTaxesModel.fromJson(e)).toList();
  }
}
