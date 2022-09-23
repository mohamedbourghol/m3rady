import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:m3rady/core/controllers/posts/posts_controller.dart';
import 'package:m3rady/core/utils/config/config.dart';
import 'package:m3rady/core/utils/storage/local/variables.dart';
import 'package:m3rady/core/view/components/components.dart';
import 'package:m3rady/core/view/layouts/main/main_layout.dart';
import 'package:m3rady/core/view/components/shared/pickers/video_picker.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:path_provider/path_provider.dart';


class PostsCreateScreen extends StatefulWidget {
  @override
  State<PostsCreateScreen> createState() => _PostsCreateScreenState();
}

class _PostsCreateScreenState extends State<PostsCreateScreen> {
  List<File>? listImages=[];
  final ImagePicker _picker = ImagePicker();
  /// Get multi image from gallery
  Future getMultiGalleryImage() async {
    try {

      List<Asset> resultList = <Asset>[];
      resultList = await MultiImagePicker.pickImages(
        maxImages: 5-listImages!.length,
        enableCamera: true,
        cupertinoOptions: CupertinoOptions(
          takePhotoIcon: "chat",
          doneButtonTitle: "Fatto",
        ),
        materialOptions: MaterialOptions(
          statusBarColor: "#1E90FF",
          actionBarColor: "#1E90FF",
          actionBarTitle: "M3rady".tr,
          allViewTitle: "all pictures".tr,

          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
      for (var im in resultList) {
        listImages!.add(await getImageFileFromAssets(im));
      }
      setState(() {

      });



    } catch (e) {
      print(e);
    }
  }

  Future<File> getImageFileFromAssets(Asset asset) async {
    final byteData = await asset.getByteData();

    final tempFile =
    File("${(await getTemporaryDirectory()).path}/${asset.name}");
    final file = await tempFile.writeAsBytes(
      byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
    );

    return file;
  }



  Future getCameraImage() async {

      final pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
      );

      if (pickedFile != null) {
        listImages!.add(File(pickedFile.path));
        setState(() {

        });


      }
      else {
        if (config['isDebugMode']) print('No image selected.');
      }



  }


  @override
  Widget build(BuildContext context) {
    return MainLayout(
      isDefaultPadding: false,
      title: 'Add Post'.tr,
      child: GetX<PostsController>(
        init: PostsController(),
        builder: (controller) => SingleChildScrollView(
          child: Column(
            children: [
              /// Edges
              Container(
                padding: const EdgeInsetsDirectional.only(
                  start: 12,
                  end: 12,
                ),
                height: 12,
              ),

              /// Request form
              Container(
                child: SingleChildScrollView(
                  child: Form(
                    key: controller.postFormKey,
                    child: Column(
                      children: [
                        /// Title
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 12,
                              right: 12,
                            ),
                            child: Text(
                              'Post Content'.tr,
                              style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),

                        /// Content
                        Padding(
                          padding:  EdgeInsets.all(12),
                          child: CTextFormField(
                            controller: controller.contentController,
                            keyboardType: TextInputType.multiline,
                            contentPadding: const EdgeInsetsDirectional.only(
                              start: 8,
                              end: 8,
                              top: 12,
                            ),
                            maxLength: 1500,
                            minLines: 8,
                            isRequired: true,
                          ),
                        ),

                        /// Break
                        Container(
                          color: Colors.grey.shade200,
                          height: 6,
                        ),

                        SizedBox(
                          height: 12,
                        ),

                        /// Title
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 12,
                            right: 12,
                          ),
                          child: Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Padding(
                              padding: const EdgeInsetsDirectional.only(
                                bottom: 12,
                              ),
                              child: Text(
                                'Category'.tr,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),

                        /// Category
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: CSelectFormField(
                            value: (GlobalVariables.user.interestedCategories !=
                                        null &&
                                    GlobalVariables
                                            .user.interestedCategories.length ==
                                        1
                                ? GlobalVariables.user.interestedCategories
                                    .entries.first.value.id
                                    .toString()
                                : null),
                            isRequired: true,
                            disabledHint: Text(
                              'Loading...'.tr,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            labelText: 'Category'.tr,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(11),
                              child: Icon(Icons.category),
                            ),
                            items: [
                              ...GlobalVariables.user.interestedCategories !=
                                          null &&
                                      GlobalVariables.user.interestedCategories
                                              .length >
                                          0
                                  ? GlobalVariables
                                      .user.interestedCategories.entries
                                      .map(
                                        (entries) => DropdownMenuItem<String>(
                                          value: entries.value.id.toString(),
                                          child: Text(
                                            entries.value.name.toString(),
                                          ),
                                        ),
                                      )
                                      .toList()
                                  : []
                            ],
                            onChanged: (id) {
                              controller.selectedCategoryId = id.toString();
                            },
                          ),
                        ),

                        /// Break
                        Container(
                          color: Colors.grey.shade200,
                          height: 6,
                        ),

                        SizedBox(
                          height: 12,
                        ),

                        /// Title
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 12,
                            right: 12,
                          ),
                          child: Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Padding(
                              padding: const EdgeInsetsDirectional.only(
                                bottom: 12,
                              ),
                              child: Text(
                                'Post Attachments'.tr,
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),

                        /// Type
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                controller.postAttachmentType.value = 'images';
                                controller.videos = {};
                              },
                              child: Row(
                                children: [
                                  Radio(
                                    value: 'images',
                                    groupValue:
                                        controller.postAttachmentType.value,
                                    activeColor: Colors.orange,
                                    onChanged: (value) {
                                      controller.postAttachmentType.value =
                                          'images';
                                      controller.videos = {};
                                    },
                                  ),
                                  Text('Images'.tr),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            GestureDetector(
                              onTap: () {
                                controller.postAttachmentType.value = 'videos';
                                controller.images = {};
                              },
                              child: Row(
                                children: [
                                  Radio(
                                    value: 'videos',
                                    groupValue:
                                        controller.postAttachmentType.value,
                                    activeColor: Colors.orange,
                                    onChanged: (value) {
                                      controller.postAttachmentType.value =
                                          'videos';
                                      controller.images = {};
                                    },
                                  ),
                                  Text('Videos'.tr),
                                ],
                              ),
                            ),
                          ],
                        ),

                        /// Title
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 12,
                              right: 12,
                            ),
                            child: Text(
                              'You can upload multiple images or one video with each post.'
                                  .tr,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 12,
                        ),

                        /// Break
                        Container(
                          color: Colors.grey.shade200,
                          height: 6,
                        ),

                        /// Title
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              (controller.postAttachmentType.value == 'images'
                                  ? 'Upload Images'.tr
                                  : 'Upload Videos'.tr),
                              style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),

                        /// Images
                        Visibility(
                          visible:
                              controller.postAttachmentType.value == 'images',
                          child: Column(
                            children: [
                              if(listImages!.length<config['maximumPostImages'])
                                Center(
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
                                                    getMultiGalleryImage().then(
                                                            (value) {




                                                        });
                                                    Get.back();
                                                  },
                                                ),

                                                ///Camera
                                                ListTile(
                                                  title: Text(
                                                    'The Camera'.tr,
                                                  ),
                                                  leading: Icon(
                                                    Icons.camera_alt_outlined,
                                                  ),
                                                  minLeadingWidth: 0,
                                                  enabled: true,
                                                  selected: false,
                                                  dense: true,
                                                  onTap: () async {
                                                    getCameraImage();

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
                           if(listImages!.length>0)
                              Padding(
                                padding: const EdgeInsetsDirectional.only(
                                  start: 12,
                                  end: 12,
                                  top: 12,
                                  bottom: 4,
                                ),
                                child: Column(
                                  children: [
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: List<Widget>.generate(
                                            listImages!.length<5?  listImages!.length:5, (index)
                                        {
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
                                                      child:
                                                           Image.file(
                                                        listImages![index],
                                                        fit: BoxFit.cover,
                                                      )

                                                    ),
                                                  ),

                                                  /// Delete Image
                                                  Visibility(
                                                    visible:  listImages!.length>0,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          listImages!.removeAt(index);
                                                         controller.handleVideoByIndexCallback(
                                                            index: index,
                                                            file: null,
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
                                                visible: index.toString() != '',
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
                                                      child: Text( ( index+1)
                                                       .toString(),
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
                                        ).toList(),
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                    /// Note
                                    Text(
                                      'The number of uploaded photos should not exceed 5 photos.'
                                          .tr,
                                      style: TextStyle(
                                        color: Colors.orange,
                                        fontSize: 12,
                                        //fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(
                                height: 6,
                              ),


                            ],
                          ),
                        ),

                        /// Videos
                        Visibility(
                          visible:
                              controller.postAttachmentType.value == 'videos',
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: List<Widget>.generate(
                                        config['maximumPostVideos'], (index) {
                                      return WVideoPicker(
                                        index: index,
                                        callback:
                                            controller.handleVideoByIndexCallback,
                                        title: (index + 1).toString(),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                SizedBox(height: 10,),
                                /// Note
                                Text(
                                  'Videos with a length of less than 5 minutes will be accepted.'
                                      .tr,
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontSize: 12,
                                    //fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 6,
                        ),

                        /// Submit
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: CMaterialButton(
                            child: Text(
                              'Publish'.tr,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed:
                                GlobalVariables.user?.statistics?['leftPosts'] >
                                        0
                                    ? () async {
                              if(controller.postAttachmentType.value == 'images')
                                {
                                  int x=listImages!.length;
                                  if(x>config['maximumPostImages'])
                                    x=config['maximumPostImages'];
                                  for(int i=0 ;i<x;i++)
                                  {
                                    controller.handleImageByIndexCallback
                                      (
                                      index: i,
                                      file: listImages![i],
                                    );
                                  }
                                }

                                        await controller.submitPostCreateForm();
                                      }
                                    : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              /// Break
              Container(
                color: Colors.grey.shade200,
                height: 6,
              ),

              /// Notes
              Visibility(
                visible: GlobalVariables.userDataUpdatesCounter > 0,
                child: Padding(
                  padding:EdgeInsets.all(12),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Note:'.tr,
                              style: TextStyle(
                                color: Colors.orange,
                              ),
                            ),
                            SizedBox(
                              width: 2,
                            ),
                            Text(
                              'You can publish X post from a total of X posts.'
                                  .trArgs([
                                (GlobalVariables
                                            .user?.statistics?['leftPosts'] ??
                                        0)
                                    .toString(),
                                (GlobalVariables.user
                                            ?.statistics?['maximumPosts'] ??
                                        0)
                                    .toString(),
                              ]),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    Get.delete<PostsController>();
  }
}


