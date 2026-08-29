class Donation {
  final String id;
  final String campaignId;
  final String campaignTitle;
  final int amount;
  final String currency;
  final String status; // pending, successful, failed, refunded
  final DateTime createdAt;
  final String? transactionReference;

  Donation({
    required this.id,
    required this.campaignId,
    required this.campaignTitle,
    required this.amount,
    this.currency = 'NGN',
    required this.status,
    required this.createdAt,
    this.transactionReference,
  });

  String get formattedAmount => '₦${(amount / 1000).toStringAsFixed(0)}K';

  factory Donation.fromJson(Map<String, dynamic> json) {
    return Donation(
      id: json['id'],
      campaignId: json['campaign_id'],
      campaignTitle: json['campaign_title'] ?? 'Unknown Campaign',
      amount: json['amount'] ?? 0,
      currency: json['currency'] ?? 'NGN',
      status: json['status'] ?? 'pending',
      createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String()),
      transactionReference: json['transaction_reference'],
    );
  }

  // Sample donations for development
  static List<Donation> getSampleDonations() {
    return [
      Donation(
        id: '1',
        campaignId: '1',
        campaignTitle: 'Build Digital Skills Centre',
        amount: 10000,
        status: 'successful',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        transactionReference: 'PSK_123456',
      ),
      Donation(
        id: '2',
        campaignId: '2',
        campaignTitle: 'Vocational Training Equipment',
        amount: 5000,
        status: 'successful',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        transactionReference: 'PSK_123457',
      ),
      Donation(
        id: '3',
        campaignId: '3',
        campaignTitle: 'Educational Materials for Prisoners',
        amount: 25000,
        status: 'pending',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        transactionReference: 'PSK_123458',
      ),
      Donation(
        id: '4',
        campaignId: '4',
        campaignTitle: 'ICT Centre for Prisoners',
        amount: 15000,
        status: 'successful',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        transactionReference: 'PSK_123459',
      ),
      Donation(
        id: '5',
        campaignId: '5',
        campaignTitle: 'Food & Welfare Support',
        amount: 2000,
        status: 'failed',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        transactionReference: 'PSK_123460',
      ),
    ];
  }
}
