import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m3rady/core/models/chats/chat.dart';
import 'package:m3rady/core/models/chats/messages/chat_message.dart';

class ChatController extends GetxController {
  ChatController({
    this.toUser,
    this.token,
  });

  /// Set to user
  var toUser;

  // Set token
  var token;

  /// Set chat
  var chat;

  /// Set messages stream
  Stream<DocumentSnapshot>? messagesStream;

  /// Set is initializing chat
  var isInitChat = true.obs;

  /// Set message form key
  final GlobalKey<FormState> messageFormKey = GlobalKey<FormState>();

  /// Set message controller
  final TextEditingController messageController = TextEditingController();

  /// Image to be sent
  File? selectedSendImage;

  /// Get chats (pagination)
  Future getChats({
    int? limit,
    int? page,
  }) async {
    return await Chat.getChats(
      limit: limit,
      page: page,
    );
  }

  /// Get or create chat
  Future getOrCreateChat({
    required int toUserId,
    required String toUserType,
  }) async {
    var chat = await Chat.getOrCreateChat(
      toUserId: toUserId,
      toUserType: toUserType,
    );

    /// Set chat
    if (chat != false) {
      this.chat = Chat.fromJson(chat['data']);

      // Set token
      this.token = this.chat.token;

      /// Realtime
      try {
        messagesStream = FirebaseFirestore.instance
            .collection('chats')
            .doc(this.chat.token)
            .snapshots();
      } catch (e) {}

      /// Set is init
      isInitChat.value = false;
    } else {
      Get.back();
    }

    return chat;
  }

  /// Get or create chat
  Future getChatByToken(token) async {
    var chat = await Chat.getChatByToken(token);

    /// Set chat
    if (chat != false) {
      this.chat = Chat.fromJson(chat['data']);

      // Set to user
      this.toUser = this.chat.toUser;

      /// Realtime
      try {
        messagesStream = FirebaseFirestore.instance
            .collection('chats')
            .doc(this.chat.token)
            .snapshots();
      } catch (e) {}

      /// Set is init
      isInitChat.value = false;
    } else {
      Get.back();
    }

    return chat;
  }

  /// Get chat messages (pagination)
  Future getChatMessages({
    int? limit,
    int? page,
  }) async {
    return await ChatMessage.getChatMessages(
      chat.token,
      limit: limit,
      page: page,
    );
  }

  /// Add chat message
  Future addChatMessage(
    token, {
    String? message,
    File? mediaFile,
    bool? isVoiceNote,
  }) async {
    return await ChatMessage.addChatMessage(
      token,
      message: message,
      mediaFile: mediaFile,
      isVoiceNote: isVoiceNote,
    );
  }

  /// Send text message
  Future sendTextMessage() async {
    if (messageFormKey.currentState != null &&
        messageFormKey.currentState!.validate()) {
      if (chat?.token != null) {
        /// Send request
        var message = await addChatMessage(
          chat.token,
          message: messageController.text.trim(),
        );

        /// If sent
        if (message != false) {
          /// Clear data
          messageController.clear();

          return ChatMessage.fromJson(message['data']);
        }
      }
    }

    return false;
  }

  /// Send media message
  Future sendMediaMessage(mediaFile) async {
    if (chat?.token != null) {
      var message = await addChatMessage(
        chat.token,
        mediaFile: mediaFile,
        //message: messageController.text.trim(),
      );

      /// If sent
      if (message != false) {
        /// Clear data
        //messageController.clear();

        return ChatMessage.fromJson(message['data']);
      }
    }

    return false;
  }

  // Send message
  Future sendMessage() async {

    String me= messageController.text;
    File? im=  selectedSendImage ;

    if (messageFormKey.currentState != null &&
        messageFormKey.currentState!.validate()) {
      /// Clear data
      messageController.clear();
     selectedSendImage = null;
      if (chat?.token != null) {
        var message = await addChatMessage(
          chat.token,
          mediaFile: im,
          message: me.trim(),
        );

        /// If sent
        if (message != false) {


          return ChatMessage.fromJson(message['data']);
        }
      }
    }

    return false;
  }
}
