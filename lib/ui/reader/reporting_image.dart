import 'dart:typed_data';
import 'package:get/get.dart' hide Response;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';
import 'package:dio_cache_interceptor_file_store/dio_cache_interceptor_file_store.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:md_fclient/utils/preloader.dart';
import 'package:path_provider/path_provider.dart' as pp;

class ReportingImage extends StatefulWidget {
  //static var cacheStore = MemCacheStore(maxSize: 100000000, maxEntrySize: 15000000);
  static var cacheStore = FileCacheStore(Preloader.to.externalStorageDir);
  static var cacheOptions = CacheOptions(
    store: cacheStore,
  );

  final String imageUrl;
  final double? width;
  final double? height;
  final bool report;

  @override
  State<ReportingImage> createState() => _ReportingImageState();

  ReportingImage({ Key? key, required this.imageUrl, this.width, this.height, this.report = true }) : super(key: key) {
    print("CONST IMAGE $imageUrl");
  }
}


class _ReportingImageState extends State<ReportingImage> {
  var hasData = false.obs;
  var hasError = false.obs;
  Rx<Uint8List> image = Uint8List(0).obs;

  @override
  void initState() {
    print("DOWNLOAD IMAGE ${widget.imageUrl}");
    downloadImage();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if(hasError.value) {
        return InkWell(
          onTap: () => reload(),
          child: Column(children: const [
            Icon(Icons.broken_image, size: 56,),
            Text("Tap to reload", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],),
        );
      }
      if(hasData.value) {
        return Image.memory(
          image.value,
          height: widget.height,
          width: widget.width,
          fit: BoxFit.fitWidth,
        );
      } else {
        return Container(
            height: 300,
            alignment: Alignment.center,
            child: const CircularProgressIndicator());
      }
    });
  }


  Future<void> sendReport(String url, bool success, bool cached, int? bytes, int? duration) async {
    if(widget.report) {
      var dio = Dio();
      dio.interceptors.add(LogInterceptor(responseBody: true, requestHeader: false, responseHeader: false));
      var response = await dio.post('https://httpbin.org/post', data: {'url': url, 'success': success, 'cached': cached, 'bytes': bytes, 'duration': duration});
    }
  }

  Future<void> reload() async {
    // if there is no previous download
    if(hasData.value || hasError.value) {
      hasData.value = false;
      hasError.value = false;
      image.value = Uint8List(0);
      await downloadImage();
    } else {
      print("Can't reload. Download not completed");
    }
  }

  // Future<bool> loadFromCache() async {
  //   Uint8List? image = await cache.get(imageUrl);
  //   if(image != null) {
  //     this.image.value = image;
  //     hasData.value = true;
  //     print("$imageUrl found in cache");
  //     return true;
  //   }else {
  //     print("$imageUrl not found in cache");
  //     return false;
  //   }
  // }

  Future<Uint8List?> downloadImage() async {
    print("INSIDE DOWNLOAD: ${widget.imageUrl}");
    var dio = Dio();

    //dio.interceptors.add(LogInterceptor(responseBody: true, requestHeader: false, responseHeader: false));
    dio.interceptors.add(DioCacheInterceptor(options: ReportingImage.cacheOptions));

    Response? response;
    var stopWatch = Stopwatch();
    stopWatch.start();

    try {
      var response = await dio.get(
          widget.imageUrl,
          options: Options(responseType: ResponseType.bytes)
      );
      stopWatch.stop();
      // SUCCESS
      var elapsedTime = stopWatch.elapsedMilliseconds;
      print("Status Code: ${response.statusCode}");
      print("Elapsed time: $elapsedTime");
      if(response.statusCode == 200 ) {
        image.value = response.data as Uint8List;
        hasData.value = true;
        await sendReport(widget.imageUrl, true, false, response.data.lengthInBytes, elapsedTime);
      }else if (response.statusCode == 304){ // Local cache hit
        image.value = Uint8List.fromList(response.data);
        hasData.value = true;
      } else {
        await sendReport(widget.imageUrl, false, false, response.data.lengthInBytes, elapsedTime);
      }

    } on DioError catch (e) {
      //  ERROR
      print("ERROR: ${widget.imageUrl}");
      e.printError();
      stopWatch.stop();
      hasError.value = true;
      if (e.response != null) {
        var elapsedTime = stopWatch.elapsedMilliseconds;
        await sendReport(widget.imageUrl, false, false, e.response!.data.lengthInBytes, elapsedTime);
      } else {
        await sendReport(widget.imageUrl, false, false, null, null);
      }
    } finally {
      stopWatch.stop();
    }
    // TODO: other errors?

    return response != null ? response.data as Uint8List : null;
  }


}
