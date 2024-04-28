import 'package:bills_collector_mobile/main.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../utils/MySharedPreferences.dart';
import 'final_page_with_login.dart';
import 'MyHomePage.dart';

class Onboarding extends StatelessWidget {
  final PageController _controller = PageController();

  Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Builder(builder: (context) {
      return Scaffold(
        resizeToAvoidBottomInset : false,
        body: Stack(
          children: [
            PageView(
              controller: _controller,
              children: const [
                OnboardingPage(
                  "Добро пожаловать",
                  "assets/onboarding/qfqfqfqfq 1.png",
                  "Поздоровайтесь с вашим новым сборщиком финансов, это ваш первый шаг к более эффективному контролю над вашими деньгами и финансовыми целями.",
                ),
                OnboardingPage(
                  "Контролируйте свои расходы и начинайте копить",
                  "assets/onboarding/digital-strategy 2.png",
                  "Bills Collector помогает вам контролировать ваши расходы, отслеживать ваши расходы и в конечном итоге сэкономить больше денег.",
                ),
                OnboardingPage(
                  "Вместе мы достигнем ваших финансовых целей",
                  "assets/onboarding/Layer 0.png",
                  "Планирование - это все. Мы поможем вам оставаться сосредоточенными на отслеживании ваших расходов и достижении ваших финансовых целей.",
                ),
                FinalPage(),
              ],
            ),
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Spacer(),
                    SmoothPageIndicator(
                      controller: _controller,
                      count: 4,
                      effect: SlideEffect(
                        dotColor: theme.colorScheme.surfaceContainer,
                        activeDotColor: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class OnboardingPage extends StatelessWidget {
  const OnboardingPage(this.heading, this.image, this.tail, {super.key});

  final String heading;
  final String image;
  final String tail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Builder(
      builder: (context) {
        return Container(
          color: theme.colorScheme.surface,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    heading,
                    style: theme.textTheme.titleLarge!.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 60.0),
                  Image.asset(image),
                  const SizedBox(
                    height: 60,
                  ),
                  Text(
                    tail,
                    style: theme.textTheme.bodyLarge!.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}


