import 'dart:collection';
import 'package:get/get.dart';
import 'package:m3rady/core/utils/storage/local/storage.dart';

class SearchController extends GetxController {
  LinkedHashSet searchKeywordsSet = new LinkedHashSet();
  bool isShowHistory = true;

  @override
  void onReady() async {
    super.onReady();

    /// Get and set stored search keywords
    await getAndSetStoredSearchKeywords();
  }

  /// Set show hide history
  void setShowHideHistory(isShown) {
    isShowHistory = isShown;
  }

  /// Get and set stored search keywords
  Future getAndSetStoredSearchKeywords() async {
    /// Get data from storage
    List searchKeywordsSetStorage =
        await LocalStorage.get('searchKeywordsSet') ?? [];

    /// Add data to the set
    searchKeywordsSet.addAll(searchKeywordsSetStorage);

    return searchKeywordsSet;
  }

  /// Add search keyword
  Future addSearchKeyword(String keyword) async {
    if (keyword.trim().length >= 3) {
      if (searchKeywordsSet.length >= 6 &&
          !searchKeywordsSet.contains(keyword)) {
        searchKeywordsSet.remove(searchKeywordsSet.last);
      }

      List oldKeywords = [keyword.trim(), ...searchKeywordsSet.toList()];
      searchKeywordsSet.clear();
      searchKeywordsSet.addAll(oldKeywords);

      /// Update storage
      await LocalStorage.set('searchKeywordsSet', searchKeywordsSet.toList());
    }
  }

  /// Delete search keyword
  Future deleteSearchKeyword(String keyword) async {
    searchKeywordsSet.remove(keyword);

    /// Update storage
    await LocalStorage.set('searchKeywordsSet', searchKeywordsSet.toList());
  }
}
