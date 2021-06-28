class Address {
  Address({
    this.cname,
    this.house,
    this.city,
    this.pincode,
    this.road,
    this.phone,
  });

  String cname;
  String house;
  String city;
  String pincode;
  String road;
  String phone;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        cname: json["cname"],
        house: json["house"],
        city: json["city"],
        pincode: json["pincode"],
        road: json["road"],
        phone: json["phone"],
      );

  Map<String, dynamic> toJson() => {
        "cname": cname,
        "house": house,
        "city": city,
        "pincode": pincode,
        "road": road,
        "phone": phone,
      };
}
