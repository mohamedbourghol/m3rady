import 'package:get/route_manager.dart';
import 'package:m3rady/core/view/layouts/advertiser/Advertiser_pages.dart';
import 'package:m3rady/core/view/layouts/guest/guest_pages.dart';
import 'package:m3rady/core/view/screens/shared/account/account.dart';
import 'package:m3rady/core/view/screens/shared/account/block_list/block_list.dart';
import 'package:m3rady/core/view/screens/shared/account/contact_accounts/edit_contact_accounts.dart';
import 'package:m3rady/core/view/screens/shared/account/location/select_location.dart';
import 'package:m3rady/core/view/screens/shared/account/password/edit_password.dart';
import 'package:m3rady/core/view/screens/shared/account/profile/edit_profile.dart';
import 'package:m3rady/core/view/screens/shared/account/social_login/edit_social_login.dart';
import 'package:m3rady/core/view/screens/shared/advertisers/elites/elites.dart';
import 'package:m3rady/core/view/screens/shared/advertisers/elites/packages/packages.dart';
import 'package:m3rady/core/view/screens/shared/advertisers/profile/profile.dart';
import 'package:m3rady/core/view/screens/shared/advertisers/profile/profile_contact.dart';
import 'package:m3rady/core/view/screens/shared/advertisers/profile/profile_rate.dart';
import 'package:m3rady/core/view/screens/shared/auth/login/login.dart';
import 'package:m3rady/core/view/screens/shared/auth/password/forgot.dart';
import 'package:m3rady/core/view/screens/shared/auth/password/reset.dart';
import 'package:m3rady/core/view/screens/shared/auth/password/verify_mobile.dart';
import 'package:m3rady/core/view/screens/shared/auth/register/account_type.dart';
import 'package:m3rady/core/view/screens/shared/auth/register/register.dart';
import 'package:m3rady/core/view/screens/shared/auth/register/verify_mobile.dart';
import 'package:m3rady/core/view/screens/shared/chat/chat.dart';
import 'package:m3rady/core/view/screens/shared/chat/chats.dart';
import 'package:m3rady/core/view/screens/shared/contact_us/contact_us.dart';
import 'package:m3rady/core/view/screens/shared/customers/profile/profile.dart';
import 'package:m3rady/core/view/screens/shared/follow/followers.dart';
import 'package:m3rady/core/view/screens/shared/follow/following.dart';
import 'package:m3rady/core/view/screens/shared/follow/requests.dart';
import 'package:m3rady/core/view/screens/shared/home/home.dart';
import 'package:m3rady/core/view/screens/shared/intro/intro.dart';
import 'package:m3rady/core/view/screens/shared/notifications/notifications.dart';
import 'package:m3rady/core/view/screens/shared/offers/create/create.dart';
import 'package:m3rady/core/view/screens/shared/offers/offers.dart';
import 'package:m3rady/core/view/screens/shared/pages/page.dart';
import 'package:m3rady/core/view/screens/shared/posts/create/create.dart';
import 'package:m3rady/core/view/screens/shared/posts/post/post.dart';
import 'package:m3rady/core/view/screens/shared/posts/saved/saved.dart';
import 'package:m3rady/core/view/screens/shared/profile/my_profile.dart';
import 'package:m3rady/core/view/screens/shared/proposals/proposal.dart';
import 'package:m3rady/core/view/screens/shared/proposals/proposals.dart';
import 'package:m3rady/core/view/screens/shared/proposals/request.dart';
import 'package:m3rady/core/view/screens/shared/search/search.dart';
import 'package:m3rady/core/view/screens/shared/splash/splash_screen.dart';
import 'package:m3rady/core/view/widgets/photo_viewer/network.dart';

import 'package:m3rady/core/view/widgets/video/video_player.dart';
import 'package:m3rady/core/view/widgets/video/video_player1.dart';


