import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shop/providers/auth.dart';

class Product with ChangeNotifier {
  String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFav;
  static int i = 4;

  Product(
      {this.id,
      @required this.description,
      @required this.imageUrl,
      this.isFav = false,
      @required this.price,
      @required this.title});

  Future<void> toggleFavStatus(BuildContext context, String pid) async {
    isFav = !isFav;
    notifyListeners();
    var authdata = Provider.of<Auth>(context, listen: false);
    var userid = authdata.userId;
    final url =
        'https://flutter-shop-7a201.firebaseio.com/user_favs/$userid/$pid.json';
    try {
      final response = await http.put(url, body: json.encode(isFav));
      if (response.statusCode >= 400) {
        isFav = !isFav;
        Scaffold.of(context).hideCurrentSnackBar();
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('failed to remove!'),
        ));
        notifyListeners();
      }
    } catch (error) {
      isFav = !isFav;
      Scaffold.of(context).hideCurrentSnackBar();
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('failed to remove!'),
      ));
      notifyListeners();
    }
  }
}
