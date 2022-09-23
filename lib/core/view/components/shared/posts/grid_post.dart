import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m3rady/core/controllers/posts/comments/comments_controller.dart';
import 'package:m3rady/core/controllers/posts/posts_controller.dart';
import 'package:m3rady/core/controllers/system/languages/languages_controller.dart';

import 'package:m3rady/core/utils/storage/local/variables.dart';
import 'package:m3rady/core/view/components/components.dart';

import 'package:m3rady/core/view/components/shared/media/media.dart';
import 'package:m3rady/core/view/components/shared/posts/advertisements/advertisement.dart';


import '../media/grid_media.dart';
import 'likes/likes_view.dart';






class GridPost extends StatefulWidget {
  var post;
  var commentId;
  GridPost({Key? key,required this.commentId,
    required this.post}) : super(key: key);

  @override
  _GridPostState createState() => _GridPostState();
}

class _GridPostState extends State<GridPost> {

  final LanguageController appLanguage = Get.find<LanguageController>();


  @override
  Widget build( context) {


    return Container(
      width: (MediaQuery.of(context).size.width)/3,
      height:(MediaQuery.of(context).size.width)/3 ,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 1,
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 0.5,
          )
        ],
      ),

      child: WGridMedia(
        mediaList: widget.post.media,
        appLocale: appLanguage.userLocale,
      ),
    );
  }
}

