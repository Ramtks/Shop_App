import 'package:flutter/material.dart';
import 'package:my_shop/Providers/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  final String userId;
  final String authToken;
  Orders(this.authToken, this._orders, this.userId);

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(
        'https://shopproject00-default-rtdb.europe-west1.firebasedatabase.app/orders/$userId.json?auth=$authToken');
    try {
      final response = await http.get(url);
      final List<OrderItem> loadedOrders = [];
      final extractedOrders =
          json.decode(response.body) as Map<String, dynamic>?;
      if (extractedOrders == null) {
        _orders = [];
        return;
      }
      extractedOrders.forEach((orderId, orderData) {
        loadedOrders.add(OrderItem(
            id: orderId,
            products: (orderData['products'] as List<dynamic>)
                .map((item) => CartItem(
                    id: item['id'],
                    price: item['price'],
                    productId: item['productId'],
                    quantity: item['quantity'],
                    title: item['title']))
                .toList(),
            orderTime: DateTime.parse(orderData['orderTime']),
            amount: orderData['amount']));
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (e) {
      //
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final timeStamp = DateTime
        .now(); //we r doing this cuz if we wait for a http request the datetime will be different bewteen the one on the serever and the one we use locally and it should be the same
    final url = Uri.parse(
        'https://shopproject00-default-rtdb.europe-west1.firebasedatabase.app/orders/$userId.json?auth=$authToken');
    try {
      final response = await http.post(url,
          body: json.encode({
            'amount': total,
            'orderTime': timeStamp
                .toIso8601String(), // this form toIso8601String usefull if we need to parse the string to datetime again
            'products': cartProducts
                .map((cp) => {
                      'id': cp.id,
                      'title': cp.title,
                      'quantity': cp.quantity,
                      'price': cp.price,
                      'productId': cp.productId,
                    })
                .toList()
          }));
      _orders.insert(
          0,
          OrderItem(
              id: json.decode(response.body)['name'],
              products: cartProducts,
              orderTime: timeStamp,
              amount: total));
      notifyListeners();
    } catch (e) {
      //
    }
  }
}
