// To parse this JSON data, do
//
//     final dataModel = dataModelFromJson(jsonString);

import 'dart:convert';

DataModel dataModelFromJson(String str) => DataModel.fromJson(json.decode(str));

String dataModelToJson(DataModel data) => json.encode(data.toJson());

class DataModel {
  DataModel({
    required this.about,
    required this.support,
    required this.guide,
    required this.faqs,
  });

  About about;
  Guide support;
  Guide guide;
  Faqs faqs;

  factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
    about: About.fromJson(json["About"]),
    support: Guide.fromJson(json["Support"]),
    guide: Guide.fromJson(json["Guide"]),
    faqs: Faqs.fromJson(json["Faqs"]),
  );

  Map<String, dynamic> toJson() => {
    "About": about.toJson(),
    "Support": support.toJson(),
    "Guide": guide.toJson(),
    "Faqs": faqs.toJson(),
  };
}

class About {
  About({
    required this.id,
    required this.details,
    required this.mobile,
    required this.site,
    required this.email,
  });

  int id;
  String details;
  String mobile;
  String site;
  String email;

  factory About.fromJson(Map<String, dynamic> json) => About(
    id: json["id"],
    details: json["details"],
    mobile: json["mobile"],
    site: json["site"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "details": details,
    "mobile": mobile,
    "site": site,
    "email": email,
  };
}

class Faqs {
  Faqs({
    required this.faqs,
  });

  List<Faq> faqs;

  factory Faqs.fromJson(Map<String, dynamic> json) => Faqs(
    faqs: List<Faq>.from(json["faqs"].map((x) => Faq.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "faqs": List<dynamic>.from(faqs.map((x) => x.toJson())),
  };
}

class Faq {
  Faq({
    required this.id,
    required this.question,
    required this.answer,
  });

  int id;
  String question;
  String answer;

  factory Faq.fromJson(Map<String, dynamic> json) => Faq(
    id: json["id"],
    question: json["question"],
    answer: json["answer"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "question": question,
    "answer": answer,
  };
}

class Guide {
  Guide({
    this.id,
    required this.title,
    required this.detail,
  });

  int? id;
  String title;
  String detail;

  factory Guide.fromJson(Map<String, dynamic> json) => Guide(
    id: json["id"],
    title: json["title"],
    detail: json["detail"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "detail": detail,
  };
}
