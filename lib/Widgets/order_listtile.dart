import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/providers/orders.dart';
import 'package:intl/intl.dart';

class OrderListTile extends StatefulWidget {
  final OrderItem o;

  OrderListTile(this.o);

  @override
  _OrderListTileState createState() => _OrderListTileState();
}

class _OrderListTileState extends State<OrderListTile> {
  var expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(children: [
        ListTile(
          title: Text("rs. ${widget.o.amount}"),
          subtitle: Text(
              'ordered on : ${DateFormat.yMMMd().format(widget.o.dateTime)}'),
          trailing: IconButton(
              icon: Icon(expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  expanded = !expanded;
                });
              }),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInCirc,
          height:
              expanded ? min(widget.o.products.length * (20.0 + 60), 400) : 0,
          color: Colors.grey,
          child: ListView.builder(
            itemBuilder: (ctx, i) => Card(
                child: ListTile(
              title: Text(widget.o.products[i].title),
              subtitle: Row(
                children: <Widget>[
                  Text(widget.o.products[i].price.toString()),
                  Text(' x '),
                  Text(widget.o.products[i].quantity.toString())
                ],
              ),
            )),
            itemCount: widget.o.products.length,
          ),
        )
      ]),
    );
  }
}
