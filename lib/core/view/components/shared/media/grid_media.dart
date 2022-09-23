import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:m3rady/core/models/media/media.dart';
import 'package:m3rady/core/view/widgets/photo_viewer/network_dialog.dart';

import 'package:m3rady/core/view/widgets/video/video_player.dart';
import 'package:m3rady/core/view/widgets/video/video_player1.dart';


class WGridMedia extends StatelessWidget {
  var mediaList;
  String  appLocale ;
  WGridMedia({
    required this.mediaList,
    required this.appLocale
  });





  @override
  Widget build(BuildContext context) {



    return (mediaList.length > 0
        ? (mediaList.length == 1 &&
                mediaList[mediaList.keys.toList()[0]].type ==
                    MediaType.image)
            ? CachedNetworkImage(
              width: Get.width,
              height: ((Get.width / Get.height > 0.5)
                  ? Get.width / 1.7
                  : mediaList[mediaList.keys.toList()[0]].width !=
                              null &&
                          mediaList[mediaList.keys.toList()[0]]
                                  .height !=
                              null &&
                          mediaList[mediaList.keys.toList()[0]]
                                  .width >
                              mediaList[mediaList.keys.toList()[0]]
                                  .height
                      ? Get.width / 1.6
                      : Get.height / 1.75),
              imageUrl:
                  mediaList[mediaList.keys.toList()[0]].mediaUrl,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              placeholder: (context, url) => Container(
                width: double.infinity,
                color: Colors.white.withOpacity(0.2),
                child: (mediaList[mediaList.keys.toList()[0]]
                            .thumbnailImageUrl ==
                        null
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Colors.black12,
                        ),
                      )
                    : Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          CircularProgressIndicator(
                            color: Colors.black12,
                          ),
                          CachedNetworkImage(
                            imageUrl:
                                mediaList[mediaList.keys.toList()[0]]
                                    .thumbnailImageUrl,
                            fit: BoxFit.fill,
                          ),
                        ],
                      )),
              ),
              errorWidget: (context, url, error) => Container(
                width: double.infinity,
                color: Colors.white.withOpacity(0.2),
                child: Center(
                  child: Icon(
                    Icons.error,
                    size: 50,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ),

            )
            :

        mediaList[mediaList.keys.toList()[0]].type ==
            MediaType.image?
            Stack(
              children: [
                CachedNetworkImage(
          width: Get.width,
          height: ((Get.width / Get.height > 0.5)
                  ? Get.width / 1.7
                  : mediaList[mediaList.keys.toList()[0]].width !=
                  null &&
                  mediaList[mediaList.keys.toList()[0]]
                      .height !=
                      null &&
                  mediaList[mediaList.keys.toList()[0]]
                      .width >
                      mediaList[mediaList.keys.toList()[0]]
                          .height
                  ? Get.width / 1.6
                  : Get.height / 1.75),
          imageUrl:
          mediaList[mediaList.keys.toList()[0]].mediaUrl,
          imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.fill,
                  ),
                ),
          ),
          placeholder: (context, url) => Container(
                width: double.infinity,
                color: Colors.white.withOpacity(0.2),
                child: (mediaList[mediaList.keys.toList()[0]]
                    .thumbnailImageUrl ==
                    null
                    ? Center(
                  child: CircularProgressIndicator(
                    color: Colors.black12,
                  ),
                )
                    : Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.black12,
                    ),
                    CachedNetworkImage(
                      imageUrl:
                      mediaList[mediaList.keys.toList()[0]]
                          .thumbnailImageUrl,
                      fit: BoxFit.fill,
                    ),
                  ],
                )),
          ),
          errorWidget: (context, url, error) => Container(
                width: double.infinity,
                color: Colors.white.withOpacity(0.2),
                child: Center(
                  child: Icon(
                    Icons.error,
                    size: 50,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
          ),

        ),
                Positioned(
                  right: 3,
                  top: 5,

                  child: SizedBox(
                      width: 20,
                      height: 20,
                      child: SvgPicture.asset(
                        'assets/icon/multi_image.svg',

                        color: Colors.white,
                      )),
                )
              ],
            ):
        Stack(
          clipBehavior: Clip.none,
          children: [
            CachedNetworkImage(
              width: Get.width,
              height: ((Get.width / Get.height > 0.5)
                  ? Get.width / 1.7
                  : mediaList[mediaList.keys.toList()[0]].width !=
                  null &&
                  mediaList[mediaList.keys.toList()[0]]
                      .height !=
                      null &&
                  mediaList[mediaList.keys.toList()[0]]
                      .width >
                      mediaList[mediaList.keys.toList()[0]]
                          .height
                  ? Get.width / 1.6
                  : Get.height / 1.75),
              imageUrl:
              mediaList[mediaList.keys.toList()[0]].thumbnailImageUrl,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              placeholder: (context, url) => Container(
                width: double.infinity,
                color: Colors.white.withOpacity(0.2),
                child: (mediaList[mediaList.keys.toList()[0]]
                    .thumbnailImageUrl ==
                    null
                    ? Center(
                  child: CircularProgressIndicator(
                    color: Colors.black12,
                  ),
                )
                    : Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    CircularProgressIndicator(
                      color: Colors.black12,
                    ),
                    CachedNetworkImage(
                      imageUrl:
                      mediaList[mediaList.keys.toList()[0]]
                          .thumbnailImageUrl,
                      fit: BoxFit.fill,
                    ),
                  ],
                )),
              ),
              errorWidget: (context, url, error) => Container(
                width: double.infinity,
                color: Colors.white.withOpacity(0.2),
                child: Center(
                  child: Icon(
                    Icons.error,
                    size: 50,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ),

            ),
            Positioned(
             right: 3,
              top: 5,

              child: SizedBox(
                width: 22,
                  height: 22,
                  child: SvgPicture.asset(
                      'assets/icon/video.svg',
                    color: Colors.white,
                  )),
            )

          ],
        )
        :appLocale.contains('en')?
    Image.asset('assets/images/txt_en.jpeg',
       fit: BoxFit.fill,
    ):
    Image.asset('assets/images/text_ar.jpeg',
      fit: BoxFit.fill,
    ));
  }
}
