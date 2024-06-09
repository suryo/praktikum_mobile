import 'package:flutter/material.dart';
import 'product_page.dart';

class CartModel extends ChangeNotifier {
  final List<Product> _cart = [];

  List<Product> get cart => _cart;

  void addToCart(Product product) {
    if (!_cart.contains(product)) {
      _cart.add(product);
    }
    product.quantity++;
    notifyListeners();
  }

  void remove(Product product) {
    if (product.quantity > 0) {
      product.quantity--;
      if (product.quantity == 0) {
        _cart.remove(product);
      }
      notifyListeners();
    }
  }

  void removeFromCart(Product product) {
    product.quantity = 0;
    _cart.remove(product);
    notifyListeners();
  }

  double getTotalPrice() {
    double total = 0.0;
    for (var product in _cart) {
      total += product.price * product.quantity;
    }
    return total;
  }
}
