import 'package:flutter/material.dart';
import '../models/onboarding_model.dart';

class OnboardingPageWidget extends StatelessWidget {
  final OnboardingPage page;
  final bool isLastPage;

  const OnboardingPageWidget({
    super.key,
    required this.page,
    required this.isLastPage,
  });

  @override
  Widget build(BuildContext context) {
    // Get screen size for responsive design
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenHeight < 700 || screenWidth < 400;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 20.0 : 30.0,
        vertical: isSmallScreen ? 10.0 : 0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon - smaller on small screens
          Container(
            width: isSmallScreen ? 90 : 140,
            height: isSmallScreen ? 90 : 140,
            decoration: BoxDecoration(
              color: page.color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              page.icon,
              size: isSmallScreen ? 45 : 70,
              color: const Color(0xFFD4AF37),
            ),
          ),
          SizedBox(height: isSmallScreen ? 20 : 30),
          // Title - smaller on small screens
          Text(
            page.title,
            style: TextStyle(
              fontSize: isSmallScreen ? 20 : 28,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0D1B2A),
              fontFamily: 'Georgia',
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isSmallScreen ? 10 : 15),
          // Description - smaller on small screens
          Text(
            page.description,
            style: TextStyle(
              fontSize: isSmallScreen ? 13 : 16,
              color: const Color(0xFF4A5A6A),
              fontFamily: 'Georgia',
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
