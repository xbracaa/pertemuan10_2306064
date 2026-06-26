import 'package:flutter/material.dart';
import 'package:pertemuan10_2306064/models/product_model.dart';
import 'dart:convert';

class ProductDetailPage extends StatelessWidget {
  // membuat var untuk menampilkan data produk
  // yag dipilih
  final ProductModel product;

  // constructor
  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Produk"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              product.image.isNotEmpty
                ? Image.memory(
                    base64Decode(product.image),
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                  ) // Image.memory
                : const Icon(Icons.image, size: 250),
              const SizedBox(height: 20),
              Text(product.name, style: TextStyle(
                fontSize: 24,
                fontWeight: .bold
                ),
              ),
              SizedBox(height: 10),
              Text("Rp ${product.price}"),
              SizedBox(height: 10,),
              Text(product.description)
            ],
          ),
        ),
    );
  }
}