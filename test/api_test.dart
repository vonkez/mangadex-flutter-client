import 'package:dio/dio.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:md_fclient/models/chapter.dart';
import 'package:md_fclient/models/login_data.dart';
import 'package:md_fclient/models/manga_feed.dart';
import 'package:md_fclient/network/api_base.dart';
import 'package:md_fclient/network/login_api.dart';
import 'package:md_fclient/network/manga_search_filter.dart';
import 'package:md_fclient/network/mangadex.dart';
import 'package:md_fclient/ui/login_controller.dart';

void main() async {
  test("test qp", () async{

    Dio dio = Dio();
    var filter = MangaSearchFilter.recentlyAdded(offset: 0, limit: 1);
    var filter2 = MangaSearchFilter(offset: 0, limit: 1,updatedAtSince: DateTime.now() );

    var response = await dio.get('https://httpbin.org/anything', queryParameters: filter2.toQueryParameters());
    print(response);

  });

  test("fetch recently added manga", () async {
    var api = Mangadex();
    var filter = MangaSearchFilter.recentlyAdded(offset: 0, limit: 1);
    var mangaList = await api.searchManga(filter);
    print(mangaList);
    expect(mangaList.length, 1);
  });

  test("fetch recently added chapters", () async {
    var api = Mangadex();
    var chapterList = await api.getRecentlyAddedChapters(limit: 5, );
    print(chapterList);
    expect(chapterList.length, 5);
  });

  test("fetch feed(chapters)", () async {
    var api = Mangadex();
    MangaFeed r  = await api.getFeed("a96676e5-8ae2-425e-b549-7f15dd34a6d8", 0, 10);
    MangaFeed r2 = await api.getFeed("a96676e5-8ae2-425e-b549-7f15dd34a6d8", 10, 25);
    print(r);
    print(r2);
    expect(r.chapters.length, 10);
    expect(r2.chapters.length, 25);
    expect(r.limit, 10);
    expect(r2.limit, 25);

  });

  test("fetch multiple mangas by id", () async {
    var api = Mangadex();
    var testIds = [
      "59b36734-f2d6-46d7-97c0-06cfd2380852",
      "b0b828a8-a886-449d-8a02-a06195b72a98",
      "bad2a52f-c5de-4099-aa19-f5e661187c35",
      "b98c4daf-be1a-46c8-ad83-21d532995240",
      "32a90765-87fc-4f22-9dc5-b77e9d20be19",
      "cbb22826-963e-4602-a5cd-a50c75723d59",
      "94cb0f39-5ebf-4fe9-b1df-aa998402325a",
      "8c7a252c-abbe-40b7-b0aa-0a9ca6f70032",
      "e11f3357-bf46-4f9f-8b41-54be28752c1f",
      "8dff0a68-5aca-4f77-9dd8-5f1355d364c4",
      "16d99766-e3ce-48dd-ae64-f46b482476ab",
      "5c3e27c4-2ff1-4b66-968e-8b813653192e",
      "fd5b5228-a652-4fe2-bdaa-e2b6ebb94b66",
      "c9e29253-aeb0-4fc0-a218-a62906e8eb18",
      "f9c33607-9180-4ba6-b85c-e4b5faee7192",
      "34f043ef-a423-422a-8e26-a54720645ee5",
      "83e76ec7-6a27-4fa4-a413-ba2a992d7df2",
      "51e2113a-6d92-4922-858f-352b11224fe5",
      "e2982fd3-8639-4148-a878-7be25362a09e",
      "88c23163-760a-49a2-a4f2-9d7877eb6efb",
      "2590f6b1-2188-477c-b31e-f5090c583ffd",
      "5b2cdbf6-9f64-4a01-9fd3-33b51724f9d3"
    ];

    var mangaList = await api.getManga(testIds);
    print(mangaList);
    expect(mangaList.length, 22);
  });

  test("fetch chapter data", () async {
    var api = Mangadex();
    var chapter = Chapter(
      id: "80daa1e1-d1ae-4402-b8b6-096be137fa7b",
      externalUrl: null,
      uploader: null,
      title: 'Oneshot',
      chapter: null,
      mangaId: '0059301b-9aa5-4dbe-98a0-a1cdde873332',
      volume: null,
      pages: 41,
      publishAt: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      translatedLanguage: '',
      version: 1
    );
    var chapterData = await api.getChapterData(chapter);
    print(chapterData);
    expect(chapterData.data.length, chapter.pages);
    expect(chapterData.data.length, chapterData.dataSaver.length);
    expect(chapterData.hash.isNotEmpty, true);
  });
  /*
  test("login test", () async {
    var api = Mangadex();

    LoginData loginData = await api.login("vonkez", "VeEHvx6TMn47t9bp");
    print(loginData);
    try {
      await api.login("vonkez", "1234534533");
      fail("Exception not thrown");
    } catch (e){
      print(e);
      expect(e, isInstanceOf<UserPassMatchException>());
    }

    try {
      await api.login("kakakeoeo", "1234534533");
      fail("Exception not thrown");
    } catch (e){
      print(e);
      expect(e, isInstanceOf<UserPassMatchException>());
    }

    expect(loginData.token.isNotEmpty, true);
    expect(loginData.refreshToken.isNotEmpty, true);
  });

  test("refresh test", () async {
    throw UnimplementedError();
  });
  */

}
