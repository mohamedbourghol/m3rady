import 'package:flutter/services.dart';
import 'package:m3rady/core/utils/storage/local/variables.dart';

class MainLoader {
  /// Set loader
  static set(bool isLoading) {
    /// Hide keyboard
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    GlobalVariables.isMainLoading.value = isLoading;
  }
}
