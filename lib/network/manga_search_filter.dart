import 'package:flutter/foundation.dart';

import 'order.dart';
import 'package:date_time_format/date_time_format.dart';

class MangaSearchFilter {
  int limit;
  int offset;
  String? title;
  int? year;

  /// uuids
  List<String> authors;

  /// uuids
  List<String> artists;

  /// uuids
  List<String> includedTags;
  TagMode includedTagsMode;

  /// uuids
  List<String> excludedTags;
  TagMode excludedTagsMode;
  List<Status> status;
  List<String> originalLanguage;
  List<String> excludedOriginalLanguage;
  List<String> availableTranslatedLanguage;
  List<Demographic> publicationDemographic;

  /// uuids
  List<String> ids;
  List<ContentRating> contentRating;

  /// YYYY-MM-DDTHH:MM:SS
  DateTime? createdAtSince;
  DateTime? updatedAtSince;
  Order order; // ???
  List<MangaInclude> includes;

  MangaSearchFilter({
    this.limit = 10,
    this.offset = 0,
    this.title,
    this.year,
    this.authors = const [],
    this.artists = const [],
    this.includedTags = const [],
    this.includedTagsMode = TagMode.AND,
    this.excludedTags = const [],
    this.excludedTagsMode = TagMode.OR,
    this.status = const [],
    this.originalLanguage = const [],
    this.excludedOriginalLanguage = const [],
    this.availableTranslatedLanguage = const [],
    this.publicationDemographic = const [],
    this.ids = const [],
    this.contentRating = const [ContentRating.safe, ContentRating.suggestive, ContentRating.erotica],
    this.createdAtSince,
    this.updatedAtSince,
    this.order = const Order.desc("latestUploadedChapter"),
    this.includes = const [],
  });

  MangaSearchFilter.recentlyAdded({
    required int offset,
    required int limit,
  }) : this(
      offset: offset,
      limit: limit,
      order: const Order.desc("createdAt"),
      contentRating: const [ContentRating.safe], // , ContentRating.suggestive, ContentRating.erotica
      includes: [MangaInclude.cover_art, MangaInclude.artist, MangaInclude.author]);

  MangaSearchFilter.ids({required List<String> mangaIds})
      : this(
    limit: mangaIds.length,
    ids: mangaIds,
    contentRating: const [
      ContentRating.safe,
      ContentRating.suggestive,
      ContentRating.erotica,
      ContentRating.pornographic
    ],
    includes: [MangaInclude.cover_art, MangaInclude.artist, MangaInclude.author],
  );

  Map<String, dynamic> toQueryParameters() {
    // var x = DateTime.now();
    // print(x.toIso8601String());
    // print(x.format(r"Y-m-d\TH:i:s"));
    // print(x.format());

      return {
        'limit': limit,
        'offset': offset,
        if (title != null) 'title': title,
        if (year != null) 'year': year,
        'authors': authors,
        'artists': artists,
        'includedTags[]': includedTags,
        'includedTagsMode': describeEnum(includedTagsMode),
        'excludedTags[]': excludedTags,
        'excludedTagsMode': describeEnum(excludedTagsMode),
        'status[]': status.map((e) => describeEnum(e)).toList(),
        'originalLanguage[]': originalLanguage,
        'excludedOriginalLanguage[]': excludedOriginalLanguage,
        'availableTranslatedLanguage[]': availableTranslatedLanguage,
        'publicationDemographic[]': publicationDemographic.map((e) => describeEnum(e)).toList(),
        'ids[]': ids,
        'contentRating[]': contentRating.map((e) => describeEnum(e)).toList(),
        if (createdAtSince != null) 'createdAtSince': createdAtSince!.toIso8601String(),
        if (updatedAtSince != null) 'updatedAtSince': updatedAtSince!.toIso8601String(),
        'order[${order.key}]': order.direction,
        'includes[]': includes.map((e) => describeEnum(e)).toList(),
      };
  }
}

enum TagMode { AND, OR }
enum Status { ongoing, completed, hiatus, cancelled }
enum Demographic { shounen, shoujo, josei, seinen, none }
enum ContentRating { safe, suggestive, erotica, pornographic }
enum MangaInclude { cover_art, artist, author }
