import 'package:flutter/material.dart';
import 'package:pertemuan10_2306064/models/product_model.dart';
import 'package:pertemuan10_2306064/pages/product_detail_page.dart';

class ProductCard extends StatelessWidget {
  // var untuk parameter
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
          crossAxisAlignment: .start,
          children: [
            SizedBox(height: 5),
            Text("Rp ${product.price}"),
            SizedBox(height: 5),
            Text(product.description),
          ],
        ),
        leading: onEdit != null ? IconButton(
          icon: Icon(Icons.edit, color: Colors.orange),
          onPressed: onEdit,
        )
        : null,
        trailing: onDelete != null ? IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        )
        : null,
      ),
    );
  }
}
