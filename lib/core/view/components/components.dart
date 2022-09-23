import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:m3rady/core/helpers/assets_helper.dart';
import 'package:m3rady/core/view/theme/colors.dart';

/*
 *  Logo
 */
Widget CLogo({
  double size = 120,
}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Image(
        height: size,
        width: size,
        image: assets['logo'],
      ),
      SizedBox(
        height: 2,
      ),
      Text(
        'M3rady'.tr,
        style: TextStyle(
          fontSize: (size / 5).toDouble(),
          //fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}

/*
 * Break (horizontal line) 
 */
Widget CBr({
  double height = 1,
  double thickness = 1,
  color,
}) {
  return Divider(
    color: color ?? Colors.grey.shade200,
    height: height,
    thickness: thickness,
  );
}

/*
 * Break (horizontal line) 
 * wrap parent with IntrinsicHeight
 */
Widget CVBr({
  double thickness = 1,
  color,
}) {
  return VerticalDivider(
    thickness: thickness,
    color: color ?? Colors.grey.shade200,
  );
}

/*
 * Bottom Sheet Head
 */
Widget CBottomSheetHead() {
  return Container(
    decoration: BoxDecoration(
      color: Colors.grey[300],
      borderRadius: BorderRadius.all(
        const Radius.circular(10.0),
      ),
    ),
    height: 5,
    width: Get.width / 6,
  );
}

/*
 *  Text Form Field
 */
Widget CTextFormField({
  controller,
  labelText,
  hintText,
  obscureText = false,
  prefixIcon,
  suffixIcon,
  border,
  readOnly = false,
  textDirection,
  keyboardType,
  value,
  validator,
  bool isRequired = false,
  fillColor,
  textAlign,
  maxLength,
  minLines,
  maxLines = 1,
  contentPadding,
  onTap,
  onChanged,
  onEditingComplete,
  onFieldSubmitted,
}) {
  border = border ?? OutlineInputBorder(borderRadius: BorderRadius.circular(5));
  fillColor = fillColor ?? Color(0xffFAFAFC);
  textAlign = textAlign ?? TextAlign.justify;
  contentPadding = contentPadding ??
      EdgeInsetsDirectional.only(
        start: 6,
        end: 6,
        top: 18,
        bottom: 16,
      );

  /// Handle max lines
  maxLines = (minLines == null ? 1 : null);

  /// Handle is required
  if (isRequired && validator == null) {
    /// Trim value
    value = value?.trim();

    validator = (value) {
      if (value == null || (value != null && value.isEmpty)) {
        return 'This field is required'.tr;
      }
    };
  }

  return TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    obscureText: obscureText,
    maxLength: maxLength,
    minLines: minLines,
    maxLines: maxLines,
    textAlign: textAlign,
    style: TextStyle(
      fontFamily: 'Tajawal',
      color: readOnly == true ? Colors.grey : Colors.black,
    ),
    decoration: InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey.shade300,
          width: 2,
        ),
      ),
      labelText: labelText,
      hintText: hintText,
      border: border,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: fillColor != null,
      fillColor: fillColor,
      contentPadding: contentPadding,
      isCollapsed: true,
      alignLabelWithHint: true,
    ),
    textDirection: textDirection,
    initialValue: (controller == null ? value : null),
    validator: validator,
    readOnly: readOnly,
    onTap: onTap,
    onChanged: onChanged,
    onEditingComplete: onEditingComplete,
    onFieldSubmitted: onFieldSubmitted,
  );
}

/*
 * Dropdown Button Form Field
 */
