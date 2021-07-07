import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../models/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _tocken, _userID;
  DateTime _expiryDate;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get userID {
    return _userID;
  }

  String get token {
    if (_tocken != null &&
        _expiryDate != null &&
        _expiryDate.isAfter(DateTime.now())) {
      return _tocken;
    }
    return null;
  }

  Future<void> _authenticate(
      String email, String password, String operation) async {
    try {
      final url =
          'https://identitytoolkit.googleapis.com/v1/accounts:$operation?key=AIzaSyBjIYfT4Z5IilBF0GlGQYqnIKZGMjEwQ4k';
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _tocken = responseData['idToken'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      _userID = responseData['localId'];
      autoLogout();
      notifyListeners();
      final autoLoginSharedPreference = await SharedPreferences.getInstance();
      final userAutoLoginData = json.encode({
        'token': _tocken,
        'userId': _userID,
        'expiryDate': _expiryDate.toIso8601String()
      });
      autoLoginSharedPreference.setString('autoLogin', userAutoLoginData);
    } catch (error) {
      throw error;
    }
  }

  Future<bool> autoLogin() async {
    final autoLoginSharedPreference = await SharedPreferences.getInstance();
    if (!autoLoginSharedPreference.containsKey('autoLogin')) {
      return false;
    }
    final loginData =
        json.decode(autoLoginSharedPreference.getString('autoLogin'))
            as Map<String, Object>;
    final expiryDate = DateTime.parse(loginData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _userID = loginData['userId'];
    _tocken = loginData['token'];
    _expiryDate = expiryDate;
    notifyListeners();
    autoLogout();
    return true;
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> logout() async {
    _userID = null;
    _tocken = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    notifyListeners();
    final autoLoginSharedPreference = await SharedPreferences.getInstance();
    autoLoginSharedPreference.clear();
  }

  void autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToLogout = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToLogout), logout);
    notifyListeners();
  }
}
