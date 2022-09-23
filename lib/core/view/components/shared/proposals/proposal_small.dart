import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m3rady/core/controllers/proposals/proposals_controller.dart';
import 'package:m3rady/core/view/components/components.dart';
import 'package:m3rady/core/view/components/shared/users/user_image.dart';
import 'package:simple_star_rating/simple_star_rating.dart';

class WProposalSmall extends StatelessWidget {
  final ProposalsController proposalsController =
      Get.put(ProposalsController());

  var proposal;

  WProposalSmall({
    required this.proposal,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: InkWell(
        onTap: () {
          Get.toNamed(
            '/proposal',
            arguments: {
              'proposalId': proposal.id,
            },
          );
        },
        child: Container(
          width: Get.width,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              /// Name, rate, content
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Image
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: GestureDetector(
                      onTap: () {
                        /// Goto user profile
                        if (!proposal.otherUser.isSelf) {
                          /// Redirect to advertiser profile
                          if (proposal.otherUser.type == 'advertiser') {
                            Get.toNamed('/advertiser/profile', arguments: {
                              'id': proposal.otherUser.id,
                            });
                          } else if (proposal.otherUser.type == 'customer') {
                            Get.toNamed('/customer/profile', arguments: {
                              'id': proposal.otherUser.id,
                            });
                          }
                        } else {
                          Get.toNamed('/profile/me');
                        }
                      },
                      child: WUserImage(
                        proposal.otherUser.imageUrl,
                        isElite: proposal.otherUser.isElite == true,
                        radius: 24,
                      ),
                    ),
                  ),

                  /// Name, rate, content
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Name
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 12,
                          ),

                          ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: 1,
                              maxWidth: Get.width - 112,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                /// Goto user profile
                                if (!proposal.otherUser.isSelf) {
                                  /// Redirect to advertiser profile
                                  if (proposal.otherUser.type == 'advertiser') {
                                    Get.toNamed('/advertiser/profile',
                                        arguments: {
                                          'id': proposal.otherUser.id,
                                        });
                                  } else if (proposal.otherUser.type ==
                                      'customer') {
                                    Get.toNamed('/customer/profile',
                                        arguments: {
                                          'id': proposal.otherUser.id,
                                        });
                                  }
                                } else {
                                  Get.toNamed('/profile/me');
                                }
                              },
                              child: Text(
                                proposal.otherUser.fullName,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),

                          SizedBox(
                            height: 2,
                          ),

                          /// Rate
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SimpleStarRating(
                                starCount: 5,
                                rating: (proposal.otherUser.rate != null
                                    ? double.parse((proposal.otherUser.rate > 5
                                            ? 5
                                            : proposal.otherUser.rate)
                                        .round()
                                        .toString())
                                    : 0),
                                size: 12,
                                spacing: 1,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(2),
                                child: Text(
                                  (proposal.otherUser.rate != null
                                      ? '(${proposal.otherUser.rate})'
                                      : "(${'No Rate'.tr})"),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          /// Content
                          Container(
                            width: Get.width - 120,
                            child: Text(
                              proposal.content,
                              style: TextStyle(
                                fontSize: 13,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      /// Actions
                      Visibility(
                        visible: (proposal.isOwner == false ||
                            (proposal.answer != null && proposal.answer != '')),
                        child: IconButton(
                          icon: Icon(
                            Icons.more_vert,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            Get.bottomSheet(
                              Container(
                                height: 100,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      CBottomSheetHead(),

                                      SizedBox(
                                        height: 12,
                                      ),

                                      /// Report proposal
                                      ListTile(
                                        title: Text('Report Proposal'.tr),
                                        leading:
                                            Icon(Icons.report_problem_outlined),
                                        minLeadingWidth: 0,
                                        enabled: true,
                                        selected: false,
                                        dense: true,
                                        onTap: () async {
                                          Get.back();

                                          await proposalsController
                                              .reportProposal(proposal.id);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              backgroundColor: Colors.white,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              /// Date
              Padding(
                padding: const EdgeInsets.only(
                  left: 6,
                  right: 6,
                  bottom: 6,
                ),
                child: Text(
                  (proposal.answeredAt != null
                      ? proposal.answeredAt
                      : proposal.createdAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black45,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
