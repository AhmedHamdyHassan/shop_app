import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id, title, description, imageUrl;
  final double price;
  bool isFavorite;

  Product(
      {@required this.id,
      @required this.description,
      @required this.imageUrl,
      @required this.price,
      @required this.title,
      this.isFavorite = false});

  void setFavoriteState(bool value) {
    isFavorite = value;
    notifyListeners();
  }

  Future<void> toggleFavorite(String token, String userID) async {
    final oldState = isFavorite;
    final url =
        'https://st-flutter-http-request-app.firebaseio.com/userFavorites/$userID/$id.json?auth=$token';
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final response = await http.put(url, body: json.encode(isFavorite));
      if (response.statusCode >= 400) {
        setFavoriteState(oldState);
      }
    } catch (error) {
      setFavoriteState(oldState);
    }
  }
}
