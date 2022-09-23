import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:m3rady/core/utils/config/config.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

Future<dynamic> dialogShowImages({
  required BuildContext context,
  var ind,
  var ur
}) async {
  /// Set url
  /// Scroll to index
  int? index = ind;
  String? url;
  List? urls;

  PhotoViewController photoViewController = PhotoViewController();

  PageController pageController = PageController();

  if (ind != null) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      pageController.animateTo(
        double.parse((Get.width * index!).toString()),
        duration: Duration(microseconds: 100),
        curve: Curves.ease,
      );
    });
  }
  index = ind ;
  url = ur is String ?ur:null;
  urls = ur is List?ur :null;


  return showDialog<dynamic>(
    context: context,
    barrierDismissible: false,

    builder: (BuildContext context) {
      return  OrientationBuilder(
        builder: (context, orientation) {
          return StatefulBuilder(
              builder: (context, setState) {
                return Dialog(
                  backgroundColor: Colors.transparent,
                  insetPadding: EdgeInsets.symmetric(
                    horizontal:0,
                    vertical: 0,
                  ),
                  child:  Dismissible(
                    key: Key('Random'),
                    onDismissed:(dis){
                      Navigator.pop(context);
                    } ,
                    direction: DismissDirection.vertical,

                    child: Scaffold(
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
                          imageProvider: CachedNetworkImageProvider(url),
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
                    ),
                  ),
                );}
          );
        },

      );
    },
  );
}
