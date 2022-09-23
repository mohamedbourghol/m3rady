import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:m3rady/core/controllers/account/account_controller.dart';
import 'package:m3rady/core/helpers/assets_helper.dart';
import 'package:m3rady/core/helpers/main_loader.dart';
import 'package:m3rady/core/utils/storage/local/variables.dart';
import 'package:m3rady/core/view/components/components.dart';
import 'package:permission_handler/permission_handler.dart';

class SelectLocationScreen extends StatefulWidget {
  @override
  _SelectLocationScreenState createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  final AccountController accountController = Get.put(AccountController(
    loadCategories: false,
    loadCountries: false,
    loadSocialLogin: true,
  ));

  MapController mapController = MapController();
  Position? position;
  LatLng? latLngView;
  LatLng? latLngMarker;
  double zoom = 16;

  @override
  void initState() {
    super.initState();

    /// Try to get location
    if (accountController.user?.addressLatitude != null &&
        accountController.user?.addressLongitude != null) {
      // Set view
      latLngView = LatLng(accountController.user?.addressLatitude,
          accountController.user?.addressLongitude);

      /// Set zoom
      zoom = 16;
    } else if (GlobalVariables.userGeoIp?['latitude'] != null &&
        GlobalVariables.userGeoIp?['longitude'] != null) {
      // Set view
      latLngView = LatLng(GlobalVariables.userGeoIp?['latitude'],
          GlobalVariables.userGeoIp?['longitude']);

      /// Set zoom
      zoom = 12;
    } else {
      latLngView = LatLng(0, 0);
    }

    /// Set marker same as view
    latLngMarker = latLngView;
  }

  /// Get user current location
  Future getCurrentLocation() async {
    /// Start loader
    MainLoader.set(true);

    try {
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      /// Stop loader
      MainLoader.set(false);

      Get.defaultDialog(
        title: 'Permissions'.tr,
        content: Text('Please give the GPS permission to the app.'.tr),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text(
              'Cancel'.tr,
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              openAppSettings();
            },
            child: Text('Settings'.tr),
          ),
        ],
      );
    }

    /// Set and move
    if (position != null) {
      /// Update current location
      setState(() {
        zoom = 16;
        latLngView = LatLng(position!.latitude, position!.longitude);
        latLngMarker = latLngView;
        mapController.move(latLngView!, zoom);
      });
    }

    /// Stop loader
    MainLoader.set(false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: WillPopScope(
            onWillPop: () async {
              return !GlobalVariables.isMainLoading.value;
            },
            child: Container(
              child: Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  Stack(
                    alignment: AlignmentDirectional.topEnd,
                    children: [
                      /// Map
                      FlutterMap(
                        mapController: mapController,
                        options: MapOptions(
                          center: latLngView!,
                          zoom: zoom,
                          onTap: (tapPosition, LatLng latLng) {
                            setState(() {
                              latLngMarker = latLng;
                            });
                          },
                          slideOnBoundaries: true,
                          minZoom: 3,
                          maxZoom: 18,
                        ),
                        layers: [
                          TileLayerOptions(
                            urlTemplate:
                                "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                            subdomains: ['a', 'b', 'c'],
                          ),
                          MarkerLayerOptions(
                            markers: [
                              Marker(
                                width: 80.0,
                                height: 80.0,
                                point: latLngMarker!,
                                rotate: true,
                                builder: (ctx) => Container(
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        size: 52,
                                        color: Colors.orange,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      /// Get current Location
                      Padding(
                        padding: const EdgeInsetsDirectional.only(
                          end: 12,
                          start: 12,
                        ),
                        child: SafeArea(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              /// Back
                              BackButton(
                                color: Colors.black,
                              ),

                              /// Location
                              Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: Colors.white70,
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(
                                      10,
                                    ),
                                  ),
                                ),
                                child: IconButton(
                                  onPressed: () => getCurrentLocation(),
                                  icon: Icon(
                                    Icons.location_searching,
                                    size: 24,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),

                  /// Save button
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: CMaterialButton(
                        color: Colors.blue.withOpacity(0.9),
                        child: Text(
                          'Save Location'.tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () async {
                          /// Start loader
                          MainLoader.set(true);

                          await accountController.updateAccount(
                            addressLongitude:
                                latLngMarker?.longitude.toString(),
                            addressLatitude: latLngMarker?.latitude.toString(),
                          );

                          /// Stop loader
                          MainLoader.set(false);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        /// Loading
        Obx(
          () => Visibility(
            visible: GlobalVariables.isMainLoading.value,
            child: Container(
              height: Get.height,
              width: Get.width,
              color: Colors.black87,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: assets['logoLight'],
                      width: Get.width / 6,
                    ),
                    LoadingBouncingLine.circle(
                      backgroundColor: Colors.white54,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
