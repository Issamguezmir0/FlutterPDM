class User {
  String? id;
  String fullName;
  String address;
  String email;
  String cin;
  String phoneNumber;
  String age;
  bool isBanned;

  String? imageFilename;

  User({
    this.id,
    required this.fullName,
    required this.address,
    required this.email,
    required this.cin,
    required this.phoneNumber,
    required this.age,
    this.isBanned = false,
    this.imageFilename,
  });

  User.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        fullName = json["fullname"] ?? "",
        address = json["adresse"] ?? "",
        email = json["email"] ?? "",
        cin = json["cin"] ?? "",
        phoneNumber = json["num_tel"] ?? "",
        age = json["age"] ?? "",
        isBanned = json["isBanned"] == "true",
        imageFilename = json["img"] ?? "";

  Map<String, dynamic> toJson({String? password}) {
    return {
      "_id": id,
      "fullname": fullName,
      "adresse": address,
      "email": email.toLowerCase().replaceAll(" ", ""),
      "password": password?.toLowerCase().replaceAll(" ", ""),
      "cin": cin,
      "num_tel": phoneNumber,
      "age": age,
      "isBanned": isBanned,
      "img": imageFilename,
    };
  }
}
