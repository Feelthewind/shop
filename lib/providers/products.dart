import 'package:flutter/material.dart';
import 'package:shopping_app/models/product.dart';

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

  List<Product> get items {
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  void addProduct() {
//    _items.add(value);
    notifyListeners();
  }
}