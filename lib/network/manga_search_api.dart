import 'package:md_fclient/models/manga.dart';
import 'package:md_fclient/network/api_base.dart';
import 'package:md_fclient/network/manga_search_filter.dart';
import 'package:md_fclient/network/parsers.dart';

mixin MangaSearchApi on Api {
  Future<List<Manga>> searchManga(MangaSearchFilter filter) async {
    print('getMangaSearch called');
    var response = await dio.get('https://api.mangadex.org/manga', queryParameters: filter.toQueryParameters());
    var result = Parsers.parseMangaSearchResponse(response);
    return result;
  }

  // TODO: get rid of this
  Future<List<Manga>> getRecentlyAddedManga({int limit = 1}) async {
    print('getRecentlyAddedManga called');
    var filter = MangaSearchFilter.recentlyAdded(offset: 0, limit: limit);
    var response = await dio.get('https://api.mangadex.org/manga', queryParameters: filter.toQueryParameters());
    var result = Parsers.parseMangaSearchResponse(response);
    return result;
  }

  // TODO: and this(?)
  Future<List<Manga>> getManga(List<String> mangaIds) async {
    print('getManga called');
    var filter = MangaSearchFilter.ids(mangaIds: mangaIds);
    var response = await dio.get('https://api.mangadex.org/manga', queryParameters: filter.toQueryParameters());
    var result = Parsers.parseMangaSearchResponse(response);
    return result;
  }


}