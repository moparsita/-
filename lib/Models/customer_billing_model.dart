import 'package:red_leaf/Plugins/get/get.dart';

class customerBillingModel {
  customerBillingModel({
    required this.first_name,
    required this.last_name,
    required this.country,
    required this.state,
    required this.city,
    required this.postcode,
    required this.address_1,
    required this.address_2,
    required this.email,
    required this.phone,
  });

  final String first_name;
  final String last_name;
  final String country;
  final String state;
  final String city;
  final String postcode;
  final String address_1;
  final String address_2;
  final String email;
  final String phone;



  factory customerBillingModel.fromJson(Map<String, dynamic> json) => customerBillingModel(
        first_name: json["first_name"],
        last_name: json["last_name"],
        country: json["country"],
        state: json["state"],
        city: json["city"],
        postcode: json["postcode"],
        address_1: json["address_1"],
        address_2: json["address_2"],
        email: json["email"],
        phone: json["phone"],


      );

  Map<String, dynamic> toMap() => {
        "first_name": first_name,
        "last_name": last_name,
        "country": country,
        "state": state,
        "city": city,
        "postcode": postcode,
        "address_1": address_1,
        "address_2": address_2,
        "email": email,
        "phone": phone,

      };

  static List<customerBillingModel> listFromJson(List data) {
    return data.map((e) => customerBillingModel.fromJson(e)).toList();
  }
}
