import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order.dart' show Order;
import '../widgets/app_drawer.dart';
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const String screenKey = '/orders_screen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Orders'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder<Object>(
            future: Provider.of<Order>(context, listen: false)
                .fatchDataFromServer(),
            builder: (ctx, response) {
              if (response.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (response.error != null) {
                return Center(
                    child: Text(
                  'No data to show due to error in server',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ));
              } else {
                return Consumer<Order>(
                  builder: (ctx2, orderData, child) => orderData.orders.isEmpty
                      ? Center(
                          child: Text(
                            'There\'s no orders to show!',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )
                      : ListView.builder(
                          itemBuilder: (ctx, i) =>
                              OrderItem(orderData.orders[i]),
                          itemCount: orderData.orders.length,
                        ),
                );
              }
            }));
  }
}
