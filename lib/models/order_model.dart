class Order {
  Order(
      {this.id,
      this.brand,
      this.name,
      this.price,
      this.priceSign,
      this.currency,
      this.imageLink,
      this.productLink,
      this.websiteLink,
      this.description,
      this.rating,
      this.category,
      this.productType,
      this.tagList,
      this.createdAt,
      this.updatedAt,
      this.productApiUrl,
      this.apiFeaturedImage,
      this.productColors,
      this.type,
      this.house,
      this.cname,
      this.city,
      this.pincode,
      this.phone,
      this.road});

  int id;
  String brand;
  String name;
  String price;
  String priceSign;
  String currency;
  String imageLink;
  String productLink;
  String websiteLink;
  String description;
  dynamic rating;
  String category;
  String productType;
  List<String> tagList;
  DateTime createdAt;
  DateTime updatedAt;
  String productApiUrl;
  String apiFeaturedImage;
  List<ProductColor> productColors;
  String type;
  String cname;
  String city;
  String pincode;
  String road;
  String phone;
  String house;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
      id: json["id"],
      brand: json["brand"],
      name: json["name"],
      cname: json["cname"],
      price: json["price"],
      priceSign: json["price_sign"],
      currency: json["currency"],
      imageLink: json["image_link"],
      productLink: json["product_link"],
      websiteLink: json["website_link"],
      description: json["description"],
      rating: json["rating"],
      category: json["category"],
      productType: json["product_type"],
      tagList: List<String>.from(json["tag_list"].map((x) => x)),
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      productApiUrl: json["product_api_url"],
      apiFeaturedImage: json["api_featured_image"],
      productColors: List<ProductColor>.from(
          json["product_colors"].map((x) => ProductColor.fromJson(x))),
      type: json['type'],
      house: json['house'],
      city: json['city'],
      pincode: json['pincode'],
      phone: json['phone'],
      road: json['road']);

  Map<String, dynamic> toJson() => {
        "id": id,
        "brand": brand,
        "name": name,
        "cname": cname,
        "price": price,
        "price_sign": priceSign,
        "currency": currency,
        "image_link": imageLink,
        "product_link": productLink,
        "website_link": websiteLink,
        "description": description,
        "rating": rating,
        "category": category,
        "product_type": productType,
        "tag_list": List<dynamic>.from(tagList.map((x) => x)),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "product_api_url": productApiUrl,
        "api_featured_image": apiFeaturedImage,
        "product_colors":
            List<dynamic>.from(productColors.map((x) => x.toJson())),
        "type": type,
        "house": house,
        "city": city,
        "pincode": pincode,
        "road": road,
        "phone": phone
      };
}

class ProductColor {
  ProductColor({
    this.hexValue,
    this.colourName,
  });

  String hexValue;
  String colourName;

  factory ProductColor.fromJson(Map<String, dynamic> json) => ProductColor(
        hexValue: json["hex_value"],
        colourName: json["colour_name"],
      );

  Map<String, dynamic> toJson() => {
        "hex_value": hexValue,
        "colour_name": colourName,
      };
}