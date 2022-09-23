import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m3rady/core/view/widgets/text/expandable_text.dart';
import 'package:m3rady/core/view/components/shared/users/user_image.dart';
import 'package:simple_star_rating/simple_star_rating.dart';

class WRater extends StatelessWidget {
  var rate;

  WRater({
    required this.rate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                      child: GestureDetector(
                        onTap: () {
                          /// Goto user profile
                          if (!rate.owner.isSelf) {
                            if (rate.owner.type == 'advertiser') {
                              Get.toNamed('/advertiser/profile', arguments: {
                                'id': rate.owner.id,
                              });
                            } else if (rate.owner.type == 'customer') {
                              Get.toNamed('/customer/profile', arguments: {
                                'id': rate.owner.id,
                              });
                            }
                          } else {
                            /// Get.toNamed('/profile/me');
                          }
                        },
                        child: WUserImage(
                          rate.owner.imageUrl,
                          isElite: rate.owner.isElite == true,
                          radius: 24,
                        ),
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
                              width: Get.width / 2,
                              child: GestureDetector(
                                onTap: () {
                                  /// Goto user profile
                                  if (!rate.owner.isSelf) {
                                    if (rate.owner.type == 'advertiser') {
                                      Get.toNamed('/advertiser/profile',
                                          arguments: {
                                            'id': rate.owner.id,
                                          });
                                    } else if (rate.owner.type == 'customer') {
                                      Get.toNamed('/customer/profile',
                                          arguments: {
                                            'id': rate.owner.id,
                                          });
                                    }
                                  } else {
                                    /// Get.toNamed('/profile/me');
                                  }
                                },
                                child: Text(
                                  rate.owner.fullName,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 14,
                                    color: Colors.grey,
                                  ),
                                  Container(
                                    width: Get.width / 4.5,
                                    child: Text(
                                      "${rate.owner.country} - ${rate.owner.city}",
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
                            SimpleStarRating(
                              starCount: 5,
                              rating: (rate.rate != null
                                  ? double.parse((rate.rate > 5 ? 5 : rate.rate)
                                      .round()
                                      .toString())
                                  : 0),
                              size: 12,
                              spacing: 1,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2),
                              child: Text(
                                (rate.rate != null
                                    ? '(${rate.rate})'
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
                            rate.comment,
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
    );
  }
}
