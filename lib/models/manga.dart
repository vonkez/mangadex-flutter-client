import 'package:md_fclient/models/author.dart';
import 'package:md_fclient/models/cover_art.dart';
import 'package:md_fclient/models/tag.dart';

import 'artist.dart';
import 'chapter.dart';

class Manga {
  String id;
  Map<String, String> titles; // lang -> title
  List<String> altTitles;
  String description;
  Map<String, String> links;
  String? status;
  String originalLanguage;
  String? publicationDemographic;
  String contentRating;
  List<Tag> tags;
  CoverArt? coverArt;
  Author? author;
  Artist? artist;
  DateTime createdAt;
  DateTime updatedAt;
  int version;
  List<Chapter> recentChapters = [];

  Manga({
    required this.id,
    required this.titles, // lang -> title
    required this.altTitles,
    required this.description,
    required this.links,
    required this.status,
    required this.originalLanguage,
    required this.publicationDemographic,
    required this.contentRating,
    required this.tags,
    required this.coverArt,
    // TODO: multiple artists/authors
    required this.author,
    required this.artist,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  });

  String get title {
    return titles['en'] ?? titles.values.first;
  }
  String get altTitle {
    return altTitles.first;
  }

  String get coverUrl {
    // TODO: coverArt null check
    return "https://uploads.mangadex.org/covers/$id/${coverArt!.filename}";
  }


  @override
  String toString() {
    return 'Manga{id: $id, title: $titles, altTitles: $altTitles, description: $description, links: $links, status: $status, originalLanguage: $originalLanguage, publicationDemographic: $publicationDemographic, contentRating: $contentRating, tags: $tags, coverArt: $coverArt, author: $author, artist: $artist, createdAt: $createdAt, updatedAt: $updatedAt, version: $version}';
  }
}
