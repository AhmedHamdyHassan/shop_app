import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_item.dart';


class ProductGridView extends StatelessWidget {

  final bool isFavorite;
  ProductGridView(this.isFavorite);

  @override
  Widget build(BuildContext context) {
    final productsData=Provider.of<ProductProvider>(context);
    final products=isFavorite?productsData.favoriteItems:productsData.items;//productsData.items;
    return GridView.builder(
      itemCount: products.length,
      padding:const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 3/2,
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10
      ),
      itemBuilder: (cxt,i)=> ChangeNotifierProvider.value(
        value:products[i],
        child: ProductItem(),
      )
    );
  }
}