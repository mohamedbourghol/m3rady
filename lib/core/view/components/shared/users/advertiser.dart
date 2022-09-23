import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m3rady/core/view/widgets/text/expandable_text.dart';
import 'package:m3rady/core/view/components/shared/users/user_image.dart';
import 'package:simple_star_rating/simple_star_rating.dart';

class WAdvertiser extends StatelessWidget {
  var advertiser;

  WAdvertiser({
    required this.advertiser,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        /// Goto user profile
        if (!advertiser.isSelf) {
          Get.toNamed('/advertiser/profile', arguments: {
            'id': advertiser.id,
          });
        }
      },
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Image
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: WUserImage(
                          advertiser.imageUrl,
                          isElite: advertiser.isElite == true,
                          radius: 24,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Name && Location
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: Get.width / 2.1,
                                child: Text(
                                  advertiser.fullName,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Icons.location_on_outlined,
                                      size: 14,
                                      color: Colors.grey,
                                    ),
                                    Container(
                                      width: Get.width / 4.1,
                                      child: Text(
                                        "${advertiser.country} - ${advertiser.city}",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black45,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                advertiser.username,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                                maxLines: 1,
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              SimpleStarRating(
                                starCount: 5,
                                rating: (advertiser.rate != null
                                    ? double.parse((advertiser.rate > 5
                                            ? 5
                                            : advertiser.rate)
                                        .round()
                                        .toString())
                                    : 0),
                                size: 12,
                                spacing: 1,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2),
                                child: Text(
                                  (advertiser.rate != null
                                      ? '(${advertiser.rate})'
                                      : "(${'No Rate'.tr})"),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 2,
                          ),
                          Container(
                            width: Get.width / 1.3,
                            child: ExpandableText(
                              advertiser.bio,
                              color: Colors.black.withOpacity(0.8),
                              trimLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
