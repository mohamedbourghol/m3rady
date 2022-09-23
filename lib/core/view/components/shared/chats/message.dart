
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m3rady/core/models/chats/messages/chat_message.dart';
import 'package:m3rady/core/view/components/shared/users/user_image.dart';
import 'package:m3rady/core/view/widgets/photo_viewer/network_dialog.dart';

class WMessage extends StatelessWidget {
  ChatMessage message;

  WMessage({
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          message.isOwner ? MainAxisAlignment.start : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Image
        Visibility(
          visible: message.isOwner,
          child: WUserImage(
            message.owner.imageUrl,
            isElite: message.owner.isElite!,
            radius: 18,
          ),
        ),

        /// Messages
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: message.isOwner
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            /// Message (text)
            (message.message != null && message.message != ''
                ? BubbleSpecialOne(
                    text: message.message!,
                    isSender: (Get.locale.toString() == 'en' ? !message.isOwner : message.isOwner),
                    color:
                        message.isOwner ? Colors.blue.shade500 : Colors.black54,
                    textStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontFamily: 'Arial',
                    ),
                    seen: message.isOwner && message.isRead,
                  )
                : SizedBox()),

            /// Message (media)
            (message.media != null
                ? Container(
                    padding: const EdgeInsets.all(6),
                    child: GestureDetector(
                      onTap: () async {
                        await dialogShowImages(
                            context: context,
                            ur:  message.media!.mediaUrl,
                        );

                      },
                      child: SizedBox(
                        height: 124,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                             message.media!.mediaUrl,


                          ),
                        ),
                      ),
                    ),
                  )
                : SizedBox()),
            /// Message (media)
            (message.localImage != null
                ? Container(
              padding: const EdgeInsets.all(6),
              child: GestureDetector(
                onTap: () async {

                },
                child: SizedBox(
                  height: 124,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      message.localImage!,


                    ),
                  ),
                ),
              ),
            )
                : SizedBox()),

            /// Time
            Visibility(
              visible: message.createdAt != null && message.createdAt != '',
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 2,
                  left: 24,
                  right: 24,
                ),
                child: Text(
                  message.createdAt!,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
            ),
          ],
        ),

        /// Image
        Visibility(
          visible: !message.isOwner,
          child: WUserImage(
            message.owner.imageUrl,
            isElite: message.owner.isElite!,
            radius: 18,
          ),
        ),
      ],
    );
  }
}
