import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/Screens/edit-product.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/providers/products.dart';

class UserProductItem extends StatelessWidget {
  final Product p;

  UserProductItem(this.p);
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    var productProvider = Provider.of<Products>(context, listen: false);
    return ListTile(
      leading: CircleAvatar(
        child: Image(
          image: NetworkImage(p.imageUrl),
        ),
        radius: 30,
        backgroundColor: Colors.white,
      ),
      title: Text(p.title),
      subtitle: Text('Rs. ${p.price}'),
      trailing: Container(
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProduct.routeName, arguments: p);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                try {
                  await productProvider.deleteItem(p.id);
                } catch (error) {
                  scaffold.showSnackBar(SnackBar(
                    content: Text('unable to delete!'),
                    duration: Duration(seconds: 1),
                  ));
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
