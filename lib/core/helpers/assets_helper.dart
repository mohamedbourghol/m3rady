import 'package:flutter/material.dart';

/// Base assets path
const String assetsBase = 'assets';

/// Images path
const String imagesBase = '$assetsBase/images';

/// Icons path
const String iconsBase = '$assetsBase/images/icons';

/// Assets
const Map assets = {
  /// Main Images
  'splash': AssetImage('$imagesBase/splash.png'),
  'logo': AssetImage('$imagesBase/logo.png'),
  'logoLight': AssetImage('$imagesBase/logo-light.png'),
  'userDefaultImage': AssetImage('$imagesBase/user-default.png'),
  'footerBuildings': AssetImage('$imagesBase/buildings.png'),
  'trailsBuildings': AssetImage('$imagesBase/light-trails-buildings.png'),
  'introPage1': AssetImage('$imagesBase/intro/introPage1.png'),
  'introPage2': AssetImage('$imagesBase/intro/introPage2.png'),
  'introPage3': AssetImage('$imagesBase/intro/introPage3.png'),

  /// Drawer Icons
  'appleLight': AssetImage('$iconsBase/apple-light.png'),
  'googleColored': AssetImage('$iconsBase/google-colored.png'),
  'elites': AssetImage('$iconsBase/elites.png'),
  'eliteOutline': AssetImage('$iconsBase/elite_outline.png'),
  'diamondOutline': AssetImage('$iconsBase/diamond_outline.png'),
  'proposalsOutline': AssetImage('$iconsBase/proposals_outline.png'),
  'adsOutline': AssetImage('$iconsBase/ads_outline.png'),
  'langOutline': AssetImage('$iconsBase/lang_outline.png'),
  'shareOutline': AssetImage('$iconsBase/share_outline.png'),
  'tableOutline': AssetImage('$iconsBase/table_outline.png'),
  'emailOutline': AssetImage('$iconsBase/email_outline.png'),
  'fileOutline': AssetImage('$iconsBase/file_outline.png'),
  'askOutline': AssetImage('$iconsBase/ask_outline.png'),
  'starOutline': AssetImage('$iconsBase/star_outline.png'),
  'savedOutline': AssetImage('$iconsBase/saved_outline.png'),
  'chatsOutline': AssetImage('$iconsBase/chats_outline.png'),
  'logoutOutline': AssetImage('$iconsBase/logout_outline.png'),

  /// Contact Us Icons
  'facebookSocial': AssetImage('$iconsBase/facebook.png'),
  'twitterSocial': AssetImage('$iconsBase/twitter.png'),
  'mobileSocial': AssetImage('$iconsBase/mobile.png'),
  'whatsappSocial': AssetImage('$iconsBase/whatsapp.png'),
  'websiteSocial': AssetImage('$iconsBase/website.png'),
  'addressSocial': AssetImage('$iconsBase/address.png'),

  /// My Account Icons
  'profileDark': AssetImage('$iconsBase/profile_dark.png'),
  'contactDark': AssetImage('$iconsBase/contact_dark.png'),
  'phoneDark': AssetImage('$iconsBase/phone_dark.png'),
  'passwordDark': AssetImage('$iconsBase/password_dark.png'),
  'keyDark': AssetImage('$iconsBase/key_dark.png'),
  'chatDark': AssetImage('$iconsBase/chat_dark.png'),
  'socialDark': AssetImage('$iconsBase/social_dark.png'),
  'cancelDark': AssetImage('$iconsBase/cancel_dark.png'),
  'blockDark': AssetImage('$iconsBase/block_dark.png'),
};
