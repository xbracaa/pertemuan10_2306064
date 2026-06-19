import 'package:flutter/material.dart';
import 'package:pertemuan10_2306064/models/product_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pertemuan10_2306064/pages/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username = '';

  // var utama untuk data
  List<ProductModel> products = [];

  @override
  void initState() {
    super.initState();
    getUser();
    loadProducts();
  }

  // membuat method loadproducts untuk menampilkan daftar product
  Future<void> loadProducts() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> productList = prefs.getStringList('products') ?? [];
    setState(() {
      products = productList
          .map((item) => ProductModel.fromJson(item)) 
          .toList();
    });
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
    ).showSnackBar(SnackBar(content: Text("Produk berhasil dihapus"),));
  }

  // showform
  void showform({ProductModel? product, int? index}) {
    final _formKey = GlobalKey<FormState>();
    TextEditingController nameController = TextEditingController(
      text: product?.name ?? "",
    );
    TextEditingController descriptionController = TextEditingController(
      text: product?.description ?? "",
    );
    TextEditingController priceController = TextEditingController(
      text: product?.price.toString() ?? "",
    );

    showDialog(
      context: context, 
      builder: (_) => AlertDialog(
        title: Text(product == null ? "Tambah Produk" : "Edit Produk"),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Nama"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Nama tidak boleh kosong";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: "Deskripsi"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Deskripsi tidak boleh kosong";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: priceController,
                decoration: InputDecoration(labelText: "Harga"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Harga tidak boleh kosong";
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      actions: [
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final newProduct = ProductModel(
              name: nameController.text, 
              description: descriptionController.text, 
              price: int.parse(priceController.text)
              );

              if (product == null) {
                addProduct(newProduct);
              } else {
                updateProduct(index!, newProduct);
              }
              Navigator.pop(context);
            }
          }, 
          child: Text(product == null ? "Simpan" : "Perbarui")
        )
      ],
      ),
    );
  }

  Future<void> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? '';
    }); 
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(0, 255, 255, 255),

      body: SafeArea(
        child: Padding(
          padding: const .all(20),
          child: Column(
            children: [
              Container(
                height: 150,
                padding: const .symmetric(horizontal: 15, vertical: 12),
                decoration: BoxDecoration(
                  color:  Colors.white,
                  borderRadius: .circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundImage: NetworkImage(
                        "https://picsum.photos/id/14/200/300"
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Text(
                            "Hai, Selamat Datang!",
                            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              Text(
                                username,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.verified,
                                color: Colors.green,
                                size: 20,
                              )
                            ],
                          ),
                        ],
                      )
                    ),
                    GestureDetector(
                      onTap: logout,
                      child: Container(
                          padding: const .all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: .circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.logout,
                            size: 20,
                            color: Colors.red,
                          ),
                        )
                    ),
                  ],
                ),
              ),
              Expanded(
            child: products.isEmpty 
            ? Center(child: Text("Belum ada produk"))  
            : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index){
                final product = products[index];

                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: .circular(15),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(15),
                    title: Text(
                      product.name,
                      style: TextStyle(
                        fontWeight: .bold
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
                    leading: IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Colors.orange,
                    ),
                    onPressed: () => showform(product: products[index], index: index),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () => deleteProduct(index),
                      ),
                  ),
                  
                );
              },
            ),
          ),
         ],
        ), 
        )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showform,
        child: Icon(Icons.add),
        ),
    );
  }
}