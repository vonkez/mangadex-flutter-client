import 'dart:io';

import 'package:md_fclient/models/manga.dart';
import 'package:md_fclient/network/mangadex.dart';
import 'package:md_fclient/utils/extensions.dart';
import 'package:path_provider/path_provider.dart' as pp;
import 'package:get/get.dart';

class Preloader {
  static Preloader get to => Get.find();

  String externalStorageDir = "";

  Preloader() {
    pp
        .getApplicationDocumentsDirectory()
        .then((value) => externalStorageDir = value.path)
        .then((value) => print(externalStorageDir));
  }
}
