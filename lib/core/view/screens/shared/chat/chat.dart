import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:m3rady/core/controllers/chat/chat_controller.dart';
import 'package:m3rady/core/models/chats/chat.dart';
import 'package:m3rady/core/models/chats/messages/chat_message.dart';
import 'package:m3rady/core/models/media/media.dart';
import 'package:m3rady/core/utils/config/config.dart';
import 'package:m3rady/core/utils/storage/local/variables.dart';
import 'package:m3rady/core/view/components/components.dart';
import 'package:m3rady/core/view/components/shared/chats/message.dart';
import 'package:m3rady/core/view/layouts/chat/chat_layout.dart';
import 'package:m3rady/core/view/layouts/main/main_layout.dart';
import 'package:pagination_view/pagination_view.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatScreen extends StatefulWidget {
  /// Set user
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var toUser = Get.arguments?['toUser'];
  var token = Get.arguments?['token'];

  ChatController chatController = Get.put(ChatController(
    toUser: Get.arguments?['toUser'],
    token: Get.arguments?['token'],
  ));

  final ScrollController messagesPaginationViewScrollController =
      ScrollController();

  var isSendingMessageLoading = false.obs;
  var isShowSendImage = false.obs;

  int messagesCurrentPage = 1;

  bool isMessagesHasNextPage = true;
  List messagesData = [];
  bool isLoading =false;

  void pagination() {
    if ((messagesPaginationViewScrollController.position.pixels ==
        messagesPaginationViewScrollController.position.maxScrollExtent)) {
        fetchMessagesByOffset(1);
    }
  }

  Future fetchMessagesByOffset(offset) async {
    print("1");
    if(offset==0)
     messagesData = [];
    late Map messages;

    /// Get messages
    if (isMessagesHasNextPage || offset == 0) {
      isLoading=true;
      setState(() {

      });
      messagesCurrentPage = offset == 0 ? 1 : messagesCurrentPage + 1;
      print("2");
      messages = await chatController.getChatMessages(
        page: messagesCurrentPage,
      );

      ///  messages
      if (messages['data'].length > 0) {
        print(messages['data']);
        isMessagesHasNextPage =
            messages['pagination']['meta']['page']['isNext'] == true;

        messagesData =messagesData+
            messages['data'].entries.map((entry) => entry.value).toList();
      }
      setState(() {
       isLoading=false;
      });
    }


  }

  /// Ensure that chat is not need to be initialized
  Future<bool> ensureInitializeChat() async {
    /// Get or create chat
    if (chatController.isInitChat.value == true) {
      if (token != null) {
        await chatController.getChatByToken(token);
      } else if (toUser != null) {
        await chatController.getOrCreateChat(
          toUserId: toUser.id,
          toUserType: toUser.type,
        );
      }
    }

    return !chatController.isInitChat.value;
  }
  final ImagePicker _picker = ImagePicker();

  /// Get image from gallery
  Future getGalleryImage(callback) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        callback(File(pickedFile.path));
      } else {
        if (config['isDebugMode']) print('No image selected.');
      }
    } catch (e) {
      Get.defaultDialog(
        title: 'Permissions'.tr,
        content: Text('Please give the gallery permission to the app.'.tr),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              'Cancel'.tr,
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              openAppSettings();
            },
            child: Text('Settings'.tr),
          ),
        ],
      );
    }
  }

  /// Get image form camera
  Future getCameraImage(callback) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
      );

      if (pickedFile != null) {
        callback(File(pickedFile.path));
      } else {
        if (config['isDebugMode']) print('No image selected.');
      }
    } catch (e) {
      Get.defaultDialog(
        title: 'Permissions'.tr,
        content: Text('Please give the camera permission to the app.'.tr),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              'Cancel'.tr,
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              openAppSettings();
            },
            child: Text('Settings'.tr),
          ),
        ],
      );
    }
  }


  @override
  void initState() {
    toUser = toUser ??
        (Get.arguments?['toUser'] != null ? Get.arguments['toUser'] : null);

    token = token ??
        (Get.arguments?['token'] != null ? Get.arguments['token'] : null);
    Future.delayed(Duration(seconds: 4)).then((value) {
      fetchMessagesByOffset(0);
    });
    messagesPaginationViewScrollController.addListener(pagination);



    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    /// Set user




    return FutureBuilder<bool>(
      future: ensureInitializeChat(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.data != null && snapshot.data == true) {
          return ChatLayout(
            isDefaultPadding: false,
            toUser: (toUser != null ? toUser : chatController.toUser),
            child: GetX<ChatController>(
              //init: ChatController(toUser: toUser),
              builder: (controller) => controller.isInitChat.value == true
                  ? Center(
                      child: LoadingBouncingLine.circle(),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Edges
                        Container(
                          padding: const EdgeInsetsDirectional.only(
                            start: 12,
                            end: 12,
                          ),
                          height: 12,
                        ),

                        /// Messages
                        Expanded(
                          child: StreamBuilder<DocumentSnapshot>(
                            stream: controller.messagesStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text('No messages.'.tr),
                                );
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: LoadingBouncingLine.circle(),
                                );
                              }



                              /// Messages

                               if(isLoading&&messagesData.length==0)
                               {
                                 return Center(
                                   child: LoadingBouncingLine.circle(),
                                 );
                               }

                              return  Column(
                                children: [
                                  isLoading? SizedBox(
                                   height: 30  ,
                                      child: Center(child: LoadingBouncingLine.circle())):SizedBox(),
                                  Expanded(
                                    child: ListView.separated(
                                      controller: messagesPaginationViewScrollController,
                                      reverse: true,
                                        itemBuilder: (context, index) {
                                      return WMessage(message: messagesData[index]);
                                    }, separatorBuilder: (context, index) {
                                      return SizedBox(height: 8, width: 8,);
                                    }, itemCount: messagesData.length),
                                  ),
                                ],
                              );

                            },
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),

                        CBr(),

                        /// Selected image
                        isShowSendImage.value == false
                            ? SizedBox()
                            : Padding(
                                padding: const EdgeInsetsDirectional.only(
                                  top: 12,
                                  start: 12,
                                ),
                                child: Stack(
                                  children: [
                                    /// Add button || Image
                                    Container(
                                      width: 80,
                                      height: 80,
                                      child: Card(
                                        clipBehavior: Clip.antiAlias,
                                        elevation: 1.5,

                                        /// Add button || Image
                                        child: Image.file(
                                          controller.selectedSendImage!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),

                                    /// Delete Image
                                    Visibility(
                                      visible: isSendingMessageLoading.value ==
                                          false,
                                      child: GestureDetector(
                                        onTap: () {
                                          controller.selectedSendImage = null;
                                          isShowSendImage.value = false;
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            width: 16,
                                            height: 16,
                                            decoration: BoxDecoration(
                                              color: Colors.white10,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.white70,
                                                  spreadRadius: 1,
                                                ),
                                              ],
                                            ),
                                            child: Icon(
                                              Icons.highlight_off,
                                              color: Colors.red.shade600,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                        Padding(
                          padding: const EdgeInsets.only(
                            top: 12,
                            bottom: 24,
                            left: 16,
                            right: 16,
                          ),
                          child: Form(
                            key: controller.messageFormKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  controller: controller.messageController,
                                  readOnly:
                                      isSendingMessageLoading.value == true,
                                  style: TextStyle(
                                    fontFamily: 'Arial',
                                    color: isSendingMessageLoading.value == true
                                        ? Colors.black45
                                        : Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Write your message...'.tr,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                        color: Color(0xffF1F2F6),
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                        color: Color(0xffF1F2F6),
                                        width: 1,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                        color: Color(0xffF1F2F6),
                                        width: 1,
                                      ),
                                    ),
                                    suffixIcon: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [

                                        /// Send image
                                        GestureDetector(
                                          child: Icon(
                                            Icons.image,
                                            color: (isSendingMessageLoading
                                                            .value ==
                                                        true ||
                                                    isShowSendImage.value ==
                                                        true)
                                                ? Colors.transparent
                                                : Colors.black45,
                                          ),
                                          onTap: () {
                                            if (isSendingMessageLoading.value ==
                                                    false &&
                                                isShowSendImage.value ==
                                                    false) {
                                              Get.bottomSheet(
                                                Container(
                                                  height: 150,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      children: [
                                                        CBottomSheetHead(),

                                                        SizedBox(
                                                          height: 12,
                                                        ),

                                                        /// Gallery
                                                        ListTile(
                                                          title: Text(
                                                            'The Gallery'.tr,
                                                          ),
                                                          leading: Icon(
                                                            Icons.image,
                                                          ),
                                                          minLeadingWidth: 0,
                                                          enabled: true,
                                                          selected: false,
                                                          dense: true,
                                                          onTap: () async {
                                                            getGalleryImage(
                                                              (imageFile) async {
                                                                /// Set image file
                                                                controller
                                                                        .selectedSendImage =
                                                                    imageFile;
                                                                isShowSendImage
                                                                        .value =
                                                                    true;
                                                              },
                                                            );

                                                            /// Back
                                                            Get.back();
                                                          },
                                                        ),

                                                        /// Camera
                                                        ListTile(
                                                          title: Text(
                                                            'The Camera'.tr,
                                                          ),
                                                          leading: Icon(
                                                            Icons
                                                                .camera_enhance,
                                                          ),
                                                          minLeadingWidth: 0,
                                                          enabled: true,
                                                          selected: false,
                                                          dense: true,
                                                          onTap: () async {
                                                            getCameraImage(
                                                              (imageFile) async {
                                                                /// Set image file
                                                                controller
                                                                        .selectedSendImage =
                                                                    imageFile;
                                                                isShowSendImage
                                                                        .value =
                                                                    true;

                                                              },
                                                            );

                                                            /// Back
                                                            Get.back();
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    10,
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                        ),

                                        /// Send text
                                        isSendingMessageLoading.value == true
                                            ? Container(
                                                width: 16,
                                                height: 16,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.black54,
                                                  strokeWidth: 2,
                                                ),
                                              )
                                            : IconButton(
                                                icon: Icon(
                                                  Icons.send,
                                                ),
                                                onPressed: () async {
                                                      List mm=[];
                                                      mm.add(ChatMessage(owner: GlobalVariables.user,
                                                        id: 0,
                                                        isOwner: true,
                                                        isRead: false,
                                                        createdAt: 'Now'.tr,
                                                        message:   controller.messageController.text,
                                                        localImage:  controller.selectedSendImage ,
                                                        channel: Chat(
                                                          id: 0,
                                                          token: '',
                                                          createdAt: 'Now'.tr,
                                                          lastMessageAt:  controller.messageController.text,

                                                        ),


                                                      ));
                                                      messagesData=mm+messagesData;
                                                      setState(() {});
                                                      isShowSendImage.value = false;
                                                  /// Send message
                                                  await controller
                                                      .sendMessage();
                                                },
                                              ),
                                      ],
                                    ),
                                    filled: true,
                                    fillColor: Color(0xffF1F2F6),
                                    contentPadding:
                                        const EdgeInsetsDirectional.only(
                                      start: 12,
                                    ),
                                  ),
                                  minLines: 1,
                                  maxLines: 4,
                                  maxLength: 250,
                                  validator: (value) {
                                    /// Trim value
                                    value = value?.trim();

                                    if (isShowSendImage.value == false &&
                                        (value == null || value.isEmpty)) {
                                      return 'This field is required'.tr;
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          );
        } else {
          return MainLayout(
            title: 'Messages'.tr,
            child: Center(
              child: LoadingBouncingLine.circle(),
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    /// Delete controllers
    Get.delete<ChatController>();

    super.dispose();
  }
}
