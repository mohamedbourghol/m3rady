import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m3rady/core/controllers/follow/follow_controller.dart';
import 'package:m3rady/core/view/components/components.dart';
import 'package:m3rady/core/view/components/shared/users/user_image.dart';

import 'follow_button.dart';

class WFollower extends StatefulWidget {
  var follower;
  int? requestId;
  bool isRequest = false;

  WFollower({
    required follower,
    bool? isRequest = false,
  }) {
    /// Set is request
    this.isRequest = isRequest == true;

    if (isRequest == true) {
      this.requestId = follower.id;
      this.follower = follower.owner;
    } else {
      this.follower = follower;
    }
  }

  @override
  State<WFollower> createState() => _WFollowerState();
}

class _WFollowerState extends State<WFollower> {
  final FollowController followController = Get.put(FollowController());
  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible == true,
      child: InkWell(
        onTap: () {
          /// Goto user profile
          if (!widget.follower.isSelf) {
            /// Redirect to advertiser profile
            if (widget.follower.type == 'advertiser') {
              Get.toNamed('/advertiser/profile', arguments: {
                'id': widget.follower.id,
              });
            } else if (widget.follower.type == 'customer') {
              Get.toNamed('/customer/profile', arguments: {
                'id': widget.follower.id,
              });
            }
          } else {
            /// Get.toNamed('/profile/me');
          }
        },
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// Image, name
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// Image
                    WUserImage(
                      widget.follower.imageUrl,
                      isElite: widget.follower.isElite == true,
                      radius: 24,
                    ),

                    SizedBox(
                      width: 6,
                    ),

                    /// Name, country
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Name
                        Container(
                          width: Get.width / 2,
                          child: Text(
                            widget.follower.fullName,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        /// Country
                        Container(
                          width: Get.width / 2,
                          child: Text(
                            "${widget.follower.country} - ${widget.follower.city}",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black45,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    )
                  ],
                ),

                /// Follow button
                widget.isRequest == false
                    ? FollowButton(
                        user: widget.follower,
                      )

                    /// Confirm button
                    : Container(
                        width: 80,
                        height: 30,
                        child: CMaterialButton(
                          borderColor: Colors.blue,
                          color: Colors.blue,
                          child: Text(
                            'Accept'.tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () async {
                            /// Accept request
                            followController.updateFollowRequestById(
                              widget.requestId!,
                              status: 'accept',
                            );

                            setState(() {
                              isVisible = false;
                            });
                          },
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
