import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:m3rady/core/controllers/contact_us/contact_us_controller.dart';
import 'package:m3rady/core/utils/storage/local/variables.dart';
import 'package:m3rady/core/view/components/components.dart';
import 'package:m3rady/core/view/layouts/main/main_layout.dart';
import 'package:m3rady/core/view/widgets/inputs/phone_number_input_text.dart';

class ContactUsScreen extends StatelessWidget {
  /// Set type
  final String? type = Get.arguments?['type'];

  /// Set country code
  var _countryCodeMobile = GlobalVariables.userGeoIpCountryCode;
  var _countryCodeWhatsapp = GlobalVariables.userGeoIpCountryCode;

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Contact Us'.tr,
      child: GetBuilder<ContactUsController>(
        init: ContactUsController(
          selectedType: type,
        ),
        builder: (controller) => Container(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Form(
              key: controller.contactUsFormKey,
              child: Column(
                children: [
                  /// Header
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                      bottom: 12,
                    ),
                    child: Text(
                      'Please complete the form below'.tr,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                      ),
                    ),
                  ),

                  /// Reason
                  CSelectFormField(
                    value: controller.selectedType,
                    isRequired: true,
                    readOnly: type != null,
                    labelText: 'Request Type'.tr,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(11),
                      child: Icon(Icons.support),
                    ),
                    items: controller.types
                        .map((reason) => DropdownMenuItem<String>(
                              value: reason.toString(),
                              child: Text(reason.toString().tr),
                            ))
                        .toList(),
                    onChanged: (reason) =>
                        controller.changeSelectedReason(reason),
                  ),

                  SizedBox(
                    height: 12,
                  ),

                  CTextFormField(
                    controller: controller.nameController,
                    keyboardType: TextInputType.text,
                    labelText: 'Full Name'.tr,
                    hintText: 'Full Name'.tr,
                    readOnly: GlobalVariables.isUserAuthenticated.value == true,
                    prefixIcon: Icon(
                      Icons.person,
                    ),
                    onEditingComplete: () {
                      Get.focusScope?.nextFocus();
                    },
                    isRequired: true,
                  ),

                  SizedBox(
                    height: 12,
                  ),

                  WInternationalPhoneNumberInputText(
                    controller: controller.mobileController,
                    fullController: controller.mobileFullController,
                    readOnly: GlobalVariables.isUserAuthenticated.value == true,
                    onInputChanged: (PhoneNumber number) {
                      _countryCodeMobile = number.isoCode.toString();

                      /// Set whats app number
                      if (controller.isMobileFollowWhatsapp == true) {
                        controller.mobileWhatsappFullController.text =
                            number.toString();
                      }
                    },
                    initalValue: PhoneNumber(
                      isoCode: _countryCodeMobile,
                    ),
                    isRequired: true,
                  ),

                  SizedBox(
                    height: 12,
                  ),

                  GestureDetector(
                    onTap: () {
                      if (GlobalVariables.isUserAuthenticated.value != true) {
                        controller.setIsMobileFollowWhatsapp(false);
                      }
                    },
                    child: WInternationalPhoneNumberInputText(
                      readOnly:
                          GlobalVariables.isUserAuthenticated.value == true,
                      onInputChanged: (PhoneNumber number) {
                        _countryCodeWhatsapp = number.isoCode.toString();

                        /// Set whats app number
                        if (controller.isMobileFollowWhatsapp == true) {
                          controller.mobileWhatsappFullController.text =
                              number.toString();
                        }
                      },
                      initalValue: PhoneNumber(
                        isoCode: _countryCodeWhatsapp,
                      ),
                      controller: controller.mobileWhatsappController,
                      fullController: controller.mobileWhatsappFullController,
                      text: 'WhatsApp number'.tr,
                    ),
                  ),

                  SizedBox(
                    height: 12,
                  ),

                  CTextFormField(
                    controller: controller.emailController,
                    readOnly: GlobalVariables.isUserAuthenticated.value == true,
                    keyboardType: TextInputType.emailAddress,
                    textDirection: TextDirection.ltr,
                    labelText: 'Email'.tr,
                    hintText: "${'Email'.tr} (${'Optional'.tr})",
                    prefixIcon: Icon(
                      Icons.email,
                    ),
                    onEditingComplete: () {
                      Get.focusScope?.nextFocus();
                    },
                  ),

                  SizedBox(
                    height: 12,
                  ),

                  CTextFormField(
                    controller: controller.messageController,
                    keyboardType: TextInputType.multiline,
                    contentPadding: const EdgeInsetsDirectional.only(
                      start: 8,
                      end: 8,
                      top: 12,
                    ),
                    maxLength: 1500,
                    minLines: 8,
                    hintText: 'Message'.tr,
                    labelText: 'Message'.tr,
                    isRequired: true,
                  ),

                  SizedBox(
                    height: 12,
                  ),

                  CMaterialButton(
                    child: Text(
                      'Send'.tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () async {
                      await controller.submitContactUsForm();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
