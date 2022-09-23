import 'package:m3rady/core/models/chats/chat.dart';
import 'package:m3rady/core/models/media/media.dart';
import 'package:m3rady/core/models/users/user.dart';
import 'package:m3rady/core/utils/services/AppServices.dart';
import 'dart:io';

class ChatMessage {
  int id;
  User owner;
  Chat channel;
  String? message;
  Media? media;
  bool isRead;
  bool isOwner;
  String? createdAt;
  File? localImage;

  ChatMessage({
    required this.id,
    required this.owner,
    required this.channel,
    this.message,
    this.media,
    required this.isRead,
    required this.isOwner,
    this.createdAt,
    this.localImage,
  });

  /// Factory
  factory ChatMessage.fromJson(Map<String, dynamic> data) {
    return ChatMessage(
      id: data['id'] as int,
      owner: User.fromJson(data['owner']),
      channel: Chat.fromJson(data['channel']),
      message: data['message'] ?? '',
      media: data['media'] != null ? Media.fromJson(data['media']) : null,
      isRead: data['isRead'],
      isOwner: data['isOwner'],
      createdAt: data['createdAt'] ?? '',
    );
  }

  /// Generate map with id from json
  static generateMapWithIdFromJson(List rawData) {
    var data = {};

    /// Handle data
    if (rawData.length > 0) {
      rawData.asMap().forEach((key, value) {
        var entry = ChatMessage.fromJson(value);

        /// Set data
        data[entry.id.toString()] = entry;
      });
    }

    return data;
  }

  /// Get chat messages (pagination)
  static Future getChatMessages(
    token, {
    int? limit,
    int? page,
  }) async {
    var data = {
      'data': {},
      'pagination': {},
    };

    var messages = await AppServices.getChatMessages(
      token,
      limit: limit,
      page: page,
    );

    if (messages['status'] == true) {
      data['data'] = generateMapWithIdFromJson(messages['data']);
      data['pagination'] = messages['pagination'];
    }

    return data;
  }

  /// Add chat message
  static Future addChatMessage(
    token, {
    String? message,
    File? mediaFile,
    bool? isVoiceNote,
  }) async {
    var data = await AppServices.addChatMessage(
      token,
      message: message,
      mediaFile: mediaFile,
      isVoiceNote: isVoiceNote,
    );

    if (data['status'] == true) {
      return {
        'message': data['message'],
        'data': data['data'],
      };
    }

    return false;
  }
}
