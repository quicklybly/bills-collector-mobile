import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../utils/MySharedPreferences.dart';

class Onboarding extends StatelessWidget {
  final PageController _controller = PageController();

  Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const tail =
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
    return Builder(
      builder: (context) {
        return Scaffold(
          body: Stack(
            children: [
              PageView(
                controller: _controller,
                children: const [
                  Page1(
                    "Earn for every Referal",
                    "assets/placeholders/1.png",
                    tail,
                  ),
                  Page1(
                    "Send Money Fast",
                    "assets/placeholders/1.png",
                    tail,
                  ),
                  Page1(
                    "Over 50 Countries",
                    "assets/placeholders/1.png",
                    tail,
                  ),
                  FinalPage("Final page", "assets/placeholders/1.png"),
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
                        effect:  SlideEffect(
                            dotColor:  theme.colorScheme.onPrimary,
                            activeDotColor:  theme.colorScheme.primary,
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
      }
    );
  }
}

class Page1 extends StatelessWidget {
  const Page1(this.heading, this.image, this.tail, {super.key});

  final String heading;
  final String image;
  final String tail;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displaySmall!.copyWith(
      color: theme.colorScheme.onPrimaryContainer,
    );

    return Container(
      color: theme.colorScheme.primaryContainer,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                heading,
                style: style,
              ),
              const SizedBox(height: 60.0),
              Image.asset(image),
              const SizedBox(
                height: 60,
              ),
              Text(tail)
            ],
          ),
        ),
      ),
    );
  }
}

class FinalPage extends StatefulWidget {
  const FinalPage(this.heading, this.image, {super.key});

  final String heading;
  final String image;

  @override
  State<FinalPage> createState() => _FinalPageState();
}

class _FinalPageState extends State<FinalPage> {
  _FinalPageState() {
    MySharedPreferences.instance.setBooleanValue("notFirstRun", true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimaryContainer,
    );

    return Scaffold(
      backgroundColor: theme.colorScheme.primaryContainer,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.heading,
              style: style,
            ),
            const SizedBox(height: 60.0),
            Image.asset(widget.image),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text(
                "Войти",
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {},
              child: const Text(
                "Зарегистрироваться",
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () {},
              child: const Text(
                "Продолжить без авторизации",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
