import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:m3rady/core/controllers/pages/pages_controller.dart';
import 'package:m3rady/core/utils/config/config.dart';
import 'package:m3rady/core/view/layouts/main/main_layout.dart';
import 'package:url_launcher/url_launcher.dart';

class PageScreen extends StatelessWidget {
  const PageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// Set slug
    String slug = config['pagesSlugs'][Get.arguments['page']];

    return MainLayout(
      title: Get.arguments['page'].toString().tr,
      child: GetBuilder<PagesController>(
        init: PagesController(
          slug: slug,
        ),
        builder: (controller) => SafeArea(
          child: Container(
            padding: const EdgeInsets.all(12),
            child: (controller.isLoadingPage
                ? Center(
                    child: LoadingBouncingLine.circle(),
                  )
                : SingleChildScrollView(
                    child: Html(
                        data: controller.page.content,
                        onLinkTap: (String? url, RenderContext context,
                            Map<String, String> attributes, element) async {
                          if (url != null && await canLaunch(url)) {
                            await launch(url);
                          }
                        }),
                  )),
          ),
        ),
      ),
    );
  }
}
