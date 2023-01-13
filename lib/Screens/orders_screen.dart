import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../Providers/orders.dart';
import 'package:provider/provider.dart';
import '../widgets/orders_item.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});
  static const routeName = '/orders-screen';

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: const AppDrawer(),
      body: ordersData.orders.isEmpty
          ? const Center(
              child: Text(
              'No orders yet',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ))
          : ListView.builder(
              itemBuilder: ((context, index) {
                return ChangeNotifierProvider.value(
                  value: ordersData.orders[index],
                  child: OrderItemsbuilder(
                    key: ValueKey(ordersData.orders[index].id),
                  ),
                );
              }),
              itemCount: ordersData.orders.length),
    );
  }
}
