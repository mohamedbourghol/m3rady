import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m3rady/core/helpers/main_loader.dart';
import 'package:m3rady/core/models/contact_us/contact_us.dart';
import 'package:m3rady/core/utils/storage/local/variables.dart';

class ContactUsController extends GetxController {
  ContactUsController({this.selectedType});

  @override
  void onReady() async {
    super.onReady();

    /// Set user data if authenticated
    if (GlobalVariables.isUserAuthenticated.value) {
      nameController.text = GlobalVariables.user.name;

      mobileController.text = GlobalVariables.user.mobile;
      mobileFullController.text = GlobalVariables.user.mobile;

      mobileWhatsappController.text =
          GlobalVariables.user.socialAccounts.whatsappNumber ??
              GlobalVariables.user.mobile;
      mobileWhatsappFullController.text =
          GlobalVariables.user.socialAccounts.whatsappNumber ??
              GlobalVariables.user.mobile;

      emailController.text = GlobalVariables.user.email;
    }
  }

  GlobalKey<FormState> contactUsFormKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController mobileFullController = TextEditingController();
  TextEditingController mobileWhatsappController = TextEditingController();
  TextEditingController mobileWhatsappFullController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController messageController = TextEditingController();

  /// Is mobile is the same as whatsapp
  bool isMobileFollowWhatsapp = true;

  /// Selected type
  var selectedType;

  /// Contact us types
  List types = [
    'Enquiry',
    'Complaint',
    'Suggestion',
    'Payments',
    'Technical support',
    'In-app advertising',
    'Report a problem',
  ];

  /// Change selected reason
  void changeSelectedReason(reason) {
    selectedType = reason;
  }

  /// Change mobile follow whats number
  void setIsMobileFollowWhatsapp(isFollow) {
    isMobileFollowWhatsapp = isFollow;
    update();
  }

  /// Submit
  Future submitContactUsForm() async {
    /// Start loader
    MainLoader.set(true);

    /// Trim message
    messageController.text = messageController.text.trim();

    if (contactUsFormKey.currentState != null &&
        contactUsFormKey.currentState!.validate()) {
      /// Create
      var request = await ContactUs.create(
        type: selectedType,
        name: nameController.text,
        mobile: mobileController.text,
        whatsappMobile: mobileWhatsappController.text.isEmpty
            ? mobileController.text
            : mobileWhatsappController.text,
        email: emailController.text,
        message: messageController.text,
      );

      /// if request created
      if (request != false) {
        /// Show ok dialog
        Get.defaultDialog(
          title: 'Sent Successfully'.tr,
          middleText: '',
          backgroundColor: Colors.white,
          titleStyle: TextStyle(
            color: Colors.green,
            fontSize: 14,
          ),
          middleTextStyle: TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
          cancelTextColor: Colors.black38,
          buttonColor: Colors.white,
          textCancel: 'Ok'.tr,
          barrierDismissible: false,
          radius: 25,
          content: Text(request['message']),
        );

        /// Clear message
        messageController.clear();
      }
    }

    /// Stop loader
    MainLoader.set(false);
  }
}
