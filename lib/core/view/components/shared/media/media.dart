import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:m3rady/core/models/media/media.dart';
import 'package:m3rady/core/view/widgets/photo_viewer/network_dialog.dart';

import 'package:m3rady/core/view/widgets/video/video_player.dart';
import 'package:m3rady/core/view/widgets/video/video_player1.dart';


class WMedia extends StatelessWidget {
  var mediaList;

  WMedia({
    required this.mediaList,
  });

  /// Set media carousel controller
  final CarouselController postMediaCarouselController = CarouselController();

  var currentPostMediaIndex = 0.obs;
  var isCurrentPostMediaIsLoading = true.obs;
  List<Widget> carouselSliderCounterList = [];

  /// Generate list of bottom slider navigators
  List<Widget> getCarouselSliderCounterList() {
    for (var index = 0; index < mediaList.length; index++) {
      carouselSliderCounterList.add(
        GestureDetector(
          onTap: () {
            postMediaCarouselController.animateToPage(index);
          },
          child: Obx(
            () => Container(
              width: 10,
              height: 10,
              margin: EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 4.0,
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: (Get.theme.brightness == Brightness.dark
                          ? Colors.black
                          : Colors.white)
                      .withOpacity(
                          (currentPostMediaIndex.value) == index ? 0.8 : 0.4),
                  width: 1.0,
                ),
                shape: BoxShape.circle,
                color: (Get.theme.brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black)
                    .withOpacity(
                        (currentPostMediaIndex.value) == index ? 0.8 : 0.4),
              ),
            ),
          ),
        ),
      );
    }

    return carouselSliderCounterList;
  }

  @override
  Widget build(BuildContext context) {
    /// Get Carousel Slider Counter List
    getCarouselSliderCounterList();

    /// Set height of slider
    var carouselSliderHeight = 0.0.obs;

    return (mediaList.length > 0
        ? Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              /// One image
              (mediaList.length == 1 &&
                      mediaList[mediaList.keys.toList()[0]].type ==
                          MediaType.image)
                  ? GestureDetector(
                      onTap: () async{
                        print("this");
                           await dialogShowImages(
                             context: context,
                             ind: currentPostMediaIndex.value,
                             ur: mediaList.entries.map((entry) {
                               if (entry.value.type == MediaType.image)
                                 return entry.value.mediaUrl;
                             }).toList(),
                           );

                      },
                      child: CachedNetworkImage(
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
                    )
                  :

                  /// Slider
                  Obx(
                      () => CarouselSlider(
                        carouselController: postMediaCarouselController,
                        options: CarouselOptions(
                          aspectRatio:
                              (Get.width / Get.height > 0.5) ? 16 / 9 : 1.2,
                          viewportFraction: 1,
                          height: carouselSliderHeight.value == 0.0
                              ? null
                              : carouselSliderHeight.value,
                          disableCenter: true,
                          initialPage: currentPostMediaIndex.value,
                          enableInfiniteScroll: (mediaList.length > 1),
                          reverse: false,
                          autoPlay: false,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration: Duration(
                            milliseconds: 100,
                          ),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          scrollDirection: Axis.horizontal,
                          onPageChanged: (index, reason) {
                            currentPostMediaIndex.value = index;
                          },
                        ),
                        items: mediaList.entries.map<Widget>((entry) {
                          Media media = entry.value;

                          var mediaWidget = (media.type == MediaType.image
                              ? CachedNetworkImage(
                                  imageUrl: media.mediaUrl,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit:  BoxFit.fill
                                            ,
                                      ),
                                    ),
                                  ),
                                  placeholder: (context, url) => Container(
                                    width: double.infinity,
                                    color: Colors.white.withOpacity(0.2),
                                    child: (media.thumbnailImageUrl == null
                                        ? Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.black12,
                                            ),
                                          )
                                        : Stack(
                                            alignment:
                                                AlignmentDirectional.center,
                                            children: [
                                              CircularProgressIndicator(
                                                color: Colors.black12,
                                              ),
                                              CachedNetworkImage(
                                                imageUrl:
                                                    media.thumbnailImageUrl!,
                                                fit:  BoxFit.fill
                                                   ,
                                              ),
                                            ],
                                          )),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
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
                              : WVideoPlayer.media(media));

                          return (media.type == MediaType.image
                              ? GestureDetector(
                                  onTap: () async {
                                    await dialogShowImages(
                                        context: context,
                                        ind: currentPostMediaIndex.value,
                                        ur: mediaList.entries.map((entry) {
                                      if (entry.value.type == MediaType.image)
                                        return entry.value.mediaUrl;
                                    }).toList(),
                                    );
                                  },
                                  child: mediaWidget,
                                )
                              : mediaWidget);
                        }).toList(),
                      ),
                    ),

              /// Slider bottom dots
              (mediaList.length > 1
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: carouselSliderCounterList,
                    )
                  : SizedBox()),
            ],
          )
        : Container(
            height: 25,
          ));
  }
}
