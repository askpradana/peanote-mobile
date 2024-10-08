import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peanote/constant/pea_theme.dart';
import 'package:peanote/controllers/onboarding_controller.dart';
import 'package:peanote/views/login_page.dart';
import 'package:peanote/views/widgets/pea_button.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    OnBoardingController controller = Get.put(OnBoardingController());
    PageController pageController = PageController();

    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              itemCount: 3,
              controller: pageController,
              onPageChanged: (value) {
                controller.currentIndex = value;
              },
              itemBuilder: (context, pagePosition) {
                return Container(
                  margin: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        controller.title[pagePosition],
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 48,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 32),
                        height: size.height / 2.5,
                        color: PeaTheme.greyColor,
                      ),
                      Text(
                        controller.description[pagePosition],
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
            Positioned(
              bottom: 8,
              left: 32,
              right: 32,
              child: Column(
                children: [
                  PeaButton(
                    title: 'Next',
                    onPressed: () {
                      if (controller.currentIndex == 2) {
                        Get.to(() => const OnBoardingLast());
                      } else {
                        controller.moveToNextPage(pageController);
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  PeaButton(
                    type: ButtonType.textButton,
                    title: 'Skip',
                    onPressed: () {
                      Get.to(() => const OnBoardingLast());
                    },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnBoardingLast extends StatelessWidget {
  const OnBoardingLast({super.key});

  @override
  Widget build(BuildContext context) {
    OnBoardingController controller = Get.put(OnBoardingController());

    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: PeaTheme.greyColor,
              height: size.height / 2.5,
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'PEA\nNOTES',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 63,
                  height: 0.8,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'all in one apps\ncapture - summarize - practices',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: PeaButton(
                type: ButtonType.outlinedButton,
                title: "Let's Go",
                onPressed: () async {
                  await controller.writeOnBoarding();
                  Get.offAll(() => const LoginPage());
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
