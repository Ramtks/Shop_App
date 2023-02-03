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
    final scaffold = ScaffoldMessenger.of(context);
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
                  onPressed: () async {
                    try {
                      await Provider.of<Products>(context,
                              listen:
                                  false) // here the await so we can see if it will throw an error then we will catch if we dont use await the catch will not run not catching anything cuz the error is not there yet
                          .deleteProduct(id);
                    } catch (error) {
                      scaffold.showSnackBar(
                          //here using a context will throw an error cuz future works like that and here flutter will be updating the widget tree and wont be sure if the context is the same as the context we it refers before
                          const SnackBar(content: Text('Deleting failed!')));
                    }
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
