import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class DetailsChapterTile extends StatelessWidget {
  bool external;
  String? externalUrl;
  String name;
  String? chapterNo;
  DateTime date;
  void Function() onTap;

  DetailsChapterTile({
    required this.name,
    required this.chapterNo,
    required this.date,
    required this.onTap,
    this.external = false,
    required this.externalUrl,
    Key? key,
  }): super(key: key);

  void _launchURL(_url) async {
    if (!await launch(_url)) throw 'Could not launch $_url';
  }

  @override
  Widget build(BuildContext context) {
    var title = (chapterNo != null ? "Chapter " + chapterNo! : "") + " - " + name;

    return ListTile(
        onTap: external ? ()=>_launchURL(externalUrl) : onTap,
        title: Text(title),
        subtitle: Text("Scantlation"),
        trailing: SizedBox(
          width: 90,
          child: Row(
            children: [
              const Icon(Icons.schedule),
              Container(
                  margin: const EdgeInsets.only(left:4),
                  width: 60,
                  child: Text(
                    timeago.format(date),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                  )
              ),
            ],
          ),
        ),

    );
  }
}