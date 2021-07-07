import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/edit_product_screen.dart';
import '../widgets/user_product.dart';
import '../providers/product_provider.dart';
import '../widgets/app_drawer.dart';

class UserProductScreen extends StatelessWidget {
  static const String screenKey = '/user_product_screen';
  Future<void> refreshPage(BuildContext context) async {
    await Provider.of<ProductProvider>(context, listen: false)
        .fatchDataFromServer(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productData = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.screenKey,
                    arguments: {'title': 'Add New Product', 'id': null});
              }),
        ],
        title: Text('My Products'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: refreshPage(context),
        builder: (ctx, futureState) => RefreshIndicator(
            onRefresh: () => refreshPage(context),
            child: futureState.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Consumer<ProductProvider>(
                    builder: (ctx, productData, _) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemBuilder: (ctx, i) => Column(
                          children: <Widget>[
                            UserProduct(
                                productData.items[i].title,
                                productData.items[i].imageUrl,
                                productData.items[i].id),
                            Divider()
                          ],
                        ),
                        itemCount: productData.items.length,
                      ),
                    ),
                  )),
      ),
    );
  }
}
