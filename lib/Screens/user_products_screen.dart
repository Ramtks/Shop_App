import 'package:flutter/material.dart';
import 'package:my_shop/widgets/app_drawer.dart';
import 'package:my_shop/widgets/user_product_item.dart';
import 'package:provider/provider.dart';
import '../Providers/products.dart';
import '../Screens/edit_product_screen.dart';

class UserProductsScreen extends StatefulWidget {
  const UserProductsScreen({super.key});
  static const routeName = '/user-products-screen';

  @override
  State<UserProductsScreen> createState() => _UserProductsScreenState();
}

class _UserProductsScreenState extends State<UserProductsScreen> {
  Future<void> _refreshProducts(BuildContext context) async {
    //we need to pass the context here cuz in a stateless widget it is not availble everywhere not like state class
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  // bool _isLoading = true;
  // @override
  // void initState() {
  //   Provider.of<Products>(context, listen: false)
  //       .fetchAndSetProducts(true)
  //       .then((_) {
  //     setState(() {
  //       _isLoading = false;
  //     });
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);
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
      body: FutureBuilder(
          future: _refreshProducts(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.error != null) {
              return const Center(
                child: Text('Fetching your Products failed!'),
              );
            } else {
              return RefreshIndicator(
                onRefresh: () => _refreshProducts(context)
                // { //this works too
                //   return Provider.of<Products>(context, listen: false)
                //       .fetchAndSetProducts();
                // },
                ,
                child: Consumer<Products>(
                  builder: (context, productsData, child) => ListView.builder(
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
          }),
    );
  }
}
