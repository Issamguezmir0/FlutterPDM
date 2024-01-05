class Event {
  String? id;
  String? title;
  String? image;
  String? organisateur;
  String? description;
  String? date;
  String? location;
  dynamic isFree;
  String? price;
  String? details;
  bool isBanned;

  Event({
    this.id,
    this.title,
    this.image,
    this.description,
    this.organisateur,
    this.date,
    this.location,
    this.isFree,
    this.price,
    this.details,
    this.isBanned = false,
  });

  Event.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        title = json["title"] ?? "",
        image = json["image"] ?? "",
        organisateur = json['organisateur'] ?? "",
        description = json["description"] ?? "",
        date = json["date"] ?? "",
        location = json["location"] ?? "",
        isFree = json["isFree"] ?? "",
        price = json["price"],
        details = json["details"] ?? "",
        isBanned = json['isBanned'] ?? false;
}
