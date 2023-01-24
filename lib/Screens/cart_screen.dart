import 'package:flutter/material.dart';
import '../Providers/orders.dart';
import '../Providers/cart.dart'
    show
        Cart; //this will import only the Cart object and here cuz i only need it from this cfile
import '../widgets/cart_item.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  static const routeName = '/cart_screen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Your cart'),
        ),
        body: Column(
          children: [
            Card(
              margin: const EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Chip(
                        label:
                            Text('${cart.totalAmount.toStringAsFixed(2)} \$')),
                    const SizedBox(
                      width: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Chip(
                        label: Text(
                          '#Items: ${cart.totalItems}',
                        ),
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                        onPressed: () {
                          if (cart.items.isNotEmpty) {
                            Provider.of<Orders>(context, listen: false)
                                .addOrder(cart.items.values.toList(),
                                    cart.totalAmount);
                            cart.clearCart();
                          }
                        },
                        child: Text(
                          'Order Now',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 16),
                        ))
                  ],
                ),
              ),
            ),
            Expanded(
                child: ListView.builder(
              itemBuilder: (context, index) {
                return CartItem(
                  productIdTeacher: cart.items.keys.toList()[index],
                  productId: cart.items.values.toList()[index].productId,
                  id: cart.items.values.toList()[index].id,
                  price: cart.items.values.toList()[index].price,
                  quantity: cart.items.values.toList()[index].quantity,
                  title: cart.items.values.toList()[index].title,
                );
              },
              itemCount: cart.items.length,
            ))
          ],
        ));
  }
}
