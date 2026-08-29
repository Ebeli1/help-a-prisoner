import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthState {
  final bool isAuthenticated;
  final User? user;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.isAuthenticated = false,
    this.user,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    User? user,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  // Pre-defined users for testing with real emails
  final Map<String, String> _users = {};

  AuthNotifier() : super(const AuthState());

  // Login with real email validation
  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    // Validate email format
    if (!_isValidEmail(email)) {
      state = state.copyWith(
        isLoading: false,
        error: 'Please enter a valid email address',
      );
      return;
    }

    // Validate password
    if (password.isEmpty || password.length < 6) {
      state = state.copyWith(
        isLoading: false,
        error: 'Password must be at least 6 characters',
      );
      return;
    }

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Check if user exists
    if (_users.containsKey(email) && _users[email] == password) {
      final user = User(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        fullName: email.split('@').first,
        email: email,
        role: 'SUPPORTER',
        isEmailVerified: true,
      );
      state = state.copyWith(
        isAuthenticated: true,
        user: user,
        isLoading: false,
      );
      return;
    }

    // Check if email exists with wrong password
    if (_users.containsKey(email)) {
      state = state.copyWith(
        isLoading: false,
        error: 'Incorrect password. Please try again.',
      );
      return;
    }

    // Email not registered
    state = state.copyWith(
      isLoading: false,
      error: 'No account found with this email. Please register.',
    );
  }

  // Register with real email validation
  Future<void> register(String fullName, String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    // Validate full name
    if (fullName.isEmpty || fullName.length < 2) {
      state = state.copyWith(
        isLoading: false,
        error: 'Please enter your full name',
      );
      return;
    }

    // Validate email format
    if (!_isValidEmail(email)) {
      state = state.copyWith(
        isLoading: false,
        error: 'Please enter a valid email address',
      );
      return;
    }

    // Validate password
    if (password.isEmpty || password.length < 6) {
      state = state.copyWith(
        isLoading: false,
        error: 'Password must be at least 6 characters',
      );
      return;
    }

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Check if email already registered
    if (_users.containsKey(email)) {
      state = state.copyWith(
        isLoading: false,
        error: 'This email is already registered. Please login.',
      );
      return;
    }

    // Register the user with real email
    _users[email] = password;
    final user = User(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      fullName: fullName,
      email: email,
      role: 'SUPPORTER',
      isEmailVerified: true,
    );

    state = state.copyWith(
      isAuthenticated: true,
      user: user,
      isLoading: false,
    );
  }

  // Logout
  void logout() {
    state = const AuthState();
  }

  // Email validation helper
  bool _isValidEmail(String email) {
    // Simple but effective email validation
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }
}
