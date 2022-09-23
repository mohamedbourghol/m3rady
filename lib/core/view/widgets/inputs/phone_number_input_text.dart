import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:m3rady/core/controllers/system/countries/countries_controller.dart';
import 'package:m3rady/core/controllers/system/languages/languages_controller.dart';
import 'package:m3rady/core/view/components/components.dart';

class WInternationalPhoneNumberInputText extends StatefulWidget {
  final TextEditingController controller;
  final TextEditingController fullController;
  final FocusNode focusNode = FocusNode();
  bool isRequired;
  bool formatInput = false;
  ValueChanged<PhoneNumber>? onInputChanged = (PhoneNumber number) {};
  VoidCallback? onSubmit;
  ValueChanged<String>? onFieldSubmitted;
  ValueChanged<PhoneNumber>? onSaved;
  ValueChanged<bool>? onInputValidated;
  PhoneNumber phoneNumber = PhoneNumber();
  PhoneNumber? initalValue;
  bool isEditingMobile = false;
  bool readOnly = false;
  String? text;
  Widget? prefixIcon;

  WInternationalPhoneNumberInputText({
    required this.controller,
    required this.fullController,
    this.onInputChanged,
    this.onFieldSubmitted,
    this.onSubmit,
    this.onInputValidated,
    this.onSaved,
    this.text,
    this.prefixIcon,
    this.isRequired = false,
    this.readOnly = false,
    this.initalValue,
  });

  @override
  _WInternationalPhoneNumberInputTextState createState() =>
      _WInternationalPhoneNumberInputTextState();
}

class _WInternationalPhoneNumberInputTextState
    extends State<WInternationalPhoneNumberInputText> {
  String lan=Get.find<LanguageController>().userLocale;


  @override
  Widget build(BuildContext context) {
    return widget.isEditingMobile || (widget.fullController.text.length > 0)
        ? Container(
            padding: const EdgeInsets.only(
              left: 8,
            ),
            child: InternationalPhoneNumberInput(

              textFieldController: widget.controller,

              selectorConfig: SelectorConfig(
                selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                useEmoji: true,



              ),
              //selectorTextStyle: null,
              //textStyle: null,
              inputDecoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade300,
                    width: 2,
                  ),
                ),
                hintText: widget.text ?? 'Mobile Number'.tr,
                labelText: widget.text ?? 'Mobile Number'.tr,
                prefixIcon: widget.prefixIcon ??
                    const Icon(
                      Icons.phone,
                      color: Colors.grey,
                    ),
                border: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
              ),
              initialValue: widget.initalValue,
              ignoreBlank: !widget.isRequired,
              autoValidateMode: AutovalidateMode.onUserInteraction,
              spaceBetweenSelectorAndTextField: 0,
              locale:lan,
              selectorButtonOnErrorPadding: 24,
              autoFocusSearch: false,
              hintText: widget.text ?? 'Mobile Number'.tr,
              errorMessage: 'This mobile number is invalid'.tr,
              searchBoxDecoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                hintText: 'Search'.tr,
              ),
              countries: Get.find<AppCountries>().countriesCodes,

              formatInput: widget.formatInput,
              keyboardType: TextInputType.numberWithOptions(
                signed: false,
                decimal: false,
              ),
              //inputBorder: inputBorder,

              onInputChanged: (PhoneNumber number) {
                /// Call back
                if (widget.onInputChanged != null) {
                  widget.onInputChanged!(number);
                }

                setState(() {
                  /// Change phone number
                  widget.phoneNumber = number;

                  /// Change fake text
                  widget.fullController.text = number.toString();
                });
              },
              onFieldSubmitted: widget.onFieldSubmitted,
              onSubmit: widget.onSubmit,
              onInputValidated: widget.onInputValidated,
              onSaved: widget.onSaved,
            ),
          )
        : CTextFormField(
            controller: widget.fullController,
            keyboardType: TextInputType.numberWithOptions(
              signed: false,
              decimal: false,
            ),
            labelText: widget.text ?? 'Mobile Number'.tr,
            prefixIcon: const Icon(
              Icons.phone,
              color: Colors.grey,
            ),
            textDirection: TextDirection.ltr,
            isRequired: widget.isRequired,
            readOnly: true,
            onTap: () {
              if (!widget.readOnly) {
                /// Clear on start editing
                widget.controller.clear();
                widget.fullController.clear();

                /// Show editable text input
                setState(() {
                  widget.isEditingMobile = true;
                });

                /// Focus on editable text input
                widget.focusNode.requestFocus();
               }
            },
          );
  }
}
