import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:md_fclient/models/manga.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'manga_details.dart';
import 'network_image_hero.dart';



class FeedItem extends StatefulWidget {
  Manga manga;

  FeedItem({Key? key, required this.manga}) : super(key: key);

  @override
  State createState() => _FeedItemState();
}

class _FeedItemState extends State<FeedItem> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 16),
          height: 175,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: NetworkImageHero(
              width: 120,
              imageUrl: widget.manga.coverUrl + ".256.jpg",
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute<void>(builder: (context) {
                  return MangaDetails(manga: widget.manga);
                }));
              },
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child:
                Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          widget.manga.title,
                            maxLines: 2,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      ...getChapterWidgets()
                    ]
                ),
          ),
        )
      ],
    );
  }

  List<Widget> getChapterWidgets() {
    return widget.manga.recentChapters.map((_chapter) {

      String text = (_chapter.chapter != null ? "Chapter " + _chapter.chapter! : "") + (_chapter.title != null ?  " - " + _chapter.title! : "");

      return Card(
        margin: EdgeInsets.only(bottom: 3),
        child: Container(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                children: [
                  const Icon(Icons.schedule),
                  Text("  " + timeago.format(_chapter.createdAt)),
                ],
              )

            ],
          ),
        ),
      );
    }).toList();
  }
}
