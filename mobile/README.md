# Help A Prisoner Mobile

## Paystack setup

The web build includes the configured Paystack test public key. You can
override it at build or run time:

```text
flutter run --dart-define=PAYSTACK_PUBLIC_KEY=pk_test_... --dart-define=PAYSTACK_SECRET_KEY=sk_test_... --dart-define=PAYSTACK_CALLBACK_URL=https://standard.paystack.co/close
```

The public key is required on web and the secret key is required on Android
and iOS by the current plugin flow. Do not use a secret key in a production
client build. Production payments should initialize and verify transactions
on a backend, then pass the returned Paystack `authorization_url` to the app.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
