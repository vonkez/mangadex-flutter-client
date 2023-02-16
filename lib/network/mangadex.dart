import 'package:md_fclient/models/chapter_data.dart';
import 'package:md_fclient/models/manga.dart';
import 'package:md_fclient/network/chapter_search_api.dart';
import 'package:md_fclient/network/login_api.dart';
import 'package:md_fclient/network/manga_search_filter.dart';
import 'package:md_fclient/network/parsers.dart';
import 'package:md_fclient/network/manga_search_api.dart';
import 'package:md_fclient/network/status_api.dart';

import '../models/chapter.dart';
import 'dart:convert';

import '../models/manga_feed.dart';
import 'api_base.dart';
import 'follow_api.dart';

class Mangadex extends Api with MangaSearchApi, ChapterSearchApi, LoginApi, FollowApi, StatusApi {

  /*
  latest updates (chapters) https://api.mangadex.org/chapter?includes[]=manga&limit=36&translatedLanguage[]=en&contentRating[]=safe&contentRating[]=suggestive&contentRating[]=erotica&order[publishAt]=desc
  Recently Added (manga) https://api.mangadex.org/manga?limit=20&contentRating[]=safe&contentRating[]=suggestive&contentRating[]=erotica&order[createdAt]=desc
  covers https://api.mangadex.org/cover?ids[]=00be933f-74aa-4f24-978c-89e01abb3aa5&ids[]=60dce2cd-c0f0-4f11-bf56-2fc42902b547&ids[]=ae50091f-ac4b-4fc3-8257-7ad402119231&ids[]=d3acf6fa-937a-4ff1-8b14-03cb51a3221c&ids[]=e1db3db1-1254-4f46-ba52-b699adb5afe1&ids[]=a1c89740-4ec5-4f93-9af7-19868f9eb116&ids[]=2c8c2422-2c26-4fae-b7d1-b68450041d3c&ids[]=3fa41a4a-9a38-4f56-b18c-68d229ad9409&ids[]=40d8bf73-1a77-4f7f-bf0b-f86d1331b732&ids[]=1e42ae00-3130-4f89-8efb-1274149a8025&ids[]=6363ddac-55ce-4fe6-930c-47fde1b1e64f&ids[]=31bbd238-b856-4fff-8679-69c5041da0c5&ids[]=836c680f-f40d-4fff-bbd6-9fdcdac94afb&ids[]=d097d59a-3124-4fc0-b02b-c9ee1f4dbbcd&ids[]=07c08fae-8691-4f8d-9b7f-4d5701686cc0&ids[]=e4a31300-98a5-4fb4-b84f-17b6250621f2&ids[]=0af952f2-4e1c-4fe1-8b0f-9f392b14039d&ids[]=9493ed4a-84a9-4f2f-b323-5802b408aefc&ids[]=b2fc33b7-e2f8-4f71-b3c2-7a17cca78171&ids[]=71f2c07b-4b12-4f99-8d32-69cbf5aa5645&limit=20
  manga single https://api.mangadex.org/manga/bbaa17c4-0f36-4bbb-9861-34fc8fdf20fc?includes[]=artist&includes[]=author&includes[]=cover_art
  multi manga https://api.mangadex.org/manga?includes[]=cover_art&contentRating[]=safe&contentRating[]=suggestive&contentRating[]=erotica&contentRating[]=pornographic&ids[]=59b36734-f2d6-46d7-97c0-06cfd2380852&ids[]=b0b828a8-a886-449d-8a02-a06195b72a98&ids[]=bad2a52f-c5de-4099-aa19-f5e661187c35&ids[]=b98c4daf-be1a-46c8-ad83-21d532995240&ids[]=32a90765-87fc-4f22-9dc5-b77e9d20be19&ids[]=cbb22826-963e-4602-a5cd-a50c75723d59&ids[]=94cb0f39-5ebf-4fe9-b1df-aa998402325a&ids[]=8c7a252c-abbe-40b7-b0aa-0a9ca6f70032&ids[]=e11f3357-bf46-4f9f-8b41-54be28752c1f&ids[]=8dff0a68-5aca-4f77-9dd8-5f1355d364c4&ids[]=16d99766-e3ce-48dd-ae64-f46b482476ab&ids[]=5c3e27c4-2ff1-4b66-968e-8b813653192e&ids[]=fd5b5228-a652-4fe2-bdaa-e2b6ebb94b66&ids[]=c9e29253-aeb0-4fc0-a218-a62906e8eb18&ids[]=f9c33607-9180-4ba6-b85c-e4b5faee7192&ids[]=34f043ef-a423-422a-8e26-a54720645ee5&ids[]=83e76ec7-6a27-4fa4-a413-ba2a992d7df2&ids[]=51e2113a-6d92-4922-858f-352b11224fe5&ids[]=e2982fd3-8639-4148-a878-7be25362a09e&ids[]=88c23163-760a-49a2-a4f2-9d7877eb6efb&ids[]=2590f6b1-2188-477c-b31e-f5090c583ffd&ids[]=5b2cdbf6-9f64-4a01-9fd3-33b51724f9d3&limit=22
  chapter of manga https://api.mangadex.org/manga/a96676e5-8ae2-425e-b549-7f15dd34a6d8/feed?translatedLanguage[]=en&limit=96&includes[]=scanlation_group&includes[]=user&order[volume]=desc&order[chapter]=desc&offset=0&contentRating[]=safe&contentRating[]=suggestive&contentRating[]=erotica&contentRating[]=pornographic
  chapter data https://api.mangadex.org/at-home/server/1617b385-0705-4d74-bc9c-2da8d484d65a?forcePort443=false
   */


  Future<ChapterData> getChapterData(Chapter chapter, {bool forcePort443 = false}) async {
    var qp = {
      'forcePort443': forcePort443,
    };
    var response = await dio.get('https://api.mangadex.org/at-home/server/${chapter.id}', queryParameters: qp);
    var result = Parsers.parseChapterData(response, chapter);
    return result;
  }

  Future<List<String>> getCovers(List<Manga> manga) async {
    throw UnimplementedError();
  }


  ///  Returns Chapters of a manga
  Future<MangaFeed> getFeed(String mangaId, int offset, int limit) async {

    var qp = {
      'offset': offset,
      'limit': limit,
      'translatedLanguage[]': ["en"],
      'contentRating[]': ["safe"], // , "suggestive", "erotica", 'pornographic'
      'includes[]': ['scanlation_group', 'user'],
      'order[chapter]': 'desc',
      'order[volume]': 'desc',
    };
    var response = await dio.get('https://api.mangadex.org/manga/$mangaId/feed', queryParameters: qp);
    var result = Parsers.parseMangaFeedResponse(response);
    return result;
  }
}