Widget CSelectFormField({
  required List<DropdownMenuItem> items,
  value,
  labelText,
  hintText,
  disabledHint,
  prefixIcon,
  suffixIcon,
  border,
  bool readOnly = false,
  bool isRequired = false,
  validator,
  fillColor,
  contentPadding,
  onTap,
  onChanged,
}) {
  border = border ??
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
      );
  fillColor = fillColor ?? Color(0xffFAFAFC);
  contentPadding = contentPadding ??
      EdgeInsetsDirectional.only(
        start: 6,
        end: 6,

        bottom: 2,
      );

  if (isRequired && validator == null) {
    validator = (value) {
      if (value == null || (value != null && value.isEmpty)) {
        return 'This field is required'.tr;
      }
    };
  }

  return DropdownButtonFormField(
    value: value,
    items: items,
    isExpanded: true,
    isDense: false,
    icon: const Icon(Icons.expand_more),
    iconSize: 24,

    disabledHint: disabledHint,
    decoration: InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey.shade300,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red.shade100,
          width: 1.5,
        ),
      ),
      labelText: (readOnly && disabledHint != null) ? null : labelText,
      hintText: (readOnly && disabledHint != null) ? null : hintText,
      border: border,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: fillColor != null,
      fillColor: fillColor,
      contentPadding: contentPadding,
    ),
    validator: validator,
    onTap: onTap,
    onChanged: readOnly ? null : onChanged,
  );
}

/*
 *  Material Button
 */
Widget CMaterialButton({
  required child,
  double minWidth = double.infinity,
  double height = 50.0,
  bool disabled = false,
  double disabledElevation = 1,
  double radius = 5,
  disabledColor,
  decoration,
  color,
  borderColor,
  shape,
  required onPressed,
}) {
  color = color ?? ApplicationColors.colors['primary'];
  disabledColor = disabledColor ?? Colors.grey[400];
  borderColor = disabled
      ? disabledColor
      : (borderColor ?? ApplicationColors.colors['primary']);
  shape = shape ??
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      );
  decoration = decoration ??
      BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.all(
          Radius.circular(radius + 1),
        ),
      );
  onPressed = disabled ? null : onPressed;

  return Container(
    decoration: decoration,
    child: MaterialButton(
      minWidth: minWidth,
      height: height,
      color: color,
      shape: shape,
      child: child,
      onPressed: disabled ? null : onPressed,
      disabledColor: disabledColor,
      disabledElevation: disabledElevation,
    ),
  );
}

/*
 * Circle Button
 */
CCircleButton({
  required child,
  required onPressed,
  double size = 14,
  color,
  spalshColor,
}) {
  color = color ?? Colors.white;
  spalshColor = spalshColor ?? Colors.grey[300];

  return ElevatedButton(
    child: child,
    style: ElevatedButton.styleFrom(
      shape: CircleBorder(),
      padding: EdgeInsets.all(size),
      primary: color,
      onPrimary: spalshColor,
    ),
    onPressed: onPressed,
  );
}

/*
 * Checkbox
 */
CCheckbox({
  required value,
  required onChanged,
  checkColor,
  activeColor,
}) {
  checkColor = checkColor ?? Colors.white;
  activeColor = activeColor ?? Colors.grey;

  return Checkbox(
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(3),
    ),
    checkColor: checkColor,
    activeColor: activeColor,
    value: value,
    onChanged: onChanged,
  );
}

