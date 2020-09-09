import 'package:flutter/material.dart';
import 'package:shop/Screens/product_detail.dart';
import 'package:shop/providers/product.dart';
import 'package:provider/provider.dart';
import '../providers/carts.dart';

class SingleProductOverview extends StatelessWidget {
  Product p;
  Cart c;
  void showDetails(BuildContext context) {
    Navigator.of(context)
        .pushNamed(ProductDetailScreen.routeName, arguments: p.id);
  }

  @override
  Widget build(BuildContext context) {
    p = Provider.of<Product>(context, listen: false);
    c = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
            onTap: () => showDetails(context),
            child: Hero(
              tag: p.id,
              child: FadeInImage(
                placeholder:
                    AssetImage('assets/images/product-placeholder.png'),
                image: NetworkImage(p.imageUrl),
                fit: BoxFit.cover,
              ),
            )),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          title: Text(
            p.title,
            textAlign: TextAlign.center,
          ),
          leading: Consumer<Product>(
            builder: (ctx, p, child) => IconButton(
              icon: Icon(
                p.isFav ? Icons.favorite : Icons.favorite_border,
              ),
              iconSize: 20,
              color: Theme.of(context).accentColor,
              onPressed: () {
                p.toggleFavStatus(context, p.id);
                Scaffold.of(context).hideCurrentSnackBar();
                p.isFav
                    ? Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Item added to favs',
                            textAlign: TextAlign.center,
                          ),
                          duration: Duration(seconds: 1),
                        ),
                      )
                    : Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Item removed from favs',
                            textAlign: TextAlign.center,
                          ),
                          duration: Duration(seconds: 1),
                        ),
                      );
              },
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.add_shopping_cart),
            iconSize: 20,
            color: Theme.of(context).accentColor,
            onPressed: () {
              c.addToCart(proId: p.id, context: context);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(
                  "item added to cart!",
                ),
                duration: Duration(seconds: 1),
                action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      c.deleteItem(p.id);
                    }),
              ));
            },
          ),
        ),
      ),
    );
  }
}
