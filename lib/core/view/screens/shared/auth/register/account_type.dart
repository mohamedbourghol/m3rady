import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m3rady/core/controllers/advertisers/business_types/business_types_controller.dart';
import 'package:m3rady/core/view/components/components.dart';
import 'package:m3rady/core/view/layouts/auth/auth_layout.dart';




class AccountTypeScreen extends StatefulWidget {
  const AccountTypeScreen({Key? key}) : super(key: key);

  @override
  _AccountTypeScreenState createState() => _AccountTypeScreenState();
}

class _AccountTypeScreenState extends State<AccountTypeScreen> {
  String type='';

  @override
  Widget build(BuildContext context) {
    return AuthLayout(
      title: 'Register'.tr,
      child: GetBuilder<BusinessTypesController>(
        init: BusinessTypesController(),
        builder: (controller) => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Header
            Padding(
              padding: const EdgeInsetsDirectional.only(
                top: 12,
                bottom: 12,
              ),
              child: CLogo(
                size: 120,
              ),
            ),

            /// Body
            Container(
              child: SingleChildScrollView(
                  child: Form(
                    key: controller.accountTypeFormKey,
                    child: Column(
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Please select the type of account that you want to register'
                                .tr,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          CSelectFormField(
                            value: controller.selectedTypeId,
                            isRequired: true,
                            readOnly: (controller.types.length == 0),
                            disabledHint: Text(
                              'Loading...'.tr,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            labelText: 'Account Type'.tr,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Icon(
                                Icons.person,
                              ),
                            ),
                            onChanged: (typeId) {
                              controller.changeSelectedType(typeId);
                              type=typeId;
                              setState(() {

                              });
                            },


                            items: (controller.types.length == 0
                            ? []
                                    : [
                                DropdownMenuItem<String>(
                                value: 'customer',
                                child: Text('Customer'.tr),
                          ),
                          ...controller.types.entries.map((entries) {
                            String value = entries.value.id.toString();
                            String title = entries.value.name;
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(title),
                            );
                          }).toList(),
                        ]),
                  ),
                  if(type=='customer')
              Column(
              children: [
              SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'The account is limited to browsing only and cannot post.'
                            .tr,
                        style: TextStyle(
                          color: Colors.grey.shade200,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],

        ),
        SizedBox(
          height: 16,
        ),
        CMaterialButton(
          child: Text(
            'Next'.tr,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          onPressed: () {
            /// Validate form
            if (controller.validateForm()) {
              /// Redirect to register
              Get.toNamed('/auth/register', arguments: {
                'selectedAccountType': {
                  'id': controller.selectedTypeId,
                  'name': (controller.selectedTypeId != 'customer'
                      ? "${controller.types[controller.selectedTypeId].name} " +
                      (Get.locale.toString() == 'en'
                          ? 'of '
                          : '')
                      : 'Customer'.tr),
                },
                'provider': Get.arguments?['provider'],
                'providerId': Get.arguments?['providerId'],
              });
            }
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
