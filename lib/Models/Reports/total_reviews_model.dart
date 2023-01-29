import 'package:red_leaf/Plugins/get/get.dart';

class TotalReviewsReport {
  TotalReviewsReport({
    required this.total,
    required this.slug,
    required this.name,
  });

  final int total;
  final String slug;
  final String name;



  factory TotalReviewsReport.fromJson(Map<String, dynamic> json) => TotalReviewsReport(
        total: json["total"],
        slug: json["slug"],
        name: json["name"],


      );

  Map<String, dynamic> toMap() => {
        "total": total,
        "slug": slug,
        "name": name,

      };

  static List<TotalReviewsReport> listFromJson(List data) {
    return data.map((e) => TotalReviewsReport.fromJson(e)).toList();
  }
}
