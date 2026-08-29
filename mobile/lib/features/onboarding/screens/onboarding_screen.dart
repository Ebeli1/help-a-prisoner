import 'package:flutter/material.dart';
import '../models/onboarding_model.dart';
import '../widgets/onboarding_page.dart';
import '../widgets/onboarding_indicator.dart';
import '../../../main.dart'; // Add this import

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _navigateToMain() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;

    return Scaffold(
      body: Column(
        children: [
          // Skip button
          Padding(
            padding: EdgeInsets.all(isSmallScreen ? 12.0 : 20.0),
            child: Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _navigateToMain, // Changed from _navigateToAuth
                child: Text(
                  'Skip',
                  style: TextStyle(
                    color: const Color(0xFF0D1B2A),
                    fontSize: isSmallScreen ? 14 : 16,
                    fontFamily: 'Georgia',
                  ),
                ),
              ),
            ),
          ),
          // Page View
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: onboardingPages.length,
              itemBuilder: (context, index) {
                return OnboardingPageWidget(
                  page: onboardingPages[index],
                  isLastPage: index == onboardingPages.length - 1,
                );
              },
            ),
          ),
          // Bottom: Indicator + Buttons
          Padding(
            padding: EdgeInsets.all(isSmallScreen ? 20.0 : 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Indicator
                OnboardingIndicator(
                  currentIndex: _currentPage,
                  totalPages: onboardingPages.length,
                ),
                // Next / Get Started Button
                ElevatedButton(
                  onPressed: () {
                    if (_currentPage < onboardingPages.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      _navigateToMain(); // Changed from _navigateToAuth
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4AF37),
                    foregroundColor: const Color(0xFF0D1B2A),
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 20 : 30,
                      vertical: isSmallScreen ? 12 : 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    _currentPage < onboardingPages.length - 1
                        ? 'Next'
                        : 'Get Started',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Georgia',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
