import 'package:flutter/material.dart';
import 'package:shopping_app/providers/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
        id: 'p1',
        title: 'Red Shirt',
        description: 'A red shirt - it is pretty red!',
        price: 29.99,
        imageUrl:
            'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_960_720.jpg'),
    Product(
        id: 'p2',
        title: 'Blue Shirt',
        description: 'A blue shirt - it is pretty blue!',
        price: 19.99,
        imageUrl:
            'https://cdn.pixabay.com/photo/2016/01/19/17/53/writing-1149962_960_720.jpg'),
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

  void addProduct(Product product) {
    final newProduct = Product(
      title: product.title,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
      id: DateTime.now().toString(),
    );
    _items.add(newProduct);
    notifyListeners();
  }
}
