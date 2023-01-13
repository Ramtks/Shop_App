import 'package:flutter/material.dart';
import 'package:my_shop/Screens/product_detail_screen.dart';
import 'package:provider/provider.dart';
import '../Providers/cart.dart';
import '../Providers/product.dart';

class ProductItem extends StatelessWidget {
  // final Key myKey;
  const ProductItem({
    super.key,
  });

  // final String id;
  // final String title;
  // final String imageUrl;

  // const ProductItem(
  //     {super.key,
  //     required this.id,
  //     required this.imageUrl,
  //     required this.title});

  @override
  Widget build(BuildContext context) {
    final currentProduct = Provider.of<Product>(context, listen: false);
    //here we want the provided data for the title and picture once and dont want to rebuild the widget everytime the data change cuz for the image and title it wont
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
          footer: GridTileBar(
              trailing: IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  // products.deleteItemById(currentProduct.id);
                  cart.addCartItem(currentProduct.id, currentProduct.title,
                      currentProduct.price);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(
                          context) // of context reach to the nearest object of that type which here is scaffold
                      .showSnackBar(SnackBar(
                    content: const Text('Added!'),
                    duration: const Duration(seconds: 1, milliseconds: 500),
                    action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {
                          cart.removeCartItem(currentProduct.id);
                        }),
                  ));
                  // Scaffold.of(context).openDrawer();
                },
                color: Colors.white,
              ),
              title: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  currentProduct.title,
                  textAlign: TextAlign.center,
                ),
              ),
              backgroundColor: Colors.black54,
              leading: Consumer<Product>(
                //child: ,
                //here we can add a child as an argument and it wont rebuild with the provided value changes but we can use it in builder function
                //but here for the favorite we want it to build this part of the widget everytime cuz the button icon changes with each value and consumer listens by default
                builder: (context, product, _) => IconButton(
                    onPressed: () {
                      product.toggleFavorite();
                    },
                    icon: Icon(product.isFavorite
                        ? Icons.favorite
                        : Icons.favorite_outline),
                    color: Colors.white),
              )),
          child: GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(
                ProductDetailScreen.routeName,
                arguments: currentProduct.id),
            child: Image.network(
              currentProduct.imageUrl,
              fit: BoxFit.cover,
            ),
          )),
    );
  }
}
