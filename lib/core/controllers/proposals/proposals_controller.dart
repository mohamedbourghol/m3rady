import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m3rady/core/controllers/advertisers/profile/profile_controller.dart';
import 'package:m3rady/core/helpers/main_loader.dart';
import 'package:m3rady/core/models/proposals/proposal.dart';
import 'package:m3rady/core/utils/storage/local/variables.dart';
import 'package:m3rady/core/view/components/components.dart';

class ProposalsController extends GetxController {
  GlobalKey<FormState> proposalFormKey = GlobalKey<FormState>();
  TextEditingController contentController = TextEditingController();
  GlobalKey<FormState> proposalAnswerFormKey = GlobalKey<FormState>();
  TextEditingController contentAnswerController = TextEditingController();
  TextEditingController expiresInAnswerController = TextEditingController();

  var isFilterShowAnswered = false.obs;
  var isFilterShowSent = false.obs;
  bool isProposalLoaded = false;

  var proposal;

  /// Images files
  Map<int, File?> images = {};

  @override
  void onInit() {
    super.onInit();
    // Set filter
    isFilterShowAnswered.value = (GlobalVariables.user.type == 'customer');
  }

  /// Set image with callback
  File? handleImageByIndexCallback({
    required int index,
    File? file,
    bool getCurrentFile = false,
  }) {
    /// Get current image
    if (getCurrentFile == true) {
      return images[index] ?? null;
    }

    if (file != null) {
      images[index] = file;
    } else {
      images.remove(index);
    }

    return file;
  }

  /// Submit
  Future submitProposalForm() async {
    /// Set advertiser controller
    AdvertisersProfileController advertisersProfileController =
        Get.find<AdvertisersProfileController>();

    /// Start loader
    MainLoader.set(true);

    /// Trim text
    contentController.text = contentController.text.trim();

    if (proposalFormKey.currentState != null &&
        proposalFormKey.currentState!.validate()) {
      /// Create
      var request = await Proposal.create(
        advertiserId: advertisersProfileController.user.id,
        content: contentController.text,
        media: images,
      );

      /// if request created
      if (request != false) {
        /// Show success dialog
        CSentSuccessfullyDialog(
          text: request['message'],
          callback: () {
            Get.back();
          },
        );

        /// Clear data
        contentController.clear();
        images = {};

        /// Rerender
        update();
      }
    }

    /// Stop loader
    MainLoader.set(false);
  }

  /// Get proposals (pagination)
  Future getProposals({
    int? limit,
    int? page,
    bool? isSent,
    bool? isAnswered,
  }) async {
    return await Proposal.getProposals(
      limit: limit,
      page: page,
      isAnswered: isAnswered,
      isSent: isSent,
    );
  }

  /// Get proposal
  Future getProposalById(id) async {
    /// Clear controller
    contentAnswerController.clear();
    expiresInAnswerController.clear();

    /// Get proposal
    var proposal = await Proposal.getProposalById(id);

    if (proposal != false) {
      isProposalLoaded = true;
      this.proposal = proposal;
      update();
    }

    return proposal;
  }

  /// Get proposal
  Future answerProposal() async {
    /// Trim
    contentAnswerController.text = contentAnswerController.text.trim();

    /// Set Proposal
    proposal.answer = contentAnswerController.text;
    proposal.expiresIn = int.parse(expiresInAnswerController.text);
    proposal.isAllowAnswer = false;

    update();

    /// Send request
    var request = await Proposal.answerProposal(
      proposal.id,
      answer: contentAnswerController.text,
      expiresIn: expiresInAnswerController.text,
    );

    if (request != false) {
      /// Clear controller
      contentAnswerController.clear();
      expiresInAnswerController.clear();

      /// Success
      CToast(text: request['message']);
    } else {
      proposal.answer = null;
      proposal.expiresIn = null;
      proposal.isAllowAnswer = true;
    }

    /// Reset proposal
    await getProposalById(proposal.id);
  }

  /// report proposal
  Future reportProposal(id) async {
    /// Show dialog
    CConfirmDialog(
      content: 'Are you sure that you want to report this proposal?'.tr,
      confirmText: 'Report'.tr,
      confirmCallback: () async {
        /// Send request
        var report = await Proposal.reportProposalById(id);

        /// Show success dialog
        if (report != false) {
          /// Show success dialog
          CToast(
            text: report['message'],
          );
        }
      },
    );
  }
}
