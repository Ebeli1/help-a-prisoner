import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_paystack_plus/flutter_paystack_plus.dart';
import '../../campaigns/models/campaign.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/screens/login_screen.dart';
import '../../volunteer/screens/volunteer_screen.dart';
import '../widgets/donation_amount_button.dart';
import '../widgets/donation_success_dialog.dart';


class GiveScreen extends ConsumerStatefulWidget {
  final Campaign? campaign;

  const GiveScreen({
    super.key,
    this.campaign,
  });

  @override
  ConsumerState<GiveScreen> createState() => _GiveScreenState();
}

class _GiveScreenState extends ConsumerState<GiveScreen> {
  // Donation state
  int _selectedAmount = 0;
  final TextEditingController _customAmountController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool _isCustomAmount = false;
  bool _isAnonymous = false;
  bool _isLoading = false;

  // Available donation amounts
  final List<int> _amounts = [1000, 5000, 10000, 25000];

  late final Campaign _selectedCampaign;

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
    _selectedCampaign = widget.campaign ?? Campaign.getSampleCampaigns().first;
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isAuthenticated = authState.isAuthenticated;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Give',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0D1B2A),
        elevation: 0,
      ),
      body:
          isAuthenticated ? _buildDonorView(context) : _buildGuestView(context),
    );
  }

  Widget _buildGuestView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_outline,
                size: 50,
                color: Color(0xFFD4AF37),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Make a Difference',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Georgia',
                color: Color(0xFF0D1B2A),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Sign in to donate to campaigns, support rehabilitation programmes, and track your impact.',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF4A5A6A),
                fontFamily: 'Georgia',
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
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
                  horizontal: 40,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Sign in / Sign up',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Georgia',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDonorView(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Campaign Info
          _buildCampaignInfo(),
          const SizedBox(height: 20),

          // Quick Amounts
          const Text(
            'Select Amount',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D1B2A),
              fontFamily: 'Georgia',
            ),
          ),
          const SizedBox(height: 10),
          _buildAmountGrid(),
          const SizedBox(height: 14),

          // Custom Amount
          _buildCustomAmount(),
          const SizedBox(height: 20),

          // Optional Message
          _buildMessageField(),
          const SizedBox(height: 14),

          // Anonymous Toggle
          _buildAnonymousToggle(),
          const SizedBox(height: 20),

          // Donate Button
          _buildDonateButton(context),
          const SizedBox(height: 16),

          // Volunteer Section
          const Divider(height: 40),
          _buildVolunteerSection(context),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildCampaignInfo() {
    return Container(
      padding: const EdgeInsets.all(14),
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
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              _selectedCampaign.imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 50,
                  height: 50,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image, color: Colors.grey, size: 24),
                );
              },
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedCampaign.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D1B2A),
                    fontFamily: 'Georgia',
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(
                      Icons.business_center,
                      size: 12,
                      color: Color(0xFF4A5A6A),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        _selectedCampaign.organizationName,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                          fontFamily: 'Georgia',
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.5,
      ),
      itemCount: _amounts.length,
      itemBuilder: (context, index) {
        final amount = _amounts[index];
        final isSelected = _selectedAmount == amount && !_isCustomAmount;
        return DonationAmountButton(
          amount: amount,
          isSelected: isSelected,
          onTap: () {
            setState(() {
              _selectedAmount = amount;
              _isCustomAmount = false;
              _customAmountController.clear();
            });
          },
        );
      },
    );
  }

  Widget _buildCustomAmount() {
    return TextField(
      controller: _customAmountController,
      keyboardType: TextInputType.number,
      onChanged: (value) {
        setState(() {
          _isCustomAmount = value.isNotEmpty;
          _selectedAmount = int.tryParse(value) ?? 0;
        });
      },
      decoration: InputDecoration(
        hintText: 'Enter custom amount (₦)',
        hintStyle: TextStyle(
          color: Colors.grey[400],
          fontFamily: 'Georgia',
        ),
        prefixIcon: const Icon(
          Icons.money,
          color: Color(0xFFD4AF37),
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFD4AF37), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
      ),
    );
  }

  Widget _buildMessageField() {
    return TextField(
      controller: _messageController,
      maxLines: 2,
      decoration: InputDecoration(
        hintText: 'Optional message (e.g. "Keep going!")',
        hintStyle: TextStyle(
          color: Colors.grey[400],
          fontFamily: 'Georgia',
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFD4AF37), width: 2),
        ),
        contentPadding: const EdgeInsets.all(14),
      ),
    );
  }

  Widget _buildAnonymousToggle() {
    return Row(
      children: [
        Checkbox(
          value: _isAnonymous,
          onChanged: (value) {
            setState(() {
              _isAnonymous = value ?? false;
            });
          },
          activeColor: const Color(0xFFD4AF37),
        ),
        const Text(
          'Donate anonymously',
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Georgia',
            color: Color(0xFF4A5A6A),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // 🔥 SIMPLIFIED PAYSTACK DONATION BUTTON
  // ============================================================
  Widget _buildDonateButton(BuildContext context) {
    final bool hasAmount = _selectedAmount > 0 || _isCustomAmount;
    final authState = ref.watch(authProvider);

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading || !hasAmount
            ? null
            : () async {
                // Check if user is authenticated
                if (!authState.isAuthenticated) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please sign in to donate'),
                      backgroundColor: Color(0xFFD4AF37),
                    ),
                  );
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                  return;
                }

                setState(() => _isLoading = true);

                try {
                  // Generate unique reference
                  final reference =
                      'HAP-${DateTime.now().millisecondsSinceEpoch}';

                  // Amount in kobo (multiply by 100)
                  final donatedAmount = _selectedAmount;
                  final amountInKobo = donatedAmount * 100;

                  if (kIsWeb && _publicKey.isEmpty) {
                    throw StateError(
                      'PAYSTACK_PUBLIC_KEY is missing for web payments.',
                    );
                  }
                  if (!kIsWeb && _secretKey.isEmpty) {
                    throw StateError(
                      'PAYSTACK_SECRET_KEY is missing for mobile payments.',
                    );
                  }

                  await FlutterPaystackPlus.openPaystackPopup(
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
                        setState(() => _isLoading = false);

                        // Show success dialog
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => DonationSuccessDialog(
                            amount: donatedAmount,
                            campaign: _selectedCampaign,
                            donationId: reference,
                          ),
                        );

                        // Clear the form
                        _customAmountController.clear();
                        _messageController.clear();
                        setState(() {
                          _selectedAmount = 0;
                          _isCustomAmount = false;
                        });
                      }
                    },
                    onClosed: () {
                      if (mounted) {
                        setState(() => _isLoading = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Payment was cancelled or closed.'),
                            duration: Duration(seconds: 2),
                            backgroundColor: Color(0xFF4A5A6A),
                          ),
                        );
                      }
                    },
                  );
                } catch (e) {
                  if (!mounted) {
                    return;
                  }
                  setState(() => _isLoading = false);
                  ScaffoldMessenger.of(this.context).showSnackBar(
                    SnackBar(
                      content: Text('Payment error: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  debugPrint('Payment error: $e');
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD4AF37),
          foregroundColor: const Color(0xFF0D1B2A),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          disabledBackgroundColor: Colors.grey[300],
        ),
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFF0D1B2A),
                ),
              )
            : Text(
                hasAmount
                    ? 'Donate ₦${_selectedAmount.toStringAsFixed(0)}'
                    : 'Select an amount to donate',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Georgia',
                ),
              ),
      ),
    );
  }

  Widget _buildVolunteerSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Want to Volunteer?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0D1B2A),
            fontFamily: 'Georgia',
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Share your skills and make a difference.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontFamily: 'Georgia',
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              _navigateToVolunteer(context);
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFD4AF37)),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'Explore Volunteer Opportunities',
              style: TextStyle(
                color: Color(0xFFD4AF37),
                fontFamily: 'Georgia',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _navigateToVolunteer(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const VolunteerScreen(),
      ),
    );
  }
}
