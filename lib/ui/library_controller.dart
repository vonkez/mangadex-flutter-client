import 'dart:math';

import 'package:get/get.dart';
import 'package:md_fclient/models/manga.dart';
import 'package:md_fclient/network/mangadex.dart';
import 'package:md_fclient/utils/extensions.dart';
import '../utils/auth.dart';
import '../network/status_api.dart';

class LibraryController extends GetxController {
  static LibraryController get to => Get.find();

  var api = Mangadex();
  Map<ReadStatus, List<Manga>> libraryMangas = {for (var status in ReadStatus.values) status:List<Manga>.empty(growable: true).obs};
  var isLoading = true.obs;

  // List<Manga> mangasWithRecentChapters = <Manga>[].obs;

  @override
  void onInit() async {
    print("oninit libarycontroller");
    if(Auth.to.loggedIn.value){
      await downloadLibraryMangas();
    }
    ever(Auth.to.loggedIn, onLogin);
    // var x = await pp.getExternalStorageDirectory();
    // print(x?.path);
    super.onInit();
  }

  void onLogin(bool loggedIn) async {
    if(loggedIn){
      await downloadLibraryMangas();
    }
  }



  Future<void> downloadLibraryMangas() async {
    var statuses = await api.getAllStatuses();
    var mangas = await api.getManga(statuses.keys.toList());
    for (var manga in mangas) {
      var status = statuses[manga.id];
      libraryMangas[status!]!.add(manga);
    }
    isLoading.value = false;
  }

}
