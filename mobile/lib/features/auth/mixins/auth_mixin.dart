import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../screens/login_screen.dart';

mixin AuthMixin {
  /// Check if user is authenticated, show login dialog if not
  bool checkAuthAndProceed(BuildContext context, WidgetRef ref) {
    final authState = ref.read(authProvider);

    if (authState.isAuthenticated) {
      return true;
    }

    _showAuthRequiredDialog(context);
    return false;
  }

  /// Show the auth required dialog
  void _showAuthRequiredDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Row(
          children: [
            Icon(
              Icons.lock_outline,
              color: Color(0xFFD4AF37),
            ),
            SizedBox(width: 12),
            Text(
              'Sign in required',
              style: TextStyle(
                fontFamily: 'Georgia',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: const Text(
          'Please sign in or create an account to continue.',
          style: TextStyle(
            fontFamily: 'Georgia',
            height: 1.6,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Color(0xFF4A5A6A),
                fontFamily: 'Georgia',
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const LoginScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4AF37),
              foregroundColor: const Color(0xFF0D1B2A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'Sign in',
              style: TextStyle(
                fontFamily: 'Georgia',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
