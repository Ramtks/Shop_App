import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Providers/products.dart';
import 'dart:math';

class ProductDetailScreen extends StatefulWidget {
  static const routeName = '/product-detail-screen';
  const ProductDetailScreen({super.key});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late ScrollController _scrollController;
  @override
  void initState() {
    _scrollController = ScrollController()
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  bool get _isSliverAppBarExpanded {
    return _scrollController.hasClients &&
        _scrollController.offset > 300 - kToolbarHeight;
  }

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loadedProduct.title),
      // ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            iconTheme: IconThemeData(color: Colors.black, shadows: [
              Shadow(
                  color: Colors.black38,
                  blurRadius: 10,
                  offset: Offset.fromDirection(1))
            ]),
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: _isSliverAppBarExpanded
                  ? Text(loadedProduct.title)
                  : Container(
                      margin:
                          const EdgeInsets.only(left: 10, top: 10, bottom: 10),
                      padding: const EdgeInsets.all(5),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Colors.black38,
                          border: Border.all(color: Colors.transparent),
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              topLeft: Radius.circular(10))),
                      child: Text(
                        loadedProduct.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15),
                      )),
              background: Hero(
                tag: loadedProduct.id,
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            // Container(
            //   decoration:
            //       BoxDecoration(borderRadius: BorderRadius.circular(10)),
            //   height: 300,
            //   width: double.infinity,
            //   child: ClipRRect(
            //     borderRadius: const BorderRadius.only(
            //         bottomLeft: Radius.circular(10),
            //         bottomRight: Radius.circular(10)),
            //     child:
            //   ),
            // ),
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
            const SizedBox(
              height: 600,
            )
          ]))
        ],
      ),
    );
  }
}
