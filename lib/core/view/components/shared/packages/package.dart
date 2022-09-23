import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m3rady/core/controllers/advertisers/packages/packages_controller.dart';
import 'package:m3rady/core/helpers/assets_helper.dart';
import 'package:m3rady/core/models/advertisers/packages/package.dart';
import 'package:m3rady/core/view/components/components.dart';

class WPackage extends StatelessWidget {
  final PackagesController packagesController = Get.put(PackagesController());
  Package package;

  WPackage(
    this.package,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          /// Name
          Text(
            package.name,
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(
            height: package.description == null ? 0 : 12,
          ),

          /// Description
          (package.description == null
              ? SizedBox()
              : Text(
                  package.description!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Arial',
                    fontSize: 16,
                  ),
                )),

          /// Image
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              child: Image(
                image: assets['elites'],
              ),
            ),
          ),

          /// Features
          Expanded(
            child: (package.specifications == null
                ? SizedBox()
                : ListView.builder(
                    itemCount: package.specifications!.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Icon(
                            Icons.bolt,
                            color: Colors.orange,
                          ),
                          Container(
                            width: Get.width - 50,
                            child: Text(
                              package.specifications![index],
                            ),
                          ),
                        ],
                      );
                    },
                  )),
          ),

          SizedBox(
            height: 6,
          ),

          /// Agreement
          Text(
            "Recurring billing, cancel anytime".tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.5,
              color: Colors.grey.shade800,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(
            height: 6,
          ),

          /// Agreement
          Text(
            "Subscription will be charged to your credit card through your ${Platform.isIOS ? "iTunes" : "Google Play"} account. Subscriptions will automatically renew unless canceled within 24-hours before the end of the current period. You can cancel anytime with your ${Platform.isIOS ? "iTunes" : "Google Play"} account settings. Any unused portion of a free trial will be forfeited if you purchase a subscription. For more information, see our"
                .tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.5,
              color: Colors.grey.shade600,
            ),
          ),

          SizedBox(
            height: 6,
          ),

          /// Policies
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                child: Text(
                  " ${'Terms and Conditions'.tr} ",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue,
                  ),
                ),
                onTap: () {
                  Get.toNamed('/page',
                      arguments: {'page': 'Terms and Conditions'});
                },
              ),
              Text(
                'and'.tr,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              InkWell(
                child: Text(
                  " ${'Privacy Policy'.tr} ",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue,
                  ),
                ),
                onTap: () {
                  Get.toNamed('/page',
                      arguments: {'page': 'Privacy Policy'});
                },
              ),
            ],
          ),

          Visibility(
            visible: packagesController.userPackage != null,
            child: Column(
              children: [
                TextButton(
                  onPressed: () {
                    packagesController.buyProduct(
                      package,
                      isManagingPurchase: true,
                    );
                  },
                  child: Text(
                    'Manage Subscription'.tr,
                    style: TextStyle(
                      color: Colors.orange,
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  "${'Ends at:'.tr} ${(package.endsAt ?? '')}",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black45,
                  ),
                ),
              ],
            ),
          ),

          /// Price
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              /// Price
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      /// Main
                      Text(
                        '${package.price} ${package.currency} ${package.subscriptionType}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Arial',
                        ),
                      ),

                      /// Break
                      Visibility(
                        visible: package.oldPrice != null,
                        child: Text(
                          ' / ',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Arial',
                          ),
                        ),
                      ),

                      /// Instead
                      Visibility(
                        visible: package.oldPrice != null,
                        child: Text(
                          '${package.oldPrice} ${package.currency}',
                          style: const TextStyle(
                            color: Colors.black45,
                            fontSize: 14,
                            fontFamily: 'Arial',
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// Subscribe
              CMaterialButton(
                onPressed: () {
                  if (packagesController.userPackage == null) {
                    packagesController.buyProduct(package);
                  }
                },
                disabled: package.isSubscribed == true,
                child: Text(
                  (package.isSubscribed == false
                          ? 'Subscribe to Package'
                          : 'You subscribed to this package')
                      .tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                color: Color(0xFFFFAC00),
                borderColor: Colors.orange,
              ),
            ],
          ),

          SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }
}
