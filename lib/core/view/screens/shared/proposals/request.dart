import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m3rady/core/controllers/advertisers/profile/profile_controller.dart';
import 'package:m3rady/core/controllers/proposals/proposals_controller.dart';
import 'package:m3rady/core/utils/config/config.dart';
import 'package:m3rady/core/view/layouts/main/main_layout.dart';
import 'package:m3rady/core/view/components/components.dart';
import 'package:m3rady/core/view/components/shared/pickers/image_picker.dart';
import 'package:m3rady/core/view/components/shared/users/user_image.dart';

class ProposalRequestScreen extends StatelessWidget {
  AdvertisersProfileController advertisersProfileController =
      Get.find<AdvertisersProfileController>();

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      isDefaultPadding: false,
      title: 'Request Proposal'.tr,
      child: GetBuilder<ProposalsController>(
        init: ProposalsController(),
        builder: (controller) => SingleChildScrollView(
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
                advertisersProfileController.user?.imageUrl,
                isElite: advertisersProfileController.user?.isElite,
                radius: 35,
              ),

              SizedBox(
                height: 6,
              ),

              /// Name
              Text(
                advertisersProfileController.user?.fullName,
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

              /// Request form
              Container(
                padding: const EdgeInsets.all(12),
                child: SingleChildScrollView(
                  child: Form(
                    key: controller.proposalFormKey,
                    child: Column(
                      children: [
                        /// Title
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(
                              bottom: 12,
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
                        CTextFormField(
                          controller: controller.contentController,
                          keyboardType: TextInputType.multiline,
                          contentPadding: const EdgeInsetsDirectional.only(
                            start: 8,
                            end: 8,
                            top: 12,
                          ),
                          maxLength: 1500,
                          minLines: 8,
                          //hintText: 'Proposal Specification'.tr,
                          //labelText: 'Proposal Specification'.tr,
                          isRequired: true,
                        ),

                        SizedBox(
                          height: 12,
                        ),

                        /// Title
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(
                              bottom: 12,
                            ),
                            child: Text(
                              'Upload Images'.tr,
                              style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),

                        /// Images
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List<Widget>.generate(
                                config['maximumProposalImages'], (index) {
                              return WImagePicker(
                                index: index,
                                callback: controller.handleImageByIndexCallback,
                                title: (index + 1).toString(),
                              );
                            }).toList(),
                          ),
                        ),

                        SizedBox(
                          height: 24,
                        ),

                        /// Submit
                        CMaterialButton(
                          child: Text(
                            'Send'.tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () async {
                            await controller.submitProposalForm();
                          },
                        ),
                      ],
                    ),
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
