import 'package:flutter/material.dart';
import 'package:my_shop/Screens/edit_product_screen.dart';
import 'package:my_shop/helpers/custom_route.dart';
import 'package:provider/provider.dart';
import '../Screens/orders_screen.dart';
import '../Screens/user_products_screen.dart';
import '../Providers/cart.dart';
import '../Providers/orders.dart';
import '../Screens/cart_screen.dart';
import './Screens/product_detail_screen.dart';
import './Screens/products_overview_screen.dart';
import './Providers/products.dart';
import 'Screens/auth_screen.dart';
import 'Providers/auth.dart';
import 'Screens/splash_screen.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => Auth())),
        ChangeNotifierProxyProvider<Auth, Products>(
          //flutter automatically cleans widget from memory if u goes to a new page like a push and replcament and also here the data we are providing is also cleaned by the changenotifierprovider automatically
          //here we are creating a new instance of an object to provide it and it is better to use the create way for more efficient
          update: ((context, auth, previous) => Products(
              auth.token,
              previous == null ? [] : previous.items,
              auth.userId)), //here we r getting the auth data provided from above but with each update of the auth we will update the products and we dont want to lose the previous items we have so we get that by the previous products class before updating
          create: (context) => Products('', [], ''),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: ((context, auth, previous) => Orders(auth.token,
              previous == null ? [] : previous.orders, auth.userId)),
          create: (context) => Orders('', [], ''),
        ),
        ChangeNotifierProvider(create: ((context) => Cart())),
      ],
      child: Consumer<Auth>(
          builder: ((context, value, _) => MaterialApp(
                debugShowCheckedModeBanner: false,
                routes: {
                  AuthScreen.routeName: (context) => const AuthScreen(),
                  EditProductScreen.routeName: (context) =>
                      const EditProductScreen(),
                  UserProductsScreen.routeName: (context) =>
                      const UserProductsScreen(),
                  OrdersScreen.routeName: (context) => const OrdersScreen(),
                  CartScreen.routeName: (context) => const CartScreen(),
                  ProductDetailScreen.routeName: (context) =>
                      const ProductDetailScreen()
                },
                title: 'MyShop',
                theme: ThemeData(
                    pageTransitionsTheme: PageTransitionsTheme(builders: {
                      //here we make custom transitions
                      TargetPlatform.android: CustompageTransitionsBuilder(),
                      TargetPlatform.iOS: CustompageTransitionsBuilder()
                    }),
                    colorScheme:
                        ColorScheme.fromSwatch(primarySwatch: Colors.blueGrey)
                            .copyWith(secondary: Colors.lightGreen),
                    fontFamily: 'Lato'),
                home: value.isAuth
                    ? const ProductOverviewScreen()
                    : FutureBuilder(
                        future: value
                            .tryAutoLogin(), //here we are not checking the boolean value cuz tryoutlogin will notify listeners so the value.isauth will run again with the new user data if it was there
                        builder: (ctx, authResulstSnapshot) =>
                            authResulstSnapshot.connectionState ==
                                    ConnectionState.waiting
                                ? const SplashScreen()
                                : const AuthScreen()),
              ))),
    );
  }
}
