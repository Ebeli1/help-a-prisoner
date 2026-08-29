import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../screens/login_screen.dart';

/// Widget that shows a login dialog when a guest user tries to access protected actions
class AuthGuard extends ConsumerWidget {
  final Widget child;
  final VoidCallback? onAuthenticated;

  const AuthGuard({
    super.key,
    required this.child,
    this.onAuthenticated,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    if (authState.isAuthenticated) {
      return child;
    }

    // Guest mode - show child but with a tap handler that triggers auth
    return GestureDetector(
      onTap: () => _showAuthRequiredDialog(context),
      child: child,
    );
  }

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
          'You need to create an account or sign in to:\n\n'
          '• Make a donation\n'
          '• Save campaigns\n'
          '• Follow projects\n'
          '• Apply as a volunteer\n'
          '• Access your donation history',
          style: TextStyle(
            fontFamily: 'Georgia',
            height: 1.6,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Maybe later',
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
              'Sign in / Sign up',
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
