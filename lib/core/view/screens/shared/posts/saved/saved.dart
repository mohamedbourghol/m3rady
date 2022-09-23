import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:m3rady/core/controllers/advertisers/advertisers_controller.dart';
import 'package:m3rady/core/controllers/posts/comments/comments_controller.dart';
import 'package:m3rady/core/controllers/posts/posts_controller.dart';
import 'package:m3rady/core/view/layouts/main/main_layout.dart';
import 'package:m3rady/core/view/components/shared/posts/post.dart';
import 'package:pagination_view/pagination_view.dart';

class PostsSavedScreen extends StatefulWidget {
  @override
  _PostsSavedScreenState createState() => _PostsSavedScreenState();
}

class _PostsSavedScreenState extends State<PostsSavedScreen> {
  final PostsController postsController = Get.put(PostsController());

  final AdvertisersController advertisersController =
      Get.put(AdvertisersController());

  final CommentsController commentsController = Get.put(CommentsController());

  /// Posts Pagination View
  ScrollController postsPaginationViewScrollController = ScrollController();

  GlobalKey<PaginationViewState> postsPaginationViewKey =
      GlobalKey<PaginationViewState>();

  int postsCurrentPage = 1;

  bool isAnyPost = false;

  bool isPostsHasNextPage = true;

  /// Fetch posts
  Future<List<dynamic>> fetchPostsByOffset(offset) async {
    List postsData = [];
    late Map posts;

    /// Get posts
    if (isPostsHasNextPage || offset == 0) {
      postsCurrentPage = offset == 0 ? 1 : postsCurrentPage + 1;

      posts = await postsController.getSavedPosts(
        page: postsCurrentPage,
      );

      /// posts
      if (posts['data'].length > 0) {
        if (isAnyPost == false) {
          setState(() {
            isAnyPost = true;
          });
        }

        isPostsHasNextPage =
            posts['pagination']['meta']['page']['isNext'] == true;

        postsData = posts['data'].entries.map((entry) => entry.value).toList();
      }
    }

    return postsData;
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      isDefaultPadding: false,
      title: 'Saved Posts'.tr,
      child: Column(
        children: [
          /// Edges
          Container(
            decoration: BoxDecoration(
              color: isAnyPost ? Colors.white : Colors.grey.shade200,
              boxShadow: [
                BoxShadow(
                  blurRadius: 1,
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 0.5,
                )
              ],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            height: 12,
          ),
          Expanded(
            child: Container(
              color: Colors.grey.shade200,
              child: PaginationView(
                key: postsPaginationViewKey,
                scrollController: postsPaginationViewScrollController,
                itemBuilder: (BuildContext context, post, int index) =>
                    WPost(post: post,commentId: 0,),
                separatorBuilder: (BuildContext context, int index) => SizedBox(
                  width: 8,
                  height: 8,
                ),
                pageFetch: fetchPostsByOffset,
                pullToRefresh: true,
                onError: (dynamic error) => Center(
                  child: Text('No posts.'.tr),
                ),
                onEmpty: Center(
                  child: Text('No posts.'.tr),
                ),
                bottomLoader: Center(
                  /// optional
                  child: LoadingBouncingLine.circle(),
                ),
                initialLoader: Center(
                  /// optional
                  child: LoadingBouncingLine.circle(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
