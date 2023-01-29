import 'package:red_leaf/Plugins/get/get.dart';

class TotalProductReport {
  TotalProductReport({
    required this.total,
    required this.slug,
    required this.name,
  });

  final int total;
  final String slug;
  final String name;



  factory TotalProductReport.fromJson(Map<String, dynamic> json) => TotalProductReport(
        total: json["total"],
        slug: json["slug"],
        name: json["name"],


      );

  Map<String, dynamic> toMap() => {
        "total": total,
        "slug": slug,
        "name": name,

      };

  static List<TotalProductReport> listFromJson(List data) {
    return data.map((e) => TotalProductReport.fromJson(e)).toList();
  }
}
