import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail-screen';
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              height: 300,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(50)),
              child: Text(
                softWrap: true,
                'price\n'
                '${loadedProduct.price}\$',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Color.fromARGB(255, 141, 141, 141), fontSize: 20),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(50)),
              child: Text(
                softWrap: true,
                'Description\n'
                '${loadedProduct.description}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Color.fromARGB(255, 141, 141, 141), fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
