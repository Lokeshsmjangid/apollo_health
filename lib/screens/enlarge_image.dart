import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';

class EnlargeImage extends StatefulWidget {
  final String? url;

  EnlargeImage({super.key, this.url});
  @override
  _EnlargeImageState createState() => _EnlargeImageState();
}

class _EnlargeImageState extends State<EnlargeImage> {

  @override
  initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    super.initState();
  }

  @override
  void dispose() {
    //SystemChrome.restoreSystemUIOverlays();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: PhotoView(
              imageProvider: CachedNetworkImageProvider(widget.url!),
              loadingBuilder: (context, event) => Center(
                child: CircularProgressIndicator(),
              ),
              errorBuilder: (context, url, error) => Center(
                child: Icon(Icons.error),
              ),
            ),
          ),
        ),
        onTap: () {
          Get.back();
        },
      ),
    );
  }
}