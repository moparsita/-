
class UserModel {
  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.mobile,
    required this.website,
    required this.consumerKey,
    required this.consumerSecret,
    required this.avatar,

  });

  final int id;
  final String firstName;
  final String lastName;
  final String fullName;
  final String mobile;
  final String website;
  final String consumerKey;
  final String consumerSecret;
  String avatar;


  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],

        fullName: json["fullName"],
        mobile: json["mobile"],
        website: json["website"],
        consumerKey: json["consumerKey"],
        consumerSecret: json["consumerSecret"],
        avatar: json["avatar"],

      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,

        "fullName": fullName,
        "mobile": mobile,
        "website": website,
        "consumerKey": consumerKey,
        "consumerSecret": consumerSecret,
        "avatar": avatar,

      };
}