/// Confirm dialog
CConfirmDialog({
  String? content,
  Widget? contentWidget,
  String? title,
  List<Widget>? actions,
  String? confirmText,
  Color? confirmTextColor,
  Function? confirmCallback,
  bool? autoClose = true,
}) {
  return Get.defaultDialog(
    title: title ?? 'Alert'.tr,
    content: contentWidget != null
        ? contentWidget
        : Padding(
            padding: const EdgeInsets.only(
              left: 6,
              right: 6,
            ),
            child: Text(
              content ?? 'Are you sure?'.tr,
              style: TextStyle(
                fontFamily: 'Tajawal',
              ),
            ),
          ),
    actions: actions ??
        [
          /// The "Yes" button
          TextButton(
            onPressed: () {
              /// Call back
              if (confirmCallback != null) {
                confirmCallback();
              }

              /// Close the dialog
              if (autoClose == true) {
                Get.back();
              }
            },
            child: Text(
              confirmText ?? 'Agree'.tr,
              style: TextStyle(
                color: confirmTextColor ?? Colors.red,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              /// Close the dialog
              Get.back();
            },
            child: Text(
              'Cancel'.tr,
            ),
          )
        ],
  );
}

/// Error dialog
CErrorDialog({
  required List errors,
  List<Widget>? actions,
  String? cancelText,
}) {
  return Get.defaultDialog(
    title: 'Warning'.tr,
    middleText: '',
    backgroundColor: Colors.white,
    titleStyle: TextStyle(
      color: Colors.redAccent,
      fontSize: 14,
    ),
    middleTextStyle: TextStyle(
      color: Colors.grey,
      fontSize: 12,
    ),
    cancelTextColor: Colors.black38,
    buttonColor: Colors.white,
    textCancel: cancelText ?? 'Agree'.tr,
    barrierDismissible: false,
    radius: 25,
    actions: actions,
    content: Padding(
      padding: const EdgeInsets.only(
        left: 6,
        right: 6,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.from([
          Text(
            'Please check the following errors'.tr,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          SizedBox(
            height: 12,
          ),
        ])
          ..addAll(
            errors.map<Widget>((error) {
              return Column(
                children: [
                  Text(
                    error,
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                ],
              );
            }).toList(),
          ),
      ),
    ),
  );
}

/// Something went wrong dialog
CSomethingWentWrongDialog({
  callback,
}) {
  return Get.defaultDialog(
    title: 'Warning'.tr,
    middleText: '',
    backgroundColor: Colors.white,
    titleStyle: TextStyle(
      color: Colors.redAccent,
      fontSize: 14,
    ),
    middleTextStyle: TextStyle(
      color: Colors.grey,
      fontSize: 12,
    ),
    cancelTextColor: Colors.black38,
    buttonColor: Colors.white,
    textCancel: 'Agree'.tr,
    barrierDismissible: false,
    radius: 25,
    content: Padding(
      padding: const EdgeInsets.only(
        left: 6,
        right: 6,
      ),
      child: Text(
        'Something went wrong please try again later!'.tr,
        style: TextStyle(
          fontFamily: 'Tajawal',
        ),
      ),
    ),
    onCancel: () {
      if (callback != null) {
        callback();
      }
    },
  );
}

/// Must login dialog
CRedirectToLoginDialog({
  callback,
}) {
  return Get.defaultDialog(
      title: 'Warning'.tr,
      middleText: '',
      backgroundColor: Colors.white,
      titleStyle: TextStyle(
        color: Colors.redAccent,
        fontSize: 14,
      ),
      middleTextStyle: TextStyle(
        color: Colors.grey,
        fontSize: 12,
      ),
      cancelTextColor: Colors.black38,
      buttonColor: Colors.white,
      textCancel: 'Agree'.tr,
      barrierDismissible: false,
      radius: 25,
      content: Padding(
        padding: const EdgeInsets.only(
          left: 6,
          right: 6,
        ),
        child: Text(
          'You must login again to your account.'.tr,
          style: TextStyle(
            fontFamily: 'Tajawal',
          ),
        ),
      ),
      onCancel: () {
        if (callback != null) {
          callback();
        }
      });
}

/// Something went wrong dialog
CSentSuccessfullyDialog({
  required String text,
  callback,
}) {
  return Get.defaultDialog(
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
    cancelTextColor: Colors.black45,
    buttonColor: Colors.white,
    textCancel: 'Ok'.tr,
    barrierDismissible: false,
    radius: 25,
    content: Padding(
      padding: const EdgeInsets.only(
        left: 6,
        right: 6,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Tajawal',
        ),
      ),
    ),
    onCancel: () async {
      if (callback != null) {
        await callback();
      }
    },
  );
}

/// Toast
CToast({
  required String text,
  callback,
  backgroundColor = Colors.black87,
  textColor = Colors.white,
}) {
  return Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.SNACKBAR,
    timeInSecForIosWeb: 2,
    webShowClose: true,
    backgroundColor: backgroundColor,
    textColor: textColor,
    fontSize: 16.0,
  );
}
