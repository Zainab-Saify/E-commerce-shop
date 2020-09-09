import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-details';

  @override
  Widget build(BuildContext context) {
    final pid = ModalRoute.of(context).settings.arguments;
    final p = Provider.of<Products>(context, listen: false).findById(pid);
    return Scaffold(
      appBar: AppBar(
        title: Text(p.title),
      ),
      body: Container(
        height: 400,
        width: double.infinity,
        padding: EdgeInsets.all(20),
        child: Hero(
            tag: pid,
            child: Image.network(
              p.imageUrl,
              fit: BoxFit.fill,
            )),
      ),
    );
  }
}
