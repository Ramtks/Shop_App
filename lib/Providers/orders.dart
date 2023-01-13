import 'package:flutter/material.dart';
import 'package:my_shop/Providers/cart.dart';

class OrderItem with ChangeNotifier {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime orderTime;
  OrderItem(
      {required this.id,
      required this.products,
      required this.orderTime,
      required this.amount});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  List<OrderItem> get orders {
    return [..._orders];
  }

  void addOrder(List<CartItem> cartProducts, double total) {
    _orders.insert(
        0,
        OrderItem(
            id: DateTime.now().toString(),
            products: cartProducts,
            orderTime: DateTime.now(),
            amount: total));
    notifyListeners();
  }
}
