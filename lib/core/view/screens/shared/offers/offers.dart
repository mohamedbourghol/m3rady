import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:m3rady/core/controllers/categories/categories_controller.dart';
import 'package:m3rady/core/controllers/filter/filter_controller.dart';
import 'package:m3rady/core/controllers/offers/offers_controller.dart';
import 'package:m3rady/core/models/users/user.dart';
import 'package:m3rady/core/utils/storage/local/variables.dart';
import 'package:m3rady/core/view/components/components.dart';
import 'package:m3rady/core/view/components/shared/categories/categories.dart';
import 'package:m3rady/core/view/components/shared/offers/offer.dart';
import 'package:m3rady/core/view/layouts/main/main_layout.dart';
import 'package:pagination_view/pagination_view.dart';

class OffersScreen extends StatefulWidget {
  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  final FilterController filterController = Get.put(FilterController());

  final CategoriesController categoriesController =
      Get.put(CategoriesController());

  final OffersController offersController = Get.put(OffersController());

  final ScrollController offersPaginationViewScrollController =
      ScrollController();

  final GlobalKey<PaginationViewState> offersPaginationViewKey =
      GlobalKey<PaginationViewState>();

  int offersCurrentPage = 0;
  bool isOffersHasNextPage = true;
  var isShowMyOffersOnly =
      (Get.arguments != null && Get.arguments['isShowMyOffersOnly']
              ? Get.arguments['isShowMyOffersOnly'] == true
              : false)
          .obs;
  var isShowTopBar = true.obs;

  Future<List<dynamic>> fetchOffersByOffset(offset) async {
    List offersData = [];
    late Map offers;

    /// Get offers
    if (isOffersHasNextPage || offset == 0) {
      offersCurrentPage = offset == 0 ? 1 : offersCurrentPage + 1;

      offers = await offersController.getOffers(
        page: offersCurrentPage,
        categoryId: categoriesController.selectedShownCategoryId.value,
        countryCode: filterController.selectedCountryCode.value,
        cityId: filterController.selectedCityId.value,
        isShowMyOffersOnly: isShowMyOffersOnly.value,
      );

      ///  offers
      if (offers['data'].length > 0) {
        isOffersHasNextPage =
            offers['pagination']['meta']['page']['isNext'] == true;

        offersData =
            offers['data'].entries.map((entry) => entry.value).toList();
      }
    }

    return offersData;
  }

