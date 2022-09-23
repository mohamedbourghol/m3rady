import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m3rady/core/controllers/offers/comments/comments_controller.dart';
import 'package:m3rady/core/controllers/offers/offers_controller.dart';
import 'package:m3rady/core/helpers/filter_helper.dart';
import 'package:m3rady/core/utils/storage/local/variables.dart';
import 'package:m3rady/core/view/components/components.dart';
import 'package:m3rady/core/view/components/shared/media/media.dart';
import 'package:m3rady/core/view/components/shared/offers/comments/comment_action.dart';
import 'package:m3rady/core/view/components/shared/users/user_image.dart';
import 'package:m3rady/core/view/widgets/text/expandable_text.dart';
import 'package:share/share.dart';
import 'package:simple_star_rating/simple_star_rating.dart';
import 'package:url_launcher/url_launcher.dart';

class WOffer extends StatelessWidget {
  var offer;
  var commentId;

  WOffer({
    required this.offer,
    this.commentId,
  });

  /// Set offers controller
  OffersController offersController = Get.put(OffersController());

  /// Set comments controller
  OffersCommentsController commentsController =
      Get.put(OffersCommentsController());

  /// Set offer parameters
  bool isOfferVisible = true;
  bool isActionsLoading = false;
  var isAllowRate = true.obs;

