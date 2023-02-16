import 'chapter.dart';

class ChapterData {
  Chapter chapter;
  String baseUrl;
  String hash;
  List<String> data;
  List<String> dataSaver;

  ChapterData({
    required this.chapter,
    required this.baseUrl,
    required this.hash,
    required this.data,
    required this.dataSaver,
  });

  String getImageUrl(int index){
    // https://uploads.mangadex.org/data/ff0c027111e28f3945ea6ab6a332b208/x1-c4e63c1721b72689e720dd3ad4ad86153f6f571ef078352cc64dadbd0612f129.jpg
    // TODO: add data saver
    // return "$baseUrl/data-saver/$hash/${dataSaver[0]}";
    return "$baseUrl/data/$hash/${data[index]}";

  }

  @override
  String toString() {
    return 'ChapterData{chapter: $chapter, baseUrl: $baseUrl, hash: $hash, data: $data, dataSaver: $dataSaver}';
  }

}
