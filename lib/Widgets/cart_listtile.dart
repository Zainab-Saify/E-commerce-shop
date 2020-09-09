import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/Screens/product_detail.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/providers/products.dart';
import '../providers/carts.dart';

class CartListTile extends StatelessWidget {
  String pid;
  final String cid;
  int quantity;

  CartListTile({
    this.pid,
    this.cid,
  });
  @override
  Widget build(BuildContext context) {
    print(cid);
    var cartData = Provider.of<Cart>(context);
    print(pid);
    Product p = Provider.of<Products>(context, listen: false).findById(pid);
    quantity = cartData.getQuantity(pid);
    return Dismissible(
      key: ValueKey(cid),
      background: Container(
        color: Colors.grey,
      ),
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('are you sure?'),
                  content: Text(
                      'do you wanna delete this item completely from your cart?'),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: Text('yes')),
                    FlatButton(
                      onPressed: () => Navigator.of(ctx).pop(false),
                      child: Text('no'),
                    ),
                  ],
                ));
      },
      onDismissed: (_) => cartData.deleteItemCompletely(pid),
      child: ListTile(
        leading: Container(
          height: 70,
          width: 50,
          child: GestureDetector(
            child: Image(
              image: NetworkImage(p.imageUrl),
              fit: BoxFit.contain,
            ),
            onTap: () {
              Navigator.of(context)
                  .pushNamed(ProductDetailScreen.routeName, arguments: p.id);
            },
          ),
        ),
        title: Text(p.title),
        subtitle: Row(
            children: [Text('price: Rs. ${p.price} '), Text('x $quantity')]),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: () => cartData.deleteItem(pid),
        ),
      ),
    );
  }
}
