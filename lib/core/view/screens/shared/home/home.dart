import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:m3rady/core/controllers/advertisers/advertisers_controller.dart';
import 'package:m3rady/core/controllers/categories/categories_controller.dart';
import 'package:m3rady/core/controllers/filter/filter_controller.dart';
import 'package:m3rady/core/controllers/posts/comments/comments_controller.dart';
import 'package:m3rady/core/controllers/posts/posts_controller.dart';
import 'package:m3rady/core/models/users/user.dart';
import 'package:m3rady/core/utils/storage/local/variables.dart';
import 'package:m3rady/core/view/components/components.dart';
import 'package:m3rady/core/view/components/shared/categories/categories.dart';
import 'package:m3rady/core/view/components/shared/posts/post.dart';
import 'package:m3rady/core/view/components/shared/users/advertiser.dart';
import 'package:m3rady/core/view/components/shared/users/elite_companies.dart';
import 'package:pagination_view/pagination_view.dart';



class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin{
  final  CategoriesController categoriesController =
  Get.put(CategoriesController());

  final FilterController filterController =
  Get.put(FilterController());

  final PostsController postsController =
  Get.put(PostsController());



  final AdvertisersController advertisersController =
  Get.put(AdvertisersController());

  /// Advertisers Pagination View
  final ScrollController advertisersPaginationViewScrollController =
  ScrollController();

  final GlobalKey<PaginationViewState> advertisersPaginationViewKey =
  GlobalKey<PaginationViewState>();

  int advertisersCurrentPage = 0;

  bool isAdvertisersHasNextPage = true;

  /// Posts Pagination View
   late ScrollController postsPaginationViewScrollController ;

  final GlobalKey<PaginationViewState> postsPaginationViewKey =
  GlobalKey<PaginationViewState>();
  final commentId = Get.arguments?['commentId'];
  int postsCurrentPage = 1;

  bool isPostsHasNextPage = true;
  List? postsData = [];
  List? adsData = [];
  var isLoading=false.obs;
  PageController pageController2 =PageController();
  /// Fetch posts
  Future fetchPostsByOffset(offset) async {

    print('here');
    if(offset==0)
      {
        isLoading.value=true;
        postsData=[];
        adsData=[];
        postsCurrentPage = 1;
        isPostsHasNextPage=true;
      }
    else if(isPostsHasNextPage){
      isLoading.value=true;

    }

    //late Map ads;

    late Map posts;

    /// Get posts
    if ((filterController.isFilterShowPosts.value == true) &&
        (isPostsHasNextPage || offset == 0)) {
      if(!isLoading.value)
        {
          isLoading.value=false;

        }
      postsCurrentPage = offset == 0 ? 1 : postsCurrentPage + 1;
      posts = await postsController.getPosts(
        page: postsCurrentPage,
        categoryId: categoriesController.selectedShownCategoryId.value,
        countryCode: filterController.selectedCountryCode.value,
        cityId: filterController.selectedCityId.value,
      );

      /// posts
      if (posts['data'].length > 0) {
        isPostsHasNextPage =
            posts['pagination']['meta']['page']['isNext'] == true;
        postsData =postsData!+ posts['data'].entries.map((entry) => entry.value).toList();
      }
   /*

      ads = await postsController.getPostsAds(
        limit: 10,
        page: 1,
        categoryId: categoriesController.selectedShownCategoryId.value,
        countryCode: filterController.selectedCountryCode.value,
        cityId: filterController.selectedCityId.value,
      );

      adsData = ads['data'].entries.map((entry) => entry.value).toList();
      print('===');
      print(adsData.length);
      print('===');
      postsData=postsData+adsData;
      */
    }

      isLoading.value=false;


  }

