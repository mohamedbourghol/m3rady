import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m3rady/core/models/categories/category.dart';

class CategoriesController extends GetxController {
  var categories = {}.obs;
  var shownCategories = {}.obs;
  var selectedShownCategoryId = ''.obs;
  var isShownSubCategories = false.obs;
  var isLoadingCategories = true.obs;

  ScrollController scrollController = new ScrollController(
    initialScrollOffset: 0.0,
    keepScrollOffset: true,
  );

  @override
  void onReady() async {
    super.onReady();

    /// Get categories
    await getCategories();
  }

  /// Get all categories
  Future getCategories() async {
    /// Start loader
    isLoadingCategories.value = true;

    /// Reset values
    categories.value = {};
    shownCategories.value = {};
    selectedShownCategoryId.value = '';

    /// Get categories
    categories.value = await Category.getCategories();

    /// Set shown categories
    shownCategories.value = categories;

    /// Stop loader
    isLoadingCategories.value = false;

    return categories;
  }

  /// Back to main categories
  void backToMainCategories() {
    /// Unselect all categories
    unSelectCategories();

    /// Reset shown categories
    shownCategories.value = categories;

    /// Set selected category
    selectedShownCategoryId.value = '';

    /// Hide sub categories
    isShownSubCategories.value = false;
  }

  /// Unselect all categories
  void unSelectCategories() {
    shownCategories.forEach((id, category) {
      /// Change category value
      category.isSelected = false;

      /// Update category
      shownCategories[id] = category;
    });
  }

  /// Set current category
  void setCurrentCategory(id) {
    /// Prepair id
    id = id.toString();

    /// Get category
    var category = shownCategories[id];

    /// Unselect all categories
    unSelectCategories();

    /// If category has sub
    if (category.subCategories != null && category.subCategories.length > 0) {
      shownCategories.value = category.subCategories;

      /// Scroll to 0
      try {
        scrollController
            .animateTo(
              0,
              duration: Duration(microseconds: 100),
              curve: Curves.ease,
            )
            .onError((error, stackTrace) {})
            .catchError((e) {});
      } catch (e) {}
    } else {
      /// Change category value
      category.isSelected = true;

      /// Update category
      shownCategories[id] = category;
    }

    /// Set selected category
    selectedShownCategoryId.value = id;

    /// If sub category is selected
    if (category.subCategories != null && category.subCategories!.length == 0) {
      /// Change category value
      category.isSelected = true;

      /// Update category
      shownCategories[id] = category;
    }

    /// Set is sub categories
    isShownSubCategories.value = true;
  }
}
