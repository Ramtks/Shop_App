import 'package:flutter/material.dart';
import 'package:my_shop/Screens/cart_screen.dart';
import 'package:my_shop/widgets/app_drawer.dart';
import '../widgets/badge.dart';
import '../widgets/products_grid.dart';
import 'package:provider/provider.dart';
import '../Providers/cart.dart';
import '../Providers/products.dart';

enum FilterOptions { favorite, all }

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({super.key});

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showOnlyFavorites = false;
  bool _isInIt = true;
  bool _isLoading = false;
  @override
  void didChangeDependencies() {
    //will run multiple times so thats why we need a bool helper
    //this runs after the widget is fully initialized but before the build run
    if (_isInIt) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInIt = false;
    super.didChangeDependencies();
  }

  // void initState() {//will run one time when the widget is created
  //   //this provide of context only work in init state if we set the listen to false
  //   // Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  //   Future.delayed(Duration.zero).then((_) {
  //     // this will run after the widget run cuz it is called as delayed even if the duration is zero
  //     Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  //   });
  //   super.initState();
  // }

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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(showOnlyFavorites: _showOnlyFavorites),
    );
  }
}
