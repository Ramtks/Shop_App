import 'package:flutter/material.dart';
import 'package:my_shop/widgets/app_drawer.dart';
import 'package:my_shop/widgets/user_product_item.dart';
import 'package:provider/provider.dart';
import '../Providers/products.dart';
import '../Screens/edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  const UserProductsScreen({super.key});
  Future<void> _refreshProducts(BuildContext context) async {
    //we need to pass the context here cuz in a stateless widget it is not availble everywhere not like state class
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  }

  static const routeName = '/user-products-screen';

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Your produtcs'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, EditProductScreen.routeName);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context)
        // { //this works
        //   return Provider.of<Products>(context, listen: false)
        //       .fetchAndSetProducts();
        // },
        ,
        child: ListView.builder(
          itemBuilder: (_, i) {
            return Column(
              children: [
                UserProductItem(
                    id: productsData.items[i].id,
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
      ),
    );
  }
}
