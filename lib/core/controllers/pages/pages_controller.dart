import 'package:get/get.dart';
import 'package:m3rady/core/models/pages/page.dart';

class PagesController extends GetxController {
  String? slug;

  PagesController({
    this.slug,
  });

  /// Set page
  late Page page;

  /// Set is loading
  bool isLoadingPage = true;

  @override
  void onReady() async {
    super.onReady();

    /// Get and set page
    if (slug != null) {
      await getPageBySlug(slug!);
    }
  }

  /// Get page by slug
  getPageBySlug(String slug) async {
    /// Get page
    page = await Page.getPageBySlug(slug);

    /// Stop loader
    isLoadingPage = false;

    update();

    return page;
  }
}
