import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:m3rady/core/controllers/advertisers/advertisers_controller.dart';
import 'package:m3rady/core/controllers/categories/categories_controller.dart';
import 'package:m3rady/core/controllers/filter/filter_controller.dart';
import 'package:m3rady/core/helpers/assets_helper.dart';
import 'package:m3rady/core/utils/storage/local/variables.dart';
import 'package:m3rady/core/view/components/components.dart';
import 'package:m3rady/core/view/components/shared/categories/categories.dart';
import 'package:m3rady/core/view/components/shared/users/advertiser.dart';
import 'package:pagination_view/pagination_view.dart';


class ElitesAdvertisersScreen extends StatefulWidget {
  @override
  _ElitesAdvertisersScreenState createState() =>
      _ElitesAdvertisersScreenState();
}

class _ElitesAdvertisersScreenState extends State<ElitesAdvertisersScreen> with AutomaticKeepAliveClientMixin{
  final FilterController filterController
  =  Get.put(FilterController());

  final CategoriesController categoriesController
  =  Get.put(CategoriesController());


  final AdvertisersController advertisersController =
  Get.put(AdvertisersController());


  ScrollController advertisersPaginationViewScrollController =
      ScrollController();

  GlobalKey<PaginationViewState> advertisersPaginationViewKey =
      GlobalKey<PaginationViewState>();

  int advertisersCurrentPage = 0;

  bool isAdvertisersHasNextPage = true;

  Future<List<dynamic>> fetchAdvertisersByOffset(offset) async {
    List advertisersData = [];
    late Map advertisers;

    /// Get posts
    if (isAdvertisersHasNextPage || offset == 0) {
      advertisersCurrentPage = offset == 0 ? 1 : advertisersCurrentPage + 1;

      advertisers = await advertisersController.getEliteAdvertisers(
        page: advertisersCurrentPage,
        categoryId: categoriesController.selectedShownCategoryId.value,
        countryCode: filterController.selectedCountryCode.value,
        cityId: filterController.selectedCityId.value,
      );

      ///  posts
      if (advertisers['data'].length > 0) {
        isAdvertisersHasNextPage =
            advertisers['pagination']['meta']['page']['isNext'] == true;

        advertisersData =
            advertisers['data'].entries.map((entry) => entry.value).toList();
      }
    }

    return advertisersData;
  }

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Container(
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
        child: Column(
          children: [
            Visibility(
              visible: ((GlobalVariables.isUserAuthenticated.value == true &&
                  GlobalVariables.user.isHasPackage == true) ||
                  (GlobalVariables.isUserAuthenticated.value == true &&
                      GlobalVariables.user.type == 'customer') ||
                  GlobalVariables.isUserAuthenticated.value == false),
              child: SizedBox(
                height: 12,
              ),
            ),

            /// Subscribe
            Visibility(
              visible: (GlobalVariables.isUserAuthenticated.value == true &&
                  GlobalVariables.user.type == 'advertiser' &&
                  GlobalVariables.user.isHasPackage == false),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image(
                              image: assets['diamondOutline'],
                            ),
                            SizedBox(
                              width: 12,
                            ),
                            Text(
                              'Subscribe to elite packages'.tr,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            Get.toNamed('/elites/packages');
                          },
                          child: Text(
                            'Subscribe'.tr,
                          ),
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: Color(0xFFFFAC00),
                            padding: const EdgeInsetsDirectional.only(
                              start: 12,
                              end: 12,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),

                  /// Break
                  Container(
                    color: Colors.grey.shade200,
                    height: 6,
                  ),
                ],
              ),
            ),

            Obx(
                  () => Visibility(
                //visible: filterController.isShowFilter.value == true,
                child: Column(
                  children: [
                    /// Categories
                    Container(
                      padding: const EdgeInsets.only(
                        bottom: 8,
                      ),
                      child: WCategories(onChange: () {
                        /// Refresh advertisers
                        try {
                          advertisersPaginationViewKey.currentState!
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

                                /// Refresh advertisers
                                try {
                                  advertisersPaginationViewKey.currentState!
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
                                  child: Text(
                                      entries.value.name.toString()),
                                ))
                                    .toList()
                              ],
                              onChanged: (cityId) {
                                filterController.changeSelectedCity(cityId);

                                /// Refresh advertisers
                                try {
                                  advertisersPaginationViewKey.currentState!
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
                  ],
                ),
              ),
            ),

            /// Advertisers
            Expanded(
              child: Container(
                color: Colors.grey.shade300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: PaginationView(
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
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();

    /// Delete controllers
    Get.delete<CategoriesController>();
    Get.delete<FilterController>();
    Get.delete<AdvertisersController>();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
