import 'package:flutter/material.dart';
import '../providers/order.dart' as ord;
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {
  final ord.OrderItam orderData;

  OrderItem(this.orderData);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      child: Card(
          margin: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text('\$${widget.orderData.amount.toStringAsFixed(2)}',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(
                  DateFormat('dd/MM/yyyy  hh:mm')
                      .format(widget.orderData.dateTime),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: IconButton(
                    icon: _expanded
                        ? Icon(Icons.expand_less)
                        : Icon(Icons.expand_more),
                    onPressed: () {
                      setState(() {
                        _expanded = !_expanded;
                      });
                    }),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: _expanded ? widget.orderData.products.length * 60.0 : 0,
                child: Container(
                  child: ListView(
                      children: widget.orderData.products
                          .map((e) => ListTile(
                                title: Text(e.title,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                                trailing: Text(
                                  '${e.quantity}x\$${e.price}',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 18),
                                ),
                              ))
                          .toList()),
                ),
              )
            ],
          )),
    );
  }
}
