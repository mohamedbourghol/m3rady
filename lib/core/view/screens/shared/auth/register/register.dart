import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:m3rady/core/controllers/auth/register_controller.dart';
import 'package:m3rady/core/utils/storage/local/variables.dart';
import 'package:m3rady/core/view/components/components.dart';
import 'package:m3rady/core/view/layouts/auth/auth_layout.dart';
import 'package:m3rady/core/view/screens/shared/auth/register/verify_mobile.dart';
import 'package:m3rady/core/view/widgets/inputs/phone_number_input_text.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  /// Set account type
  var accountType = Get.arguments?['selectedAccountType'];

  /// Set social data
  var provider = Get.arguments?['provider'];

  var providerId = Get.arguments?['providerId'];

  /// Set country code
  var _countryCode = GlobalVariables.userGeoIpCountryCode;

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      automaticallyImplyLeading: true,
      title: 'Register'.tr,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Body
            Container(
              child: GetBuilder<RegisterController>(
                init: RegisterController(),
                builder: (controller) => Form(
                  key: controller.registerFormKey,
                  child: Column(
                    children: [
                      Padding(
                        padding:  EdgeInsets.all(16),
                        child: Text(
                          'Register using your account'.tr,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      CTextFormField(
                        controller: controller.nameController,
                        keyboardType: TextInputType.name,
                        labelText: (accountType['id'] != 'customer'
                            ? 'Business Name'.tr
                            : 'Full Name'.tr),
                        prefixIcon: (accountType['id'] == 'customer'
                            ? Icon(Icons.person,)
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Icon(
                                    Icons.person,
                                  ),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Text(accountType['name']),
                                ],
                              )),
                        maxLength: 50,
                        isRequired: true,
                        onEditingComplete: () {
                          Get.focusScope?.nextFocus();
                        },
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      WInternationalPhoneNumberInputText(
                        controller: controller.mobileController,
                        fullController: controller.mobileFullController,

                        onInputChanged: (PhoneNumber number) {
                          _countryCode = number.isoCode.toString();
                          //controller.selectedCountryCode=number.isoCode.toString();
                          controller.changeSelectedCountry(number.isoCode);

                        },
                        initalValue: PhoneNumber(
                          isoCode: _countryCode,
                        ),
                        isRequired: true,

                      ),
                      SizedBox(
                        height: 12,
                      ),
                      CTextFormField(
                        controller: controller.emailController,
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
                      if(accountType['id']!='customer')
                      ...List<Widget>.generate(
                        1,
                            (index) {
                          return Column(
                              children: [
                                CSelectFormField(
                                  value: controller
                                      .selectedInterestedCategories
                                      .containsKey(
                                      index.toString())
                                      ? controller
                                      .selectedInterestedCategories[
                                  index.toString()]
                                      .toString()
                                      : (index == 0 ? null : '0'),
                                  isRequired: index == 0,
                                  readOnly:
                                  (controller.categories.length ==
                                      0),
                                  disabledHint: Text(
                                    'Loading...'.tr,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  labelText:
                                  'Category'.tr + ' ${index + 1}',
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.all(11),
                                    child: Icon(Icons.category),
                                  ),
                                  items: [
                                ...(index == 0
                                ? []
                                    : [
                                DropdownMenuItem<String>(
                                value: '0',
                                  child: Text(
                                    'No category'.tr,
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ]),
                          ...controller.categories.entries
                              .map(
                          (entries) =>
                          DropdownMenuItem<
                          String>(
                          value: entries.value.id
                              .toString(),
                          child: Text(
                          entries.value.name
                              .toString(),
                          ),
                          ),
                          )
                              .toList(),
                          ],
                          onChanged: (id) {
                          if (id.toString() == '0') {
                          controller
                              .selectedInterestedCategories
                              .remove(index.toString());
                          } else {
                          controller
                              .selectedInterestedCategories[
                          index
                              .toString()] = id
                              .toString();
                          }

                          controller.update();
                          },
                          ),
                          SizedBox(
                          height: 12,
                          ),
                          ],
                          );
                        },
                      ).toList(),

                      CSelectFormField(
                        value: controller.selectedCityId,
                        isRequired: true,
                        readOnly: (controller.cities.length == 0),
                        disabledHint: Text(
                          'City'.tr,
                          /*(controller.cities.length == 0)
                              ? 'Loading...'.tr
                              : 'City'.tr,*/
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        labelText: 'City'.tr,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(11),
                          child: FaIcon(FontAwesomeIcons.city),
                        ),
                        items: controller.cities.entries
                            .map((entries) => DropdownMenuItem<String>(
                                  value: entries.value.id.toString(),
                                  child: Text(entries.value.name.toString()),
                                ))
                            .toList(),
                        onChanged: (cityId) =>
                            controller.changeSelectedCity(cityId),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      CTextFormField(
                        controller: controller.passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: !controller.passwordVisibility,
                        textDirection: TextDirection.ltr,
                        labelText: 'Password'.tr,
                        prefixIcon: Icon(
                          Icons.lock,
                        ),
                        suffixIcon: InkWell(
                          child: Icon(
                            !controller.passwordVisibility
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onTap: () => controller.togglePasswordVisibility(),
                        ),
                        isRequired: true,
                        onEditingComplete: () {
                          Get.focusScope?.nextFocus();
                        },
                        validator: (value) {
                          if (value == null ||
                              (value != null && value.isEmpty)) {
                            return 'This field is required'.tr;
                          } else if (controller.passwordController.text
                                  .toString() !=
                              controller.passwordConfirmationController.text
                                  .toString()) {
                            return 'The password and the password confirmation is not the same'
                                .tr;
                          }

                          /// Min 5
                        },
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      CTextFormField(
                        controller: controller.passwordConfirmationController,
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: !controller.passwordConfirmationVisibility,
                        textDirection: TextDirection.ltr,
                        labelText: 'Confirm Password'.tr,
                        prefixIcon: Icon(
                          Icons.lock,
                        ),
                        suffixIcon: InkWell(
                          child: Icon(
                            !controller.passwordConfirmationVisibility
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onTap: () =>
                              controller.togglePasswordConfirmationVisibility(),
                        ),
                        isRequired: true,
                        onEditingComplete: () {
                          Get.focusScope?.nextFocus();
                        },
                      ),
                      SizedBox(
                        height: 6,
                      ),

                      SizedBox(
                        height: 6,
                      ),
                      Container(
                        width: Get.width,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  CCheckbox(
                                    value: controller.isAgreeToPolicies,
                                    onChanged: controller.setIsAgreeToPolicies,
                                  ),
                                  InkWell(
                                    child: Text(
                                      'I accept all the'.tr,
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                    onTap: () =>
                                        controller.toggleIsAgreeToPolicies(),
                                  ),
                                  InkWell(
                                    child: Text(
                                      " ${'Terms and Conditions'.tr} ",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    onTap: () {
                                      Get.toNamed('/page', arguments: {
                                        'page': 'Terms and Conditions'
                                      });
                                    },
                                  ),
                                  Text(
                                    'and'.tr,
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  InkWell(
                                    child: Text(
                                      " ${'Privacy Policy'.tr}.",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    onTap: () {
                                      Get.toNamed('/page', arguments: {
                                        'page': 'Privacy Policy'
                                      });
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  CCheckbox(
                                    value:
                                        controller.isAgreeToSendNotifications,
                                    onChanged: controller
                                        .setIsAgreeToSendNotifications,
                                  ),
                                  InkWell(
                                    child: Text(
                                      'Allow the application to send notifications'
                                          .tr,
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                    onTap: () => controller
                                        .toggleIsAgreeToSendNotifications(),
                                  ),
                                  Text('.'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      CMaterialButton(
                        child: Text(
                          'Register'.tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () async {
                          /// Unfocus
                          Get.focusScope?.unfocus();

                          /// Set social data
                          controller.provider = controller.provider ?? provider;
                          controller.providerId =
                              controller.providerId ?? providerId;

                          /// Register
                          controller.register(
                            accountType: accountType,
                            isRequestMobileVerificationCode: true,
                              go: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) =>
                                      RegisterVerifyMobileScreen()),
                                );
                              }
                          );
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
    );
  }
}
