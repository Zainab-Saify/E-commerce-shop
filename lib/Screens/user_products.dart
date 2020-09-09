import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/Screens/edit-product.dart';
import 'package:shop/Widgets/app_drawer.dart';
import 'package:shop/Widgets/user_product_item.dart';
import 'package:shop/providers/products.dart';

class UserProducts extends StatelessWidget {
  static const routeName = '/user-products';
  @override
  Widget build(BuildContext context) {
    var products = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        backgroundColor: Colors.deepOrange,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () =>
                  Navigator.of(context).pushNamed(EditProduct.routeName))
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: products.userProducts.isEmpty
            ? Center(
                child: Text('you have not added any products yet!'),
              )
            : ListView.builder(
                itemCount: products.userProducts.length,
                itemBuilder: (ctx, i) {
                  return Column(
                    children: <Widget>[
                      UserProductItem(products.userProducts[i]),
                      Divider()
                    ],
                  );
                },
              ),
      ),
    );
  }
}
