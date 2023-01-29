import 'package:red_leaf/Plugins/get/get.dart';

class TotalCustomerReport {
  TotalCustomerReport({
    required this.slug,
    required this.name,
    required this.total,
  });

  final String slug;
  final String name;
  final int total;



  factory TotalCustomerReport.fromJson(Map<String, dynamic> json) => TotalCustomerReport(
        slug: json["slug"],
        name: json["name"],
        total: json["total"],


      );

  Map<String, dynamic> toMap() => {
        "slug": slug,
        "name": name,
        "total": total,

      };

  static List<TotalCustomerReport> listFromJson(List data) {
    return data.map((e) => TotalCustomerReport.fromJson(e)).toList();
  }
}
