class Chapter {
  String id;
  String? volume;
  String? chapter;
  String? title;
  int pages;
  String? uploader;
  String translatedLanguage;
  //String hash;
  //List<String> data;
  //List<String> dataSaver;
  String? externalUrl;
  String mangaId;
  String? scanlationId;
  String? userId;
  DateTime publishAt;
  DateTime createdAt;
  DateTime updatedAt;
  int version;

  Chapter(
      {required this.id,
      required this.volume,
      required this.chapter,
      required this.title,
      required this.pages,
      required this.uploader,
      required this.translatedLanguage,
//      required this.hash,
//       required this.data,
//       required this.dataSaver,
      required this.externalUrl,
      required this.publishAt,
      required this.createdAt,
      required this.updatedAt,
      required this.version,
      required this.mangaId,
      this.scanlationId,
      this.userId});

  @override
  String toString() {
    return 'Chapter{id: $id, volume: $volume, chapter: $chapter, title: $title, pages: $pages, uploader: $uploader, translatedLanguage: $translatedLanguage, externalUrl: $externalUrl, mangaId: $mangaId, scanlationId: $scanlationId, userId: $userId, publishAt: $publishAt, createdAt: $createdAt, updatedAt: $updatedAt, version: $version}';
  }
}
