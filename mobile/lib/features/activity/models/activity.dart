class Activity {
  final String id;
  final String type; // donation, campaign_follow, volunteer_apply, etc.
  final String title;
  final String description;
  final String? campaignId;
  final String? opportunityId;
  final int? amount;
  final String status; // pending, successful, failed, completed, etc.
  final DateTime createdAt;
  final String icon; // icon name for display

  Activity({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    this.campaignId,
    this.opportunityId,
    this.amount,
    required this.status,
    required this.createdAt,
    required this.icon,
  });

  factory Activity.fromDonation({
    required String id,
    required String campaignTitle,
    required int amount,
    required String status,
    required DateTime createdAt,
  }) {
    String statusLabel = status == 'successful' ? 'Completed' : status;
    return Activity(
      id: id,
      type: 'donation',
      title: 'Donation Made',
      description: '₦${(amount / 1000).toStringAsFixed(0)}K to $campaignTitle',
      campaignId: id,
      amount: amount,
      status: statusLabel,
      createdAt: createdAt,
      icon: 'favorite',
    );
  }

  factory Activity.fromVolunteerApplication({
    required String id,
    required String opportunityTitle,
    required String status,
    required DateTime createdAt,
  }) {
    return Activity(
      id: id,
      type: 'volunteer_apply',
      title: 'Volunteer Application',
      description: 'Applied to: $opportunityTitle',
      opportunityId: id,
      status: status,
      createdAt: createdAt,
      icon: 'volunteer_activism',
    );
  }

  factory Activity.fromCampaignFollow({
    required String id,
    required String campaignTitle,
    required DateTime createdAt,
  }) {
    return Activity(
      id: id,
      type: 'campaign_follow',
      title: 'Following Campaign',
      description: 'You started following $campaignTitle',
      campaignId: id,
      status: 'active',
      createdAt: createdAt,
      icon: 'bookmark',
    );
  }

  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} minutes ago';
      }
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${createdAt.month}/${createdAt.day}/${createdAt.year}';
    }
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'title': title,
        'description': description,
        'campaign_id': campaignId,
        'opportunity_id': opportunityId,
        'amount': amount,
        'status': status,
        'created_at': createdAt.toIso8601String(),
        'icon': icon,
      };
}
