import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_app/models/http_exception.dart';
import 'package:shopping_app/providers/auth.dart';
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
  String authToken;
  String userId;

  void update(Auth auth) {
    authToken = auth.token;
    userId = auth.userId;
  }

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
    final productUrl = 'https://flutter-update-396ab.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.get(productUrl);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final url = 'https://flutter-update-396ab.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);

      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          isFavorite: favoriteData == null ? false : favoriteData[prodId] ?? false,
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
    final url = 'https://flutter-update-396ab.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
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
      final url =
          'https://flutter-update-396ab.firebaseio.com/products/$id.json?auth=$authToken';
      try {
        final response = await http.patch(url,
            body: json.encode({
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

  Future<void> deleteProduct(String id) async {
    final url = 'https://flutter-update-396ab.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    try {
      final response = await http.delete(url);
      if (response.statusCode > 400) {
        _items.insert(existingProductIndex, existingProduct);
        notifyListeners();
        throw HttpException('Could not delete product.');
      }
      existingProduct = null;
    } catch (e) {
      throw e;
    }
  }
}
