import 'package:red_leaf/Plugins/get/get.dart';

class TotalOrderReport {
  TotalOrderReport({
    required this.total,
    required this.slug,
    required this.name,
  });

  final int total;
  final String slug;
  final String name;



  factory TotalOrderReport.fromJson(Map<String, dynamic> json) => TotalOrderReport(
        total: json["total"],
        slug: json["slug"],
        name: json["name"],


      );

  Map<String, dynamic> toMap() => {
        "total": total,
        "slug": slug,
        "name": name,

      };

  static List<TotalOrderReport> listFromJson(List data) {
    return data.map((e) => TotalOrderReport.fromJson(e)).toList();
  }
}
