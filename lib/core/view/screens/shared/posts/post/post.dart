import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:m3rady/core/controllers/posts/posts_controller.dart';
import 'package:m3rady/core/view/layouts/main/main_layout.dart';
import 'package:m3rady/core/view/components/shared/posts/post.dart';


class PostsScreen extends StatefulWidget {
  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final postId = Get.arguments?['postId'];

  final commentId = Get.arguments?['commentId'];

  var post;

  /// Set posts controller
  PostsController postsController = Get.put(PostsController());

  /// Get post
  Future<bool> getPost(id) async {
    post = await postsController.getPostById(id);

    if (post != false) {
      return true;
    }

    Get.back();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      isDefaultPadding: false,
      title: 'Posts'.tr,
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

          Expanded(
            child: Container(
              child: FutureBuilder<bool>(
                future: getPost(postId),
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot.data != null && snapshot.data == true) {
                    return WPost(post: post, commentId:commentId);
                  }

                  return Container(
                    child: Center(
                      child: LoadingBouncingLine.circle(),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
