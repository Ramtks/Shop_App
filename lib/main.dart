import 'package:flutter/material.dart';
import 'package:my_shop/Screens/edit_product_screen.dart';
import 'package:provider/provider.dart';
import '../Screens/orders_screen.dart';
import '../Screens/user_products_screen.dart';
import '../Providers/cart.dart';
import '../Providers/orders.dart';
import '../Screens/cart_screen.dart';
import './Screens/product_detail_screen.dart';
import './Screens/products_overview_screen.dart';
import './Providers/products.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => Orders())),
        ChangeNotifierProvider(
          //flutter autoatically cleans widget from memory if u goes to a new page like a push and replcament and also here the data we are providing is also cleaned by the changenotifierprovider automatically
          //here we are creating a new instance of an object to provide it and it is better to use the create way for more efficient
          create: (context) => Products(),
        ),
        ChangeNotifierProvider(create: ((context) => Cart())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          EditProductScreen.routeName: (context) => const EditProductScreen(),
          UserProductsScreen.routeName: (context) => const UserProductsScreen(),
          OrdersScreen.routeName: (context) => const OrdersScreen(),
          CartScreen.routeName: (context) => const CartScreen(),
          ProductDetailScreen.routeName: (context) =>
              const ProductDetailScreen()
        },
        title: 'MyShop',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blueGrey)
                .copyWith(secondary: Colors.lightGreen),
            fontFamily: 'Lato'),
        home: const ProductOverviewScreen(),
      ),
    );
  }
}
