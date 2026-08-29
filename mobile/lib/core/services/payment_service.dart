import 'package:flutter/material.dart';
import 'package:flutter_paystack_plus/flutter_paystack_plus.dart';

class PaymentService {
  static final PaymentService _instance = PaymentService._internal();
  factory PaymentService() => _instance;
  PaymentService._internal();

  Future<void> startPayment({
    required String customerEmail,
    required String amount,
    required String reference,
    required BuildContext context,
    String? publicKey,
    String? secretKey,
    String? authorizationUrl,
    String? callBackUrl,
    String? currency,
    required VoidCallback onSuccess,
    required VoidCallback onClosed,
  }) async {
    await FlutterPaystackPlus.openPaystackPopup(
      context: context,
      customerEmail: customerEmail,
      amount: amount,
      reference: reference,
      publicKey: publicKey,
      secretKey: secretKey,
      authorizationUrl: authorizationUrl,
      callBackUrl: callBackUrl,
      currency: currency,
      onSuccess: onSuccess,
      onClosed: onClosed,
    );
  }
}
