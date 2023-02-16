import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get.dart';
import 'package:md_fclient/models/chapter.dart';
import 'package:md_fclient/models/manga.dart';
import 'package:md_fclient/network/mangadex.dart';
import 'package:md_fclient/network/status_api.dart';
import '../utils/auth.dart';
import '../network/api_base.dart';
import 'library_controller.dart';


class MangaDetailsController extends GetxController {
  var api = Mangadex();
  var scrollController = ScrollController();
  late Rx<Manga> manga;

  MangaDetailsController(Manga manga): super() {
    this.manga = manga.obs;
    this.scrollController.addListener(() { scrollAtTop.value = scrollController.offset < 30 ? true: false;  });
    onInit();
    print("constr details");

  }
  /// initial loadings
  var mangaLoaded = true.obs;
  var chaptersLoaded = false.obs;
  var userDataLoaded = false.obs;

  var chaptersLoading = false.obs;
  var scrollAtTop = true.obs;
  RxInt offset = 0.obs;
  RxInt total = 0.obs;
  List<Chapter> chapters = <Chapter>[].obs;
  var following = false.obs;
  var status = ReadStatus.not_reading.obs;


  @override
  void onInit() async {
    print("oninit details");
    await loadMoreChapters(96);
    if(Auth.to.loggedIn.value){
      await loadUserData();
    }

    chaptersLoaded.value = true;
  }

  Future<void> refreshAll() async{
    mangaLoaded.value = false;
    chaptersLoaded.value = false;
    offset.value = 0;
    total.value = 0;
    chapters.clear();

    manga.value = (await api.getManga([manga.value.id]))[0];
    mangaLoaded.value = true;
    await loadMoreChapters(96);
    chaptersLoaded.value = true;
  }

  Future<void> loadMoreChapters(int amount) async {
    chaptersLoading.value = true;
    var feed = await api.getFeed(manga.value.id, offset.value, offset.value+amount);
    offset += amount;
    total.value = feed.total;
    chapters.addAll(feed.chapters);
    chaptersLoading.value = false;

  }

  Future<void> loadUserData() async {
    following.value = await api.isFollowingManga(manga.value.id);
    status.value = await api.getStatus(manga.value.id);
    print("follow: ${following.value}");
    print("status: ${status.value}");
    userDataLoaded.value = true;
  }

  Future<void> changeStatus(ReadStatus readStatus) async {
    await api.changeStatus(manga.value.id, readStatus);
    LibraryController.to.libraryMangas[status.value]!.removeWhere((element) => element.id == manga.value.id);
    LibraryController.to.libraryMangas[readStatus]!.add(manga.value);
    status.value = readStatus;
  }

  Future<void> follow() async {
    var success = await api.followManga(manga.value.id);
    if(success) {
      following.value = true;
    }
  }

  Future<void> unFollow() async {
    var success = await api.unfollowManga(manga.value.id);
    if(success) {
      following.value = false;
    }
  }


}