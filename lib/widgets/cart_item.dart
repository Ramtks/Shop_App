import 'package:flutter/material.dart';
import 'package:my_shop/Providers/cart.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final String productId;
  final String productIdTeacher;
  final String id;
  final String title;
  final double price;
  final int quantity;
  const CartItem(
      {super.key,
      required this.id,
      required this.title,
      required this.price,
      required this.quantity,
      required this.productId,
      required this.productIdTeacher});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    return Dismissible(
      confirmDismiss: (direction) {
        return showDialog(
          //confirmdismiss need a future bool value and show dilog return a future
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Are you sure?'),
            content:
                const Text('Do you want to remove this item from the cart?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  },
                  child: const Text('Yes')),
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },
                  child: const Text('No'))
            ],
          ),
        );
      },
      onDismissed: (direction) {
        cart.removeItem(productIdTeacher);
      },
      direction: DismissDirection.endToStart,
      key: UniqueKey(),
      background: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [
              Color.fromARGB(255, 231, 147, 141),
              Color.fromARGB(255, 247, 28, 13)
            ])),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: IconButton(
            onPressed: (() {}),
            icon: const Icon(
              Icons.delete,
              color: Colors.white,
              size: 40,
            )),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            contentPadding: const EdgeInsets.all(0),
            leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                radius: 25,
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: FittedBox(
                      child: Text(
                    "$price \$",
                    style: const TextStyle(color: Colors.white),
                  )),
                )),
            title: Text(title),
            subtitle: Text('Total: ${(quantity * price).toStringAsFixed(2)}'),
            trailing: SizedBox(
                height: 60,
                width: 120,
                child: FittedBox(
                  child: Row(children: [
                    IconButton(
                      onPressed: () {
                        cart.addCartItem(productId, '${title}ajmi', price);
                      },
                      icon: const Icon(Icons.add),
                      iconSize: 20,
                    ),
                    Text('$quantity X'),
                    IconButton(
                        onPressed: () {
                          cart.removeCartItem(productId);
                        },
                        icon: const Icon(Icons.remove),
                        iconSize: 20)
                  ]),
                )),
          ),
        ),
      ),
    );
  }
}
