import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../cart_model.dart';
import 'product_page.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart Page'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.cart.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(cart.cart[index].name),
                  subtitle: Text('\$${cart.cart[index].price} x ${cart.cart[index].quantity}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Total: \$${cart.cart[index].price * cart.cart[index].quantity}'),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Confirm Deletion'),
                                content: Text('Are you sure you want to remove ${cart.cart[index].name} from the cart?'),
                                actions: [
                                  TextButton(
                                    child: Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text('Confirm'),
                                    onPressed: () {
                                      cart.removeFromCart(cart.cart[index]);
                                      Navigator.of(context).pop();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('${cart.cart[index].name} has been removed from the cart'),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total Price: \$${cart.getTotalPrice().toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
