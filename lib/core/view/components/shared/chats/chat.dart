import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m3rady/core/view/components/shared/users/user_image.dart';

class WChat extends StatelessWidget {
  var chat;

  WChat({
    required this.chat,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(
          '/chat',
          arguments: {
            'token': chat.token,
          },
        );
      },
      child: Container(
        padding: const EdgeInsetsDirectional.only(
          start: 12,
          end: 12,
          top: 4,
          bottom: 4,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// Image && is online
            Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: [
                /// Image
                WUserImage(
                  chat.toUser.imageUrl,
                  isElite: chat.toUser.isElite,
                  radius: 23,
                ),

                /// Is online
                Padding(
                  padding: const EdgeInsets.all(2),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: (chat.toUser.isOnline == true
                          ? Colors.lightGreen
                          : Colors.transparent),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),

            /// Name && last message
            Container(
              width: Get.width / 1.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Name
                  Text(
                    chat.toUser.fullName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),

                  SizedBox(
                    height: 2,
                  ),

                  /// Last message
                  Text(
                    (chat.lastMessage != null &&
                            chat.lastMessage.message.length > 0
                        ? chat.lastMessage.message
                            .toString()
                            .replaceAll('\n', ' ')
                            .trim()
                        : '-'),
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 13,
                      fontFamily: 'Arial',
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            /// Unread messages && last message date
            ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: Get.width / 12,
                maxWidth: Get.width / 6,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  /// Time
                  Text(
                    chat.lastMessage != null
                        ? chat.lastMessage.createdAt
                        : chat.createdAt,
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 10,
                    ),
                  ),

                  /// Unread messages
                  Visibility(
                    visible: chat.unreadMessagesCount > 0,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.all(
                            const Radius.circular(5),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            chat.unreadMessagesCount.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
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
