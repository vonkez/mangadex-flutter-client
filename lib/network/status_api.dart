
import 'package:flutter/foundation.dart';
import 'package:md_fclient/network/parsers.dart';
import 'package:md_fclient/ui/login_controller.dart';

import '../utils/auth.dart';
import 'api_base.dart';
import 'package:dio/dio.dart';

enum ReadStatus { reading, on_hold, plan_to_read, dropped, re_reading, completed, not_reading }

mixin StatusApi on Api {
  Future<ReadStatus> getStatus(String mangaId) async {
    print('getStatus called');
    var token = await Auth.to.getSessionToken();
    var options = Options(headers: {"Authorization": "Bearer "+ token});
    try {
      var response = await dio.get('https://api.mangadex.org/manga/$mangaId/status', options: options);
      var statusString = response.data['status'];
      if(statusString == null){
        return ReadStatus.not_reading;
      }else {
        return ReadStatus.values.firstWhere((e) => describeEnum(e) == statusString);
      }
    } on DioError catch (e){
      print("getStatus error:");
      print(e);
      rethrow;
    }
  }

  Future<void> changeStatus(String mangaId, ReadStatus status) async {
    print('changeStatus called');
    var token = await Auth.to.getSessionToken();
    var options = Options(headers: {"Authorization": "Bearer "+ token});
    try {
      var data = { 'status': status == ReadStatus.not_reading ? 'null' : describeEnum(status) };
      var response = await dio.post('https://api.mangadex.org/manga/$mangaId/status', options: options, data: data);
    } catch (e) {
      print("changeStatus error:");
      print(e);
      rethrow;
    }
  }

  Future<Map<String, ReadStatus>> getAllStatuses() async {
    print('getAllStatuses called');
    var token = await Auth.to.getSessionToken();
    var options = Options(headers: {"Authorization": "Bearer "+ token});
    try {
      var response = await dio.get('https://api.mangadex.org/manga/status', options: options);
      return Parsers.parseStatusesReponse(response);
    } catch (e) {
      print("getAllStatuses error:");
      print(e);
      rethrow;
    }
  }

}