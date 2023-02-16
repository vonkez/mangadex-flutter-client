
import 'package:md_fclient/models/manga.dart';
import 'package:md_fclient/network/parsers.dart';
import 'package:md_fclient/ui/login_controller.dart';

import '../utils/auth.dart';
import 'api_base.dart';
import 'package:dio/dio.dart';

mixin FollowApi on Api {
  Future<bool> isFollowingManga(String mangaId) async {
    print('isFollowingManga called');
    var token = await Auth.to.getSessionToken();
    var options = Options(headers: {"Authorization": "Bearer "+ token});
    try {
      var response = await dio.get('https://api.mangadex.org/user/follows/manga/$mangaId', options: options);
      return true;
    } on DioError catch (e){
      if(e.response != null && e.response?.statusCode == 404){
        return false;
      } else{
        print("isFollowingManga error:");
        print(e);
        return false;
      }
    }
  }

  Future<bool> followManga(String mangaId) async {
    print('followManga called');
    var token = await Auth.to.getSessionToken();
    var options = Options(headers: {"Authorization": "Bearer "+ token});
    try {
      var response = await dio.post('https://api.mangadex.org/manga/$mangaId/follow', options: options);
      return true;
    } catch (e) {
      print("followManga error:");
      print(e);
      return false;
    }
  }

  Future<bool> unfollowManga(String mangaId) async {
    print('unfollowManga called');
    var token = await Auth.to.getSessionToken();
    var options = Options(headers: {"Authorization": "Bearer "+ token});
    try {
      var response = await dio.delete('https://api.mangadex.org/manga/$mangaId/follow', options: options);
      return true;
    } catch (e) {
      print("unfollowManga error:");
      print(e);
      return false;
    }
  }

  Future<List<Manga>> getFollowedManga() async {
    print('getFollowedManga called');
    var token = await Auth.to.getSessionToken();
    var options = Options(headers: {"Authorization": "Bearer "+ token});
    try {
      var response = await dio.get('https://api.mangadex.org/user/follows/manga', options: options);
      var mangas = Parsers.parseMangaSearchResponse(response);
      return mangas;
    } catch (e) {
      print("getFollowedManga error:");
      print(e);
      rethrow;
    }
  }
}