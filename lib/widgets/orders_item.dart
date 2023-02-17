import 'dart:math';
import 'package:flutter/material.dart';
import '../Providers/orders.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class OrderItemsbuilder extends StatefulWidget {
  const OrderItemsbuilder({super.key});

  @override
  State<OrderItemsbuilder> createState() => _OrderItemsbuilderState();
}

class _OrderItemsbuilderState extends State<OrderItemsbuilder> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    final ordersitem = Provider.of<OrderItem>(context);
    return AnimatedContainer(
      curve: Curves.easeIn,
      height:
          _expanded ? min(ordersitem.products.length * 20.0 + 145, 200) : 100,
      duration: const Duration(milliseconds: 250),
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text('${ordersitem.amount.toStringAsFixed(2)} \$'),
              subtitle: Text(DateFormat('dd/MM/yyyy hh:mm a')
                  .format(ordersitem.orderTime)),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              curve: Curves.easeIn,
              duration: const Duration(milliseconds: 250),
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    Color.fromARGB(137, 255, 255, 255),
                    Colors.white
                  ])),
              height: _expanded
                  ? min(ordersitem.products.length * 20.0 + 40, 180)
                  : 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: ordersitem.products
                      .map((e) => Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  e.title,
                                  style: const TextStyle(
                                      fontSize: 17, fontFamily: 'Lato'),
                                ),
                                Text(
                                  '${e.quantity} x ${e.price}\$',
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                )
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
