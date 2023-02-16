import 'dart:ui';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:expandable/expandable.dart';
import 'package:md_fclient/network/status_api.dart';
import 'package:md_fclient/ui/reader/reader.dart';
import 'package:md_fclient/utils/extensions.dart';
import 'package:md_fclient/models/manga.dart';
import 'package:md_fclient/ui/titled_chips.dart';


import 'details_chapter_tile.dart';
import 'manga_details_controller.dart';
import 'network_image_hero.dart';


class MangaDetails extends StatelessWidget {
  Manga manga;
  late MangaDetailsController controller;
  var selected = ReadStatus.dropped.obs;

  MangaDetails({Key? key, required this.manga}) : super(key: key) {
    controller = MangaDetailsController(manga);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      controller: controller.scrollController,
      slivers: [
        SliverAppBar(
          pinned: false,
          floating: true,
          centerTitle: true,
          //backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () => null,
            )
          ],

          title: Obx(() => AnimatedOpacity(
              opacity: controller.scrollAtTop.value ? 0 : 1,
              duration: const Duration(milliseconds: 500),
              child: Text(controller.manga.value.title))),
        ),

        /// HEADER TOP
        SliverToBoxAdapter(
            child: Stack(
          alignment: Alignment.bottomCenter,
          children: [_createHeaderBackground(context), _createHeader(context)],
        )),

        /// CHIPS
        SliverToBoxAdapter(
            child: Padding(
          padding: const EdgeInsets.only(right: 15.0, left: 15, bottom: 10),
          child: Wrap(
            spacing: 8,
            runSpacing: 4,
            children: _createTopChips(),
          ),
        )),

