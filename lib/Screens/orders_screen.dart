import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../Providers/orders.dart';
import 'package:provider/provider.dart';
import '../widgets/orders_item.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});
  static const routeName = '/orders-screen';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future? _ordersFuture;
  Future obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _ordersFuture =
        obtainOrdersFuture(); //this here will make sure we have only one future and doesnt load a new future though a new excuting of the future builder with fetching again (here it wont makes a diff but if we have multiple changing state variables it will be usefull for not building a new future with every widget rebuilding)
    super.initState();
  }

  // var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Orders'),
        ),
        drawer: const AppDrawer(),
        body: FutureBuilder(
            //elegant alternative for fetching orders and showing a loading spinner isntead of using a statefull widget (like in product overview screen)
            future: _ordersFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.error != null) {
                return const Center(
                  child: Text('Fetching your orders failed!'),
                );
              } else {
                return ordersData.orders.isEmpty
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
                        itemCount: ordersData.orders.length);
              }
            }));
  }
}
