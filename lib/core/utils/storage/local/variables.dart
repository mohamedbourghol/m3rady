import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

/// Set system shared vars
class GlobalVariables {
  /// is main loading
  static var isMainLoading = false.obs;

  /// is main loading
  static var isHomeFilterIsShown= false.obs;

  /// Set system country code
  static var systemCountryCode;

  /// Set authenticated user data
  static var user;

  /// Set user local
  static var imagePath='';

  /// Set user geo ip
  static var userGeoIp;

  /// Set user geo ip country code
  static var userGeoIpCountryCode;

  /// Set counter for user data updates
  static var userDataUpdatesCounter = 0.obs;

  /// Set is authenticated
  static var isUserAuthenticated = (user != null).obs;

  /// Set if the device is connected to the internet
  static var isDeviceConnectedToTheInternet = true.obs;

  /// Set follow status of system users
  static var usersFollowStatus = {}.obs;

  /// Set video player controllers
  static Map<int, VideoPlayerController> videoPlayerControllers = {};

  /// Set video player settings
  static Map<int, dynamic> videoPlayerSettings = {};

  /// Set hidden posts
  static List hiddenCommunity = [];
}
