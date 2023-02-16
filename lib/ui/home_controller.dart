import 'package:get/get.dart';
import 'package:md_fclient/network/mangadex.dart';
import 'package:md_fclient/utils/extensions.dart';
import 'package:md_fclient/models/manga.dart';
import 'package:path_provider/path_provider.dart' as pp;

import '../network/api_base.dart';


class HomeController extends GetxController {
  static HomeController get to => Get.find();

  var api = Mangadex();
  List<Manga> recentlyAddedMangas = <Manga>[].obs;
  List<Manga> mangasWithRecentChapters = <Manga>[].obs;

  @override
  void onInit() async {
    var f1 = updateRecentlyAddedMangas();
    var f2 = updateMangasWithRecentChapters();
    await f1;
    await f2;
    print("oninit home");
    // var x = await pp.getExternalStorageDirectory();
    // print(x?.path);
    super.onInit();
  }

  Future<void> updateRecentlyAddedMangas() async {
    recentlyAddedMangas.clear();
    recentlyAddedMangas.assignAll(await api.getRecentlyAddedManga(limit: 8));
  }

  Future<void> updateMangasWithRecentChapters() async {
    mangasWithRecentChapters.clear();
    var chapters = (await api.getRecentlyAddedChapters(limit: 16)).groupBy((chapter) => chapter.mangaId);
    var mangas = await api.getManga(chapters.keys.toList());
    for (var element in mangas) {
      element.recentChapters = chapters[element.id]!;
    }
    mangasWithRecentChapters.assignAll(mangas);
  }
}