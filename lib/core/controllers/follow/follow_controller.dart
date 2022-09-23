import 'package:get/get.dart';
import 'package:m3rady/core/models/follow/follow.dart';
import 'package:m3rady/core/view/components/components.dart';

class FollowController extends GetxController {
  /// Get following (pagination)
  Future getFollowed({
    limit,
    page,
    String? userType,
    int? userId,
  }) async {
    return await Follow.getFollowed(
      limit: limit,
      page: page,
      userType: userType,
      userId: userId,
    );
  }

  /// Get followers (pagination)
  Future getFollowers({
    limit,
    page,
    String? userType,
    int? userId,
  }) async {
    return await Follow.getFollowers(
      limit: limit,
      page: page,
      userType: userType,
      userId: userId,
    );
  }

  /// Get requests (pagination)
  Future getFollowRequests({
    limit,
    page,
  }) async {
    return await Follow.getFollowRequests(
      limit: limit,
      page: page,
    );
  }

  /// Update user follow
  Future toggleFollowUser({
    required userId,
    required userType,
    isFollow,
  }) async {
    var follow = await Follow.toggleFollowUser(
      id: userId,
      type: userType,
      isFollow: isFollow,
    );

    if (follow != false) {
      /// Show toast
      CToast(text: follow['message']);
    }

    return follow;
  }

  /// Update follow request
  Future updateFollowRequestByFollower(
    follower, {
    required status,
  }) async {
    return await updateFollowRequestById(
      follower.id,
      status: status,
    );
  }

  /// Update follow request
  Future updateFollowRequestById(
    id, {
    required status,
  }) async {
    var follow = await Follow.updateFollowRequest(
      id,
      status: status,
    );

    if (follow != false) {
      /// Show toast
      CToast(text: follow['message']);
    }

    return follow;
  }
}