List<GetPage> routes = [
  /// ---------------------------------------------------------------------------
  /*
  * Main
  */

  /// Splash
  GetPage(
    name: '/splash',
    page: () => SplashScreen(),
    transition: Transition.noTransition,
  ),

  /// ---------------------------------------------------------------------------

  /// Intro
  GetPage(
    name: '/intro',
    page: () => IntroScreen(),
  ),

  /// ---------------------------------------------------------------------------

  /// Auth Login
  GetPage(
    name: '/auth/login',
    page: () => LoginScreen(),
    transition: Transition.fadeIn,
  ),

  /// Auth Register
  GetPage(
    name: '/auth/account-type',
    page: () => AccountTypeScreen(),
  ),
  GetPage(
    name: '/auth/register',
    page: () => RegisterScreen(),
  ),
  GetPage(
    name: '/auth/register/mobile/verify',
    page: () => RegisterVerifyMobileScreen(),
  ),

  /// Auth Password
  GetPage(
    name: '/auth/password/forgot',
    page: () => ForgotPasswordScreen(),
  ),
  GetPage(
    name: '/auth/password/mobile/verify',
    page: () => ForgotPasswordVerifyMobileScreen(),
  ),
  GetPage(
    name: '/auth/password/reset',
    page: () => ResetPasswordScreen(),
  ),

  /// ---------------------------------------------------------------------------

  /// ---------------------------------------------------------------------------
  /// ---------------------------------------------------------------------------
  /*
   * Shared
   */

  /// Home (Bottom nav bar)
  GetPage(
    name: '/home',
    page: () =>  Advertiser(
      intPage: 0,
    ),
    transition: Transition.fadeIn,
  ),
  /// Advertiser
  GetPage(
    name: '/Advertiser',
    page: () => Advertiser(
      intPage: 0,
    ),
    transition: Transition.fadeIn,
  ),
  /// customer
  GetPage(
    name: '/customer',
    page: () => Advertiser(
      intPage: 0,
    ),
    transition: Transition.fadeIn,
  ),
  /// Guest
  GetPage(
    name: '/guest',
    page: () => Guest(),
    transition: Transition.fadeIn,
  ),



  /// Search (Top nav bar)
  GetPage(
    name: '/search',
    page: () => SearchScreen(),
  ),

  /// Elite advertisers (Bottom nav bar)
  GetPage(
    name: '/advertisers/elite',
    page: () => ElitesAdvertisersScreen(),
    transition: Transition.fadeIn,
  ),



  /// Elites packages
  GetPage(
    name: '/elites/packages',
    page: () => ElitesPackagesScreen(),
  ),

  /// ---------------------------------------------------------------------------
  /// Account

  /// My Account (Bottom nav bar)
  GetPage(
    name: '/account',
    page: () => MyAccountScreen(),
  ),

  /// Edit profile
  GetPage(
    name: '/account/profile/edit',
    page: () => EditProfileScreen(),
  ),

  /// Edit password
  GetPage(
    name: '/account/password/edit',
    page: () => EditPasswordScreen(),
  ),

  /// Edit social login
  GetPage(
    name: '/account/social/login/edit',
    page: () => EditSocialLoginScreen(),
  ),

  /// Edit contact
  GetPage(
    name: '/account/contact/edit',
    page: () => EditContactScreen(),
  ),

  /// Edit block users
  GetPage(
    name: '/account/block/users',
    page: () => BlockListScreen(),
  ),

  /// Edit location
  GetPage(
    name: '/account/location/edit',
    page: () => SelectLocationScreen(),
    transition: Transition.noTransition,
  ),

  /// ---------------------------------------------------------------------------

  /// Chat
  GetPage(
    name: '/chat',
    page: () => ChatScreen(),
    transition: Transition.noTransition,
  ),

  /// Chats
  GetPage(
    name: '/chats',
    page: () => ChatsScreen(),
  ),

  /// ---------------------------------------------------------------------------

  /// Pages
  GetPage(
    name: '/page',
    page: () => PageScreen(),
  ),

  /// ---------------------------------------------------------------------------

  /// Contact Us
  GetPage(
    name: '/contact-us',
    page: () => ContactUsScreen(),
  ),

  /// ---------------------------------------------------------------------------

  /// Photo viewer (network)
  GetPage(
    name: '/photo-viewer/network',
    page: () => PhotoViewerNetworkScreen(),
    transition: Transition.fadeIn,
  ),

  /// ---------------------------------------------------------------------------

  /// Post
  GetPage(
    name: '/post',
    page: () => PostsScreen(),
  ),

  /// Saved posts
  GetPage(
    name: '/posts/saved',
    page: () => PostsSavedScreen(),
  ),

  /// Create posts
  GetPage(
    name: '/posts/create',
    page: () => PostsCreateScreen(),
  ),

  /// ---------------------------------------------------------------------------

  /// Offers
  GetPage(
    name: '/offers',
    page: () => OffersScreen(),
  ),

  /// Create offers
  GetPage(
    name: '/offers/create',
    page: () => OffersCreateScreen(),
  ),

  /// ---------------------------------------------------------------------------

  /// Proposals
  GetPage(
    name: '/proposals',
    page: () => ProposalsScreen(),
  ),

  /// Proposal
  GetPage(
    name: '/proposal',
    page: () => ProposalScreen(),
  ),

  /// Proposal request
  GetPage(
    name: '/proposal/request',
    page: () => ProposalRequestScreen(),
  ),

  /// ---------------------------------------------------------------------------

  /// Profile

  /// My Profile
  GetPage(
    name: '/profile/me',
    page: () => MyProfile(),
    transition: Transition.fadeIn,
  ),

  /// Customer profile
  GetPage(
    name: '/customer/profile',
    page: () => CustomerProfileScreen(),
  ),

  /// Advertiser profile
  GetPage(
    name: '/advertiser/profile',
    page: () => AdvertiserProfileScreen(),
  ),

  /// Advertiser profile (contact)
  GetPage(
    name: '/advertiser/profile/contact-us',
    page: () => AdvertiserProfileContactUsScreen(),
  ),

  /// Advertiser profile (rate)
  GetPage(
    name: '/advertiser/profile/rate',
    page: () => AdvertiserProfileRateScreen(),
  ),

  /// ---------------------------------------------------------------------------

  /// Following
  GetPage(
    name: '/profile/following',
    page: () => FollowingScreen(),
  ),

  /// Followers
  GetPage(
    name: '/profile/followers',
    page: () => FollowersScreen(),
  ),

  /// Followers requests
  GetPage(
    name: '/profile/followers/requests',
    page: () => FollowersRequestsScreen(),
  ),

  /// ---------------------------------------------------------------------------

  /// Video player
  GetPage(
    name: '/player/video/media',
    page: () => WVideoPlayer(),
  ),
];
