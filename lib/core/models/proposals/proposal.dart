import 'package:m3rady/core/models/media/media.dart';
import 'package:m3rady/core/models/users/user.dart';
import 'package:m3rady/core/utils/services/AppServices.dart';

class Proposal {
  int id;
  String content;
  String? answer;
  Map? media;
  User owner;
  User toUser;
  User otherUser;
  int? expiresIn;
  bool? isExpired;
  bool? isAllowAnswer;
  bool? isOwner;
  String? expiresAt;
  String? answeredAt;
  String? createdAt;

  Proposal({
    required this.id,
    required this.content,
    this.answer,
    this.media,
    required this.owner,
    required this.toUser,
    required this.otherUser,
    this.expiresIn,
    this.isExpired,
    this.isOwner,
    this.isAllowAnswer,
    this.expiresAt,
    this.answeredAt,
    this.createdAt,
  });

  /// Factory
  factory Proposal.fromJson(Map<String, dynamic> data) {
    return Proposal(
      id: data['id'] as int,
      content: data['content'] as String,
      answer: data['answer'],
      media: Media.generateMapWithIdFromJson(data['media']),
      owner: User.fromJson(data['owner']),
      toUser: User.fromJson(data['toUser']),
      otherUser: User.fromJson(
          (data['isOwner'] == true ? data['toUser'] : data['owner'])),
      expiresIn: data['expiresIn'],
      isAllowAnswer: (data['isAllowAnswer'] ?? false) as bool,
      isExpired: (data['isExpired'] ?? false) as bool,
      isOwner: (data['isOwner'] ?? false) as bool,
      expiresAt: data['expiresAt'],
      answeredAt: data['answeredAt'],
      createdAt: data['createdAt'],
    );
  }

  /// Generate map with id from json
  static generateMapWithIdFromJson(List rawData) {
    var data = {};

    /// Handle data
    if (rawData.length > 0) {
      rawData.asMap().forEach((key, value) {
        var entry = Proposal.fromJson(value);

        /// Set data
        data[entry.id.toString()] = entry;
      });
    }

    return data;
  }

  /// Create proposal
  static Future create({
    required int advertiserId,
    required String content,
    Map? media,
  }) async {
    /// Set auto show errors
    await AppServices.setAutoShowErrors(true);

    var request = await AppServices.createProposal(
      advertiserId: advertiserId,
      content: content,
      media: media,
    );

    if (request['status'] == true) {
      return {
        'message': request['message'],
        'data': request['data'],
      };
    }

    return false;
  }

  /// Get proposals (pagination)
  static Future getProposals({
    int? limit,
    int? page,
    bool? isAnswered,
    bool? isSent,
  }) async {
    var data = {
      'data': {},
      'pagination': {},
    };

    var proposals = await AppServices.getProposals(
      limit: limit,
      page: page,
      isSent: isSent,
      isAnswered: isAnswered,
    );

    if (proposals['status'] == true) {
      data['data'] = generateMapWithIdFromJson(proposals['data']);

      data['pagination'] = proposals['pagination'];
    }

    return data;
  }

  /// Get proposal
  static Future getProposalById(int id) async {
    var proposal = await AppServices.getProposalById(id);

    if (proposal['status'] != false) {
      return Proposal.fromJson(proposal['data']);
    }

    return false;
  }

  /// Answer proposal
  static Future answerProposal(
    id, {
    required answer,
    required expiresIn,
  }) async {
    /// Set auto show errors
    await AppServices.setAutoShowErrors(true);

    var request = await AppServices.answerProposal(
      id,
      answer: answer,
      expiresIn: expiresIn,
    );

    if (request['status'] == true) {
      /// If post has data
      return {
        'message': request['message'],
        'data': request['data'],
      };
    }

    return false;
  }

  /// Report proposal
  static Future reportProposalById(id) async {
    var report = await AppServices.reportProposalById(id);

    if (report['status'] == true) {
      return {
        'message': report['message'],
        'data': report['data'],
      };
    }

    return false;
  }
}
