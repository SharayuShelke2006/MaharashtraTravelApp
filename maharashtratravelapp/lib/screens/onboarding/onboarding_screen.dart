import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../widgets/primary_button.dart';
import '../auth/welcome_screen.dart';
import 'onboarding_data.dart';
import 'package:go_router/go_router.dart';
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();

  int currentPage = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void nextPage() {
    if (currentPage == onboardingPages.length - 1) {
      context.go('/welcome');
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _controller,
        itemCount: onboardingPages.length,
        onPageChanged: (value) {
          setState(() {
            currentPage = value;
          });
        },
        itemBuilder: (context, index) {
          final page = onboardingPages[index];

          return Stack(
            children: [

              /// Background Image
              SizedBox.expand(
                child: Image.asset(
                  page.image,
                  fit: BoxFit.cover,
                ),
              ),

              /// Gradient
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black12,
                      Colors.black87,
                    ],
                  ),
                ),
              ),

              /// Skip Button
              SafeArea(
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: TextButton(
                      onPressed: () {
                        context.go('/welcome');
                      },
                      child: const Text(
                        "Skip",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              /// Bottom Card
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: GlassmorphicContainer(
                    width: double.infinity,
                    height: 340,
                    borderRadius: 30,
                    blur: 18,
                    alignment: Alignment.bottomCenter,
                    border: 1,
                    linearGradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(.18),
                        Colors.white.withOpacity(.05),
                      ],
                    ),
                    borderGradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(.4),
                        Colors.white.withOpacity(.1),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(26),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            page.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 15),

                          Text(
                            page.description,
                            style: TextStyle(
                              color: Colors.white.withOpacity(.85),
                              fontSize: 17,
                              height: 1.6,
                            ),
                          ),

                          const Spacer(),

                          Center(
                            child: SmoothPageIndicator(
                              controller: _controller,
                              count: onboardingPages.length,
                              effect: ExpandingDotsEffect(
                                activeDotColor: Colors.white,
                                dotColor: Colors.white38,
                                dotHeight: 8,
                                dotWidth: 8,
                                expansionFactor: 3,
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),

                          PrimaryButton(
                            text: currentPage == onboardingPages.length - 1
                                ? "Let's Explore"
                                : "Next",
                            onPressed: nextPage,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}