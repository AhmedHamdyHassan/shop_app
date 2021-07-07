import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import '../screens/user_product_screen.dart';
import '../screens/orders_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Menu'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text(
              'Shop',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.screenKey);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Products',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(UserProductScreen.screenKey);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).popAndPushNamed('/');
              Provider.of<Auth>(context, listen: false).logout();
            },
          )
        ],
      ),
    );
  }
}
