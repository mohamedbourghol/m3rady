const Map config = {
  /// The application name
  'appName': 'M3rady',

  /// The application version
  'version': '1.2.24 (26)',

  /// Default application language
  'defaultLocale': 'ar',

  /// Get the device locale and set it as the default app locate
  'usedDeviceDefaultLocale': true,

  /// Show debug print and errors messages
  'isDebugMode': false,

  /// Splash screen initial timer in seconds
  'splashScreenTimer': 0,

  /// The default country code
  'defaultCountryCode': 'SA',

  /// Don't show all countries on registration and show only the specific countries in the backend
  'isLimitedCountries': true,

  /// Use the default device country in the registration
  'usedDeviceDefaultCountry': true,

  /// The base backend api
  'baseAPIsURL': 'https://m3radyapp.com/api/v1',

  /// Pages slugs in the backend
  'pagesSlugs': {
    'Privacy Policy': 'privacy-policy',
    'Terms and Conditions': 'terms-and-conditions',
    'About Us': 'about-us',
  },

  /// share app text (the text that will be shown when someone share the app)
  'shareAppText': 'M3rady https://m3radyapp.com',

  /// Activate social login
  'isActivateSocialLogin': true,

  /// Video player key
  'videoPlayerKey': 'M3radyVideo',

  /// Video cache key
  'videoCacheKey': 'M3radyVideoCache',

  /// Maximum cached Videos
  'videoPlayerMaximumCachedVideos': 5,

  /// Save cache path
  'cacheSavePath': 'cache',

  /// Maximum allowed proposal images (to be uploaded)
  'maximumProposalImages': 3,

  /// Maximum allowed post images (to be uploaded)
  'maximumPostImages': 5,

  /// Maximum allowed post videos (to be uploaded)
  'maximumPostVideos': 1,

  /// Maximum allowed offer images (to be uploaded)
  'maximumOfferImages': 5,

  /// Maximum allowed offer videos (to be uploaded)
  'maximumOfferVideos': 1,

  /// Maximum interested categories
  'maximumInterestedCategories': 5,
};
