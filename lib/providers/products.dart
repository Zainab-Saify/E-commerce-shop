import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shop/models/httpException.dart';
import 'package:shop/providers/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {
  List<Product> _items = [];
  final token;
  final userId;
  List<Product> _userProducts = [];

  Products(this.token, this.userId, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get userProducts {
    return [..._userProducts];
  }

  List<Product> get favItems {
    return _items.where((pro) => pro.isFav).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((pro) => pro.id == id);
  }

  Future<void> addItem(Product p) async {
    const url = 'https://flutter-shop-7a201.firebaseio.com/products.json';
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': p.title,
            'price': p.price,
            'description': p.description,
            'imageUrl': p.imageUrl,
            'creatorId': userId,
          }));
      p.id = json.decode(response.body)['name'];
      _items.add(p);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> deleteItem(String pid) async {
    Product p = findById(pid);
    final url = 'https://flutter-shop-7a201.firebaseio.com/products/$pid.json';

    _items.remove(p);
    var response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.add(p);
      throw HttpException("failed to delete item.");
    }

    p = null;
    notifyListeners();
  }

  Future<void> fetchProducts() async {
    const url = 'https://flutter-shop-7a201.firebaseio.com/products.json';

    try {
      final response = await http.get(url);
      print(json.decode(response.body));
      List<Product> loadedProducts = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final favUrl =
          'https://flutter-shop-7a201.firebaseio.com/user_favs/$userId.json';
      final favResponse = await http.get(favUrl);
      final favPros =
          (json.decode(favResponse.body) as Map<String, dynamic>).keys.toList();
      extractedData.forEach((proId, proData) {
        loadedProducts.add(Product(
            description: proData['description'],
            imageUrl: proData['imageUrl'],
            price: proData['price'],
            title: proData['title'],
            id: proId,
            isFav: favPros.contains(proId)));

        if (proData['creatorId'] == userId) {
          _userProducts.add(Product(
              description: proData['description'],
              imageUrl: proData['imageUrl'],
              price: proData['price'],
              title: proData['title'],
              id: proId,
              isFav: favPros.contains(proId)));
        }
      });

      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
