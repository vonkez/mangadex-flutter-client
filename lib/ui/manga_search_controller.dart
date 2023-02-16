import 'package:get/get.dart';
import 'package:md_fclient/models/manga.dart';
import 'package:md_fclient/network/manga_search_filter.dart';
import 'package:md_fclient/network/mangadex.dart';
import 'package:md_fclient/network/order.dart';

class MangaSearchController extends GetxController {
  static MangaSearchController get to => Get.find();
  Mangadex api = Mangadex();
  var query = "".obs;
  var suggestions = <Manga>[].obs;
  var results = <Manga>[].obs;

  // Filters
  var demographic = <Demographic>[].obs;
  var status = <Status>[].obs;
  var contentRating = <ContentRating>[].obs;

  @override
  void onInit() async {

    debounce(query, (query) async {
      print("Search debounce: $query");
      await search();
    }, time: const Duration(seconds: 2));

    ever(query, (_) {
      if (_ == "") suggestions.clear();
    });

    print("oninit MangaSearch");

    super.onInit();
  }

  Future<void> search() async {
    // if (query.value == "") {
    //   suggestions.clear();
    //   return;
    // }

    var filter = MangaSearchFilter(
      offset: 0,
      limit: 5,
      title: query.value as String,
      order: const Order.desc("relevance"),
      status: status.value,
      publicationDemographic: demographic.value,
      contentRating: contentRating.value,
      includes: [MangaInclude.cover_art, MangaInclude.artist, MangaInclude.author],
    );
    var res = await api.searchManga(filter);
    suggestions.clear();
    suggestions.addAll(res);
    results.value = suggestions;
  }

}
