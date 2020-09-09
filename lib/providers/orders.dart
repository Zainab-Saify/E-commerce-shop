import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'carts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  String id;
  final double amount;
  final List<CartItem> products;
  DateTime dateTime;
  static int i = 0;

  OrderItem({
    this.id,
    this.amount,
    this.products,
    this.dateTime,
  });
}

class Order with ChangeNotifier {
  List<OrderItem> _items = [];
  final token;
  final userId;

  Order(
    this.token,
    this.userId,
  );

  List<OrderItem> get items {
    fetchOrders();
    if (_items == []) return [];
    return [..._items];
  }

  Future<void> addOrder(
      BuildContext context, double total, List<CartItem> cartitems) async {
    final url = 'https://flutter-shop-7a201.firebaseio.com/orders/$userId.json';
    final timeStamp = DateTime.now();
    var cartdata = Provider.of<Cart>(context, listen: false);
    try {
      var response = await http.post(url,
          body: json.encode({
            'amount': total,
            'products': cartitems.map((cp) {
              return {
                'title': cp.title,
                'quantity': cp.quantity,
                'price': cp.price,
                'id': DateTime.now().toIso8601String()
              };
            }).toList(),
            'dateTime': timeStamp.toIso8601String()
          }));

      _items.insert(
          0,
          OrderItem(
              id: json.decode(response.body)['name'],
              amount: total,
              products: cartitems,
              dateTime: timeStamp));
      cartdata.emptyCart();
    } catch (error) {}

    notifyListeners();
  }

  Future<void> fetchOrders() async {
    final url = 'https://flutter-shop-7a201.firebaseio.com/orders/$userId.json';
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final decodedData = json.decode(response.body) as Map<String, dynamic>;
    if (decodedData == null) {
      return;
    }
    decodedData.forEach((orderid, orderData) {
      loadedOrders.add(OrderItem(
          id: orderid,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List)
              .map((item) => CartItem(
                  price: item['price'],
                  quantity: item['quantity'],
                  title: item['title'],
                  id: item['id']))
              .toList()));
    });

    _items = loadedOrders.reversed.toList();
    notifyListeners();
  }

  double getTotal() {
    return _items[0].amount;
  }
}
