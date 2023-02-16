import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:md_fclient/utils/extensions.dart';

import 'package:md_fclient/ui/safe_future_builder.dart';

import 'feed_item.dart';

import 'home_controller.dart';
import 'manga_details.dart';
import 'network_image_hero.dart';

class Home extends StatelessWidget {
  Home({Key? key, required this.tabController}) : super(key: key);
  TabController tabController;

  @override
  Widget build(BuildContext context) {
    return TabBarView(controller: tabController, children: [
      // first tab
      Obx(
        () {
          if (HomeController.to.recentlyAddedMangas.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return GridView.builder(
                padding: const EdgeInsets.all(20.0),
                itemCount: HomeController.to.recentlyAddedMangas.length,
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
                          imageUrl: HomeController
                              .to.recentlyAddedMangas[index].coverUrl+ ".256.jpg",
                          onTap: () {
                            Navigator.of(context).push(
                                MaterialPageRoute<void>(builder: (context) {
                              return MangaDetails(
                                  manga: HomeController
                                      .to.recentlyAddedMangas[index]);
                            }));
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          HomeController.to.recentlyAddedMangas[index].title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  );
                });
          }
        },
      ),
      // second tab
      Obx(() {
        if (HomeController.to.mangasWithRecentChapters.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            padding: const EdgeInsets.only(right: 2, left: 6, top:8),
              itemCount: HomeController.to.mangasWithRecentChapters.length,
              itemBuilder: (context, index) {
                return FeedItem(
                    manga: HomeController.to.mangasWithRecentChapters[index]);
              });
        }
      })
    ]);
  }
}
