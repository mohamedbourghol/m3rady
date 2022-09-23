import 'package:flutter/material.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:m3rady/core/view/widgets/builders/categories/categories_builde.dart';
import 'package:m3rady/core/controllers/categories/categories_controller.dart';
import 'package:get/get.dart';

class WCategories extends StatelessWidget {
  var onChange;

  WCategories({
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return GetX(
      init: CategoriesController(),
      builder: (CategoriesController controller) => Container(
        color: Colors.white,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: controller.isShownSubCategories.value,
              child: Padding(
                padding: const EdgeInsetsDirectional.only(
                  end: 6,
                ),
                child: InkWell(
                  onTap: () {
                    controller.backToMainCategories();
                    onChange();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey,
                          child: Icon(
                            Icons.category,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          'All Categories'.tr,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            (controller.shownCategories.length > 0
                ? Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      controller: controller.scrollController,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: controller.shownCategories.entries
                            .map<Widget>((entries) {
                          var category = entries.value;

                          String imageUrl = category.imageUrl;
                          String name = category.name;
                          bool isSelected = (category.isSelected != null
                              ? category.isSelected
                              : false);

                          return GestureDetector(
                            onTap: () {
                              controller.setCurrentCategory(entries.key);

                              /// No sub categories
                              if (category?.subCategories?.length == 0) {
                                onChange();
                              }
                            },
                            child: BCategories(
                              imageUrl: imageUrl,
                              name: name,
                              isSelected: isSelected,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  )
                : (controller.isLoadingCategories.value == true
                    ? LoadingBouncingLine.circle()
                    : Text('No categories'.tr))),
          ],
        ),
      ),
    );
  }
}