        /// BUTTONS
        SliverToBoxAdapter(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Spacer(flex: 1),
              Expanded(
                flex: 9,
                child: Obx(()=>PopupMenuButton<ReadStatus>(
                  icon: Row(
                    children: [
                      Flexible(flex:1,child: Text(_getStatusText(controller.status.value))),
                      const Icon(Icons.arrow_drop_down_outlined)
                    ],
                  ),
                  initialValue: controller.status.value,
                  onSelected: (v)=> controller.changeStatus(v),
                  itemBuilder: (context) => <PopupMenuEntry<ReadStatus>>[
                    const PopupMenuItem<ReadStatus>(
                        value:ReadStatus.completed,
                        child: Text('Completed')
                    ),
                    const PopupMenuItem<ReadStatus>(
                        value:ReadStatus.dropped,
                        child: Text('Dropped')
                    ),
                    const PopupMenuItem<ReadStatus>(
                        value:ReadStatus.on_hold,
                        child: Text('On hold')
                    ),
                    const PopupMenuItem<ReadStatus>(
                        value:ReadStatus.reading,
                        child: Text('Reading')
                    ),
                    const PopupMenuItem<ReadStatus>(
                        value:ReadStatus.plan_to_read,
                        child: Text('Plan to read')
                    ),
                    const PopupMenuItem<ReadStatus>(
                        value:ReadStatus.re_reading,
                        child: Text('Re reading')
                    ),
                    const PopupMenuItem<ReadStatus>(
                        value:ReadStatus.not_reading,
                        child: Text('Not reading')
                    ),
                  ],
                ),),
              ),
              const Spacer(flex: 1),
              _getFollowButton(),
              const Spacer(flex: 1),
              Expanded(
                flex: 16,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.play_arrow),
                  label: const Text("Start reading"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(1, 38), // double.infinity is the width and 30 is the height
                  ),
                ),
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
        const SliverToBoxAdapter(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
          child: Text(
            "Synopsis",
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
          ),
        )),

        /// Expandable
        SliverToBoxAdapter(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: ExpandableNotifier(
            controller: ExpandableController(initialExpanded: false),
            child: Column(
              children: [
                Expandable(
                  theme: const ExpandableThemeData(
                    crossFadePoint: 0.7,
                    animationDuration: Duration(milliseconds: 150),
                    scrollAnimationDuration: Duration(milliseconds: 150),
                  ),

                  /// COLLAPSED
                  collapsed: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.manga.value.description,
                        softWrap: true,
                        maxLines: 3,
                        overflow: TextOverflow.fade,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                      const Divider(
                        //color: const Color.fromRGBO(255, 103, 64, 1),
                        thickness: 1,
                      ),
                      ExpandableButton(
                        child: const Icon(Icons.keyboard_arrow_down),
                      )
                    ],
                  ),

                  /// EXPANDED
                  expanded: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.manga.value.description,
                        softWrap: true,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(height: 8,),
                      /// EXPANDED CONTENT
                      Wrap(
                        spacing: 12,
                        children: _createTagChips(),
                        runSpacing: 4,
                      ),
                      const Divider(
                        //color: const Color.fromRGBO(255, 103, 64, 1),
                        thickness: 1,
                      ),
                      Center(
                        child: ExpandableButton(
                          child: const Icon(Icons.keyboard_arrow_up),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        )),

        /// CHAPTERS
        Obx(() {
          if (controller.chaptersLoaded.value) {
            return SliverList(delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
              print("index: " + index.toString());
              print("chapters: " + controller.chapters.length.toString());
              print("total: " + controller.total.value.toString());
              print("loading new: " + controller.chaptersLoading.value.toString());
              print("------------------");
              if (index >= controller.total.value) {
                return null;
              }else if (index == controller.chapters.length){
                if(controller.chaptersLoading.value) {
                  return Center(heightFactor: 3, child: CircularProgressIndicator() ,key: UniqueKey(),);
                } else {
                  return InkWell(
                    child: const Center(heightFactor: 3, child: Text("Load More")),
                    onTap: () {
                      //controller.chapters.shuffle();
                      controller.loadMoreChapters(96);
                    },
                    key: UniqueKey(),
                  );
                }

              } else if (index > controller.chapters.length){
                return null;
              } else {
                return DetailsChapterTile(
                  key: UniqueKey(),
                  chapterNo: controller.chapters[index].chapter,
                  name: controller.chapters[index].title ?? "Chapter ${controller.chapters[index].chapter}",
                  date:  controller.chapters[index].publishAt,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute<void>(builder: (context) {
                      return Reader(
                        chapter: controller.chapters[index],
                        pageCount: controller.chapters[index].pages,
                        title: controller.chapters[index].title ?? "Chapter ${controller.chapters[index].chapter}",
                      );
                    }));
                  },
                  external: controller.chapters[index].externalUrl != null && controller.chapters[index].externalUrl!.isNotEmpty,
                  externalUrl: controller.chapters[index].externalUrl,
                );
              }
            },
            addAutomaticKeepAlives: false,
            ));
          } else {
            return const SliverToBoxAdapter(
                child: Center(heightFactor: 5, child: CircularProgressIndicator())
            );
          }
        })
      ],
    ));

    return Center(
      child: NetworkImageHero(
        imageUrl: manga.coverUrl,
        onTap: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  List<TitledChips> _createTagChips() {
    List<TitledChips> result = List.empty(growable: true);

    if (controller.manga.value.artist != null) {
      result.add(TitledChips(
          title: "Artist",
          chipContent: [controller.manga.value.artist!.name]
      ));
    }

    if (controller.manga.value.author != null) {
      result.add(TitledChips(
          title: "Author",
          chipContent: [controller.manga.value.author!.name ]
      ));
    }

    var grouped = controller.manga.value.tags.groupBy((e) => e.group);
    grouped.forEach((key, value) {
      String title;
      switch (key) {
        case "genre":
          title = "Genres";
          break;
        case "format":
          title = "Format";
          break;
        case "theme":
          title = "Themes";
          break;
        default:
          title = "?????!!";
      }
      result.add(
          TitledChips(
              title: title,
              chipContent: value.map((e) => e.name).toList()
          )
      );
    });

    if (controller.manga.value.publicationDemographic != null) {
      result.add(TitledChips(
          title: "Demographic",
          chipContent: [controller.manga.value.publicationDemographic!.capitalizeFirst! ]
      ));
    }

    return result;
  }

  List<ActionChip> _createTopChips() {
    List<ActionChip> result = List.empty(growable: true);
    controller.manga.value.tags.forEach((tag) {
      if (tag.group == "genre" || tag.group == "format") {
        result.add(ActionChip(
          label: Text(tag.name),
          onPressed: () {},
          visualDensity: VisualDensity(horizontal: 0.0, vertical: -1),
        ));
      } else if (tag.group == "content"){
        result.add(ActionChip(
          label: Text(tag.name),
          backgroundColor: Colors.red,
          onPressed: () {},
          visualDensity: VisualDensity(horizontal: 0.0, vertical: -1),
        ));
      }
      // TODO: add content rating
    });
    return result;
  }

  String _createArtistAuthorString() {
    String str = "";
    if (controller.manga.value.author != null) {
      str += controller.manga.value.author!.name;
    }
    if (controller.manga.value.artist != null) {
      str += ", ";
      str += controller.manga.value.artist!.name;
    }
    return str;
  }

  Widget _getFollowButton(){
    return Obx((){
      if (controller.following.value) {
        return ElevatedButton(

          onPressed: () => controller.unFollow(),
          child: const Icon(Icons.bookmark),
          style: ElevatedButton.styleFrom(
            primary: Colors.green,
            minimumSize: const Size(1, 38), // double.infinity is the width and 30 is the height
          ),
        );
      } else {
        return ElevatedButton(
          onPressed: () => controller.follow(),
          child: const Icon(Icons.bookmark_outline_rounded),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(1, 38), // double.infinity is the width and 30 is the height
          ),
        );
      }
    });
  }

  Widget _createHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          NetworkImageHero(
            height: 175,
            imageUrl: manga.coverUrl+".256.jpg",
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(controller.manga.value.title,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w700,
                      )),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    controller.manga.value.altTitles.isNotEmpty ? controller.manga.value.altTitle : "",
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    _createArtistAuthorString(),
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _createHeaderBackground(BuildContext context) {
    return Container(
      height: 230,
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: const [0.5, 1],
              colors: [Theme.of(context).colorScheme.background, Colors.transparent]).createShader(bounds);
        },
        child: Stack(
          children: [
            // TODO: add fade
            Obx(() => ExtendedImage.network(
                  controller.manga.value.coverUrl,
                  fit: BoxFit.cover,
                  height: 223,
                  width: 6000,
                  filterQuality: FilterQuality.medium,
                )),
            BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                child: Container(color: Colors.black.withOpacity(0.1))),
          ],
        ),
      ),
    );
  }

  String _getStatusText(ReadStatus readStatus){
    switch (readStatus) {

      case ReadStatus.reading:
        return "Reading";
        break;
      case ReadStatus.on_hold:
        return "On hold";
        break;
      case ReadStatus.plan_to_read:
        return "Plan to read";
        break;
      case ReadStatus.dropped:
        return "Dropped";
        break;
      case ReadStatus.re_reading:
        return "Re reading";
        break;
      case ReadStatus.completed:
        return "Completed";
        break;
      case ReadStatus.not_reading:
        return "Not reading";
        break;
    }
  }
}
