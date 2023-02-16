import 'package:dio/dio.dart';
import 'package:md_fclient/models/artist.dart';
import 'package:md_fclient/models/author.dart';
import 'package:md_fclient/models/chapter_data.dart';
import 'package:md_fclient/models/cover_art.dart';
import 'package:md_fclient/network/status_api.dart';

import '../models/chapter.dart';
import '../models/manga.dart';
import '../models/manga_feed.dart';
import '../models/tag.dart';

class Parsers {
  static MangaFeed parseMangaFeedResponse(Response response) {
    var results = response.data['data'];
    List<Chapter> chapters = results
        .map((chapter) => _chapterFromData(chapter))
        .toList()
        .cast<Chapter>();

    return MangaFeed(
      chapters: chapters,
      limit: response.data['limit'],
      offset: response.data['offset'],
      total: response.data['total'],
    );
  }

  static List<Chapter> parseChapterSearchResponse(Response response) {
    var results = response.data['data'];
    return results
        .map((chapter) {
      return _chapterFromData(chapter);
    })
        .toList()
        .cast<Chapter>();
  }

  static List<Manga> parseMangaSearchResponse(Response response) {
    var results = response.data['data'];
    return results
        .map((manga) {
      return _mangaFromData(manga);
    })
        .toList()
        .cast<Manga>();
  }

  static ChapterData parseChapterData(Response response, Chapter chapter) {
    var results = response.data;
    var chapterData = ChapterData(
        chapter: chapter,
        baseUrl: results['baseUrl'],
        hash: results['chapter']['hash'],
        data: results['chapter']['data'].cast<String>(),
        dataSaver: results['chapter']['dataSaver'].cast<String>());
    return chapterData;
  }

  static Map<String, ReadStatus> parseStatusesReponse(Response response) {
    Map<String, String> statusesRaw = response.data['statuses'].cast<String, String>();
    return statusesRaw.map((key, value) => MapEntry(key, _stringToReadStatus(value)));
  }

  static ReadStatus _stringToReadStatus(String statusString){
    switch (statusString){
      case "reading":
        return ReadStatus.reading;
        break;
      case "on_hold":
        return ReadStatus.on_hold;
        break;
      case "plan_to_read":
        return ReadStatus.plan_to_read;
        break;
      case "dropped":
        return ReadStatus.dropped;
        break;
      case "re_reading":
        return ReadStatus.re_reading;
        break;
      case "completed":
        return ReadStatus.completed;
        break;
      case "not_reading": // ??
        return ReadStatus.not_reading;
        break;
    }
    throw Exception("ReadStatus conversion error");
  }

  static String _pickLocalizedString(dynamic localizedString) {
    if (localizedString.length == 0) {
      return "NO DATA";
    } else {
      return localizedString['en'] ?? localizedString.values.first;
    }
  }

  static List<Tag> _parseTags(dynamic tagsData) {
    List<Tag> tags = [];

    for (var tag in tagsData) {
      var _tag = Tag(
          id: tag['id'],
          group: tag['attributes']['group'],
          name: _pickLocalizedString(tag['attributes']['name']),
          version: tag['attributes']['version']);
      tags.add(_tag);
    }

    return tags;
  }

  static CoverArt? _coverArtFromRelationship(dynamic relationData) {
    return relationData['attributes'] == null ? null : CoverArt(
        id: relationData['id'],
        filename: relationData['attributes']['fileName'],
        description: relationData['attributes']['description'],
        volume: relationData['attributes']['volume'],
        createdAt: DateTime.parse(relationData['attributes']['createdAt']),
        updatedAt: DateTime.parse(relationData['attributes']['updatedAt']),
        version: relationData['attributes']['version']
    );
  }

  static Artist? _artistFromRelationship(dynamic relationData) {
    return relationData['attributes'] == null ? null : Artist(
        id: relationData['id'],
        name: relationData['attributes']['name'],
        imageUrl: relationData['attributes']['imageUrl'],
        biography: "Not implemented!",
        // TODO: fix this
        createdAt: DateTime.parse(relationData['attributes']['createdAt']),
        updatedAt: DateTime.parse(relationData['attributes']['updatedAt']),
        version: relationData['attributes']['version']
    );
  }

