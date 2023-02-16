import 'package:dio/dio.dart';
import 'package:md_fclient/models/login_data.dart';

class LoginParsers {
  static LoginData parseLoginData(Response response) {
    var results = response.data;
    if (results['message'] != null){
      return LoginData(token: results["token"]["session"],refreshToken: results["token"]["refresh"], message: results['message']);
    }else{
      return LoginData(token: results["token"]["session"],refreshToken: results["token"]["refresh"]);
    }
  }
}