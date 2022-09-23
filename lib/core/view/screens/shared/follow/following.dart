import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:m3rady/core/controllers/follow/follow_controller.dart';
import 'package:m3rady/core/view/components/shared/follow/follower.dart';
import 'package:m3rady/core/view/layouts/main/main_layout.dart';
import 'package:pagination_view/pagination_view.dart';

class FollowingScreen extends StatefulWidget {
  @override
  State<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  final FollowController followController = Get.put(FollowController());

  String? userType = Get.arguments?['type'] ?? null;
  int? userId = Get.arguments?['id'] ?? null;

  /// Follows Pagination View
  final ScrollController followsPaginationViewScrollController =
      ScrollController();

  final GlobalKey<PaginationViewState> followsPaginationViewKey =
      GlobalKey<PaginationViewState>();

  int followsCurrentPage = 1;

  bool isFollowsHasNextPage = true;

  /// Fetch follows
  Future<List<dynamic>> fetchFollowsByOffset(offset) async {
    List followsData = [];
    late Map follows;

    /// Get follows
    if (isFollowsHasNextPage || offset == 0) {
      followsCurrentPage = offset == 0 ? 1 : followsCurrentPage + 1;

      follows = await followController.getFollowed(
        page: followsCurrentPage,
        userId: userId,
        userType: userType,
      );

      ///  follows
      if (follows['data'].length > 0) {
        isFollowsHasNextPage =
            follows['pagination']['meta']['page']['isNext'] == true;

        followsData =
            follows['data'].entries.map((entry) => entry.value).toList();
      }
    }
    return followsData;
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Following'.tr,
      isDefaultPadding: false,
      child: Column(
        children: [
          /// Edges
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              boxShadow: [
                BoxShadow(
                  blurRadius: 1,
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 0.5,
                )
              ],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            height: 12,
          ),

          Expanded(
            child: Container(
              color: Colors.grey.shade200,
              child: PaginationView(
                key: followsPaginationViewKey,
                scrollController: followsPaginationViewScrollController,
                itemBuilder: (BuildContext context, follower, int index) =>
                    WFollower(follower: follower),
                separatorBuilder: (BuildContext context, int index) => SizedBox(
                  width: 8,
                  height: 8,
                ),
                pageFetch: fetchFollowsByOffset,
                pullToRefresh: true,
                onError: (dynamic error) => Center(
                  child: Text('No one.'.tr),
                ),
                onEmpty: Center(
                  child: Text('No one.'.tr),
                ),
                bottomLoader: Center(
                  child: LoadingBouncingLine.circle(),
                ),
                initialLoader: Center(
                  child: LoadingBouncingLine.circle(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    /// Delete controllers
    Get.delete<FollowController>();

    super.dispose();
  }
}
