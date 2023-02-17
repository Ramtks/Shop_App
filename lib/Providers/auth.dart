import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:my_shop/Models/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

  bool get isAuth {
    return token != '';
  }

  String get userId {
    return _userId!;
  }

  String get token {
    if (_expiryDate != null) {
      if (_expiryDate!.isAfter(DateTime.now()) && _token != null) {
        return _token!;
      }
    }
    return '';
  }

  Future<void> _authenticate(
      String? password, String? email, String changedSegment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$changedSegment?key=AIzaSyBeKkTljURd-rIReT9IT02dXEd7Le47ENY');
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(message: responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences
          .getInstance(); //if we await we will get prefs as the access but if we dont await we will get prefs as future
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expireyDate': _expiryDate!.toIso8601String()
      });
      prefs.setString('userData', userData);
    } catch (e) {
      rethrow; // here we will have an error if the connection failed (no internet access , backend server is down , etc)
    }
  }

  Future<void> signUp(String? password, String? email) async {
    return _authenticate(password, email,
        'signUp'); //we put return here cuz this is the future in which will returned by the http request post and if we use await when we call this function we would be wait for post request and if we dont use return here we would be wait for the auto generated future from the async
  }

  Future<void> logIn(String? password, String? email) async {
    return _authenticate(password, email, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedData =
        json.decode((prefs.getString('userData'))!) as Map<String, dynamic>;
    final expireyDate = DateTime.parse(extractedData['expireyDate']);
    if (expireyDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedData['token'];
    _userId = extractedData['userId'];
    _expiryDate = expireyDate;
    notifyListeners();
    autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = '';
    _userId = '';
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData')
    prefs.clear();
  }

  void autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    if (_expiryDate != null) {
      final timeToExpirey = _expiryDate?.difference(DateTime.now()).inSeconds;
      _authTimer = Timer(Duration(seconds: timeToExpirey!), logout);
    }
  }
}
