import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:m3rady/core/controllers/account/account_controller.dart';
import 'package:m3rady/core/view/components/components.dart';
import 'package:m3rady/core/view/components/shared/users/user_image.dart';

class WBlockedUser extends StatelessWidget {
  var user;

  WBlockedUser({
    this.user,
  });

  final AccountController accountController = Get.put(AccountController(
    loadCategories: false,
    loadCountries: false,
    loadSocialLogin: false,
    loadAccount: false,
  ));

  var isBlocked = true.obs;
  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible == true,
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Image, name
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// Image
                  WUserImage(
                    user.imageUrl,
                    isElite: user.isElite == true,
                    radius: 24,
                  ),

                  SizedBox(
                    width: 6,
                  ),

                  /// Name, country
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Name
                      Container(
                        width: Get.width / 2,
                        child: Text(
                          user.fullName,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      /// Country
                      Container(
                        width: Get.width / 2,
                        child: Text(
                          "${user.country} - ${user.city}",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black45,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  )
                ],
              ),

              /// Block button
              Obx(
                () => Container(
                  width: 100,
                  height: 30,
                  child: CMaterialButton(
                    height: 30,
                    borderColor:
                        (isBlocked.value == true ? Colors.grey : Colors.red),
                    color: (isBlocked.value == true ? Colors.grey : Colors.red),
                    child: Text(
                      (isBlocked.value ? "Unblock" : "Block").tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () async {
                      /// Block or unblock
                      isBlocked.value = !isBlocked.value;

                      /// Send request
                      await accountController.toggleBlockUser(
                        id: user.id,
                        type: user.type,
                        isBlocked: isBlocked.value,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
