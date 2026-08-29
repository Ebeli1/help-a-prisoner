import 'package:flutter/material.dart';

class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}

const List<OnboardingPage> onboardingPages = [
  OnboardingPage(
    title: 'Support Rehabilitation',
    description:
        'Help prisoners rebuild their lives through education, skills training, and rehabilitation programmes.',
    icon: Icons.handshake,
    color: Color(0xFF0D1B2A),
  ),
  OnboardingPage(
    title: 'Track Your Impact',
    description:
        'See exactly how your donations are changing lives. Every programme shows real results and progress.',
    icon: Icons.track_changes,
    color: Color(0xFF1B2A3A),
  ),
  OnboardingPage(
    title: 'Verified, Transparent, Trusted',
    description:
        'Every campaign is verified by our team. You can trust that your support goes to genuine, impactful programmes.',
    icon: Icons.verified,
    color: Color(0xFF2A3A4A),
  ),
];
