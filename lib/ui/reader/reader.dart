import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response;
import 'package:md_fclient/models/chapter.dart';
import 'package:md_fclient/models/chapter_data.dart';
import 'package:md_fclient/network/mangadex.dart';
import 'package:md_fclient/ui/reader/reporting_image.dart';
import 'package:md_fclient/ui/reader/sliding_app_bar.dart';
import 'package:md_fclient/ui/reader/sliding_slider.dart';

import 'scrollable_positioned_list.dart';

class Reader extends StatefulWidget {
  Reader({Key? key, required this.chapter, required this.title, required this.pageCount}) : super(key: key);
  final Chapter chapter;
  final int pageCount;
  final sliderPage = 1.0.obs;
  final String title;

  @override
  State<Reader> createState() => _ReaderState();
}

class _ReaderState extends State<Reader> with SingleTickerProviderStateMixin {
  bool _visible = false;
  Timer? _debounce;
  ChapterData? chapterData;
  late final AnimationController _controller;
  late final ItemScrollController _itemScrollController;
  late final ItemPositionsListener _itemPositionsListener;
  late final items;

  @override
  void initState() {
    Mangadex().getChapterData(widget.chapter).then(
            (value) => setState(
                    ()=> chapterData = value
            )
    );
    
    //items = List.generate(widget.pageCount, (index) => "http://placehold.it/250x250&text=image$index");
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _itemScrollController = ItemScrollController();
    _itemPositionsListener = ItemPositionsListener.create();
    _itemPositionsListener.itemPositions.addListener(() {
      if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 400), () {
        widget.sliderPage.value = _itemPositionsListener.itemPositions.value.first.index.clamp(1, widget.pageCount).toDouble();
      });
      //print("first: ${_itemPositionsListener.itemPositions.value.first.index} -- last: ${_itemPositionsListener.itemPositions.value.last.index}");
    });
    super.initState();
  }
  

  Widget pageBuilder(context, index){
    if(index==0){
      return Container(height: 100, width: 100, color: Colors.red,);
    }else if(index==widget.pageCount+1){
      return Container(height: 100, width: 100, color: Colors.amber,);
    }else{
      return ReportingImage(key: ValueKey<int>(index), imageUrl: chapterData!.getImageUrl(index-1), report: false,);
    }
  }

  void scrollToNextImage() {
    int lastVisibleIndex = _itemPositionsListener.itemPositions.value.last.index;
    double offset =  _itemPositionsListener.itemPositions.value.last.itemLeadingEdge - 0.6;
    _itemScrollController.scrollTo(index: lastVisibleIndex, duration: const Duration(milliseconds: 400), alignment: offset, curve: Curves.easeInOutSine);
  }

  void scrollToPreviousImage() {
    int fistVisibleIndex = _itemPositionsListener.itemPositions.value.first.index;
    double offset =  _itemPositionsListener.itemPositions.value.first.itemLeadingEdge + 0.6;
    _itemScrollController.scrollTo(index: fistVisibleIndex, duration: const Duration(milliseconds: 400), alignment: offset, curve: Curves.easeInOutSine);
  }

  void toggleMenu() {
    setState((){
      widget.sliderPage.value = _itemPositionsListener.itemPositions.value.first.index.clamp(1, widget.pageCount).toDouble();
      _visible = !_visible;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(chapterData==null) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.loose,
        children: [
          /// IMAGES
          InteractiveViewer(
            child: ScrollablePositionedList.builder(
              itemCount: widget.pageCount+2,
              itemScrollController: _itemScrollController,
              itemPositionsListener: _itemPositionsListener,
              itemBuilder: pageBuilder,
              // children: <Widget>[
              //   ReportingImage(imageUrl: "https://catlikecoding.com/numberflow/gallery/swirlies.jpg",report: false,),
              //   ReportingImage(imageUrl: "https://catlikecoding.com/numberflow/gallery/swirlies.jpg",report: false,),
              //   ReportingImage(imageUrl: "https://catlikecoding.com/numberflow/gallery/swirlies.jpg",report: false,),
              //   ReportingImage(imageUrl: "https://docs.flutter.dev/assets/images/docs/widget-catalog/material-app-baar.png",)
              //   //Image.network("https://uploads.mangadex.org/covers/789642f8-ca89-4e4e-8f7b-eee4d17ea08b/60530e72-f76f-45d5-b6f9-f95e05058fc3.png.512.jpg")
              // ],
            ),
          ),

          /// GESTURES
          Row(
            children: [
              Expanded(child: GestureDetector(onTap: () => scrollToPreviousImage())),
              Expanded(child: GestureDetector(onTap: () => toggleMenu())),
              Expanded(child: GestureDetector(onTap: () => scrollToNextImage())),
            ],
          ),
          /// MENUS
          SizedBox(
            height: 120,
            child: SlidingAppBar(
              controller: _controller,
              visible: _visible,
              child: AppBar(title: Text(widget.title)),
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 100,
                child: SlidingSlider(
                  controller: _controller,
                  visible: _visible,
                  child: Obx(()=> Slider(
                    min: 1,
                    max: widget.pageCount.toDouble(),
                    divisions: widget.pageCount-1,
                    label: "Page ${widget.sliderPage.toInt()}",
                    onChanged: (double value) {
                      setState(() {
                        widget.sliderPage.value=value;
                        _itemScrollController.scrollTo(index: value.toInt(), duration: const Duration(milliseconds: 400), curve: Curves.easeInOutSine);
                        print("slider: $value");
                      });
                    },
                    value: widget.sliderPage.value,
                  )),
                ),
              )
          )
        ],
      ),

    );
  }
}
