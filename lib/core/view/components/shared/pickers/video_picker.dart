import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:m3rady/core/utils/config/config.dart';
import 'package:m3rady/core/view/components/components.dart';


import 'package:m3rady/core/view/widgets/video/video_player.dart';
import 'dart:io';

class WVideoPicker extends StatefulWidget {
  int index;
  String title;
  Function callback;
  File? video;

  WVideoPicker({
    required this.index,
    required this.callback,
    this.title = '',
  });

  @override
  _WVideoPickerState createState() => _WVideoPickerState();
}

class _WVideoPickerState extends State<WVideoPicker> {
  final ImagePicker _picker = ImagePicker();

  /// Get video from gallary
  Future getGalleryVideo() async {
    try {
      final pickedFile = await _picker.pickVideo(
        source: ImageSource.gallery,


      );

      if (pickedFile != null) {

        setState(() {
          widget.video = File(pickedFile.path);
          widget.callback(
            index: widget.index,
            file: widget.video,
          );
        });
      } else {
        if (config['isDebugMode']) print('No video selected.');
      }
    } catch (e) {
      if (config['isDebugMode']) print(e);
    }
  }

  /// Get video form camera
  Future getCameraVideo() async {
    try {
      final pickedFile = await _picker.pickVideo(
        source: ImageSource.camera,

      );

      if (pickedFile != null) {
        setState(() {
          widget.video = File(pickedFile.path);
          widget.callback(
            index: widget.index,
            file: widget.video,
          );
        });
      } else {
        if (config['isDebugMode']) print('No video selected.');
      }
    } catch (e) {
      if (config['isDebugMode']) print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    /// Set current video if exits
    widget.video = widget.callback(
      index: widget.index,
      file: widget.video,
      getCurrentFile: true,
    );

    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        /// Video
        Stack(
          children: [
            /// Add button || Video
            Container(
              width: widget.video != null?324:124,
              height: widget.video != null?324:124,
              child: Card(
                clipBehavior: Clip.antiAlias,
                elevation: 1.5,
                /// Add button || Video
                child: widget.video != null
                    ? WVideoPlayer1.file(widget.video!)
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
                                          getGalleryVideo();
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
                                          getCameraVideo();
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

            /// Delete Video
            Visibility(
              visible: widget.video != null,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    widget.video = null;
                    widget.callback(
                      index: widget.index,
                      file: widget.video,
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

        /// Video number
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
