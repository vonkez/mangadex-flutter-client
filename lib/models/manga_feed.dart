import 'chapter.dart';

class MangaFeed {
  List<Chapter> chapters;
  int limit;
  int offset;
  int total;

  MangaFeed({
    required this.chapters,
    required this.limit,
    required this.offset,
    required this.total,
  });

  @override
  String toString() {
    return 'MangaFeed{chapters: $chapters, limit: $limit, offset: $offset, total: $total}';
  }
}