  @override
  void initState() {
    super.initState();

    /// Offer scroll listener
    offersPaginationViewScrollController.addListener(() {
      if (offersPaginationViewScrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        isShowTopBar.value = false;
      } else {
        ///isShowTopBar.value = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'The Offers'.tr,
      isDefaultPadding: false,
      floatingActionButton:
          (GlobalVariables.isUserAuthenticated.value == true &&
                  GlobalVariables.user.type == 'advertiser' &&
                  GlobalVariables.user.isAllowAddOffer == true &&
                  GlobalVariables.user.accountStatus.toString() !=
                      UserStatus.inactive.toString() &&
                  GlobalVariables.user.isProfileCompleted == true
              ? FloatingActionButton(
                  heroTag: "offers.create",
                  onPressed: () {
                    Get.toNamed('/offers/create');
                  },
                  child: const Icon(Icons.add),
                  backgroundColor: Colors.orange,
                )
              : null),
      child: Column(
        children: [
          /// Edges
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
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

          /// Filter
          Obx(
            () => Visibility(
              visible: isShowTopBar.value == false,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: InkWell(
                  onTap: () {
                    isShowTopBar.value =
                        !isShowTopBar.value;
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
                          (isShowTopBar.value == true
                              ? 'Hide Categories'.tr
                              : 'Show Categories'.tr),
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color:
                                (isShowTopBar.value == true
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
                            (isShowTopBar.value == true
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
            ),
          ),

          Obx(
            () => Visibility(
              visible: isShowTopBar.value == true,
              child: Column(
                children: [
                  /// Categories
                  Container(
                    padding: const EdgeInsets.only(
                      bottom: 8,
                    ),
                    child: WCategories(onChange: () {
                      /// Refresh offers
                      try {
                        offersPaginationViewKey.currentState!
                            .refresh()
                            .onError((error, stackTrace) {})
                            .catchError((e) {});
                      } catch (e) {}
                    }),
                  ),
                  CBr(),
                  SizedBox(
                    height: 6,
                  ),

                  /// Countries and cites
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.only(
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
                            value: filterController.selectedCountryCode.value,
                            disabledHint: Text(
                              'Country'.tr,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            labelText: 'Country'.tr,
                            /*prefixIcon: Padding(
                                      padding: const EdgeInsets.all(11),
                                      child: FaIcon(FontAwesomeIcons.globe),
                                    ),*/
                            contentPadding: const EdgeInsetsDirectional.only(
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
                                    (entries) => DropdownMenuItem<String>(
                                      value: entries.value.code.toString(),
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
                                            entries.value.name.toString(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList()
                            ],
                            onChanged: (country) {
                              filterController.changeSelectedCountry(country);

                              /// Refresh offers
                              try {
                                offersPaginationViewKey.currentState!
                                    .refresh()
                                    .onError((error, stackTrace) {})
                                    .catchError((e) {});
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
                            contentPadding: const EdgeInsetsDirectional.only(
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
                                  .map((entries) => DropdownMenuItem<String>(
                                        value: entries.value.id.toString(),
                                        child:
                                            Text(entries.value.name.toString()),
                                      ))
                                  .toList()
                            ],
                            onChanged: (cityId) {
                              filterController.changeSelectedCity(cityId);

                              /// Refresh offers
                              try {
                                offersPaginationViewKey.currentState!
                                    .refresh()
                                    .onError((error, stackTrace) {})
                                    .catchError((e) {});
                              } catch (e) {}
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 6,
                  ),

                  CBr(),

                  Visibility(
                    visible:
                        GlobalVariables.isUserAuthenticated.value == true &&
                            GlobalVariables.user.type == 'advertiser',
                    child: Column(
                      children: [
                        /// List Type
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 8,
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
                                    minHeight: 34,
                                    maxHeight: 34,
                                  ),
                                  child: CMaterialButton(
                                    disabled: !isShowMyOffersOnly.value,
                                    borderColor: Color(0xffFD8200),
                                    color: (!isShowMyOffersOnly.value
                                        ? Color(0xffFD8200)
                                        : Colors.white),
                                    disabledColor: Color(0xffFD8200),
                                    child: Text(
                                      'All Offers'.tr,
                                      style: TextStyle(
                                        color: (!isShowMyOffersOnly.value
                                            ? Colors.white
                                            : Color(0xffFD8200)),
                                      ),
                                    ),
                                    onPressed: () {
                                      isShowMyOffersOnly.value = false;

                                      /// Refresh data
                                      try {
                                        offersPaginationViewKey.currentState!
                                            .refresh()
                                            .onError((error, stackTrace) {})
                                            .catchError((e) {});
                                      } catch (e) {}
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
                                    minHeight: 34,
                                    maxHeight: 34,
                                  ),
                                  child: CMaterialButton(
                                    disabled: isShowMyOffersOnly.value,
                                    borderColor: Color(0xffFD8200),
                                    color: (isShowMyOffersOnly.value
                                        ? Color(0xffFD8200)
                                        : Colors.white),
                                    disabledColor: Color(0xffFD8200),
                                    child: Text(
                                      'My Offers'.tr,
                                      style: TextStyle(
                                        color: (isShowMyOffersOnly.value
                                            ? Colors.white
                                            : Color(0xffFD8200)),
                                      ),
                                    ),
                                    onPressed: () {
                                      isShowMyOffersOnly.value = true;

                                      /// Refresh data
                                      try {
                                        offersPaginationViewKey.currentState!
                                            .refresh()
                                            .onError((error, stackTrace) {})
                                            .catchError((e) {});
                                      } catch (e) {}
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

                  CBr(),
                ],
              ),
            ),
          ),

          /// Offers
          Expanded(
            child: Container(
              color: Colors.grey.shade300,
              child: PaginationView(
                key: offersPaginationViewKey,
                scrollController: offersPaginationViewScrollController,
                itemBuilder: (BuildContext context, offer, int index) =>
                    WOffer(offer: offer),
                separatorBuilder: (BuildContext context, int index) => SizedBox(
                  width: 8,
                  height: 8,
                ),
                pageFetch: fetchOffersByOffset,
                pullToRefresh: true,
                onError: (dynamic error) => Center(
                  child: Text('No offers.'.tr),
                ),
                onEmpty: Center(
                  child: Text('No offers.'.tr),
                ),
                bottomLoader: Center(
                  child: LoadingBouncingLine.circle(),
                ),
                initialLoader: Center(
                  child: LoadingBouncingLine.circle(),
                ),
              ),
            ),
          ),

          SizedBox(
            height: 24,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    /// Delete controllers
    Get.delete<CategoriesController>();
    Get.delete<FilterController>();
    Get.delete<OffersController>();
  }
}
