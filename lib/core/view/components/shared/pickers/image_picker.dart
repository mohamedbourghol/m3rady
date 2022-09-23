import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:m3rady/core/utils/config/config.dart';
import 'package:m3rady/core/view/components/components.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class WImagePicker extends StatefulWidget {
  int index;
  String title;
  Function callback;
  File? image;

  WImagePicker({
    required this.index,
    required this.callback,
    this.title = '',
  });

  @override
  _WImagePickerState createState() => _WImagePickerState();
}

class _WImagePickerState extends State<WImagePicker> {
  final ImagePicker _picker = ImagePicker();

  /// Get image from gallery
  Future getGalleryImage() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );

      if (pickedFile != null) {
        setState(() {
          widget.image = File(pickedFile.path);
          widget.callback(
            index: widget.index,
            file: widget.image,
          );
        });
      } else {
        if (config['isDebugMode']) print('No image selected.');
      }
    } catch (e) {
      Get.defaultDialog(
        title: 'Permissions'.tr,
        content: Text('Please give the gallery permission to the app.'.tr),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              'Cancel'.tr,
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              openAppSettings();
            },
            child: Text('Settings'.tr),
          ),
        ],
      );
    }
  }

  /// Get image form camera
  Future getCameraImage() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
      );

      if (pickedFile != null) {
        setState(() {
          widget.image = File(pickedFile.path);
          widget.callback(
            index: widget.index,
            file: widget.image,
          );
        });
      } else {
        if (config['isDebugMode']) print('No image selected.');
      }
    } catch (e) {
      Get.defaultDialog(
        title: 'Permissions'.tr,
        content: Text('Please give the camera permission to the app.'.tr),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              'Cancel'.tr,
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              openAppSettings();
            },
            child: Text('Settings'.tr),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    /// Set current image if exits
    widget.image = widget.callback(
      index: widget.index,
      file: widget.image,
      getCurrentFile: true,
    );

    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        /// Image
        Stack(
          children: [
            /// Add button || Image
            Container(
              width: 124,
              height: 124,
              child: Card(
                clipBehavior: Clip.antiAlias,
                elevation: 1.5,
                /// Add button || Image
                child: widget.image != null
                    ? Image.file(
                        widget.image!,
                        fit: BoxFit.cover,
                      )
                    : Center(
                        child: GestureDetector(
                          onTap: () {
                            Get.bottomSheet(
                              Container(
                                height: 150,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      CBottomSheetHead(),

                                      SizedBox(
                                        height: 12,
                                      ),

                                      /// Gallery
                                      ListTile(
                                        title: Text(
                                          'The Gallery'.tr,
                                        ),
                                        leading: Icon(
                                          Icons.image,
                                        ),
                                        minLeadingWidth: 0,
                                        enabled: true,
                                        selected: false,
                                        dense: true,
                                        onTap: () async {
                                          getGalleryImage();
                                          Get.back();
                                        },
                                      ),

                                      /// Camera
                                      ListTile(
                                        title: Text(
                                          'The Camera'.tr,
                                        ),
                                        leading: Icon(
                                          Icons.camera_enhance,
                                        ),
                                        minLeadingWidth: 0,
                                        enabled: true,
                                        selected: false,
                                        dense: true,
                                        onTap: () async {
                                          getCameraImage();
                                          Get.back();
                                        },
                                      ),
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
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(50),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade200,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.add,
                              color: Colors.black38,
                              size: 25,
                            ),
                          ),
                        ),
                      ),
              ),
            ),

            /// Delete Image
            Visibility(
              visible: widget.image != null,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    widget.image = null;
                    widget.callback(
                      index: widget.index,
                      file: widget.image,
                    );
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white70,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.highlight_off,
                      color: Colors.red.shade600,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        /// Image number
        Visibility(
          visible: widget.title != '',
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              width: 16,
              height: 17,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.all(
                  Radius.circular(4),
                ),
              ),
              child: Center(
                child: Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.black38,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