  /// Show offer form
  void showEditUsernameForm() {
    /// Set category id
    offersController.selectedCategoryIdUpdate =
        (offer.categoryId != null ? offer.categoryId.toString() : null);

    /// Set content
    offersController.contentUpdateController.text = offer.content;

    CConfirmDialog(
      confirmText: 'Edit Offer'.tr,
      title: 'Edit Offer'.tr,
      contentWidget: Column(
        children: [
          Form(
            //autovalidateMode: AutovalidateMode.onUserInteraction,
            key: offersController.offerUpdateFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CSelectFormField(
                  value: offersController.selectedCategoryIdUpdate,
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
                    ...GlobalVariables.user.interestedCategories != null &&
                            GlobalVariables.user.interestedCategories.length > 0
                        ? GlobalVariables.user.interestedCategories.entries
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
                    offersController.selectedCategoryIdUpdate = id.toString();
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                CTextFormField(
                  controller: offersController.contentUpdateController,
                  keyboardType: TextInputType.multiline,
                  contentPadding: const EdgeInsetsDirectional.only(
                    start: 8,
                    end: 8,
                    top: 12,
                  ),
                  maxLength: 1500,
                  minLines: 4,
                  hintText: 'Offer Content'.tr,
                  labelText: 'Offer Content'.tr,
                  isRequired: true,
                ),
              ],
            ),
          ),
        ],
      ),
      confirmTextColor: Colors.green,
      confirmCallback: () async {
        /// Trim text
        offersController.contentUpdateController.text =
            offersController.contentUpdateController.text.trim();

        /// Validate
        if (offersController.offerUpdateFormKey.currentState != null &&
            offersController.offerUpdateFormKey.currentState!.validate()) {
          /// Set content
          offer.content = offersController.contentUpdateController.text;

          /// Set category id
          offer.categoryId =
              int.parse(offersController.selectedCategoryIdUpdate!);

          /// Update
          offersController.update();

          /// Back
          Get.back();

          /// Update offer
          await offersController.updateOffer(
            offer.id,
            content: offersController.contentUpdateController.text,
            categoryId: offersController.selectedCategoryIdUpdate,
          );
        }
      },
      autoClose: false,
    );
  }

  /// Show add rate
  void showAddRateModal() {
    /// Set data
    offersController.rateStars = null;
    var isShowError = false.obs;

    CConfirmDialog(
      confirmText: 'Add Rate'.tr,
      title: 'Offer Rate'.tr,
      contentWidget: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Stars
              Directionality(
                textDirection: TextDirection.ltr,
                child: SimpleStarRating(
                  rating: offersController.rateStars ?? 0.0,
                  onRated: (rate) {
                    offersController.rateStars = rate;
                  },
                  allowHalfRating: false,
                  isReadOnly: false,
                  starCount: 5,
                  size: 21,
                  spacing: 6,
                ),
              ),

              /// Error
              Obx(
                () => Visibility(
                  visible: isShowError.value == true,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      'Please add stars to your rate.'.tr,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      confirmTextColor: Colors.green,
      confirmCallback: () async {
        if (offersController.rateStars == null) {
          /// Show error
          isShowError.value = true;
        } else {
          /// Hide error
          isShowError.value = false;

          /// Add rate
          offersController.rateOffer(
            id: offer.id,
            rate: offersController.rateStars,
          );

          /// Hide add rate button
          isAllowRate.value = false;

          /// Close
          Get.back();
        }
      },
      autoClose: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OffersController>(builder: (controller) {
      return Visibility(
        visible: isOfferVisible,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 1,
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 0.5,
                  )
                ],
              ),
              width: double.infinity,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(6),
                            child: GestureDetector(
                              onTap: () {
                                /// Goto user profile
                                if (!offer.owner.isSelf) {
                                  Get.toNamed('/advertiser/profile',
                                      arguments: {
                                        'id': offer.owner.id,
                                      });
                                } else {
                                  Get.toNamed('/profile/me');
                                }
                              },
                              child: WUserImage(
                                offer.owner.imageUrl,
                                isElite: offer.owner.isElite == true,
                                radius: 25,
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Company name
                              GestureDetector(
                                onTap: () {
                                  /// Goto user profile
                                  if (!offer.owner.isSelf) {
                                    Get.toNamed('/advertiser/profile',
                                        arguments: {
                                          'id': offer.owner.id,
                                        });
                                  } else {
                                    Get.toNamed('/profile/me');
                                  }
                                },
                                child: Row(
                                  children: [
                                    ConstrainedBox(
                                      constraints: BoxConstraints(
                                        minWidth: 1,
                                        maxWidth: Get.width / 1.5,
                                      ),
                                      child: Text(
                                        offer.owner.fullName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue.shade400,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 6,
                                    ),

                                    /// Follow
                                    /*(offer.owner.isFollowed == false
                                        ? InkWell(
                                            child: Text(
                                              'Follow'.tr,
                                              style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 12,
                                              ),
                                            ),
                                            onTap: () {},
                                            enableFeedback: true,
                                          )
                                        : InkWell(
                                            child: Text(
                                              'Unfollow'.tr,
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                              ),
                                            ),
                                            onTap: () {},
                                            enableFeedback: true,
                                          )),*/
                                  ],
                                ),
                              ),

                              /// Location, Date
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on_outlined,
                                    size: 18,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    "${offer.owner.country} - ${offer.owner.city}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black45,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Container(
                                    width: 5,
                                    height: 5,
                                    decoration: BoxDecoration(
                                      color: Colors.black45,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    (offer.createdAt != ''
                                        ? offer.createdAt
                                        : 'Now'.tr),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black45,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),

                      /// More
                      (!offer.permissions['isAllowActions'] ||
                              offer.permissions['isAllowReport'] == false)
                          ? SizedBox()
                          : IconButton(
                              icon: (isActionsLoading == false
                                  ? Icon(
                                      Icons.more_vert,
                                      color: Colors.grey,
                                    )
                                  : Container(
                                      width: 12,
                                      height: 12,
                                      child: CircularProgressIndicator(
                                        color: Colors.black12,
                                        strokeWidth: 2,
                                      ),
                                    )),
                              onPressed: isActionsLoading == true
                                  ? () {}
                                  : () async {
                                      /*
                                      /// Start loading
                                      isActionsLoading = true;
                                      controller.update();

                                      var updatedOffer =
                                          await controller.getOfferById(offer.id);

                                      /// Stop loading
                                      isActionsLoading = false;
                                      controller.update();

                                      if (updatedOffer != false) {
                                        offer = updatedOffer;
                                      }
                                      */

                                      Get.bottomSheet(
                                        Container(
                                          height: 100,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              children: [
                                                CBottomSheetHead(),

                                                SizedBox(
                                                  height: 6,
                                                ),

                                                /// Save offer
                                                /*(!(offer.permissions[
                                                                'isAllowSave'] ==
                                                            true &&
                                                        offer.isSaved == false)
                                                    ? SizedBox()
                                                    : ListTile(
                                                        title: Text(
                                                            'Save Offer'.tr),
                                                        subtitle: Text(
                                                          'Save offer to get back to it anytime.'
                                                              .tr,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                        leading: Icon(Icons
                                                            .bookmark_add_outlined),
                                                        minLeadingWidth: 0,
                                                        enabled: true,
                                                        selected: false,
                                                        dense: true,
                                                        onTap: () async {
                                                          /// Close bottom sheet
                                                          Get.back();

                                                          offer.isSaved =
                                                              !offer.isSaved;

                                                          /// Report offer
                                                          await controller
                                                              .saveOffer(
                                                            offer.id,
                                                            offer.isSaved,
                                                          );
                                                        },
                                                      )),*/

                                                /// UnSave offer
                                                /*(!(offer.permissions[
                                                                'isAllowSave'] ==
                                                            true &&
                                                        offer.isSaved == true)
                                                    ? SizedBox()
                                                    : ListTile(
                                                        title: Text(
                                                            'Unsave Offer'.tr),
                                                        subtitle: Text(
                                                          'Remove this offer from the saved list.'
                                                              .tr,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                        leading: Icon(Icons
                                                            .bookmark_border),
                                                        minLeadingWidth: 0,
                                                        enabled: true,
                                                        selected: false,
                                                        dense: true,
                                                        onTap: () async {
                                                          /// Close bottom sheet
                                                          Get.back();

                                                          offer.isSaved =
                                                              !offer.isSaved;

                                                          /// Report offer
                                                          await controller
                                                              .saveOffer(
                                                            offer.id,
                                                            offer.isSaved,
                                                          );

                                                          /// Hide offer
                                                          if (Get.currentRoute ==
                                                              '/offers/saved') {
                                                            isOfferVisible =
                                                                false;
                                                            controller.update();
                                                          }
                                                        },
                                                      )),*/

                                                /// Get Notifications
                                                /* (!(offer.permissions[
                                                                'isAllowGetNotifications'] ==
                                                            true &&
                                                        offer.isSubscribed ==
                                                            false)
                                                    ? SizedBox()
                                                    : ListTile(
                                                        title: Text(
                                                            'Get Notifications'
                                                                .tr),
                                                        subtitle: Text(
                                                          'Get notifications about the new comments.'
                                                              .tr,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                        leading: Icon(Icons
                                                            .notifications_outlined),
                                                        minLeadingWidth: 0,
                                                        enabled: true,
                                                        selected: false,
                                                        dense: true,
                                                        onTap: () async {
                                                          /// Close sheet
                                                          Get.back();

                                                          /// Subscribe offer
                                                          await controller
                                                              .subscribeOffer(
                                                                  offer.id,
                                                                  true);
                                                        },
                                                      )),*/

                                                /// Stop Notifications
                                                /*(!(offer.permissions[
                                                                'isAllowGetNotifications'] ==
                                                            true &&
                                                        offer.isSubscribed ==
                                                            true)
                                                    ? SizedBox()
                                                    : ListTile(
                                                        title: Text(
                                                            'Stop Notifications'
                                                                .tr),
                                                        subtitle: Text(
                                                          'Stop notifications about the new comments.'
                                                              .tr,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                        leading: Icon(Icons
                                                            .notifications_off_outlined),
                                                        minLeadingWidth: 0,
                                                        enabled: true,
                                                        selected: false,
                                                        dense: true,
                                                        onTap: () async {
                                                          /// Close sheet
                                                          Get.back();

                                                          /// Subscribe offer
                                                          await controller
                                                              .subscribeOffer(
                                                                  offer.id,
                                                                  false);
                                                        },
                                                      )),*/

                                                /// Hide Offer
                                                /*(!(offer.permissions[
                                                                'isAllowHideCompanyOffers'] ==
                                                            true &&
                                                        offer.isHidden == false)
                                                    ? SizedBox()
                                                    : ListTile(
                                                        title: Text(
                                                            'Hide Offer'.tr),
                                                        subtitle: Text(
                                                          'Hide any offer from this user.'
                                                              .tr,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                        leading:
                                                            Icon(Icons.block),
                                                        minLeadingWidth: 0,
                                                        enabled: true,
                                                        selected: false,
                                                        dense: true,
                                                        onTap: () async {
                                                          /// Close sheet
                                                          Get.back();

                                                          /// Show dialog
                                                          CConfirmDialog(
                                                            content:
                                                                'Are you sure that you want to hide this offer? This action will hide all the offers from this user.'
                                                                    .tr,
                                                            confirmText:
                                                                'Hide Offer'.tr,
                                                            confirmCallback:
                                                                () async {
                                                              /// Hide offer
                                                              var hide = await controller
                                                                  .hideOffersByAdvertiserId(
                                                                      offer.owner
                                                                          .id,
                                                                      true);

                                                              if (hide !=
                                                                  false) {
                                                                /// Hide offer
                                                                if (Get.currentRoute !=
                                                                    '/advertiser/profile') {
                                                                  isOfferVisible =
                                                                      false;
                                                                  controller
                                                                      .update();
                                                                }

                                                                /// Show success dialog
                                                                CToast(
                                                                  text: hide[
                                                                      'message'],
                                                                );
                                                              }
                                                            },
                                                          );
                                                        },
                                                      )),*/

                                                /// Show Offer
                                                /*(!(offer.permissions[
                                                                'isAllowHideCompanyOffers'] ==
                                                            true &&
                                                        offer.isHidden == true)
                                                    ? SizedBox()
                                                    : ListTile(
                                                        title: Text(
                                                            'Show Offer'.tr),
                                                        subtitle: Text(
                                                          'Show any offer from this user.'
                                                              .tr,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                        leading: Icon(Icons
                                                            .visibility_outlined),
                                                        minLeadingWidth: 0,
                                                        enabled: true,
                                                        selected: false,
                                                        dense: true,
                                                        onTap: () async {
                                                          /// Close sheet
                                                          Get.back();

                                                          /// Show offer
                                                          var show =
                                                              await controller
                                                                  .hideOffersByAdvertiserId(
                                                                      offer.owner
                                                                          .id,
                                                                      false);

                                                          if (show != false) {
                                                            /// Show success dialog
                                                            CToast(
                                                              text: show[
                                                                  'message'],
                                                            );
                                                          }
                                                        },
                                                      )),*/

                                                /// Report Offer
                                                (offer.permissions[
                                                            'isAllowReport'] ==
                                                        false
                                                    ? SizedBox()
                                                    : ListTile(
                                                        title: Text(
                                                            'Report Offer'.tr),
                                                        subtitle: Text(
                                                          'Report this offer.'
                                                              .tr,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                        leading: Icon(Icons
                                                            .report_problem_outlined),
                                                        minLeadingWidth: 0,
                                                        enabled: true,
                                                        selected: false,
                                                        dense: true,
                                                        onTap: () async {
                                                          /// Close bottom sheet
                                                          Get.back();

                                                          /// Report offer
                                                          await controller
                                                              .reportOffer(
                                                                  offer.id);
                                                        },
                                                      )),

                                                /// Edit Offer
                                                /*(offer.permissions[
                                                            'isAllowEdit'] ==
                                                        false
                                                    ? SizedBox()
                                                    : ListTile(
                                                        title: Text(
                                                            'Edit Offer'.tr),
                                                        subtitle: Text(
                                                          'Edit this offer.'.tr,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                        leading:
                                                            Icon(Icons.edit),
                                                        minLeadingWidth: 0,
                                                        enabled: true,
                                                        selected: false,
                                                        dense: true,
                                                        onTap: () async {
                                                          /// Close bottom sheet
                                                          Get.back();

                                                          /// Edit offer
                                                          showEditUsernameForm();
                                                        },
                                                      )),*/

                                                /// Delete Offer
                                                /*(offer.permissions[
                                                            'isAllowDelete'] ==
                                                        false
                                                    ? SizedBox()
                                                    : ListTile(
                                                        title: Text(
                                                            'Delete Offer'.tr),
                                                        subtitle: Text(
                                                          'Delete this offer.'
                                                              .tr,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                        leading:
                                                            Icon(Icons.delete),
                                                        minLeadingWidth: 0,
                                                        enabled: true,
                                                        selected: false,
                                                        dense: true,
                                                        onTap: () async {
                                                          /// Close bottom sheet
                                                          Get.back();

                                                          /// Show dialog
                                                          CConfirmDialog(
                                                            content:
                                                                'Are you sure that you want to delete this offer?'
                                                                    .tr,
                                                            confirmText:
                                                                'Delete Offer'
                                                                    .tr,
                                                            confirmCallback:
                                                                () async {
                                                              /// Hide offer
                                                              var delete =
                                                                  await controller
                                                                      .deleteOffer(
                                                                          offer.id);

                                                              if (delete !=
                                                                  false) {
                                                                /// Hide offer
                                                                isOfferVisible =
                                                                    false;
                                                                controller
                                                                    .update();

                                                                /// Show success dialog
                                                                CToast(
                                                                  text: delete[
                                                                      'message'],
                                                                );
                                                              }
                                                            },
                                                          );
                                                        },
                                                      )),*/
                                              ],
                                            ),
                                          ),
                                        ),
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      );
                                    },
                            ),
                    ],
                  ),

                  /// Discount, etc...
                  Column(
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: 6,
                          ),
                          CBr(
                            thickness: 4,
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                /// Validity
                                Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                    start: 12,
                                  ),
                                  child: Container(
                                    width: Get.width / 4,
                                    child: Column(
                                      children: [
                                        Text(
                                          'Offer Expiry'.tr,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          offer.isExpired == true
                                              ? 'Expired'.tr
                                              : "${'After'.tr} ${offer.expiresIn} ${'days'.tr}",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Arial',
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                /// Break
                                Container(
                                  height: 50,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 12,
                                      right: 12,
                                    ),
                                    child: CVBr(
                                      thickness: 3,
                                      color: Colors.grey.shade200,
                                    ),
                                  ),
                                ),

                                /// Discount
                                Container(
                                  width: Get.width / 4,
                                  child: Column(
                                    children: [
                                      Text(
                                        'Discount'.tr,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${offer.salePercentage}%',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: 'Arial',
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue,
                                            ),
                                          ),
                                          Icon(
                                            Icons.sell_outlined,
                                            size: 18,
                                            color: Colors.orange,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                /// Break
                                Container(
                                  height: 50,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 12,
                                      right: 12,
                                    ),
                                    child: CVBr(
                                      thickness: 3,
                                      color: Colors.grey.shade200,
                                    ),
                                  ),
                                ),

                                /// Website
                                Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                    end: 12,
                                  ),
                                  child: Container(
                                    width: Get.width / 4,
                                    child: InkWell(
                                      onTap: () async {
                                        if (offer.advertisementUrl != null &&
                                            offer.isExpired != true &&
                                            await canLaunch(
                                                offer.advertisementUrl)) {
                                          await launch(offer.advertisementUrl);
                                        }
                                      },
                                      child: Column(
                                        children: [
                                          Text(
                                            'Offer Url'.tr,
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            offer.advertisementUrl != null &&
                                                    offer.isExpired != true
                                                ? 'View Website'.tr
                                                : '-',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Arial',
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          CBr(
                            thickness: 4,
                          ),

                          /// Rate
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Offer Rate'.tr,
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Row(
                                      children: [
                                        SimpleStarRating(
                                          starCount: 5,
                                          rating: offer.rate != null
                                              ? (offer.rate != null
                                                  ? double.parse((offer.rate > 5
                                                          ? 5
                                                          : offer.rate)
                                                      .round()
                                                      .toString())
                                                  : 0)
                                              : 0,
                                          size: 16,
                                          spacing: 1,
                                        ),
                                        SizedBox(width: 2),
                                        Padding(
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                            top: 4,
                                          ),
                                          child: Text(
                                            offer.rate == null
                                                ? ''
                                                : "(${offer.rate})",
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                /// Add Rate
                                Obx(
                                  () => Visibility(
                                    visible: (isAllowRate.value == true &&
                                        offer.permissions['isAllowRate'] ==
                                            true &&
                                        offer.isExpired != true &&
                                        offer.isRated != true),
                                    child: Container(
                                      width: 100,
                                      height: 30,
                                      child: CMaterialButton(
                                        borderColor: Colors.orange,
                                        color: Colors.orange,
                                        child: Text(
                                          'Add Rate'.tr,
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        onPressed: () => showAddRateModal(),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          CBr(
                            thickness: 4,
                          ),
                          SizedBox(
                            height: 6,
                          ),
                        ],
                      ),

                      SizedBox(
                        height: 6,
                      ),

                      /// Content text
                      Padding(
                        padding: const EdgeInsetsDirectional.only(
                          start: 12,
                          end: 12,
                        ),
                        child: Container(
                          width: Get.width,
                          child: ExpandableText(
                            offer.content,
                            trimLines: 2,
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 6,
                      ),

                      /// Media with Views
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          /// Media
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: WMedia(
                              mediaList: offer.media,
                            ),
                          ),

                          /// Visits
                          Padding(
                            padding: const EdgeInsets.all(6),
                            child: Container(
                              width: 85,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Colors.black38,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  /*Icon(
                                    Icons.remove_red_eye_outlined,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  SizedBox(
                                    width: 1,
                                  ),*/
                                  Text(
                                    'view'.trArgs(
                                      [
                                        FilterHelper.formatNumbers(
                                                offer.statistics['views']) ??
                                            '0',
                                      ],
                                    ),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 0,
                      ),
                      CBr(),

                      /// Offer actions
                      Visibility(
                        visible: offer.isExpired != true,
                        child: Container(
                          //width: Get.width / 1.3,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            /*borderRadius: BorderRadiusDirectional.only(
                              topEnd: Radius.circular(15),
                            ),*/
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(
                              start: 24,
                              end: 24,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                /// Likes
                                InkWell(
                                  child: Row(
                                    children: [
                                      Icon(
                                        (offer.isLiked
                                            ? Icons.favorite
                                            : Icons.favorite_outline),
                                        color: (offer.isLiked
                                            ? Colors.red
                                            : Colors.grey),
                                        size: 25,
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Text(
                                        'like'.trArgs(
                                          [
                                            FilterHelper.formatNumbers(offer
                                                    .statistics['likes']) ??
                                                '0',
                                          ],
                                        ),
                                        style: TextStyle(
                                          color: Colors.black45,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap:
                                      (offer.permissions['isAllowLike'] == false
                                          ? null
                                          : () {
                                              offer.isLiked = !offer.isLiked;
                                              if (offer.isLiked) {
                                                offer.statistics['likes']++;
                                              } else {
                                                offer.statistics['likes']--;
                                              }
                                              controller.updateIsLikedByOfferId(
                                                offer.id,
                                                offer.isLiked,
                                              );
                                            }),
                                ),

                                /// Comments
                                WOfferCommentAction(
                                  offer: offer,
                                  commentId: commentId,
                                ),

                                /// Share
                                InkWell(
                                  onTap: (offer.permissions['isAllowShare'] ==
                                          false
                                      ? null
                                      : () {
                                          Share.share(
                                            '${offer.websiteUrl}',
                                            subject: offer.owner.fullName,
                                          );
                                        }),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.reply_outlined,
                                        color: Colors.grey,
                                        size: 25,
                                      ),
                                      Text(
                                        'Share'.tr,
                                        style: TextStyle(
                                          color: Colors.black45,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
