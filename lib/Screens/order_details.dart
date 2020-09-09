import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/Widgets/order_listtile.dart';
import 'package:shop/providers/orders.dart';

class OrderDetail extends StatelessWidget {
  static const routeName = '/order-details';
  @override
  Widget build(BuildContext context) {
    var orderdata = Provider.of<Order>(context).items;
    return Scaffold(
      appBar: AppBar(
        title: Text("Order History!"),
      ),
      body: orderdata.isEmpty
          ? Center(
              child: Text('no orders placed yet!'),
            )
          : ListView.builder(
              itemBuilder: (ctx, i) => OrderListTile(orderdata[i]),
              itemCount: orderdata.length,
            ),
    );
  }
}
