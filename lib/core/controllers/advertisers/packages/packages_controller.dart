import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_ios/store_kit_wrappers.dart';
import 'package:m3rady/core/helpers/main_loader.dart';
import 'package:m3rady/core/models/advertisers/packages/package.dart';
import 'package:m3rady/core/models/users/user.dart';
import 'package:m3rady/core/utils/config/config.dart';
import 'package:m3rady/core/utils/storage/local/variables.dart';
import 'package:m3rady/core/view/components/components.dart';

class PackagesController extends GetxController {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription _subscription;

  var shownPackages = {}.obs;
  Map? allPackages;
  Package? userPackage;
  var isLoadingPackages = true.obs;
  Set<String> _productIds = {};
  List<ProductDetails> _products = [];
  bool isAvailable = true;
  bool isManagingPurchase = false;

  @override
  void onInit() async {
    final Stream purchaseUpdated = _inAppPurchase.purchaseStream;

    _subscription = purchaseUpdated.listen(
      (purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList);
      },
      onDone: () {
        _subscription.cancel();
      },
      onError: (error) {
        // handle error here.
        if (config['isDebugMode']) print(error);
      },
    );

    /// Get packages
    allPackages = await getAndSetPackages();

    /// Set shown packages
    if (allPackages != null) {
      shownPackages.value = allPackages!;
    }

    /// Handle store package
    if (shownPackages.length > 0) {
      /// Set products ids
      shownPackages.forEach((key, package) {
        if (package.isTrial == false && package.productId != null) {
          _productIds.add(package.productId!);
        }
      });

      /// Init store info
      await _initStoreInfo();

      /// Finish pending
      await _finishPendingTransaction();
    }

    /// Get user data
    await User.getAndSetUserGlobalData();

    /// Handle current user package
    if (GlobalVariables.user.isHasPackage == true) {
      this.userPackage = GlobalVariables.user.userPackage;

      /// Hide all packages
      shownPackages.value = {};

      update();
    }

    /// Stop loader
    isLoadingPackages.value = false;

