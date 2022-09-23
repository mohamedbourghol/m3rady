
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:m3rady/core/controllers/proposals/proposals_controller.dart';
import 'package:m3rady/core/view/components/components.dart';
import 'package:m3rady/core/view/layouts/main/main_layout.dart';
import 'package:m3rady/core/view/components/shared/users/user_image.dart';
import 'package:m3rady/core/view/widgets/photo_viewer/network_dialog.dart';

class ProposalScreen extends StatefulWidget {
  @override
  _ProposalScreenState createState() => _ProposalScreenState();
}

class _ProposalScreenState extends State<ProposalScreen> {
  ProposalsController proposalController = Get.put(ProposalsController());

  /// Set proposal
  final proposalId = Get.arguments?['proposalId'];

  /// Get proposal
  Future<bool> getProposal(id) async {
    var proposal;

    if (proposalController.isProposalLoaded == false) {
      proposal = await proposalController.getProposalById(id);
    } else {
      return true;
    }

    return (proposal != false);
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      isDefaultPadding: false,
      title: 'The Proposal'.tr,
      child: GetBuilder<ProposalsController>(
        builder: (controller) => FutureBuilder<bool>(
          future: getProposal(proposalId),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.data != null && snapshot.data == true) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    /// Edges
                    Container(
                      padding: const EdgeInsetsDirectional.only(
                        start: 12,
                        end: 12,
                      ),
                      height: 12,
                    ),

                    /// Image
                    WUserImage(
                      controller.proposal.otherUser?.imageUrl,
                      isElite: controller.proposal.otherUser?.isElite,
                      radius: 35,
                    ),

                    SizedBox(
                      height: 6,
                    ),

                    /// Name
                    Text(
                      controller.proposal.otherUser?.fullName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54,
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

                    SizedBox(
                      height: 6,
                    ),

                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Specifications
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 12,
                              right: 12,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 12,
                                ),

                                /// Title
                                Align(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                      bottom: 8,
                                    ),
                                    child: Text(
                                      'Proposal Specification'.tr,
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),

                                /// Content
                                Text(
                                  controller.proposal.content,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Arial',
                                  ),
                                ),

                                SizedBox(
                                  height: 12,
                                ),
                              ],
                            ),
                          ),

                          /// Media
                          Visibility(
                            visible: (controller.proposal.media.length > 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 12,
                                ),

                                /// Break
                                Container(
                                  color: Colors.grey.shade200,
                                  height: 6,
                                ),

                                SizedBox(
                                  height: 12,
                                ),

                                /// Title
                                Align(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                      bottom: 8,
                                      start: 12,
                                      end: 12,
                                    ),
                                    child: Text(
                                      'The Images'.tr,
                                      style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),

                                /// Content
                                Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                    start: 12,
                                    end: 12,
                                  ),
                                  child: Container(
                                    padding: const EdgeInsetsDirectional.only(
                                      bottom: 8,
                                    ),
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: List<Widget>.generate(
                                            controller.proposal.media.length,
                                            (index) {
                                          /// Image
                                          return Stack(
                                            alignment: AlignmentDirectional
                                                .bottomCenter,
                                            children: [
                                              /// Add button || Image
                                              Container(
                                                width: 124,
                                                height: 124,
                                                child: Card(
                                                  clipBehavior: Clip.antiAlias,
                                                  elevation: 1.5,

                                                  /// Add button || Image
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      if (controller
                                                              .proposal
                                                              ?.media[controller
                                                                      .proposal
                                                                      .media
                                                                      .keys
                                                                      .toList()[
                                                                  index]]
                                                              ?.mediaUrl !=
                                                          '') {
                                                        await dialogShowImages(
                                                            context: context,
                                                            ur:controller
                                                                .proposal
                                                                ?.media[controller
                                                                .proposal
                                                                .media
                                                                .keys
                                                                .toList()[
                                                        index]]
                                                          ?.mediaUrl,
                                                        );

                                                      }
                                                    },
                                                    child: CachedNetworkImage(
                                                     imageUrl:  controller
                                                              .proposal
                                                              ?.media[controller
                                                                      .proposal
                                                                      .media
                                                                      .keys
                                                                      .toList()[
                                                                  index]]
                                                              ?.mediaUrl ??
                                                          '',


                                                    ),
                                                  ),
                                                ),
                                              ),

                                              /// Image number
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(12),
                                                child: Container(
                                                  width: 16,
                                                  height: 17,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade200,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(4),
                                                    ),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      (index + 1).toString(),
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black38,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(
                                  height: 12,
                                ),
                              ],
                            ),
                          ),

                          /// Answer
                          Visibility(
                            visible: (controller.proposal.answer != null &&
                                controller.proposal.answer != ''),
                            child: Column(
                              children: [
                                /// Break
                                Container(
                                  color: Colors.grey.shade200,
                                  height: 6,
                                ),

                                SizedBox(
                                  height: 12,
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 12,
                                    right: 12,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      /// Title
                                      Align(
                                        alignment:
                                            AlignmentDirectional.centerStart,
                                        child: Padding(
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                            bottom: 8,
                                          ),
                                          child: Text(
                                            'Proposal Response'.tr,
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),

                                      /// Content
                                      Text(
                                        controller.proposal?.answer ?? '-',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'Arial',
                                        ),
                                      ),

                                      SizedBox(
                                        height: 12,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /// Expire in
                          Visibility(
                            visible: (controller.proposal.expiresIn != null &&
                                controller.proposal.expiresIn != ''),
                            child: Column(
                              children: [
                                /// Break
                                Container(
                                  color: Colors.grey.shade200,
                                  height: 6,
                                ),

                                SizedBox(
                                  height: 12,
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 12,
                                    right: 12,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      /// Title
                                      Align(
                                        alignment:
                                            AlignmentDirectional.centerStart,
                                        child: Padding(
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                            bottom: 8,
                                          ),
                                          child: Text(
                                            'Expires after'.tr,
                                            style: TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),

                                      /// Content
                                      Text(
                                        controller.proposal.expiresIn
                                                .toString() +
                                            ' ' +
                                            'days'.tr,
                                        /*+
                                            controller.proposal.expiresAt ?? '-',*/
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: 'Arial',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /// Add Answer
                          Visibility(
                            visible: controller.proposal.isAllowAnswer == true,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 12,
                                ),

                                /// Break
                                Container(
                                  color: Colors.grey.shade200,
                                  height: 6,
                                ),

                                /// Form
                                Form(
                                  key: controller.proposalAnswerFormKey,
                                  child: Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                      top: 12,
                                      start: 12,
                                      end: 12,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        /// Answer
                                        CTextFormField(
                                          controller: controller
                                              .contentAnswerController,
                                          keyboardType: TextInputType.multiline,
                                          contentPadding:
                                              EdgeInsetsDirectional.only(
                                            start: 8,
                                            end: 8,
                                            top: 12,
                                          ),
                                          maxLength: 1500,
                                          minLines: 4,
                                          hintText: 'Answer the proposal'.tr,
                                          labelText: 'Answer the proposal'.tr,
                                          isRequired: true,
                                          onEditingComplete: () {
                                            Get.focusScope?.nextFocus();
                                          },
                                        ),

                                        /// Days
                                        CTextFormField(
                                          controller: controller
                                              .expiresInAnswerController,
                                          keyboardType: TextInputType.number,
                                          labelText: 'Validity days'.tr,
                                          hintText:
                                              "${'Validity days'.tr} (${'15 ' + 'days'.tr})",
                                          isRequired: true,
                                          onEditingComplete: () {
                                            Get.focusScope?.nextFocus();
                                          },
                                        ),

                                        SizedBox(
                                          height: 24,
                                        ),

                                        /// Submit
                                        CMaterialButton(
                                          child: Text(
                                            'Answer the proposal'.tr,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          onPressed: () async {
                                            Get.focusScope?.unfocus();

                                            await controller.answerProposal();
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                SizedBox(
                                  height: 12,
                                ),

                                /// Break
                                Container(
                                  color: Colors.grey.shade200,
                                  height: 6,
                                ),
                              ],
                            ),
                          ),

                          SizedBox(
                            height: 12,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            return Container(
              child: Center(
                child: LoadingBouncingLine.circle(),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    proposalController.proposal = null;
    proposalController.isProposalLoaded = false;
  }
}
