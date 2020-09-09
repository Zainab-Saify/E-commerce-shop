import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../providers/product.dart';

class CartItem {
  String id;
  final String title;
  int quantity;
  final double price;
  static int i = 0;

  CartItem(
      {@required this.price,
      @required this.quantity,
      @required this.title,
      this.id});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  void addToCart(
      {@required String proId, int quantity = 1, BuildContext context}) {
    if (_items.containsKey(proId)) {
      print('quantity updated');
      _items.update(
          proId,
          (exsitingCartItem) => CartItem(
              price: exsitingCartItem.price,
              quantity: exsitingCartItem.quantity + 1,
              title: exsitingCartItem.title));
      notifyListeners();
    } else {
      print('product added');
      Product p = Provider.of<Products>(context, listen: false)
          .items
          .firstWhere((pro) => pro.id == proId);
      _items.putIfAbsent(proId,
          () => CartItem(price: p.price, quantity: quantity, title: p.title));
      notifyListeners();
    }
  }

  int get totalItems {
    print('total items called');
    if (_items == null)
      return 0;
    else
      return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  int getQuantity(String pid) {
    if (_items.containsKey(pid)) {
      return _items[pid].quantity;
    }
    return 0;
  }

  void deleteItem(proId) {
    if (_items.containsKey(proId)) {
      print('quantity updated');
      _items.update(
          proId,
          (exsitingCartItem) => CartItem(
              price: exsitingCartItem.price,
              quantity: exsitingCartItem.quantity - 1,
              title: exsitingCartItem.title));

      if (getQuantity(proId) == 0) {
        _items.remove(proId);
      }
      notifyListeners();
    }
  }

  void deleteItemCompletely(proId) {
    _items.remove(proId);
    notifyListeners();
  }

  void emptyCart() {
    _items = {};
    notifyListeners();
  }

  List<CartItem> toList() {
    List<CartItem> cartitemlist = [];
    _items.forEach((key, value) {
      cartitemlist.add(value);
    });
    return cartitemlist;
  }
}
