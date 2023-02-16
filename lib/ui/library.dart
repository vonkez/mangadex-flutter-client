import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:md_fclient/ui/library_controller.dart';
import 'package:md_fclient/ui/manga_details.dart';
import 'package:md_fclient/ui/network_image_hero.dart';

import '../network/status_api.dart';
import '../utils/auth.dart';
import 'home_controller.dart';

class Library extends StatelessWidget {
  Library({Key? key, required this.tabController}) : super(key: key);
  TabController tabController;

  @override
  Widget build(BuildContext context) {
    return TabBarView(controller: tabController, children: [
      buildTab(ReadStatus.reading),
      buildTab(ReadStatus.on_hold),
      buildTab(ReadStatus.re_reading),
      buildTab(ReadStatus.plan_to_read),
      buildTab(ReadStatus.completed),
      buildTab(ReadStatus.dropped),
    ]);
  }

  Widget buildTab(ReadStatus readStatus){
    return Obx(
          () {
        if(!Auth.to.loggedIn.value){
          return const Center(child: Text("Login to access your library."));
        } else if (LibraryController.to.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return GridView.builder(
              padding: const EdgeInsets.all(20.0),
              itemCount: LibraryController.to.libraryMangas[readStatus]!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 5,
                  //childAspectRatio: 0.63,
                  mainAxisExtent: 268),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: NetworkImageHero(
                        height: 220,
                        imageUrl: LibraryController
                            .to.libraryMangas[readStatus]![index].coverUrl+ ".256.jpg",
                        onTap: () {
                          Navigator.of(context).push(
                              MaterialPageRoute<void>(builder: (context) {
                                return MangaDetails(
                                    manga: LibraryController
                                        .to.libraryMangas[readStatus]![index]);
                              }));
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        LibraryController.to.libraryMangas[readStatus]![index].title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                );
              });
        }
      },
    );
  }
}
