import 'dart:convert';

class ProductModel {
  final String name;
  final String description;
  final int price;

  //constructor
  ProductModel({
    required this.name,
    required this.description,
    required this.price,
  });

  //object -> map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
    };
  }

  // map -> onject
  factory ProductModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return ProductModel(
      name: map['name'] ?? '',
      description: map['description'],
      price: map['price']?.toInt() ?? 0,
    );
  }

  // object -> string
  String toJson() => json.encode(toMap());

  // string -> object
  factory ProductModel.fromJson(String source) {
    return ProductModel.fromMap(
      jsonDecode(source,)
    );
  }
  
}