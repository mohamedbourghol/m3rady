import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:m3rady/core/controllers/follow/follow_controller.dart';
import 'package:m3rady/core/view/components/components.dart';
import 'package:m3rady/core/view/components/shared/follow/follower.dart';
import 'package:m3rady/core/view/layouts/main/main_layout.dart';
import 'package:pagination_view/pagination_view.dart';

class FollowersScreen extends StatefulWidget {
  @override
  State<FollowersScreen> createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen> {
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

      follows = await followController.getFollowers(
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
      title: 'Followers'.tr,
      isDefaultPadding: false,
      child: Column(
        children: [
          /// Edges
          Container(
            width: Get.width,
            decoration: BoxDecoration(
              color: Colors.white,
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
            child: Padding(
              padding: EdgeInsetsDirectional.only(
                top: 12,
                bottom: userId == null ? 12 : 0,
                start: 12,
                end: 12,
              ),
              child: Visibility(
                visible: userId == null,
                child: InkWell(
                  onTap: () {
                    Get.toNamed(
                      '/profile/followers/requests',
                    );
                  },
                  child: Text(
                    'View follow requests'.tr,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
          ),

          CBr(),

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
