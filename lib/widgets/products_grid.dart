import 'package:flutter/material.dart';
import 'package:my_shop/Providers/product.dart';
import 'package:provider/provider.dart';
import '../Providers/products.dart';
import './product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showOnlyFavorites;
  const ProductsGrid({super.key, required this.showOnlyFavorites});

  @override
  Widget build(BuildContext context) {
    final productsq = Provider.of<Products>(context);
    final List<Product> products =
        showOnlyFavorites ? productsq.favoriteItems : productsq.items;
    products.removeWhere((element) => element.isDeleted);

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        //here using the value way is the right thing because with listview and gridview flutter recycle the previous made items and does not recreate it so the create way will make an issue cuz it wont keep up with the widget that is data is chanigng and is being rescycled
        //when ever we r using an exsiting object (here is the products list)  it is better to use the .value way
        value: products[index],
        child: ProductItem(
          key: ValueKey(
            products[index].id,
          ),
          // id: products[index].id,
          // imageUrl: products[index].imageUrl,
          // title: products[index].title
        ),
      ),
      itemCount: products.length,
    );
  }
}
