import 'package:flutter/material.dart';
import 'package:pertemuan10_2306064/models/product_model.dart';
import 'package:pertemuan10_2306064/pages/product_detail_page.dart';
import 'dart:convert';


class ProductCard extends StatelessWidget {
  //  variabel parameter
  final ProductModel product;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  // constructor
  const ProductCard({
    super.key,
    required this.product,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: .circular(15)),
      child: ListTile(
        contentPadding: EdgeInsets.all(15),
        title: Text(product.name, style: TextStyle(fontWeight: .bold)),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailPage(product: product),
          ),
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            product.image.isNotEmpty
              ? Image.memory(
                  base64Decode(product.image),
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                )
              : const Icon(Icons.image, size: 120),
            const SizedBox(height: 5),
            Text("Rp ${product.price}"),
            const SizedBox(height: 5),
            Text(product.description),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onEdit != null)
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.green),
                onPressed: () => onEdit!(),
              ),
            const SizedBox(width: 10),
            if (onDelete != null)
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => onDelete!(),
              ),
          ],
        ),
      ),
    );
  }
}