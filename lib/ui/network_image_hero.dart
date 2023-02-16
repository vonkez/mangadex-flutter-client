import 'package:flutter/material.dart';
import 'package:extended_image/extended_image.dart';

class NetworkImageHero extends StatefulWidget {
  const NetworkImageHero({ Key? key, required this.imageUrl, required this.onTap, this.width, this.height }) : super(key: key);

  final String imageUrl;
  final VoidCallback onTap;
  final double? width;
  final double? height;

  @override
  State<StatefulWidget> createState() => _NetworkImageHeroState();

}

class _NetworkImageHeroState extends State<NetworkImageHero> with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;

  @override
  void initState() {
    _fadeController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1),
        lowerBound: 0.0,
        upperBound: 1.0);
    super.initState();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: widget.imageUrl,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          child: ExtendedImage.network(

            widget.imageUrl,
            width: widget.width,
            height: widget.height,
            fit: BoxFit.fitHeight,
            cache: true,
            filterQuality: FilterQuality.high,

          ),
        ),
      ),
    );
  }

}