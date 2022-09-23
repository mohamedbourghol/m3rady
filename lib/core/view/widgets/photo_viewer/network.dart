import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:m3rady/core/utils/config/config.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoViewerNetworkScreen extends StatefulWidget {
  @override
  _PhotoViewerNetworkScreenState createState() =>
      _PhotoViewerNetworkScreenState();
}

class _PhotoViewerNetworkScreenState extends State<PhotoViewerNetworkScreen> {
  int? index = (Get.arguments?['index'] != null
      ? Get.arguments['index']
      : null);
  String? url;
  List? urls;

  PhotoViewController photoViewController = PhotoViewController();

  PageController pageController = PageController();

  /// Init
  @override
  void initState() {
    super.initState();

    /// Scroll to index
    if (index != null) {
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        pageController.animateTo(
          double.parse((Get.width * index!).toString()),
          duration: Duration(microseconds: 100),
          curve: Curves.ease,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    /// Set url
    index = index ??
        (Get.arguments?['index'] != null ? Get.arguments['index'] : null);
    url = url ?? (Get.arguments?['url'] != null ? Get.arguments['url'] : null);
    urls =
        urls ?? (Get.arguments?['urls'] != urls ? Get.arguments['urls'] : null);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 12,
        title: Text(
          config['appName']
              .toString()
              .tr,
          style: Get.theme.appBarTheme.titleTextStyle,
        ),
      ),
      body: Container(
        color: Colors.black,
        child: (url != null
            ? PhotoView(
          controller: photoViewController,
          imageProvider: CachedNetworkImageProvider(url!),
          errorBuilder: (context, object, error) =>
              Container(
                width: double.infinity,
                color: Colors.grey.withOpacity(0.2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error,
                      size: 80,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      'Something went wrong while trying to load the image.'
                          .tr,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
          loadingBuilder: (context, event) =>
              Center(
                child: LoadingBouncingLine.circle(
                  backgroundColor: Colors.white,
                ),
              ),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.contained * 3,
        )
            : PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          pageController: pageController,

          builder: (BuildContext context, int index) {
            return PhotoViewGalleryPageOptions(
              controller: photoViewController,
              imageProvider: CachedNetworkImageProvider(urls![index]),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.contained * 3,
            );
          },
          //enableRotation: true,
          itemCount: urls!.length,
          loadingBuilder: (context, event) =>
              Center(
                child: LoadingBouncingLine.circle(
                  backgroundColor: Colors.white,
                ),
              ),
        )),
      ),
    );
  }
}
