import 'package:flutter/material.dart';
import 'package:shop/Screens/auth-screen.dart';
import 'package:shop/Screens/cart_detail.dart';
import 'package:shop/Screens/edit-product.dart';
import 'package:shop/Screens/order_details.dart';
import 'package:shop/Screens/order_placed.dart';
import 'package:shop/Screens/product_detail.dart';
import 'package:shop/Screens/product_overview.dart';
import 'package:shop/Screens/user_products.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/providers/orders.dart';
import './providers/products.dart';
import 'package:provider/provider.dart';
import './providers/carts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (ctx) => Auth()),
          ChangeNotifierProxyProvider<Auth, Products>(
              update: (ctx, auth, previousProducts) => Products(
                  auth.token,
                  auth.userId,
                  previousProducts == null ? [] : previousProducts.items)),
          ChangeNotifierProvider(create: (ctx) => Cart()),
          ChangeNotifierProxyProvider<Auth, Order>(
              update: (ctx, auth, previousOrders) => Order(
                    auth.token,
                    auth.userId,
                  )),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'shoppie',
            theme: ThemeData(
                primarySwatch: Colors.deepOrange, accentColor: Colors.amber),
            home: auth.isAuth
                ? ProductOverviewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResult) =>
                        authResult.connectionState == ConnectionState.waiting
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : AuthScreen(),
                  ),
            routes: {
              '/home': (ctx) => ProductOverviewScreen(),
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartDetailScreen.routeName: (ctx) => CartDetailScreen(),
              OrderPlacedScreen.routeName: (ctx) => OrderPlacedScreen(),
              OrderDetail.routeName: (ctx) => OrderDetail(),
              UserProducts.routeName: (ctx) => UserProducts(),
              EditProduct.routeName: (ctx) => EditProduct(),
              AuthScreen.routeName: (ctx) => AuthScreen(),
            },
          ),
        ));
  }
}
