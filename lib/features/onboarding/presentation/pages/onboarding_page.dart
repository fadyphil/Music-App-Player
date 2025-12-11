import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:music_player/core/theme/app_pallete.dart';
import 'package:music_player/features/home/presentation/pages/home_page.dart';
import 'package:music_player/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:music_player/features/onboarding/presentation/widgets/onboarding_content.dart';
import 'package:music_player/core/di/init_dependencies.dart'; // Import serviceLocator

class OnboardingPage extends StatefulWidget {
  final VoidCallback? onDone;
  
  const OnboardingPage({
    super.key,
    this.onDone,
  });

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();

  final List<Map<String, dynamic>> _onboardingData = [
    {
      "title": "Welcome to Music Player",
      "desc": "Experience your local music library like never before with our sleek and modern player.",
      "icon": Icons.music_note_rounded,
    },
    {
      "title": "Smart Analytics",
      "desc": "Track your listening habits, favorite genres, and top artists with our built-in analytics.",
      "icon": Icons.analytics_outlined,
    },
    {
      "title": "Seamless Playback",
      "desc": "Enjoy uninterrupted playback with background support and intuitive controls.",
      "icon": Icons.play_circle_fill_rounded,
    },
  ];

  void _onNext(BuildContext context, int currentIndex) {
    if (currentIndex < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding(context);
    }
  }

  void _finishOnboarding(BuildContext context) {
    if (widget.onDone != null) {
      widget.onDone!();
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<OnboardingCubit>(),
      child: Scaffold(
        backgroundColor: AppPallete.backgroundColor,
        body: SafeArea(
          child: BlocBuilder<OnboardingCubit, int>(
            builder: (context, currentIndex) {
              return Column(
                children: [
                  // Skip Button
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextButton(
                        onPressed: () {
                          context.read<OnboardingCubit>().cacheFirstRun();
                          _finishOnboarding(context);
                        },
                        child: const Text(
                          'Skip',
                          style: TextStyle(
                            color: AppPallete.grey,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Page View
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _onboardingData.length,
                      onPageChanged: (index) {
                        context.read<OnboardingCubit>().pageChanged(index);
                      },
                      itemBuilder: (context, index) {
                        return OnboardingContent(
                          title: _onboardingData[index]["title"],
                          description: _onboardingData[index]["desc"],
                          icon: _onboardingData[index]["icon"],
                        );
                      },
                    ),
                  ),

                  // Bottom Controls
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Dot Indicators
                        Row(
                          children: List.generate(
                            _onboardingData.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.only(right: 8),
                              height: 8,
                              width: currentIndex == index ? 24 : 8,
                              decoration: BoxDecoration(
                                color: currentIndex == index
                                    ? AppPallete.primaryGreen
                                    : AppPallete.grey,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),

                        // Next/Done Button
                        ElevatedButton(
                          onPressed: () {
                            if (currentIndex == _onboardingData.length - 1) {
                              context.read<OnboardingCubit>().cacheFirstRun();
                            }
                            _onNext(context, currentIndex);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppPallete.primaryGreen,
                            foregroundColor: AppPallete.backgroundColor,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(20),
                          ),
                          child: Icon(
                            currentIndex == _onboardingData.length - 1
                                ? Icons.check
                                : Icons.arrow_forward,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}