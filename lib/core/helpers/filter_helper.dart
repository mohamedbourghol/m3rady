import 'package:intl/intl.dart';

class FilterHelper {
  /// Format numbers
  static formatNumbers(number) {
    if (number < 999) {
      return number.toString();
    }
    return NumberFormat.compactCurrency(
      decimalDigits: 1,
      /// if you want to add currency symbol then pass that in this else leave it empty.
      symbol: '',
    ).format(number).toString();
  }
}
