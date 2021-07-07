import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/app_drawer.dart';
import '../screens/cart_screen.dart';
import '../providers/cart.dart';
import '../widgets/badge.dart.dart';
import '../widgets/product_grid_view.dart';

enum selectOption { all, favorite }

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _option = false, _isLoading = true;

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
    Provider.of<ProductProvider>(context, listen: false)
        .fatchDataFromServer()
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (selectOption value) {
              setState(() {
                if (value == selectOption.all) {
                  _option = false;
                } else {
                  _option = true;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) {
              return [
                PopupMenuItem(
                  child: Text('All'),
                  value: selectOption.all,
                ),
                PopupMenuItem(
                  child: Text('Favorites'),
                  value: selectOption.favorite,
                )
              ];
            },
          ),
          Consumer<Cart>(
            builder: (_, cart, childWidget) => Badge(
                child: childWidget, value: cart.cartItemNumber.toString()),
            child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.screenKey);
                }),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductGridView(_option),
    );
  }
}