  /// Fetch advertisers
  Future<List<dynamic>> fetchAdvertisersByOffset(offset) async {
    List advertisersData = [];
    late Map advertisers;

    /// Get advertisers
    if ((filterController.isFilterShowPosts.value == false) &&
        (isAdvertisersHasNextPage || offset == 0)) {
      advertisersCurrentPage = offset == 0 ? 1 : advertisersCurrentPage + 1;

      advertisers = await advertisersController.getAdvertisers(
        page: advertisersCurrentPage,
        categoryId: categoriesController.selectedShownCategoryId.value,
        countryCode: filterController.selectedCountryCode.value,
        cityId: filterController.selectedCityId.value,
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



  /// Show dialogs
  void showDialogs() {
    /// Complete account
    // if (GlobalVariables.isUserAuthenticated.value == true &&
    //     GlobalVariables.user.type == 'advertiser' &&
    //     GlobalVariables.user.isProfileCompleted == false) {
    //   CConfirmDialog(
    //     title: 'Complete Profile'.tr,
    //     content:
    //     'Before using the application and publish offers and posts, you must complete the rest of the account information. Go to settings to complete your profile.'
    //         .tr,
    //     confirmText: 'Complete Profile'.tr,
    //     confirmTextColor: Colors.green,
    //     confirmCallback: () {
    //       Get.back();
    //       Get.toNamed('/account');
    //     },
    //     autoClose: false,
    //   );
    // }

    /// Account disabled
    if (GlobalVariables.isUserAuthenticated.value == true &&
        GlobalVariables.user.accountStatus.toString() ==
            UserStatus.inactive.toString()) {
      CErrorDialog(errors: [
        'Your account is inactive you must activate your account to use the application and publish offers and posts.'
            .tr,
      ]);
    }

   else{
      advertisersController.fetchModals(context);
    }
  }



  @override
  void initState() {
    postsPaginationViewScrollController =
        ScrollController(

        );
    fetchPostsByOffset(0);
    super.initState();
    advertisersPaginationViewScrollController.addListener(() {
      if (advertisersPaginationViewScrollController
          .position.userScrollDirection ==
          ScrollDirection.reverse) {
        GlobalVariables.isHomeFilterIsShown.value = false;
      }
    });

    /// Posts scroll listener
    postsPaginationViewScrollController.addListener(() {
      if (postsPaginationViewScrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        GlobalVariables.isHomeFilterIsShown.value = false;
      }
      if(postsPaginationViewScrollController.position.pixels ==
          postsPaginationViewScrollController.position.maxScrollExtent)
        {
          fetchPostsByOffset(1);
        }
    });

    /// After loading
    WidgetsBinding.instance?.addPostFrameCallback(
          (_) {
        /// Show dialogs
        showDialogs();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Column(
        children: [
          WEliteCompanies(),
          Obx(
                () => Container(
              color: Get.theme.backgroundColor,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Filter control
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: InkWell(
                      onTap: () {
                        GlobalVariables.isHomeFilterIsShown.value =
                        !GlobalVariables.isHomeFilterIsShown.value;
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.only(
                              start: 6,
                            ),
                            child: Text(
                              (GlobalVariables.isHomeFilterIsShown.value == true
                                  ? 'Hide Categories'.tr
                                  : 'Show Categories'.tr),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: (GlobalVariables
                                    .isHomeFilterIsShown.value ==
                                    true
                                    ? Colors.black54
                                    : Colors.black87),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.only(
                              start: 6,
                              end: 6,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.orangeAccent,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                (GlobalVariables.isHomeFilterIsShown.value ==
                                    true
                                    ? Icons.expand_less
                                    : Icons.expand_more),
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Visibility(
                    visible: GlobalVariables.isHomeFilterIsShown.value == true,
                    child: Container(
                      color: Colors.grey.withOpacity(0.1),
                      child: Column(
                        children: [
                          CBr(),

                          /// Categories
                          Container(
                            color: Colors.white,
                            padding: const EdgeInsets.only(
                              top: 8,
                              bottom: 8,
                            ),
                            child: WCategories(
                              onChange: () {
                                try {
                                  if (filterController
                                      .isFilterShowPosts.value ==
                                      true) {
                                    /// Refresh posts
                                    /// Refresh posts
                                    fetchPostsByOffset(0);


                                  } else {
                                    /// Refresh  advertisers
                                    pageController2.jumpToPage(1);

                                  }
                                } catch (e) {}
                              },
                            ),
                          ),
                          SizedBox(
                            height: 6,
                          ),

                          /// Countries and cites
                          Container(
                            color: Colors.white,
                            padding: const EdgeInsets.only(
                              top: 6,
                              bottom: 6,
                              left: 12,
                              right: 12,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                /// Country
                                Container(
                                  width: Get.width / 2.2,
                                  child: CSelectFormField(
                                    value: filterController
                                        .selectedCountryCode.value,
                                    disabledHint: Text(
                                      'Country'.tr,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    labelText: 'Country'.tr,
                                    contentPadding:
                                    const EdgeInsetsDirectional.only(
                                      start: 12,
                                      end: 6,
                                      top: 0,
                                      bottom: 0,
                                    ),
                                    items: [
                                      DropdownMenuItem<String>(
                                        value: '',
                                        child: Text(
                                          'All Countries'.tr,
                                        ),
                                      ),
                                      ...filterController.countries.entries
                                          .map(
                                            (entries) =>
                                            DropdownMenuItem<String>(
                                              value:
                                              entries.value.code.toString(),
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                    'packages/intl_phone_number_input/assets/flags/${entries.value.code.toString().toLowerCase()}.png',
                                                    height: 12,
                                                    width: 24,
                                                  ),
                                                  SizedBox(
                                                    width: 6,
                                                  ),
                                                  Text(
                                                    entries.value.name
                                                        .toString(),
                                                  ),
                                                ],
                                              ),
                                            ),
                                      )
                                          .toList()
                                    ],
                                    onChanged: (country) {
                                      filterController
                                          .changeSelectedCountry(country);

                                      try {
                                        if (filterController
                                            .isFilterShowPosts.value ==
                                            true) {

                                          fetchPostsByOffset(0);


                                        } else {
                                          /// Refresh  advertisers
                                          pageController2.jumpToPage(1);

                                        }
                                      } catch (e) {}
                                    },
                                  ),
                                ),

                                /// City
                                Container(
                                  width: Get.width / 2.2,
                                  child: CSelectFormField(
                                    value: filterController.selectedCityId.value
                                        .toString(),
                                    disabledHint: Text(
                                      'City'.tr,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    labelText: 'City'.tr,
                                    /*prefixIcon: Padding(
                                      padding: const EdgeInsets.all(11),
                                      child: FaIcon(FontAwesomeIcons.city),
                                    ),*/
                                    contentPadding:
                                    const EdgeInsetsDirectional.only(
                                      start: 12,
                                      end: 6,
                                      top: 0,
                                      bottom: 0,
                                    ),
                                    items: [
                                      DropdownMenuItem<String>(
                                        value: '',
                                        child: Text(
                                          'All Cities'.tr,
                                        ),
                                      ),
                                      ...filterController.cities.entries
                                          .map((entries) =>
                                          DropdownMenuItem<String>(
                                            value:
                                            entries.value.id.toString(),
                                            child: Text(entries.value.name
                                                .toString()),
                                          ))
                                          .toList()
                                    ],
                                    onChanged: (cityId) {
                                      filterController
                                          .changeSelectedCity(cityId);
                                      /// Refresh posts
                                      try {
                                        if (filterController
                                            .isFilterShowPosts.value ==
                                            true) {
                                          /// Refresh posts
                                          /// Refresh posts
                                          fetchPostsByOffset(0);

                                        } else {
                                          /// Refresh  advertisers
                                          pageController2.jumpToPage(1);

                                        }
                                      } catch (e) {}


                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(
                            height: 4,
                          ),

                          CBr(),

                          /// List Type
                          Container(
                            color: Colors.white,
                            padding: const EdgeInsets.only(
                              top: 6,
                              bottom: 6,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                        filterController
                                            .isFilterShowPosts.value = false;
                                        if (pageController2.hasClients)
                                        pageController2.jumpToPage(1);
                                      },
                                    ),
                                  ),
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
                                        fetchPostsByOffset(0);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          CBr(),

          /// Advertisers
          Obx(
                () => Visibility(
              visible: !filterController.isFilterShowPosts.value,
              child: Expanded(
                child: Container(
                  color: Colors.grey.shade200,
                  child: PageView(
                    controller: pageController2,
                    children: [
                      PaginationView(
                        key: advertisersPaginationViewKey,
                        scrollController:
                        advertisersPaginationViewScrollController,
                        itemBuilder:
                            (BuildContext context, advertiser, int index) =>
                            WAdvertiser(advertiser: advertiser),
                        separatorBuilder: (BuildContext context, int index) =>
                            SizedBox(
                              width: 8,
                              height: 8,
                            ),
                        pageFetch: fetchAdvertisersByOffset,
                        pullToRefresh: true,
                        onError: (dynamic error) => Center(
                          child: Text('No advertisers.'.tr),
                        ),
                        onEmpty: Center(
                          child: Text('No advertisers.'.tr),
                        ),
                        bottomLoader: Center(
                          child: LoadingBouncingLine.circle(),
                        ),
                        initialLoader: Center(
                          child: LoadingBouncingLine.circle(),
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
                child:postsData!.length==0&&isLoading.value==false?
                Center(child: Text('No posts.'.tr)):
                Container(
                  color: Colors.grey.shade300,
                  child:isLoading.value&&postsData!.length==0?
                  Center(
                    child: LoadingBouncingLine.circle(),
                  ):
                  Column(
                    children: [
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: ()async{
                            await fetchPostsByOffset(0);
                          },
                          child: ListView.separated(
                            controller: postsPaginationViewScrollController,

                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) {

                                 return  WPost(post: postsData![index],commentId:   0 ,);
                          },
                              separatorBuilder: (context, index) =>  const SizedBox(
                                width: 8,
                                height: 8,
                              ),
                              itemCount:postsData!=null? postsData!.length:0),
                        ),
                      ),
                      if(isLoading.value)
                      SizedBox(
                        height: 30,
                        child: Center(
                          child: LoadingBouncingLine.circle(),
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
      floatingActionButton:
      (    GlobalVariables.user!=null&&
          GlobalVariables.user.type == 'advertiser' &&
          GlobalVariables.user.accountStatus.toString() !=
              UserStatus.inactive.toString()
          ? FloatingActionButton(
        heroTag: "posts.create",
        onPressed: () {
          Get.toNamed('/posts/create');
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.orange,
      )
          : null),
    );



  }

  @override
  void dispose() {
    /// Delete controllers
    Get.delete<CategoriesController>();
    Get.delete<FilterController>();
    /// Get.delete<PostsController>();
   /// Get.delete<AdvertisersController>();
    Get.delete<CommentsController>();

    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
