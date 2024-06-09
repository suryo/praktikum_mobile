import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../cart_model.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late Future<List<Product>> futureProducts;

  @override
  void initState() {
    super.initState();
    futureProducts = fetchProducts();
  }

  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('http://zonainformatika.com/api/testproduct'));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Page'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<List<Product>>(
        future: futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load products'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products available'));
          } else {
            final products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ProductListItem(product: products[index]);
              },
            );
          }
        },
      ),
    );
  }
}

class Product {
  final int id;
  final String name;
  final String desc;
  final int price;
  final String imageUrl;
  int quantity;

  Product({
    required this.id,
    required this.name,
    required this.desc,
    required this.price,
    required this.imageUrl,
    this.quantity = 0,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      desc: json['desc'],
      price: int.parse(json['price']),
      imageUrl: json['image_url'],
    );
  }
}

class ProductListItem extends StatelessWidget {
  final Product product;

  ProductListItem({required this.product});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context);

    return ListTile(
      title: Text(product.name),
      subtitle: Text('\$${product.price}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: () {
              cart.remove(product);
            },
          ),
          Text(product.quantity.toString()),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              cart.addToCart(product);
            },
          ),
          ElevatedButton(
            onPressed: () {
              cart.addToCart(product);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${product.name} added to cart!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: Text('Add to Cart'),
          ),
        ],
      ),
    );
  }
}
