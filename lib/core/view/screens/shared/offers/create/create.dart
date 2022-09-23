import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m3rady/core/controllers/offers/offers_controller.dart';
import 'package:m3rady/core/utils/config/config.dart';
import 'package:m3rady/core/utils/storage/local/variables.dart';
import 'package:m3rady/core/view/components/components.dart';
import 'package:m3rady/core/view/components/shared/pickers/image_picker.dart';
import 'package:m3rady/core/view/components/shared/pickers/video_picker.dart';
import 'package:m3rady/core/view/layouts/main/main_layout.dart';

class OffersCreateScreen extends StatefulWidget {
  @override
  State<OffersCreateScreen> createState() => _OffersCreateScreenState();
}

class _OffersCreateScreenState extends State<OffersCreateScreen> {
  /// Show dialogs
  void showDialogs() {
    /// Offer dialog
    CConfirmDialog(
      content:
          "Before adding offers, you must make sure that you have obtained a license from the competent authorities in your country.\nIn the event of posting fake offers, the advertiser will bear all legal consequences.\nNo more than one advertisement may be published during the week."
              .tr,
      actions: [
        TextButton(
          onPressed: () {
            /// Back
            Get.back();
          },
          child: Text(
            'Agree'.tr,
            style: TextStyle(
              color: Colors.green,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    /// After loading
    WidgetsBinding.instance?.addPostFrameCallback(
      (_) {
        /// Show dialogs
        showDialogs();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      isDefaultPadding: false,
      title: 'Add Offer'.tr,
      child: GetX<OffersController>(
        init: OffersController(),
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

              /// Request form
              Container(
                child: SingleChildScrollView(
                  child: Form(
                    key: controller.offerFormKey,
                    child: Column(
                      children: [
                        /// Title
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 12,
                              right: 12,
                            ),
                            child: Text(
                              'Offer Content'.tr,
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
                          padding: const EdgeInsets.all(12),
                          child: CTextFormField(
                            controller: controller.contentController,
                            keyboardType: TextInputType.multiline,
                            contentPadding: const EdgeInsetsDirectional.only(
                              start: 8,
                              end: 8,
                              top: 12,
                            ),
                            maxLength: 1500,
                            minLines: 8,
                            isRequired: true,
                          ),
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
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 12,
                            right: 12,
                          ),
                          child: Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Padding(
                              padding: const EdgeInsetsDirectional.only(
                                bottom: 12,
                              ),
                              child: Text(
                                'Offer Attachments'.tr,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),

                        /// Type
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                controller.offerAttachmentType.value = 'images';
                                controller.videos = {};
                              },
                              child: Row(
                                children: [
                                  Radio(
                                    value: 'images',
                                    groupValue:
                                        controller.offerAttachmentType.value,
                                    activeColor: Colors.orange,
                                    onChanged: (value) {
                                      controller.offerAttachmentType.value =
                                          'images';
                                      controller.videos = {};
                                    },
                                  ),
                                  Text('Images'.tr),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            GestureDetector(
                              onTap: () {
                                controller.offerAttachmentType.value = 'videos';
                                controller.images = {};
                              },
                              child: Row(
                                children: [
                                  Radio(
                                    value: 'videos',
                                    groupValue:
                                        controller.offerAttachmentType.value,
                                    activeColor: Colors.orange,
                                    onChanged: (value) {
                                      controller.offerAttachmentType.value =
                                          'videos';
                                      controller.images = {};
                                    },
                                  ),
                                  Text('Videos'.tr),
                                ],
                              ),
                            ),
                          ],
                        ),

                        /// Title
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 12,
                              right: 12,
                            ),
                            child: Text(
                              'You can upload multiple images or one video with each offer.'
                                  .tr,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
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

                        /// Title
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              (controller.offerAttachmentType.value == 'images'
                                  ? 'Upload Images'.tr
                                  : 'Upload Videos'.tr),
                              style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),

                        /// Images
                        Visibility(
                          visible:
                              controller.offerAttachmentType.value == 'images',
                          child: Column(
                            children: [
                              /// Images selector
                              Padding(
                                padding: const EdgeInsetsDirectional.only(
                                  start: 12,
                                  end: 12,
                                  top: 12,
                                  bottom: 4,
                                ),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: List<Widget>.generate(
                                        config['maximumOfferImages'], (index) {
                                      return WImagePicker(
                                        index: index,
                                        callback: controller
                                            .handleImageByIndexCallback,
                                        title: (index + 1).toString(),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: 6,
                              ),

                              /// Note
                              Text(
                                'You can upload multiple images by scroll left and right.'
                                    .tr,
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 12,
                                  //fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          height: 12,
                        ),

                        /// Videos
                        Visibility(
                          visible:
                              controller.offerAttachmentType.value == 'videos',
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List<Widget>.generate(
                                    config['maximumOfferVideos'], (index) {
                                  return WVideoPicker(
                                    index: index,
                                    callback:
                                        controller.handleVideoByIndexCallback,
                                    title: (index + 1).toString(),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
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
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 12,
                            right: 12,
                          ),
                          child: Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Padding(
                              padding: const EdgeInsetsDirectional.only(
                                bottom: 12,
                              ),
                              child: Text(
                                'Category'.tr,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),

                        /// Category
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: CSelectFormField(
                            value: (GlobalVariables.user.interestedCategories !=
                                        null &&
                                    GlobalVariables
                                            .user.interestedCategories.length ==
                                        1
                                ? GlobalVariables.user.interestedCategories
                                    .entries.first.value.id
                                    .toString()
                                : null),
                            isRequired: true,
                            disabledHint: Text(
                              'Loading...'.tr,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            labelText: 'Category'.tr,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(11),
                              child: Icon(Icons.category),
                            ),
                            items: [
                              ...GlobalVariables.user.interestedCategories !=
                                          null &&
                                      GlobalVariables.user.interestedCategories
                                              .length >
                                          0
                                  ? GlobalVariables
                                      .user.interestedCategories.entries
                                      .map(
                                        (entries) => DropdownMenuItem<String>(
                                          value: entries.value.id.toString(),
                                          child: Text(
                                            entries.value.name.toString(),
                                          ),
                                        ),
                                      )
                                      .toList()
                                  : []
                            ],
                            onChanged: (id) {
                              controller.selectedCategoryId = id.toString();
                            },
                          ),
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
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 12,
                            right: 12,
                          ),
                          child: Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Padding(
                              padding: const EdgeInsetsDirectional.only(
                                bottom: 12,
                              ),
                              child: Text(
                                'Validity days'.tr,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),

                        /// Validity
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: CTextFormField(
                            controller: controller.expiresInController,
                            keyboardType: TextInputType.number,
                            labelText: 'Validity days'.tr,
                            hintText:
                                "${'Validity days'.tr} (${'15 ' + 'days'.tr})",
                            validator: (value) {
                              if (value == null ||
                                  (value != null && value.isEmpty)) {
                                return 'This field is required'.tr;
                              }

                              if (int.parse(value) < 1) {
                                return  "Shouldn't be less than 1 day.".tr;
                              }

                              if (int.parse(value) > 30) {
                                return "Shouldn't be more than 30 days.".tr;
                              }
                            },
                            onEditingComplete: () {
                              Get.focusScope?.nextFocus();
                            },
                          ),
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
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 12,
                            right: 12,
                          ),
                          child: Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Padding(
                              padding: const EdgeInsetsDirectional.only(
                                bottom: 12,
                              ),
                              child: Text(
                                'Sale percentage'.tr,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),

                        /// Sale percentage
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child:

                              /// Sale percentage
                              CTextFormField(
                            controller: controller.salePercentageController,
                            keyboardType: TextInputType.number,
                            labelText: 'Sale percentage'.tr,
                            hintText: "${'Sale percentage'.tr} (50%)",
                            validator: (value) {
                              if (value == null ||
                                  (value != null && value.isEmpty)) {
                                return 'This field is required'.tr;
                              }

                              if (int.parse(value) < 1) {
                                return  "Shouldn't be less than 1.".tr;
                              }

                              if (int.parse(value) > 100) {
                                return "Shouldn't be more than 100.".tr;
                              }
                            },
                            onEditingComplete: () {
                              Get.focusScope?.nextFocus();
                            },
                          ),
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
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 12,
                            right: 12,
                          ),
                          child: Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Padding(
                              padding: const EdgeInsetsDirectional.only(
                                bottom: 12,
                              ),
                              child: Text(
                                'Offer Url'.tr + " (${'Optional'.tr})",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),

                        /// Url
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child:

                              /// Url
                              CTextFormField(
                            controller: controller.advertisementUrlController,
                            keyboardType: TextInputType.url,
                            labelText: 'Offer Url'.tr,
                            hintText: "https://m3rady.com",
                            validator: (value) {
                              if (value.length > 0 && !value.toString().isURL) {
                                return 'The url is invalid.'.tr;
                              }
                            },
                            onEditingComplete: () {
                              Get.focusScope?.nextFocus();
                            },
                          ),
                        ),

                        /// Submit
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: CMaterialButton(
                            child: Text(
                              'Publish'.tr,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () async {
                              await controller.submitOfferCreateForm();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              /// Break
              Container(
                color: Colors.grey.shade200,
                height: 6,
              ),

              /// Notes
              Padding(
                padding: const EdgeInsets.all(12),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Note:'.tr,
                            style: TextStyle(
                              color: Colors.orange,
                            ),
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Text(
                            "The offer will be reviewed by the administration before it is published,\n and you can't delete or edit it after publication."
                                .tr,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    Get.delete<OffersController>();
  }
}
