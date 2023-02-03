import 'package:flutter/material.dart';
import 'package:my_shop/Models/http_exception.dart';
import 'product.dart';
import 'package:http/http.dart'
    as http; //this is called bundling the package all in prefix
import 'dart:convert';

class Products with ChangeNotifier {
  // ignore: prefer_final_fields
  List<Product> _items = [];
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
  Future<void> fetchAndSetProducts() async {
    final url = Uri.parse(
        'https://shopproject00-default-rtdb.europe-west1.firebasedatabase.app/products.json');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>?;
      if (extractedData == null) {
        _items = [];
        return;
      }
      List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            imageUrl: prodData['imageUrl'],
            price: prodData['price'],
            isFavorite: prodData['isfavorite']));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (e) {
      //
    }
  }

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

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      final url = Uri.parse(
          'https://shopproject00-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json');
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price.toString(),
            'imageUrl': newProduct.imageUrl
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      return;
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://shopproject00-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json');
    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    final existingProduct = _items[
        existingProductIndex]; //here we r making a reference to the item we about to delete from the list and even so we will delete it from the list dart wont remove it from memory cuz an object needs it
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(
        url); //http. delete (patch also) doesn't throw an error but u can get the status code from the error that happend with the request but http.post and http.get throws an error (http package only throws its errors on get and post request)
    if (response.statusCode >= 400) {
      _items.insert(
          existingProductIndex, existingProduct); //this is optimistic updating
      notifyListeners();
      throw HttpException(message: 'Could not delete the item');
    }
  }
}
