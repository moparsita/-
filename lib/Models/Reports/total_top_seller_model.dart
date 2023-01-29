import 'package:red_leaf/Plugins/get/get.dart';

class TopSellerReport {
  TopSellerReport({
    required this.product_id,
    required this.quantity,
    this.title,
  });

  final int product_id;
  final int quantity;
  final String? title;



  factory TopSellerReport.fromJson(Map<String, dynamic> json) => TopSellerReport(
        product_id: json["product_id"],
        quantity: json["quantity"],
        title: json["title"],


      );

  Map<String, dynamic> toMap() => {
        "product_id": product_id,
        "quantity": quantity,
        "title": title,

      };

  static List<TopSellerReport> listFromJson(List data) {
    return data.map((e) => TopSellerReport.fromJson(e)).toList();
  }
}
