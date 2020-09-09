import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/Screens/order_details.dart';
import '../providers/orders.dart';

class OrderPlacedScreen extends StatelessWidget {
  static const routeName = '/order-paced';
  @override
  Widget build(BuildContext context) {
    var orderdata = Provider.of<Order>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text("Order Placed!!"),
        ),
        body: Column(children: [
          Center(
            child: Text(
              "order placed Successfully!!",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          Center(child: Text('total amount! ${orderdata.getTotal()}')),
          SizedBox(
            height: 40,
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(15),
                child: RaisedButton(
                  child: Text("view order details"),
                  color: Colors.amber,
                  onPressed: () {
                    Navigator.of(context).pushNamed(OrderDetail.routeName);
                  },
                ),
              ),
              SizedBox(
                width: 30,
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: RaisedButton(
                  child: Text("Continue Shopping!"),
                  color: Colors.amber,
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/home');
                  },
                ),
              )
            ],
          )
        ]));
  }
}
