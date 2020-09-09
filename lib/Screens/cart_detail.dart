import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/Screens/order_placed.dart';
import 'package:shop/providers/orders.dart';
import '../providers/carts.dart';
import '../Widgets/cart_listtile.dart';

class CartDetailScreen extends StatefulWidget {
  static const routeName = '/cart-details';

  @override
  _CartDetailScreenState createState() => _CartDetailScreenState();
}

class _CartDetailScreenState extends State<CartDetailScreen> {
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<Cart>(context);
    var orderdata = Provider.of<Order>(context, listen: false);
    List<String> pids = cart.items.keys.toList();
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Cart!'),
        ),
        body: Column(children: <Widget>[
          Card(
            elevation: 6,
            margin: EdgeInsets.all(20),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Total",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  Consumer<Cart>(
                    builder: (ctx, cart, child) => Chip(
                      label: Text("Rs. ${cart.totalAmount}"),
                      backgroundColor: Colors.amber,
                    ),
                  ),
                  Consumer<Cart>(
                    builder: (ctx, cart, child) => isLoading
                        ? Container(
                            height: 50,
                            width: 70,
                            child: Center(
                              child: Container(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator()),
                            ),
                          )
                        : FlatButton(
                            child: Text(
                              'ORDER NOW!',
                              style: TextStyle(color: Colors.orange),
                            ),
                            onPressed: cart.totalItems == 0
                                ? null
                                : () {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    orderdata
                                        .addOrder(context, cart.totalAmount,
                                            cart.toList())
                                        .then((_) {
                                      isLoading = false;
                                      Navigator.of(context).pushNamed(
                                          OrderPlacedScreen.routeName);
                                    });
                                  },
                          ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
              child: ListView.builder(
            itemBuilder: (ctx, i) => CartListTile(
              pid: pids[i],
              cid: cart.items.values.toList()[i].id,
            ),
            itemCount: cart.totalItems,
          ))
        ]));
  }
}
