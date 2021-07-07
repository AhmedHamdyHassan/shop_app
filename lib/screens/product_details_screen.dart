import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const String screenKey = 'Product_Details_Screen';
  @override
  Widget build(BuildContext context) {
    final productID = ModalRoute.of(context).settings.arguments as String;
    final product =
        Provider.of<ProductProvider>(context, listen: false).getByID(productID);
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height / 2.3,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                child: Text(product.title),
                color: Colors.black54,
              ),
              background: Hero(
                tag: product.id,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            SizedBox(
              height: 10,
            ),
            Text(
              '\$${product.price}',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity,
              child: Text(product.description,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              padding: EdgeInsets.symmetric(horizontal: 10),
            )
          ]))
        ],
      ),
    );
  }
}
