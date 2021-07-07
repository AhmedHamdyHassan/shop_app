import 'package:flutter/cupertino.dart';
import '../providers/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItam {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  OrderItam(
      {@required this.id,
      @required this.amount,
      @required this.dateTime,
      @required this.products});
}

class Order with ChangeNotifier {
  List<OrderItam> _orders = [];
  final String _token, _userId;

  Order(this._token, this._userId, this._orders);

  List<OrderItam> get orders {
    return [..._orders];
  }

  Future<void> fatchDataFromServer() async {
    final url =
        'https://st-flutter-http-request-app.firebaseio.com/orders/$_userId.json?auth=$_token';
    try {
      List<OrderItam> fatechedItems = [];
      final response = await http.get(url);
      final fatchedData = json.decode(response.body) as Map<String, dynamic>;
      if (fatchedData == null) {
        return;
      }
      fatchedData.forEach((orderId, orderData) {
        fatechedItems.add(OrderItam(
            id: orderId,
            amount: orderData['amount'],
            dateTime: DateTime.parse(orderData['dateTime']),
            products: (orderData['products'] as List<dynamic>)
                .map((item) => CartItem(
                    id: item['id'],
                    price: item['price'],
                    quantity: item['quantity'],
                    title: item['title']))
                .toList()));
      });
      _orders = fatechedItems.reversed.toList();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addOrder(List<CartItem> cartProduct, double total) async {
    final url =
        'https://st-flutter-http-request-app.firebaseio.com/orders/$_userId.json?auth=$_token';
    try {
      final date = DateTime.now();
      final response = await http.post(url,
          body: json.encode({
            'amount': total,
            'dateTime': date.toIso8601String(),
            'products': cartProduct.map((e) {
              return {
                'id': e.id,
                'title': e.title,
                'quantity': e.quantity,
                'price': e.price
              };
            }).toList()
          }));
      _orders.insert(
          0,
          OrderItam(
              id: json.decode(response.body)['name'],
              amount: total,
              dateTime: date,
              products: cartProduct));
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