  static Author? _authorFromRelationship(dynamic relationData) {
    return relationData['attributes'] == null ? null : Author(
        id: relationData['id'],
        name: relationData['attributes']['name'],
        imageUrl: relationData['attributes']['imageUrl'],
        biography: "Not implemented!",
        // TODO: fix this
        createdAt: DateTime.parse(relationData['attributes']['createdAt']),
        updatedAt: DateTime.parse(relationData['attributes']['updatedAt']),
        version: relationData['attributes']['version']
    );
  }

  static Manga _mangaFromData(dynamic mangaData) {
    List<String> altTitles = [];
    Author? author;
    Artist? artist;
    CoverArt? coverArt;
    var tempLinks =  mangaData['attributes']['links'];
    Map<String, String> links = tempLinks?.length == 0 || tempLinks==null ?
    <String, String>{}: tempLinks.cast<String, String>();

    for (var altTitle in mangaData['attributes']['altTitles']) {
      // altTitle is localisedString
      List<String> x = altTitle.values.toList().cast<String>();
      altTitles.addAll(x);
    }

    for (var relation in mangaData['relationships']) {
      switch (relation['type']) {
        case "author":
          author = _authorFromRelationship(relation);
          break;
        case "artist":
          artist = _artistFromRelationship(relation);
          break;
        case "cover_art":
          coverArt = _coverArtFromRelationship(relation);
          break;
      }
    }

    Manga manga = Manga(
        id: mangaData['id'],
        titles: mangaData['attributes']['title'].cast<String, String>(),
        altTitles: altTitles,
        description: _pickLocalizedString(mangaData['attributes']['description']),
        status: mangaData['attributes']['status'],
        publicationDemographic: mangaData['attributes']['publicationDemographic'],
        contentRating: mangaData['attributes']['contentRating'],
        tags: _parseTags(mangaData['attributes']['tags']),
        originalLanguage: mangaData['attributes']['originalLanguage'],
        coverArt: coverArt,
        author: author,
        artist: artist,
        createdAt: DateTime.parse(mangaData['attributes']['createdAt']),
        updatedAt: DateTime.parse(mangaData['attributes']['updatedAt']),
        version: mangaData['attributes']['version'],
        links: links
    );
    return manga;
  }

  static Chapter _chapterFromData(dynamic chapterData) {
    String? _mangaId;
    String? _scanlationId;
    String? _userId;

    // TODO: add scantaltion and user object
    for (var relation in chapterData['relationships']) {
      switch (relation['type']) {
        case "manga":
          _mangaId = relation['id'];
          break;
        case "scanlation_group":
          _scanlationId = relation['id'];
          break;
        case "user":
          _userId = relation['id'];
          break;
      }
    }

    Chapter chapter = Chapter(
        id: chapterData['id'],
        volume: chapterData['attributes']['volume'],
        chapter: chapterData['attributes']['chapter'],
        title: chapterData['attributes']['title'],
        translatedLanguage: chapterData['attributes']['translatedLanguage'],
        pages: chapterData['attributes']['pages'],
        uploader: chapterData['attributes']['uploader'],
        // hash: chapterData['attributes']['hash'],
        // data: chapterData['attributes']['data'].cast<String>(),
        // dataSaver: chapterData['attributes']['dataSaver'].cast<String>(),
        externalUrl: chapterData['attributes']['externalUrl'],
        publishAt: DateTime.parse(chapterData['attributes']['publishAt']),
        createdAt: DateTime.parse(chapterData['attributes']['createdAt']),
        updatedAt: DateTime.parse(chapterData['attributes']['updatedAt']),
        version: chapterData['attributes']['version'],
        mangaId: _mangaId!,
        scanlationId: _scanlationId,
        userId: _userId
    );
    return chapter;
  }




}
