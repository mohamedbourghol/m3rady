import 'dart:async';

import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:m3rady/core/controllers/chat/chat_controller.dart';
import 'package:m3rady/core/view/components/components.dart';
import 'package:m3rady/core/view/layouts/main/main_layout.dart';
import 'package:get/get.dart';
import 'package:m3rady/core/view/components/shared/chats/chat.dart';
import 'package:pagination_view/pagination_view.dart';

class ChatsScreen extends StatefulWidget {
  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  Timer? _refreshChatsPerTimer;

  ChatController chatsController = Get.put(ChatController());

  ScrollController chatsPaginationViewScrollController = ScrollController();

  GlobalKey<PaginationViewState> chatsPaginationViewKey =
      GlobalKey<PaginationViewState>();

  int chatsCurrentPage = 1;

  bool isChatsHasNextPage = true;

  Future<List<dynamic>> fetchChatsByOffset(offset) async {
    List chatsData = [];
    late Map chats;

    /// Get chats
    if (isChatsHasNextPage || offset == 0) {
      chatsCurrentPage = offset == 0 ? 1 : chatsCurrentPage + 1;

      chats = await chatsController.getChats(
        page: chatsCurrentPage,
      );

      /// chats
      if (chats['data'].length > 0) {
        isChatsHasNextPage =
            chats['pagination']['meta']['page']['isNext'] == true;

        chatsData = chats['data'].entries.map((entry) => entry.value).toList();
      }
    }

    return chatsData;
  }

  @override
  Widget build(BuildContext context) {
    /// Refresh messages timer
    if (_refreshChatsPerTimer == null) {
      _refreshChatsPerTimer =
          Timer.periodic(Duration(seconds: 15), (Timer t) async {
        /// Refresh data
        try {
          chatsPaginationViewKey.currentState!
              .refresh()
              .onError((error, stackTrace) {})
              .catchError((e) {});
        } catch (e) {}
      });
    }

    return MainLayout(
      title: 'Messages'.tr,
      isDefaultPadding: false,
      child: SafeArea(
        child: Column(
          children: [
            /// Edges
            Container(
              padding: const EdgeInsetsDirectional.only(
                start: 12,
                end: 12,
              ),
              height: 12,
            ),

            Expanded(
              child: PaginationView(
                key: chatsPaginationViewKey,
                scrollController: chatsPaginationViewScrollController,
                itemBuilder: (BuildContext context, chat, int index) =>
                    WChat(chat: chat),
                separatorBuilder: (BuildContext context, int index) => SizedBox(
                  child: CBr(),
                  width: 8,
                  height: 8,
                ),
                pageFetch: fetchChatsByOffset,
                pullToRefresh: true,
                onError: (dynamic error) => Center(
                  child: Text('No messages.'.tr),
                ),
                onEmpty: Center(
                  child: Text('No messages.'.tr),
                ),
                bottomLoader: Center(
                  /// optional
                  child: LoadingBouncingLine.circle(),
                ),
                initialLoader: Center(
                  /// optional
                  child: LoadingBouncingLine.circle(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    /// Cancel timer
    _refreshChatsPerTimer?.cancel();

    /// Delete controllers
    Get.delete<ChatController>();

    super.dispose();
  }
}
