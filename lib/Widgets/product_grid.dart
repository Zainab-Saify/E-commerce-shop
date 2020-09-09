import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products.dart';
import 'single_product_overview.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavsOnly;

  ProductGrid(this.showFavsOnly);
  @override
  Widget build(BuildContext context) {
    print(showFavsOnly);
    final productsData = Provider.of<Products>(context);
    final products = showFavsOnly ? productsData.favItems : productsData.items;
    return GridView.builder(
      itemBuilder: (context, i) => ChangeNotifierProvider.value(
          value: products[i], child: SingleProductOverview()),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 3 / 2),
    );
  }
}
