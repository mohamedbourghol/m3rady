import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:m3rady/core/models/advertisers/business_types/business_type.dart';

class BusinessTypesController extends GetxController {
  GlobalKey<FormState> accountTypeFormKey = GlobalKey<FormState>();

  /// Set selected type id
  String? selectedTypeId;

  /// Set types
  Map types = {};

  @override
  void onReady() async {
    super.onReady();

    /// Get and set types
    await getBusinessTypes();
  }

  /// Change selected type id
  void changeSelectedType(typeId) {
    /// Set type
    selectedTypeId = typeId;

    update();
  }

  /// Validate form
  bool validateForm() {
    FormState? form = accountTypeFormKey.currentState;
    if (form != null) {
      return form.validate();
    }
    return false;
  }

  /// Get page by slug
  getBusinessTypes() async {
    /// Get types
    types = await BusinessType.getBusinessTypes();

    update();

    return types;
  }
}
