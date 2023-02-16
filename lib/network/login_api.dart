import 'dart:io';

import 'package:dio/dio.dart';
import 'package:md_fclient/models/chapter.dart';
import 'package:md_fclient/models/login_data.dart';
import 'package:md_fclient/network/login_parsers.dart';
import 'package:md_fclient/network/parsers.dart';

import 'api_base.dart';

mixin LoginApi on Api {
  Future<LoginData> login(String username, String password) async {
    print('login called');
    var data = {
      'username': username,
      'email': username,
      'password': password,
    };
    try {
      var response = await dio.post('https://api.mangadex.org/auth/login', data: data);
      var result = LoginParsers.parseLoginData(response);
      return result;
    } on DioError catch (e) {
      if (e.response != null && e.response?.statusCode == 401) {
        var detail = e.response?.data['errors'][0]['detail'];
        var id = e.response?.data['errors'][0]['id'];
        if (detail == "User is unverified") {
          throw UnverifiedException(id);
        } else if (detail == "User / Password does not match") {
          throw UserPassMatchException(id);
        }
        else{
          rethrow;
        }
      } else {
        rethrow;
      }
    } catch (e) {
     rethrow;
    }

  }

  Future<LoginData> refreshToken(String refreshToken) async {
    print('refreshToken called');
    var data = {
      'token': refreshToken,
    };
    try {
      var response = await dio.post('https://api.mangadex.org/auth/refresh', data: data);
      var result = LoginParsers.parseLoginData(response);
      return result;
    } on DioError catch (e) {
      if (e.response != null ) {
        var detail = e.response?.data['errors'][0]['detail'];
        var id = e.response?.data['errors'][0]['id'];
        print("Refresh token error: $detail");
        rethrow;
      } else {
        rethrow;
      }
    }
    throw Exception("Unknown login exception");
  }
}


class UnverifiedException implements Exception {
  String id;

  UnverifiedException(this.id);

  @override
  String toString() {
    return 'Please verify your account before logging in';
  }
}

class UserPassMatchException implements Exception {
  String id;

  UserPassMatchException(this.id);
  @override

  String toString() {
    return 'Username/password does not match';
  }
}
