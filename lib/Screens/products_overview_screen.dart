import 'package:flutter/material.dart';
import 'package:my_shop/Screens/cart_screen.dart';
import 'package:my_shop/Screens/orders_screen.dart';
import 'package:my_shop/widgets/app_drawer.dart';
import '../widgets/badge.dart';
import '../widgets/products_grid.dart';
import 'package:provider/provider.dart';
import '../Providers/cart.dart';

enum FilterOptions { favorite, all }

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({super.key});

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: [
          Consumer<Cart>(
            builder: (_, cart, child) {
              return Badge(
                value: cart.totalItems.toString(),
                color: Theme.of(context).colorScheme.secondary,
                child: child!,
              );
            },
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.pushNamed(context, CartScreen.routeName);
              },
            ),
          ),
          PopupMenuButton(
            onSelected: (FilterOptions value) {
              setState(() {
                if (value == FilterOptions.favorite) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FilterOptions.favorite,
                child: Text('Only Favorites'),
              ),
              const PopupMenuItem(
                  value: FilterOptions.all, child: Text('Show All'))
            ],
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: ProductsGrid(showOnlyFavorites: _showOnlyFavorites),
    );
  }
}
