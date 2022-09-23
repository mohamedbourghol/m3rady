import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:m3rady/core/controllers/advertisers/advertisers_controller.dart';
import 'package:m3rady/core/controllers/categories/categories_controller.dart';
import 'package:m3rady/core/controllers/filter/filter_controller.dart';
import 'package:m3rady/core/controllers/posts/comments/comments_controller.dart';
import 'package:m3rady/core/controllers/posts/posts_controller.dart';
import 'package:m3rady/core/controllers/search/search_controller.dart';
import 'package:m3rady/core/view/components/components.dart';
import 'package:m3rady/core/view/layouts/main/main_layout.dart';
import 'package:m3rady/core/view/components/shared/users/advertiser.dart';
import 'package:m3rady/core/view/components/shared/posts/post.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:pagination_view/pagination_view.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final CategoriesController categoriesController =
      Get.put(CategoriesController());

  final FilterController filterController = Get.put(FilterController(
    isFilterShowPosts: false,
  ));

  final PostsController postsController = Get.put(PostsController());

  final AdvertisersController advertisersController =
      Get.put(AdvertisersController());

  final CommentsController commentsController = Get.put(CommentsController());

  final SearchController searchController = Get.put(SearchController());

  final searchBarController = FloatingSearchBarController();

  /// Advertisers Pagination View
  ScrollController advertisersPaginationViewScrollController =
      ScrollController();

  GlobalKey<PaginationViewState> advertisersPaginationViewKey =
      GlobalKey<PaginationViewState>();

  int advertisersCurrentPage = 0;

  bool isAdvertisersHasNextPage = true;

  /// Posts Pagination View
  ScrollController postsPaginationViewScrollController = ScrollController();

  GlobalKey<PaginationViewState> postsPaginationViewKey =
      GlobalKey<PaginationViewState>();

  int postsCurrentPage = 1;

  bool isPostsHasNextPage = true;

  /// Fetch posts
  Future<List<dynamic>> fetchPostsByOffset(offset) async {
    List postsData = [];
    late Map posts;

    /// Get posts
    if ((isPostsHasNextPage || offset == 0) &&
        searchBarController.query != '') {
      postsCurrentPage = offset == 0 ? 1 : postsCurrentPage + 1;
      posts = await postsController.getPostsSearch(
        page: postsCurrentPage,
        keyword: searchBarController.query,
        //categoryId: categoriesController.selectedShownCategoryId.value,
        //countryCode: filterController.selectedCountryCode.value,
        //cityId: filterController.selectedCityId.value,
      );

      ///  posts
      if (posts['data'].length > 0) {
        isPostsHasNextPage =
            posts['pagination']['meta']['page']['isNext'] == true;

        postsData = posts['data'].entries.map((entry) => entry.value).toList();
      }
    }

    return postsData;
  }

  /// Fetch advertisers
  Future<List<dynamic>> fetchAdvertisersByOffset(offset) async {
    List advertisersData = [];
    late Map advertisers;

    /// Get advertisers
    if ((isAdvertisersHasNextPage || offset == 0) &&
        searchBarController.query != '') {
      advertisersCurrentPage = offset == 0 ? 1 : advertisersCurrentPage + 1;
      advertisers = await advertisersController.getAdvertisersSearch(
        page: advertisersCurrentPage,
        keyword: searchBarController.query,
        //categoryId: categoriesController.selectedShownCategoryId.value,
        //countryCode: filterController.selectedCountryCode.value,
        //cityId: filterController.selectedCityId.value,
      );

      ///  advertisers
      if (advertisers['data'].length > 0) {
        isAdvertisersHasNextPage =
            advertisers['pagination']['meta']['page']['isNext'] == true;

        advertisersData =
            advertisers['data'].entries.map((entry) => entry.value).toList();
      }
    }

    return advertisersData;
  }

  /// Refresh data
  void refreshData() {
    /// Refresh posts
    if (filterController.isFilterShowPosts.value == true) {
      try {
        postsPaginationViewKey.currentState!
            .refresh()
            .onError((error, stackTrace) {})
            .catchError((e) {});
      } catch (e) {}
    } else {
      /// Refresh  advertisers
      try {
        advertisersPaginationViewKey.currentState!
            .refresh()
            .onError((error, stackTrace) {})
            .catchError((e) {});
      } catch (e) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    /// Advertiser scroll listener
    advertisersPaginationViewScrollController.addListener(() {
      if (advertisersPaginationViewScrollController
              .position.userScrollDirection ==
          ScrollDirection.reverse) {
        filterController.isShowFilter.value = false;
      }
    });

    /// Posts scroll listener
    postsPaginationViewScrollController.addListener(() {
      if (postsPaginationViewScrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        filterController.isShowFilter.value = false;
      }
    });

    /// Get old search data
    Future<bool> ensureSearchData() async {
      await searchController.getAndSetStoredSearchKeywords();

      return true;
    }

    return MainLayout(
      title: 'The Search'.tr,
      isDefaultPadding: false,
      child: FutureBuilder<bool>(
          future: ensureSearchData(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 12,
                  ),
                  child: Column(
                    children: [
                      Obx(
                        () => Container(
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// List Type
                              Container(
                                color: Colors.white,
                                padding: const EdgeInsets.only(
                                  top: 8,
                                  bottom: 8,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                        start: 10,
                                      ),
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                          minWidth: 1,
                                          maxWidth: Get.width / 2.2,
                                          minHeight: 1,
                                          maxHeight: 34,
                                        ),
                                        child: CMaterialButton(
                                          disabled: !filterController
                                              .isFilterShowPosts.value,
                                          borderColor: Color(0xffFD8200),
                                          color: (!filterController
                                                  .isFilterShowPosts.value
                                              ? Color(0xffFD8200)
                                              : Colors.white),
                                          disabledColor: Color(0xffFD8200),
                                          child: Text(
                                            'Advertisers'.tr,
                                            style: TextStyle(
                                              color: (!filterController
                                                      .isFilterShowPosts.value
                                                  ? Colors.white
                                                  : Color(0xffFD8200)),
                                            ),
                                          ),
                                          onPressed: () {
                                            filterController.isFilterShowPosts
                                                .value = false;
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 12,
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                        end: 10,
                                      ),
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(
                                          minWidth: 1,
                                          maxWidth: Get.width / 2.2,
                                          minHeight: 1,
                                          maxHeight: 34,
                                        ),
                                        child: CMaterialButton(
                                          disabled: filterController
                                              .isFilterShowPosts.value,
                                          borderColor: Color(0xffFD8200),
                                          color: (filterController
                                                  .isFilterShowPosts.value
                                              ? Color(0xffFD8200)
                                              : Colors.white),
                                          disabledColor: Color(0xffFD8200),
                                          child: Text(
                                            'Posts'.tr,
                                            style: TextStyle(
                                              color: (filterController
                                                      .isFilterShowPosts.value
                                                  ? Colors.white
                                                  : Color(0xffFD8200)),
                                            ),
                                          ),
                                          onPressed: () {
                                            filterController
                                                .isFilterShowPosts.value = true;
                                          },
                                        ),
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
                      ),

                      SizedBox(
                        height: 60,
                      ),

                      CBr(),

                      /// Advertisers
                      Obx(
                        () => Visibility(
                          visible: !filterController.isFilterShowPosts.value,
                          child: Expanded(
                            child: Container(
                              color: Colors.grey.shade200,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: PaginationView(
                                      key: advertisersPaginationViewKey,
                                      scrollController:
                                          advertisersPaginationViewScrollController,
                                      itemBuilder: (BuildContext context,
                                              advertiser, int index) =>
                                          WAdvertiser(advertiser: advertiser),
                                      separatorBuilder:
                                          (BuildContext context, int index) =>
                                              SizedBox(width: 8, height: 8),
                                      pageFetch: fetchAdvertisersByOffset,
                                      pullToRefresh: true,
                                      onError: (dynamic error) => Center(
                                        child: Text('No advertisers.'.tr),
                                      ),
                                      onEmpty: Center(
                                        child: Text('No advertisers.'.tr),
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
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      /// Posts
                      Obx(
                        () => Visibility(
                          visible: filterController.isFilterShowPosts.value,
                          child: Expanded(
                            child: Container(
                              color: Colors.grey.shade200,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: PaginationView(
                                      key: postsPaginationViewKey,
                                      scrollController:
                                          postsPaginationViewScrollController,
                                      itemBuilder: (BuildContext context, post,
                                              int index) =>
                                          WPost(post: post,commentId: 0,),
                                      separatorBuilder:
                                          (BuildContext context, int index) =>
                                              SizedBox(
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
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                /// Search
                Padding(
                  padding: const EdgeInsets.only(top: 55),
                  child: FloatingSearchBar(
                    controller: searchBarController,
                    hint: 'Search keyword...'.tr,
                    scrollPadding: EdgeInsets.only(top: 16, bottom: 56),
                    transitionDuration: const Duration(milliseconds: 500),
                    transitionCurve: Curves.easeInOut,
                    physics: const BouncingScrollPhysics(),
                    axisAlignment:
                        Get.mediaQuery.orientation == Orientation.portrait
                            ? 0.0
                            : -1.0,
                    openAxisAlignment: 0.0,
                    width: Get.width,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    debounceDelay: const Duration(milliseconds: 100),
                    queryStyle: TextStyle(
                      fontFamily: 'Arial',
                    ),
                    hintStyle: TextStyle(
                      fontFamily: 'Arial',
                    ),
                    onSubmitted: (query) {
                      /// Trim
                      query = query.trim();

                      if (query.length == 0 || query.length >= 3) {
                        /// Add query
                        if (query.length >= 3) {
                          searchController.addSearchKeyword(query);
                        }

                        /// refresh data
                        refreshData();
                      } else if (query.length > 0 && query.length < 3) {
                        CErrorDialog(errors: [
                          "The search keyword must be 3 chars at least.".tr,
                        ]);
                      }

                      /// Close
                      searchBarController.close();

                      /// Update
                      setState(() {});
                    },
                    onQueryChanged: (query) {
                      /// Trim
                      query = query.trim();

                      if (query.length == 0 || query.length >= 3) {
                        /// Refresh data
                        refreshData();
                      }

                      /// Show hide history
                      if (query.length == 0) {
                        searchController.setShowHideHistory(true);
                      } else {
                        searchController.setShowHideHistory(false);
                      }

                      /// Update
                      setState(() {});
                    },
                    elevation: 3,
                    backdropColor: Colors.transparent,
                    transition: CircularFloatingSearchBarTransition(),
                    automaticallyImplyBackButton: false,
                    clearQueryOnClose: false,
                    margins: EdgeInsets.only(
                      top: 12,
                      bottom: 0,
                      left: 12,
                      right: 12,
                    ),
                    builder: (context, transition) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Material(
                          color: Colors.white,
                          elevation: 2.0,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: searchController.isShowHistory == false
                                ? []
                                : searchController.searchKeywordsSet
                                    .map((keyword) => Dismissible(
                                          key: UniqueKey(),
                                          direction:
                                              DismissDirection.startToEnd,
                                          onDismissed: (direction) async {
                                            /// Vibrate
                                           // HapticFeedback.lightImpact();

                                            await searchController
                                                .deleteSearchKeyword(keyword);

                                            /// Update
                                            setState(() {});
                                          },
                                          background: Container(
                                            padding: const EdgeInsets.all(12),
                                            color: Colors.red,
                                            child: Align(
                                              alignment: AlignmentDirectional
                                                  .centerStart,
                                              child: Text(
                                                'Delete'.tr,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                          child: ListTile(
                                            title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(keyword),
                                                IconButton(
                                                  onPressed: () async {
                                                    await searchController
                                                        .deleteSearchKeyword(
                                                            keyword);

                                                    /// Update
                                                    setState(() {});
                                                  },
                                                  icon: Icon(
                                                    Icons.close,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            minLeadingWidth: 0,
                                            onTap: () {
                                              searchBarController.query =
                                                  keyword;
                                              searchBarController.close();

                                              /// Refresh data
                                              refreshData();
                                            },
                                          ),
                                        ))
                                    .toList(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }),
    );
  }

  @override
  void dispose() {
    /// Delete controllers
    Get.delete<SearchController>();
    searchBarController.dispose();

    super.dispose();
  }
}
