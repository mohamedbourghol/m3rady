import 'package:m3rady/core/models/chats/messages/chat_message.dart';
import 'package:m3rady/core/models/users/user.dart';
import 'package:m3rady/core/utils/services/AppServices.dart';

class Chat {
  int id;
  String token;
  User? toUser;
  ChatMessage? lastMessage;
  int? unreadMessagesCount;
  String? lastMessageAt;
  String? createdAt;

  Chat({
    required this.id,
    required this.token,
    this.toUser,
    this.lastMessage,
    this.unreadMessagesCount,
    this.lastMessageAt,
    this.createdAt,
  });

  /// Factory
  factory Chat.fromJson(Map<String, dynamic> data) {
    return Chat(
      id: data['id'] as int,
      token: data['token'] as String,
      toUser: data['toUser'] != null ? User.fromJson(data['toUser']) : null,
      lastMessage: data['lastMessage'] != null
          ? ChatMessage.fromJson(data['lastMessage'])
          : null,
      unreadMessagesCount: data['unreadMessagesCount'] ?? 0,
      lastMessageAt: data['lastMessageAt'] ?? '',
      createdAt: data['createdAt'] ?? '',
    );
  }

  /// Generate map with id from json
  static generateMapWithIdFromJson(List rawData) {
    var data = {};

    /// Handle data
    if (rawData.length > 0) {
      rawData.asMap().forEach((key, value) {
        var entry = Chat.fromJson(value);

        /// Set data
        data[entry.id.toString()] = entry;
      });
    }

    return data;
  }

  /// Get chats (pagination)
  static Future getChats({
    int? limit,
    int? page,
  }) async {
    var data = {
      'data': {},
      'pagination': {},
    };

    var chats = await AppServices.getChats(
      limit: limit,
      page: page,
    );

    if (chats['status'] == true) {
      data['data'] = generateMapWithIdFromJson(chats['data']);
      data['pagination'] = chats['pagination'];
    }

    return data;
  }

  /// Get or create chat
  static Future getOrCreateChat({
    required int toUserId,
    required String toUserType,
  }) async {
    var data = await AppServices.getOrCreateChat(
      toUserId: toUserId,
      toUserType: toUserType,
    );

    if (data['status'] == true) {
      return {
        'message': data['message'],
        'data': data['data'],
      };
    }

    return false;
  }

  /// Get chat by token
  static Future getChatByToken(token) async {
    var data = await AppServices.getChatByToken(token);

    if (data['status'] == true) {
      return {
        'message': data['message'],
        'data': data['data'],
      };
    }

    return false;
  }
}
