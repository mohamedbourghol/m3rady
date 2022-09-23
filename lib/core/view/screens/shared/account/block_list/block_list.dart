import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:m3rady/core/controllers/account/account_controller.dart';
import 'package:m3rady/core/view/components/shared/blocked_user/blocked_user.dart';
import 'package:m3rady/core/view/layouts/main/main_layout.dart';
import 'package:pagination_view/pagination_view.dart';

class BlockListScreen extends StatelessWidget {
  final AccountController accountController = Get.put(AccountController(
    loadCategories: false,
    loadCountries: false,
    loadSocialLogin: false,
    loadAccount: false,
  ));

  /// Advertisers Pagination View
  final ScrollController blockListPaginationViewScrollController =
      ScrollController();

  final GlobalKey<PaginationViewState> blockListPaginationViewKey =
      GlobalKey<PaginationViewState>();

  int blockListCurrentPage = 0;

  bool isBlockListHasNextPage = true;

  /// Fetch block list
  Future<List<dynamic>> fetchBlockListByOffset(offset) async {
    List blockListData = [];
    late Map blockList;

    /// Get block list
    if (isBlockListHasNextPage || offset == 0) {
      blockListCurrentPage = offset == 0 ? 1 : blockListCurrentPage + 1;

      blockList = await accountController.getBlockList(
        page: blockListCurrentPage,
      );

      ///  advertisers
      if (blockList['data'].length > 0) {
        isBlockListHasNextPage =
            blockList['pagination']['meta']['page']['isNext'] == true;

        blockListData =
            blockList['data'].entries.map((entry) => entry.value).toList();
      }
    }

    return blockListData;
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      isDefaultPadding: false,
      title: 'Blocked Users'.tr,
      child: GetBuilder<AccountController>(
        builder: (controller) => Column(
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
                  key: blockListPaginationViewKey,
                  scrollController: blockListPaginationViewScrollController,
                  itemBuilder: (BuildContext context, user, int index) =>
                      WBlockedUser(user: user),
                  separatorBuilder: (BuildContext context, int index) =>
                      SizedBox(
                    width: 8,
                    height: 8,
                  ),
                  pageFetch: fetchBlockListByOffset,
                  pullToRefresh: true,
                  onError: (dynamic error) => Center(
                    child: Text('No users.'.tr),
                  ),
                  onEmpty: Center(
                    child: Text('No users.'.tr),
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
            SizedBox(
              height: 24,
            ),
          ],
        ),
      ),
    );
  }
}