    super.onInit();
  }

  /// Listen to purchase update stream
  _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    try {
      purchaseDetailsList.forEach(
        (PurchaseDetails purchaseDetails) async {
          /// Debug
          if (config['isDebugMode']) {
            print([
              purchaseDetails.status,
              purchaseDetails.error?.message,
              purchaseDetails.productID,
              purchaseDetails.purchaseID,
              purchaseDetails.verificationData.source,
              purchaseDetails.verificationData.serverVerificationData,
              purchaseDetails.verificationData.localVerificationData,
            ]);
            /*CErrorDialog(errors: [
              purchaseDetails.status.toString(),
              purchaseDetails.error?.message.toString(),
              purchaseDetails.productID.toString(),
              purchaseDetails.purchaseID.toString(),
              purchaseDetails.verificationData.source.toString(),
              purchaseDetails.verificationData.serverVerificationData
                  .toString(),
              purchaseDetails.verificationData.localVerificationData
                  .toString(),
            ]);
          }*/
          }

          /// Send identifier to the backend
          if (purchaseDetails.verificationData.serverVerificationData
                  .toString() !=
              '') {
            var validation = await Package.sendPackageIdentifier(
              productId: purchaseDetails.productID.toString(),
              purchaseID: purchaseDetails.purchaseID.toString(),
              identifier: purchaseDetails
                  .verificationData.serverVerificationData
                  .toString(),
              deviceOS: (Platform.isIOS ? 'IOS' : 'Android'),
              transactionDate:
                  purchaseDetails.verificationData.serverVerificationData,
              status: purchaseDetails.status.toString(),
              source: purchaseDetails.verificationData.source.toString(),
            );

            /// Reload user data
            await User.getAndSetUserGlobalData();

            /// Show dialog
            if (validation != false &&
                GlobalVariables.user.isHasPackage == true) {
              /// Handle current user package
              if (GlobalVariables.user.userPackage != null) {
                this.userPackage = GlobalVariables.user.userPackage;

                /// Hide all packages
                shownPackages.value = {};

                update();
              }
            }
          }

          if (purchaseDetails.status == PurchaseStatus.pending) {
            /// Start loader
            MainLoader.set(true);

            CToast(
              text: "Validating Purchase.".tr,
            );
          } else {
            /// Error
            if (purchaseDetails.status == PurchaseStatus.error) {
              if (![
                "BillingResponse.userCanceled",
                "BillingResponse.itemAlreadyOwned",
                "BillingResponse.developerError",
              ].contains(purchaseDetails.error?.message)) {
                CToast(
                  text: "Failed to subscribe to this package.".tr,
                );
              } else if (purchaseDetails.error?.message ==
                  "BillingResponse.developerError") {
                /// Pending complete
                if (purchaseDetails.pendingCompletePurchase) {
                  await _inAppPurchase.completePurchase(purchaseDetails);
                }

                /// Send verify request
                var validation = await validatePackage(
                  source: purchaseDetails.verificationData.source,
                  verificationData:
                      purchaseDetails.verificationData.serverVerificationData,
                  transactionDate: purchaseDetails.transactionDate,
                  productId: purchaseDetails.productID,
                  purchaseID: purchaseDetails.purchaseID,
                  status: purchaseDetails.status.toString(),
                );

                /// Reload user data
                await User.getAndSetUserGlobalData();

                /// Show dialog
                if (validation != false &&
                    GlobalVariables.user.isHasPackage == true) {
                  /// Handle current user package
                  if (GlobalVariables.user.userPackage != null) {
                    this.userPackage = GlobalVariables.user.userPackage;

                    /// Hide all packages
                    shownPackages.value = {};

                    update();
                  }
                } else {
                  CToast(
                    text:
                        'Please restart the application to validate the subscription.'
                            .tr,
                  );
                }
              }

              /// Stop loader
              MainLoader.set(false);
            } else if (purchaseDetails.status == PurchaseStatus.purchased ||
                purchaseDetails.status == PurchaseStatus.restored) {
              /// if (isManagingPurchase == false) {
              /// Send verify request
              var validation = await validatePackage(
                source: purchaseDetails.verificationData.source,
                verificationData:
                    purchaseDetails.verificationData.serverVerificationData,
                transactionDate: purchaseDetails.transactionDate,
                productId: purchaseDetails.productID,
                purchaseID: purchaseDetails.purchaseID,
                status: purchaseDetails.status.toString(),
              );

              /// Reload user data
              await User.getAndSetUserGlobalData();

              /// Show dialog
              if (validation != false &&
                  GlobalVariables.user.isHasPackage == true) {
                /*CToast(
                    text: 'You are subscribed to an elite package.'.tr,
                  );*/

                /// Handle current user package
                if (GlobalVariables.user.userPackage != null) {
                  this.userPackage = GlobalVariables.user.userPackage;

                  /// Hide all packages
                  shownPackages.value = {};

                  update();
                }
              }
              /*else {
                  CSomethingWentWrongDialog();
                }*/

              /// }

              /// Pending complete
              if (purchaseDetails.pendingCompletePurchase) {
                await _inAppPurchase.completePurchase(purchaseDetails);
              }

              /// Finish pending
              await _finishPendingTransaction();

              /// Stop loader
              MainLoader.set(false);
            }
          }
        },
      );
    } catch (e) {
      if (config['isDebugMode']) print(e);

      /// Stop loader
      MainLoader.set(false);
    }
  }

  /// Init store info
  _initStoreInfo() async {
    try {
      isAvailable = await _inAppPurchase.isAvailable();

      if (isAvailable == true && _productIds.length > 0) {
        ProductDetailsResponse productDetailResponse =
            await _inAppPurchase.queryProductDetails(_productIds);

        if (productDetailResponse.error == null) {
          _products = productDetailResponse.productDetails;
        }
      } else {
        /// Hide all packages
        shownPackages.value = {};
      }
    } catch (e) {
      if (config['isDebugMode']) print(e);
    }
  }

  /// Finish pending transactions
  Future _finishPendingTransaction() async {
    try {
      if (Platform.isIOS) {
        var paymentWrapper = SKPaymentQueueWrapper();
        var transactions = await paymentWrapper.transactions();

        await Future.forEach(
          transactions,
          (SKPaymentTransactionWrapper transaction) async {
            await paymentWrapper.finishTransaction(transaction);
          },
        );
      }
    } catch (e) {
      if (config['isDebugMode']) print(e);
    }
  }

  /// Buy product by index
  buyProduct(
    Package package, {
    isManagingPurchase = false,
  }) async {
    /// Start loader
    MainLoader.set(true);

    /// Set is canceling
    this.isManagingPurchase = isManagingPurchase == true;

    try {
      /// Check if the package exists
      if (_products.length > 0 && _productIds.contains(package.productId)) {
        /// Get product index
        var index = _productIds.toList().indexOf(package.productId.toString());

        /// Finish pending
        await _finishPendingTransaction();

        final PurchaseParam purchaseParam =
            PurchaseParam(productDetails: _products[index]);

        /// Vibrate
       // HapticFeedback.lightImpact();

        /// Buy
        if (Platform.isAndroid) {
          await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
        } else if (Platform.isIOS) {
          await _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
        }
      } else {
        CToast(
          text: "You can't subscribe to this package right now.".tr,
        );

        /// Stop loader
        MainLoader.set(false);
      }
    } catch (e) {
      if (config['isDebugMode']) print(e);

      /// Stop loader
      MainLoader.set(false);
    }
  }

  /// Get packages
  Future getAndSetPackages() async {
    var request = await Package.getPackages();

    if (request != false) {
      return request;
    }
  }

  /// Get package
  Future getUserPackage() async {
    return await Package.getUserPackage();
  }

  /// Validate package
  Future validatePackage({
    productId,
    verificationData,
    transactionDate,
    purchaseID,
    status,
    source,
  }) async {
    return await Package.validatePackage(
      productId: productId,
      verificationData: verificationData,
      deviceOS: (Platform.isIOS ? 'IOS' : 'Android'),
      transactionDate: transactionDate,
      purchaseID: purchaseID,
      status: status,
      source: source,
    );
  }

  @override
  void dispose() async {
    super.dispose();

    /// Finish pending
    await _finishPendingTransaction();
    _subscription.cancel();
  }
}
