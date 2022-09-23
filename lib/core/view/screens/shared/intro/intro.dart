import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:get/get.dart';
import 'package:m3rady/core/helpers/assets_helper.dart';
import 'package:m3rady/core/helpers/main_loader.dart';
import 'package:m3rady/core/utils/storage/local/storage.dart';
import 'package:m3rady/core/view/layouts/intro/intro_layout.dart';

class IntroScreen extends StatelessWidget {
  /// The intro ended
  void introEnded() {
    /// Stop showing intro next time
    LocalStorage.set('isShowIntroScreen', false);

    /// Stop any loading
    MainLoader.set(false);

    /// Redirect to login
    Get.offAllNamed('/auth/login');
  }

  @override
  Widget build(BuildContext context) {
    List<PageViewModel> listPages = [
      PageViewModel(
        title: 'M3rady App'.tr,
        bodyWidget: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.blue,
              fontFamily: 'Cairo',
            ),
            children: <TextSpan>[
              TextSpan(
                text: 'Welcome to M3rady App'.tr,
              ),
              TextSpan(
                text: '\n',
              ),
              TextSpan(
                text: 'The first application in the field of business'.tr,
                style: TextStyle(
                  color: Color(0xff9b59b6),
                ),
              ),
              TextSpan(
                text: '\n',
              ),
              TextSpan(
                text: '✓ Free ✓ No ads ✓ No commissions'.tr,
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        image: Center(
          child: Image(
            image: assets['introPage1'],
            height: Get.width / 1.5,
          ),
        ),
      ),
      PageViewModel(
        title: 'The Advertisers'.tr,
        bodyWidget: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.blue,
              fontFamily: 'Cairo',
            ),
            children: <TextSpan>[
              TextSpan(
                text: 'Upload photos and videos of your own work.'.tr,
              ),
              TextSpan(
                text: '\n',
              ),
              TextSpan(
                text:
                    'The pictures and the vidoes should be beautiful and perfect to attract the customers.'
                        .tr,
              ),
              TextSpan(
                text: '\n',
              ),
              TextSpan(
                text: 'And we have a section for'.tr,
              ),
              TextSpan(
                text: ' ',
              ),
              TextSpan(
                text: 'the Elites'.tr,
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        image: Center(
          child: Image(
            image: assets['introPage2'],
            height: Get.width / 1.5,
          ),
        ),
      ),
      PageViewModel(
        title: 'The Customers'.tr,
        bodyWidget: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.blue,
              fontFamily: 'Cairo',
            ),
            children: <TextSpan>[
              TextSpan(
                text:
                    'Register now and follow the advertisers and ask them for prices directly within the application and you can chat with them and do not forget the section of'
                        .tr,
              ),
              TextSpan(
                text: ' ',
              ),
              TextSpan(
                text: 'the Offers'.tr,
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        footer: ElevatedButton(
          onPressed: introEnded,
          child: Text("Start Now".tr),
        ),
        image: Center(
          child: Image(
            image: assets['introPage3'],
            height: Get.width / 1.5,
          ),
        ),
      ),
    ];

    return IntroLayout(
      child: IntroductionScreen(
        globalBackgroundColor: Colors.white,
        pages: listPages,
        onDone: introEnded,
        onSkip: introEnded,
        showSkipButton: true,
        skip: Text('Skip'.tr),
        next: Text('Next'.tr),
        done: Text(
          'Start Now'.tr,
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        dotsDecorator: DotsDecorator(
          size: const Size.square(10),
          activeSize: const Size(
            20,
            10,
          ),
          activeColor: Colors.lightBlue,
          color: Colors.black26,
          spacing: const EdgeInsets.symmetric(
            horizontal: 3,
          ),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              25,
            ),
          ),
        ),
      ),
    );
  }
}
