import 'package:md_fclient/models/chapter.dart';
import 'package:md_fclient/network/parsers.dart';

import 'api_base.dart';

mixin ChapterSearchApi on Api {
  Future<List<Chapter>> getRecentlyAddedChapters({int limit = 1}) async {
    print('getRecentlyAddedChapters called');
    var qp = {
      'limit': limit,
      'translatedLanguage[]': ['en'],
      'contentRating[]': ["safe", "suggestive", "erotica"], // safe
      'order[publishAt]': 'desc',
      'includes[]': ['manga']
    };
    var response = await dio.get('https://api.mangadex.org/chapter', queryParameters: qp);
    var result = Parsers.parseChapterSearchResponse(response);
    return result;
  }

}