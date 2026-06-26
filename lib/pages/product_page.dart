import 'package:flutter/material.dart';
import 'package:pertemuan10_2306064/models/product_model.dart';
import 'package:pertemuan10_2306064/widgets/product_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:typed_data';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  // variabel utama
  List<ProductModel> products = [];
  // membuat method loadproducts untuk menampilkan daftar product
  Future<void> loadProducts() async {
    final res = await SharedPreferences.getInstance();
    List<String> productList = res.getStringList('products') ?? [];
    setState(() {
      products = productList
          .map((item) => ProductModel.fromJson(item))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  // methode saveprododuct untuk menyimpan product
  Future<void> saveProduct() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> productList = products.map((item) => item.toJson()).toList();
    await prefs.setStringList('products', productList);
  }

  // method addproduct untuk menambah product
  Future<void> addProduct(ProductModel product) async {
    setState(() {
      products.add(product);
    });
    await saveProduct();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Produk berhasil ditambahkan")),
    );
  }

  // method update
  Future<void> updateProduct(int index, ProductModel product) async {
    setState(() {
      products[index] = product;
    });
    await saveProduct();
  }

  // methode delete product
  Future<void> deleteProduct(int index) async {
    setState(() {
      products.removeAt(index);
    });
    await saveProduct();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Produk berhasil dihapus")));
  }

  // method utk gambar
  Future<String> convertImageToBase64(XFile image) async{
    Uint8List bytes = await image.readAsBytes();

    return base64Encode(bytes);
  }
  // showform
  void showform({ProductModel? product, int? index}) {
    TextEditingController nameController = TextEditingController(
      text: product?.name ?? "",
    );
    TextEditingController descriptionController = TextEditingController(
      text: product?.description ?? "",
    );
    TextEditingController priceController = TextEditingController(
      text: product?.price.toString() ?? "",
    );
    TextEditingController imgController = TextEditingController(
      text: product?.image.toString() ?? "",
    );

    XFile ?selectedImage;
    final ImagePicker picker = ImagePicker();

    //method ambil gambar dari galeri
    Future<void> pickImage(StateSetter setDialogState) async {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        String base64Image = await convertImageToBase64(image);
        setDialogState(() {
          selectedImage = image;
          imgController.text = base64Image;
        });
      }
    }

    Widget previewImage(){
      //  kondisi jika menambah produk
      if (selectedImage !=null){
        return FutureBuilder<Uint8List>(
          future: selectedImage!.readAsBytes(),
          builder: (context, snapshot) {
            //  loading
            if (!snapshot.hasData){
              return const CircularProgressIndicator();
            }
            return Image.memory(
              snapshot.data!,
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            );
          }
        );
      }
      //kondisi jika edit produk
      if (product?.image.isNotEmpty ?? false) {
        if (product!.image.startsWith('http') || product!.image.startsWith('blob:')) {
          return Image.network(
            product!.image,
            width: 120,
            height: 120,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 120),
          );
        } else {
          try {
            return Image.memory(
              base64Decode(product!.image),
              width: 120,
              height: 120,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 120),
            );
          } catch (e) {
            return const Icon(Icons.broken_image, size: 120);
          }
        }
      }

      return const SizedBox.shrink();
    }

    final formKey = GlobalKey<FormState>();
    
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, dialogSetState) => AlertDialog(
          title: Text(product == null ? "Tambah Produk" : "Edit Produk"),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: "Nama"),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Nama produk wajib diisi";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: "Deskripsi"),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Deskripsi wajib diisi";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: priceController,
                  decoration: InputDecoration(labelText: "Harga"),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Harga wajib diisi";
                    }
                    if (int.tryParse(value) == null) {
                      return "Harga harus berupa angka";
                    }
                    if (int.parse(value) <= 0) {
                      return "Harga harus lebih dari 0";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => pickImage(dialogSetState),
                  icon: const Icon(Icons.image),
                  label: const Text("Pilih Gambar"),
                ),
                const SizedBox(height: 20),
                previewImage(),
                const SizedBox(height: 20)
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                if (!formKey.currentState!.validate()) {
                  return;
                }
                String imageBase64 = product?.image ?? "";
                if (selectedImage != null) {
                  imageBase64 = await convertImageToBase64(
                    selectedImage!,
                  );
                }
                final newProduct = ProductModel(
                  name: nameController.text,
                  description: descriptionController.text,
                  price: int.parse(priceController.text),
                  image: imageBase64,
                );

                if (product == null) {
                  addProduct(newProduct);
                } else {
                  updateProduct(index!, newProduct);
                }
                Navigator.pop(context);
              },
              child: Text(product == null ? "Simpan" : "Update"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Produk",
          style: TextStyle(color: Colors.white, fontWeight: .bold),
        ),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: products.isEmpty
                  ? Center(child: Text("Belum ada produk"))
                  : ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductCard(
                          product: product,
                          onDelete: () => deleteProduct(index),
                          onEdit: () => 
                            showform(product: product, index: index),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showform,
        child: Icon(Icons.add),
      ),
    );
  }
}