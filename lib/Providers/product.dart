import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String imageUrl;
  final double price;
  final String description;

  bool
      isFavorite; //this is not final cuz it will change after the object product is createds
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

  void toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }
}
