import 'dart:convert';

class ProductModel {
  // membuat var data
  final String name;
  final String description; // kalo kondisi data tidak wajib, tipe data diisi jd string?
  final int price;

  // membuat constructor
  ProductModel({
    required this.name,
    required this.description,
    required this.price
  });

  // convert objek ke mmap 
  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'description': description,
      'price': price
    };
  }

  // convert map ke object
  factory ProductModel.fromMap(
    Map<String, dynamic> map,
  ) {
    return ProductModel(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: map['price'] ?? 0,
    );
  }

  // object ke json string
  String toJson() => jsonEncode(toMap());

  //  json string ke object
  factory ProductModel.fromJson(String source) {
    return ProductModel.fromMap(
      jsonDecode(source),
    );
  }
}