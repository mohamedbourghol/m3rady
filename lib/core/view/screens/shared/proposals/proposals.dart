import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:m3rady/core/controllers/proposals/proposals_controller.dart';
import 'package:m3rady/core/utils/storage/local/variables.dart';
import 'package:m3rady/core/view/layouts/main/main_layout.dart';
import 'package:m3rady/core/view/components/components.dart';
import 'package:m3rady/core/view/components/shared/proposals/proposal_small.dart';
import 'package:pagination_view/pagination_view.dart';

class ProposalsScreen extends StatelessWidget {
  final ProposalsController proposalsController =
      Get.put(ProposalsController());

  /// Proposal Pagination View
  ScrollController proposalsPaginationViewScrollController = ScrollController();

  GlobalKey<PaginationViewState> proposalsPaginationViewKey =
      GlobalKey<PaginationViewState>();

  int proposalCurrentPage = 1;

  bool isProposalHasNextPage = true;

  /// Fetch proposal
  Future<List<dynamic>> fetchProposalsByOffset(offset) async {
    List proposalsData = [];
    late Map proposals;

    /// Get proposal
    if (isProposalHasNextPage || offset == 0) {
      proposalCurrentPage = offset == 0 ? 1 : proposalCurrentPage + 1;
      proposals = await proposalsController.getProposals(
        page: proposalCurrentPage,
        isAnswered: proposalsController.isFilterShowAnswered.value == true,
        isSent: proposalsController.isFilterShowSent.value,
      );

      ///  proposal
      if (proposals['data'].length > 0) {
        isProposalHasNextPage =
            proposals['pagination']['meta']['page']['isNext'] == true;

        proposalsData =
            proposals['data'].entries.map((entry) => entry.value).toList();
      }
    }

    return proposalsData;
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      isDefaultPadding: false,
      title: 'The Proposals'.tr,
      child: Obx(
        () => Column(
          children: [
            /// Edges
            Container(
              padding: const EdgeInsetsDirectional.only(
                start: 12,
                end: 12,
              ),
              height: 12,
            ),

            /// List Type
            Container(
              color: Colors.white,
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: 10,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: 1,
                        maxWidth: Get.width / 2.2,
                        minHeight: 34,
                        maxHeight: 34,
                      ),
                      child: CMaterialButton(
                        disabled:
                            !proposalsController.isFilterShowAnswered.value,
                        borderColor: Color(0xffFD8200),
                        color: (!proposalsController.isFilterShowAnswered.value
                            ? Color(0xffFD8200)
                            : Colors.white),
                        disabledColor: Color(0xffFD8200),
                        child: Text(
                          'Unanswered'.tr,
                          style: TextStyle(
                            color:
                                (!proposalsController.isFilterShowAnswered.value
                                    ? Colors.white
                                    : Color(0xffFD8200)),
                          ),
                        ),
                        onPressed: () {
                          proposalsController.isFilterShowAnswered.value =
                              false;

                          /// Refresh data
                          try {
                            proposalsPaginationViewKey.currentState!
                                .refresh()
                                .onError((error, stackTrace) {})
                                .catchError((e) {});
                          } catch (e) {}
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                      end: 10,
                    ),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: 1,
                        maxWidth: Get.width / 2.2,
                        minHeight: 34,
                        maxHeight: 34,
                      ),
                      child: CMaterialButton(
                        disabled:
                            proposalsController.isFilterShowAnswered.value,
                        borderColor: Color(0xffFD8200),
                        color: (proposalsController.isFilterShowAnswered.value
                            ? Color(0xffFD8200)
                            : Colors.white),
                        disabledColor: Color(0xffFD8200),
                        child: Text(
                          'Answered'.tr,
                          style: TextStyle(
                            color:
                                (proposalsController.isFilterShowAnswered.value
                                    ? Colors.white
                                    : Color(0xffFD8200)),
                          ),
                        ),
                        onPressed: () {
                          proposalsController.isFilterShowAnswered.value = true;

                          /// Refresh data
                          try {
                            proposalsPaginationViewKey.currentState!
                                .refresh()
                                .onError((error, stackTrace) {})
                                .catchError((e) {});
                          } catch (e) {}
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 6,
            ),

            /// Break
            Container(
              color: Colors.grey.shade200,
              height: 6,
            ),

            Visibility(
              visible: GlobalVariables.user.type == 'advertiser',
              child: Column(
                children: [
                  SizedBox(
                    height: 6,
                  ),

                  /// List Type
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                            start: 10,
                          ),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: 1,
                              maxWidth: Get.width / 2.2,
                              minHeight: 34,
                              maxHeight: 34,
                            ),
                            child: CMaterialButton(
                              disabled:
                                  !proposalsController.isFilterShowSent.value,
                              borderColor: Colors.blue,
                              color:
                                  (!proposalsController.isFilterShowSent.value
                                      ? Colors.blue
                                      : Colors.white),
                              disabledColor: Colors.blue,
                              child: Text(
                                'Received'.tr,
                                style: TextStyle(
                                  color: (!proposalsController
                                          .isFilterShowSent.value
                                      ? Colors.white
                                      : Colors.blue),
                                ),
                              ),
                              onPressed: () {
                                proposalsController.isFilterShowSent.value =
                                    false;

                                /// Refresh data
                                try {
                                  proposalsPaginationViewKey.currentState!
                                      .refresh()
                                      .onError((error, stackTrace) {})
                                      .catchError((e) {});
                                } catch (e) {}
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(
                            end: 10,
                          ),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: 1,
                              maxWidth: Get.width / 2.2,
                              minHeight: 34,
                              maxHeight: 34,
                            ),
                            child: CMaterialButton(
                              disabled:
                                  proposalsController.isFilterShowSent.value,
                              borderColor: Colors.blue,
                              color: (proposalsController.isFilterShowSent.value
                                  ? Colors.blue
                                  : Colors.white),
                              disabledColor: Colors.blue,
                              child: Text(
                                'My Proposals'.tr,
                                style: TextStyle(
                                  color: (proposalsController
                                          .isFilterShowSent.value
                                      ? Colors.white
                                      : Colors.blue),
                                ),
                              ),
                              onPressed: () {
                                proposalsController.isFilterShowSent.value =
                                    true;

                                /// Refresh data
                                try {
                                  proposalsPaginationViewKey.currentState!
                                      .refresh()
                                      .onError((error, stackTrace) {})
                                      .catchError((e) {});
                                } catch (e) {}
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Break
                  Container(
                    color: Colors.grey.shade200,
                    height: 6,
                  ),
                ],
              ),
            ),

            Expanded(
              child: Container(
                color: Colors.grey.shade200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: PaginationView(
                        key: proposalsPaginationViewKey,
                        scrollController:
                            proposalsPaginationViewScrollController,
                        itemBuilder:
                            (BuildContext context, proposal, int index) =>
                                WProposalSmall(proposal: proposal),
                        separatorBuilder: (BuildContext context, int index) =>
                            SizedBox(
                          width: 8,
                          height: 8,
                        ),
                        pageFetch: fetchProposalsByOffset,
                        pullToRefresh: true,
                        onError: (dynamic error) => Center(
                          child: Text('No proposals.'.tr),
                        ),
                        onEmpty: Center(
                          child: Text('No proposals.'.tr),
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
            ),
          ],
        ),
      ),
    );
  }
}
