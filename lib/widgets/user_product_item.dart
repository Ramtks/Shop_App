import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/products.dart';
import '../Screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  const UserProductItem(
      {super.key,
      required this.title,
      required this.imageUrl,
      required this.id});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        title: Text(title),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        trailing: SizedBox(
          width: 100,
          height: 30,
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, EditProductScreen.routeName,
                        arguments: id);
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(context).colorScheme.primary,
                  )),
              IconButton(
                  onPressed: () {
                    Provider.of<Products>(context, listen: false)
                        .deleteProduct(id);
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).errorColor,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
