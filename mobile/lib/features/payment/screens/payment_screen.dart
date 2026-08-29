import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/payment_service.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/screens/login_screen.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  final int amount;
  final String campaignId;
  final String campaignTitle;

  const PaymentScreen({
    super.key,
    required this.amount,
    required this.campaignId,
    required this.campaignTitle,
  });

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  bool _isProcessing = false;
  String _paymentStatus = '';

  static const _publicKey = String.fromEnvironment(
    'PAYSTACK_PUBLIC_KEY',
    defaultValue: 'pk_test_5ef876d32e5923550707f5026cd301c1fc522800',
  );
  static const _secretKey = String.fromEnvironment('PAYSTACK_SECRET_KEY');
  static const _callbackUrl = String.fromEnvironment(
    'PAYSTACK_CALLBACK_URL',
    defaultValue: 'https://standard.paystack.co/close',
  );

  @override
  void initState() {
    super.initState();
    _initializePayment();
  }

  Future<void> _initializePayment() async {
    final authState = ref.read(authProvider);
    if (!authState.isAuthenticated || authState.user == null) {
      setState(() {
        _paymentStatus = 'Please sign in to continue';
      });
      return;
    }

    setState(() {
      _isProcessing = true;
      _paymentStatus = 'Initializing payment...';
    });

    try {
      // Generate unique reference
      final reference = 'HAP-${DateTime.now().millisecondsSinceEpoch}';

      // Amount in kobo (multiply by 100)
      final amountInKobo = widget.amount * 100;

      if (kIsWeb && _publicKey.isEmpty) {
        throw StateError('PAYSTACK_PUBLIC_KEY is missing for web payments.');
      }
      if (!kIsWeb && _secretKey.isEmpty) {
        throw StateError(
          'PAYSTACK_SECRET_KEY is missing for mobile payments. Use a backend '
          'authorization URL instead for production.',
        );
      }

      await PaymentService().startPayment(
        context: context,
        customerEmail: authState.user!.email,
        amount: amountInKobo.toString(),
        reference: reference,
        publicKey: _publicKey.isEmpty ? null : _publicKey,
        secretKey: _secretKey.isEmpty ? null : _secretKey,
        callBackUrl: _callbackUrl,
        currency: 'NGN',
        onSuccess: () {
          if (mounted) {
            setState(() {
              _paymentStatus = 'Payment successful! ✅';
            });
            Future.delayed(const Duration(seconds: 1), () {
              if (mounted) {
                _showSuccessDialog(context);
              }
            });
          }
        },
        onClosed: () {
          if (mounted) {
            setState(() {
              _isProcessing = false;
              _paymentStatus = 'Payment closed or cancelled.';
            });
          }
        },
      );

      // If we get here and onSuccess wasn't called, payment was closed
      if (mounted) {
        setState(() {
          _isProcessing = false;
          if (!_paymentStatus.contains('successful')) {
            _paymentStatus = 'Payment was not completed.';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _paymentStatus = 'Error: $e';
        });
      }
      debugPrint('Payment error: $e');
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 40,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Payment Successful!',
              style: TextStyle(
                fontFamily: 'Georgia',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Your donation has been received.',
              style: TextStyle(
                fontFamily: 'Georgia',
                color: Color(0xFF4A5A6A),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    '₦${widget.amount.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD4AF37),
                      fontFamily: 'Georgia',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.campaignTitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontFamily: 'Georgia',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text(
              'Done',
              style: TextStyle(
                color: Color(0xFFD4AF37),
                fontFamily: 'Georgia',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Payment',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0D1B2A),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Amount Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Donation Amount',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF4A5A6A),
                      fontFamily: 'Georgia',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '₦${widget.amount.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0D1B2A),
                      fontFamily: 'Georgia',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.campaignTitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontFamily: 'Georgia',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Status Message
            if (_paymentStatus.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _paymentStatus.contains('successful') ||
                          _paymentStatus.contains('✅')
                      ? Colors.green.withValues(alpha: 0.1)
                      : _paymentStatus.contains('failed') ||
                              _paymentStatus.contains('Error')
                          ? Colors.red.withValues(alpha: 0.1)
                          : Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      _paymentStatus.contains('successful') ||
                              _paymentStatus.contains('✅')
                          ? Icons.check_circle
                          : _paymentStatus.contains('failed') ||
                                  _paymentStatus.contains('Error')
                              ? Icons.error_outline
                              : Icons.info_outline,
                      color: _paymentStatus.contains('successful') ||
                              _paymentStatus.contains('✅')
                          ? Colors.green
                          : _paymentStatus.contains('failed') ||
                                  _paymentStatus.contains('Error')
                              ? Colors.red
                              : Colors.orange,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _paymentStatus,
                        style: TextStyle(
                          fontFamily: 'Georgia',
                          fontSize: 14,
                          color: _paymentStatus.contains('successful') ||
                                  _paymentStatus.contains('✅')
                              ? Colors.green[700]
                              : _paymentStatus.contains('failed') ||
                                      _paymentStatus.contains('Error')
                                  ? Colors.red[700]
                                  : Colors.orange[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 24),

            // Auth Check
            if (!authState.isAuthenticated)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.lock_outline,
                        size: 48,
                        color: Color(0xFFD4AF37),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Please sign in to make a donation',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Georgia',
                          color: Color(0xFF4A5A6A),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            fontFamily: 'Georgia',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Loading Indicator
            if (_isProcessing)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CircularProgressIndicator(
                      color: Color(0xFFD4AF37),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Processing payment...',
                      style: TextStyle(
                        fontFamily: 'Georgia',
                        color: Color(0xFF4A5A6A),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
