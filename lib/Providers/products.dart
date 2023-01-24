import 'package:flutter/material.dart';
import 'product.dart';
import 'package:http/http.dart'
    as http; //this is called bundling the package all in prefix
import 'dart:convert';

class Products with ChangeNotifier {
  // ignore: prefer_final_fields
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://i5.walmartimages.com/asr/b41bd905-f204-4666-8b42-140387381a0b.32043a79df9d2166b1ed7b576bda9e21.jpeg?odnHeight=580&odnWidth=580&odnBg=FFFFFF',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];
  // var _showFavoriteOnly = false;
  List<Product> get items {
    // if (_showFavoriteOnly) {
    //   return _items.where((element) => element.isFavorite).toList();
    // }
    return [
      ..._items
    ]; //this will give us a copy of that list cuz we dont want to access the _items list directly
  }

  // void showFavoriteOnly() {
  //   _showFavoriteOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoriteOnly = false;
  //   notifyListeners();
  // }

  Product findById(String productId) {
    return _items.firstWhere((element) => element.id == productId);
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  // void deleteItemById(String id) {
  //   _items.removeWhere((element) => element.id == id);
  //   notifyListeners();
  // }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://shopproject00-default-rtdb.europe-west1.firebasedatabase.app/products.json');
    // final url = Uri.https('flutter-update.firebaseio.com', '/products.json'); //alternative syntax
    try {
      final response = await http.post(url,
          body: json.encode({
            //json is a format for transmiting data to and from web servers and stands for javascript object notation
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'isfavorite': product.isFavorite
          }));
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          imageUrl: product.imageUrl,
          price: product.price);
      _items.add(newProduct);

      // _items.insert(0, newProduct);  //to add the product ib the start of the list
      notifyListeners();
    } finally {}
  }

  // Future<void> addProduct(Product product) {
  //   final url = Uri.parse(
  //       'https://shopproject00-default-rtdb.europe-west1.firebasedatabase.app/products.json');
  //   // final url = Uri.https('flutter-update.firebaseio.com', '/products.json'); //alternative syntax
  //   return http //difference between the async await way from this .then way that here the code after the .then (after .then() 'thiscode') will run but in the await it wont until the code in await finish
  //       .post(url,
  //           body: json.encode({
  //             //json is a format for transmiting data to and from web servers and stands for javascript object notation
  //             'title': product.title,
  //             'description': product.description,
  //             'imageUrl': product.imageUrl,
  //             'price': product.price,
  //             'isfavorite': product.isFavorite
  //           }))
  //       .then((response) {
  //     final newProduct = Product(
  //         id: json.decode(response.body)['name'],
  //         title: product.title,
  //         description: product.description,
  //         imageUrl: product.imageUrl,
  //         price: product.price);
  //     _items.add(newProduct);

  //     // _items.insert(0, newProduct);  //to add the product ib the start of the list
  //     notifyListeners();
  //   });
  // }

  void updateProduct(String id, Product newProduct) {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      return;
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
