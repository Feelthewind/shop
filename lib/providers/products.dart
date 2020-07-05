import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_app/providers/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
//    Product(
//        id: 'p1',
//        title: 'Red Shirt',
//        description: 'A red shirt - it is pretty red!',
//        price: 29.99,
//        imageUrl:
//            'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_960_720.jpg'),
//    Product(
//        id: 'p2',
//        title: 'Blue Shirt',
//        description: 'A blue shirt - it is pretty blue!',
//        price: 19.99,
//        imageUrl:
//            'https://cdn.pixabay.com/photo/2016/01/19/17/53/writing-1149962_960_720.jpg'),
  ];
//  var _showFavoritesOnly = false;

  List<Product> get items {
//    if (_showFavoritesOnly) {
//      return [..._items].where((prodItem) => prodItem.isFavorite).toList();
//    }
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    const url = 'https://flutter-update-396ab.firebaseio.com/products.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          isFavorite: prodData['isFavorite'],
          imageUrl: prodData['imageUrl'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addProduct(Product product) async {
    const url = 'https://flutter-update-396ab.firebaseio.com/products.json';
    try {
      final response = await http.post(url, body: json.encode({
        'title': product.title,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'price': product.price,
        'isFavorite': product.isFavorite,
      }));
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((element) => element.id == id);
    if (prodIndex >= 0) {
      final url = 'https://flutter-update-396ab.firebaseio.com/products/$id.json';
      try {
        final response = await http.patch(url, body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'imageUrl': newProduct.imageUrl,
          'price': newProduct.price,
        }));
        _items[prodIndex] = newProduct;
        notifyListeners();
      } catch (e) {
        throw e;
      }
    } else {
      print('...');
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
