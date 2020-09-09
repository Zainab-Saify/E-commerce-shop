import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/Screens/user_products.dart';
import 'package:shop/providers/auth.dart';
import '../Screens/order_details.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          AppBar(
            title: Text("Helloo Friend!"),
            backgroundColor: Colors.deepOrange,
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.shopping_basket,
              size: 30,
            ),
            title: Text(
              "Shop",
              textAlign: TextAlign.left,
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/home');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.timelapse,
              size: 30,
            ),
            title: Text(
              "order History",
              textAlign: TextAlign.left,
            ),
            onTap: () {
              Navigator.of(context).pushNamed(OrderDetail.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.store,
              size: 30,
            ),
            title: Text(
              "Your Products",
              textAlign: TextAlign.left,
            ),
            onTap: () {
              Navigator.of(context).pushNamed(UserProducts.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              size: 30,
            ),
            title: Text(
              "Log-Out",
              textAlign: TextAlign.left,
            ),
            onTap: () {
              Navigator.of(context).pop();
              Provider.of<Auth>(context, listen: false).logout();
            },
          )
        ],
      ),
    );
  }
}
