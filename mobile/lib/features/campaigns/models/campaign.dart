class Campaign {
  final String id;
  final String title;
  final String description;
  final String category;
  final String organizationName;
  final String organizationId;
  final String imageUrl;
  final int targetAmount;
  final int raisedAmount;
  final String status; // active, funded, completed
  final bool isFeatured;
  final DateTime createdAt;
  final DateTime? endDate;

  Campaign({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.organizationName,
    required this.organizationId,
    required this.imageUrl,
    required this.targetAmount,
    required this.raisedAmount,
    required this.status,
    this.isFeatured = false,
    required this.createdAt,
    this.endDate,
  });

  double get progress {
    if (targetAmount == 0) return 0;
    return (raisedAmount / targetAmount).clamp(0.0, 1.0);
  }

  String get formattedProgress => '${(progress * 100).toStringAsFixed(0)}%';

  String get formattedRaised => '₦${(raisedAmount / 1000).toStringAsFixed(0)}K';
  String get formattedTarget => '₦${(targetAmount / 1000).toStringAsFixed(0)}K';

  factory Campaign.fromJson(Map<String, dynamic> json) {
    return Campaign(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      category: json['category'] ?? 'General',
      organizationName: json['organization_name'] ?? 'Unknown Organization',
      organizationId: json['organization_id'] ?? '',
      imageUrl: json['image_url'] ?? 'https://via.placeholder.com/400x200',
      targetAmount: json['target_amount'] ?? 0,
      raisedAmount: json['raised_amount'] ?? 0,
      status: json['status'] ?? 'active',
      isFeatured: json['is_featured'] ?? false,
      createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String()),
      endDate:
          json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
    );
  }

  // Sample data for development
  static List<Campaign> getSampleCampaigns() {
    return [
      Campaign(
        id: '1',
        title: 'Build Digital Skills Centre',
        description:
            'Help us build a modern digital skills centre at Port Harcourt Correctional Centre.',
        category: 'Training',
        organizationName: 'Discipleship Leadership Institution',
        organizationId: 'org1',
        imageUrl:
            'https://images.unsplash.com/photo-1497366216548-37526070297c?w=400&h=200&fit=crop',
        targetAmount: 5000000,
        raisedAmount: 3200000,
        status: 'active',
        isFeatured: true,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
      Campaign(
        id: '2',
        title: 'Vocational Training Equipment',
        description:
            'Provide vocational training equipment for 50 participants.',
        category: 'Training',
        organizationName: 'Golden Heart Foundation',
        organizationId: 'org2',
        imageUrl:
            'https://images.unsplash.com/photo-1531482615713-2afd69097998?w=400&h=200&fit=crop',
        targetAmount: 3000000,
        raisedAmount: 1200000,
        status: 'active',
        isFeatured: false,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Campaign(
        id: '3',
        title: 'Educational Materials for Prisoners',
        description:
            'Provide books, stationery, and learning materials for 100 prisoners.',
        category: 'Education',
        organizationName: 'Dominion City Prisons Ministry',
        organizationId: 'org3',
        imageUrl:
            'https://images.unsplash.com/photo-1503676260728-1c00da094a0b?w=400&h=200&fit=crop',
        targetAmount: 1500000,
        raisedAmount: 1500000,
        status: 'funded',
        isFeatured: false,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      Campaign(
        id: '4',
        title: 'ICT Centre for Prisoners',
        description:
            'Build an ICT centre with 20 computers for digital literacy training.',
        category: 'Infrastructure',
        organizationName: 'Golden Heart Foundation',
        organizationId: 'org2',
        imageUrl:
            'https://images.unsplash.com/photo-1497366811353-6870744d04b2?w=400&h=200&fit=crop',
        targetAmount: 8000000,
        raisedAmount: 4500000,
        status: 'active',
        isFeatured: false,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
      Campaign(
        id: '5',
        title: 'Food & Welfare Support',
        description:
            'Provide essential food supplies and welfare items to 200 prisoners.',
        category: 'Welfare',
        organizationName: 'Dominion City Prisons Ministry',
        organizationId: 'org3',
        imageUrl:
            'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=400&h=200&fit=crop',
        targetAmount: 2000000,
        raisedAmount: 800000,
        status: 'active',
        isFeatured: false,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
    ];
  }
}
