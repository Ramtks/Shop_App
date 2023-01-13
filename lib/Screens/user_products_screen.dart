import 'package:flutter/material.dart';
import 'package:my_shop/widgets/app_drawer.dart';
import 'package:my_shop/widgets/user_product_item.dart';
import 'package:provider/provider.dart';
import '../Providers/products.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({super.key});
  static const routeName = '/user-products-screen';

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Your produtcs'),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.add))],
      ),
      body: ListView.builder(
        itemBuilder: (_, i) {
          return Column(
            children: [
              UserProductItem(
                  title: productsData.items[i].title,
                  imageUrl: productsData.items[i].imageUrl),
              const Divider(
                thickness: 1,
              )
            ],
          );
        },
        itemCount: productsData.items.length,
      ),
    );
  }
}
