import 'package:red_leaf/Plugins/get/get.dart';

class TotalSalesReport {
  TotalSalesReport({
    required this.total_sales,
    required this.net_sales,
    required this.average_sales,
    required this.total_orders,
    required this.total_items,
    required this.total_tax,
    required this.total_shipping,
    required this.total_refunds,
    required this.total_discount,
  });

  final String total_sales;
  final String net_sales;
  final String average_sales;
  final int total_orders;
  final int total_items;
  final String total_tax;
  final String total_shipping;
  final int total_refunds;
  final String total_discount;



  factory TotalSalesReport.fromJson(Map<String, dynamic> json) => TotalSalesReport(
        total_sales: json["total_sales"],
        net_sales: json["net_sales"],
        average_sales: json["average_sales"],
        total_orders: json["total_orders"],
        total_items: json["total_items"],
        total_tax: json["total_tax"],
        total_shipping: json["total_shipping"],
        total_refunds: json["total_refunds"],
        total_discount: json["total_discount"],


      );

  Map<String, dynamic> toMap() => {
        "total_sales": total_sales,
        "net_sales": net_sales,
        "average_sales": average_sales,
        "total_orders": total_orders,
        "total_items": total_items,
        "total_tax": total_tax,
        "total_shipping": total_shipping,
        "total_refunds": total_refunds,
        "total_discount": total_discount,

      };

  static List<TotalSalesReport> listFromJson(List data) {
    return data.map((e) => TotalSalesReport.fromJson(e)).toList();
  }
}
