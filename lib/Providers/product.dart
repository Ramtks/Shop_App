import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:my_shop/Models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String imageUrl;
  final double price;
  final String description;

  bool
      isFavorite; //this is not final cuz it will change after the object product is created
  bool isDeleted;
  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.imageUrl,
      required this.price,
      this.isFavorite = false,
      this.isDeleted = false});
  void toggleDelete() {
    isDeleted = !isDeleted;
    notifyListeners();
  }

  void _setFavStatus(bool newValue) {
    isFavorite = newValue;
  }

  Future<void> toggleFavorite(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = Uri.parse(
        'https://shopproject00-default-rtdb.europe-west1.firebasedatabase.app/userfavorites/$userId/$id.json?auth=$token');
    try {
      final response = await http.put(url, body: json.encode(isFavorite));
      if (response.statusCode >= 400) {
        _setFavStatus(oldStatus);
        notifyListeners();
      }
    } catch (e) {
      _setFavStatus(oldStatus);
      notifyListeners();
    } finally {
      final response =
          await http.put(url, body: json.encode({'isfavorite': isFavorite}));
      if (response.statusCode >= 400) {
        throw HttpException(message: 'Could not change the favorite status');
      }
    } //here http package wont throw an error if the patching is failed so we do the status code workaround but we have the try and catch incase of a network error
  }
}
