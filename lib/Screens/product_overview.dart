import 'package:flutter/material.dart';
import 'package:shop/Screens/cart_detail.dart';
import 'package:shop/Widgets/app_drawer.dart';
import 'package:shop/providers/products.dart';
import '../Widgets/product_grid.dart';
import 'package:provider/provider.dart';
import '../providers/carts.dart';

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var showFavsOnly = false;
  var init = true;
  var isLoading = false;

  @override
  void didChangeDependencies() {
    if (init) {
      setState(() {
        isLoading = true;
      });

      Provider.of<Products>(context).fetchProducts().then((_) {
        setState(() {
          isLoading = false;
        });
      });
    }
    init = false;
    super.didChangeDependencies();
  }

  Future<void> refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => refreshProducts(context),
      child: Scaffold(
          appBar: AppBar(
            title: Text('Dmall'),
            actions: [
              Stack(children: [
                IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.of(context).pushNamed(CartDetailScreen.routeName);
                  },
                ),
                Positioned(
                  top: 4,
                  right: 2,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.amber,
                    child: Consumer<Cart>(
                      builder: (ctx, cart, child) => Text(
                        cart.totalItems.toString(),
                        style: TextStyle(fontSize: 8),
                      ),
                    ),
                  ),
                ),
              ]),
              PopupMenuButton(
                icon: Icon(Icons.more_vert),
                onSelected: (int selectedValue) {
                  setState(() {
                    if (selectedValue == 0)
                      showFavsOnly = true;
                    else
                      showFavsOnly = false;
                  });
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                    child: Text("favorities"),
                    value: 0,
                  ),
                  PopupMenuItem(
                    child: Text("show all"),
                    value: 1,
                  )
                ],
              ),
            ],
            backgroundColor: Theme.of(context).primaryColor,
          ),
          drawer: AppDrawer(),
          body: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: ProductGrid(showFavsOnly))),
    );
  }
}
