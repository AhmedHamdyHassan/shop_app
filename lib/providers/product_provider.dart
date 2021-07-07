import 'package:flutter/material.dart';
import 'package:shop_app/models/http_exception.dart';
import './products.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductProvider with ChangeNotifier {
  List<Product> _productItems = [];
  final String _token, _userID;

  ProductProvider(this._token, this._userID, this._productItems);

  List<Product> get items {
    return [..._productItems];
  }

  List<Product> get favoriteItems {
    return _productItems.where((element) => element.isFavorite).toList();
  }

  Product getByID(String id) {
    return _productItems.firstWhere((element) => element.id == id);
  }

  Future<void> fatchDataFromServer([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? '&orderBy="creatorId"&equalTo="$_userID"' : '';
    var url =
        'https://st-flutter-http-request-app.firebaseio.com/products.json?auth=$_token' +
            filterString;
    try {
      var response = await http.get(url);
      final fatchedData = json.decode(response.body) as Map<String, dynamic>;
      url =
          'https://st-flutter-http-request-app.firebaseio.com/userFavorites/$_userID.json?auth=$_token';
      response = await http.get(url);
      final favoriteUserItems =
          json.decode(response.body) as Map<String, dynamic>;
      List<Product> fatechedItems = [];
      fatchedData.forEach((productID, productData) {
        fatechedItems.add(Product(
            id: productID,
            description: productData['description'],
            imageUrl: productData['imageUrl'],
            price: productData['price'],
            title: productData['title'],
            isFavorite: favoriteUserItems == null
                ? false
                : favoriteUserItems[productID] ?? false));
      });
      _productItems = fatechedItems;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://st-flutter-http-request-app.firebaseio.com/products.json?auth=$_token';
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'creatorId': _userID
          }));
      _productItems.add(Product(
          id: json.decode(response.body)['name'],
          description: product.description,
          imageUrl: product.imageUrl,
          price: product.price,
          title: product.title));
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final productIndex =
        _productItems.indexWhere((element) => element.id == id);
    if (productIndex >= 0) {
      _productItems[productIndex] = newProduct;
      final url =
          'https://st-flutter-http-request-app.firebaseio.com/products/$id.json?auth=$_token';
      try {
        await http
            .patch(url,
                body: json.encode({
                  'description': newProduct.description,
                  'imageUrl': newProduct.imageUrl,
                  'price': newProduct.price,
                  'title': newProduct.title,
                }))
            .then((value) {
          if (value.statusCode >= 400) {
            throw Error();
          }
        });
      } catch (error) {
        print(error.toString());
        throw error;
      }
    }
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://st-flutter-http-request-app.firebaseio.com/products/$id.json?auth=$_token';
    final tempProduct = _productItems.firstWhere((element) => element.id == id);
    final tempProductIndex =
        _productItems.indexWhere((element) => element.id == id);
    try {
      final response = await http.delete(url);
      _productItems.removeWhere((element) => element.id == id);
      notifyListeners();
      if (response.statusCode >= 400) {
        throw HttpException(
            'Delete failed due to an error heppened while connecting to server');
      }
    } catch (error) {
      _productItems.insert(tempProductIndex, tempProduct);
      notifyListeners();
      throw error;
    }
  }
}
