class VolunteerApplication {
  final String id;
  final String opportunityId;
  final String opportunityTitle;
  final String organization;
  final String applicantName;
  final String applicantEmail;
  final String phone;
  final String? message;
  final String status; // pending, under_review, approved, rejected, completed
  final DateTime appliedAt;
  final DateTime? reviewedAt;

  VolunteerApplication({
    required this.id,
    required this.opportunityId,
    required this.opportunityTitle,
    required this.organization,
    required this.applicantName,
    required this.applicantEmail,
    required this.phone,
    this.message,
    required this.status,
    required this.appliedAt,
    this.reviewedAt,
  });

  factory VolunteerApplication.fromJson(Map<String, dynamic> json) {
    return VolunteerApplication(
      id: json['id'],
      opportunityId: json['opportunity_id'],
      opportunityTitle: json['opportunity_title'] ?? 'Unknown Opportunity',
      organization: json['organization'] ?? 'Unknown Organization',
      applicantName: json['applicant_name'],
      applicantEmail: json['applicant_email'],
      phone: json['phone'] ?? '',
      message: json['message'],
      status: json['status'] ?? 'pending',
      appliedAt: DateTime.parse(
          json['applied_at'] ?? DateTime.now().toIso8601String()),
      reviewedAt: json['reviewed_at'] != null
          ? DateTime.parse(json['reviewed_at'])
          : null,
    );
  }

  // Sample data for development
  static List<VolunteerApplication> getSampleApplications() {
    return [
      VolunteerApplication(
        id: '1',
        opportunityId: '1',
        opportunityTitle: 'Digital Skills Trainer',
        organization: 'Discipleship Leadership Institution',
        applicantName: 'John Doe',
        applicantEmail: 'john@example.com',
        phone: '08012345678',
        message:
            'I have 5 years of experience teaching digital literacy and am passionate about helping others learn.',
        status: 'under_review',
        appliedAt: DateTime.now().subtract(const Duration(days: 3)),
        reviewedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      VolunteerApplication(
        id: '2',
        opportunityId: '2',
        opportunityTitle: 'Mentorship Programme Coordinator',
        organization: 'Dominion City Prisons Ministry',
        applicantName: 'Jane Smith',
        applicantEmail: 'jane@example.com',
        phone: '08087654321',
        message:
            'I have experience mentoring young people and coordinating community programmes.',
        status: 'approved',
        appliedAt: DateTime.now().subtract(const Duration(days: 10)),
        reviewedAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
      VolunteerApplication(
        id: '3',
        opportunityId: '3',
        opportunityTitle: 'Vocational Skills Instructor',
        organization: 'Golden Heart Foundation',
        applicantName: 'Michael Johnson',
        applicantEmail: 'michael@example.com',
        phone: '08011223344',
        message:
            'I am a trained carpenter with 10 years of experience and would love to teach vocational skills.',
        status: 'pending',
        appliedAt: DateTime.now().subtract(const Duration(days: 1)),
        reviewedAt: null,
      ),
      VolunteerApplication(
        id: '4',
        opportunityId: '4',
        opportunityTitle: 'Admin Support Volunteer',
        organization: 'Discipleship Leadership Institution',
        applicantName: 'Sarah Williams',
        applicantEmail: 'sarah@example.com',
        phone: '08055667788',
        message:
            'I have strong organizational skills and experience in administrative support.',
        status: 'rejected',
        appliedAt: DateTime.now().subtract(const Duration(days: 14)),
        reviewedAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
      VolunteerApplication(
        id: '5',
        opportunityId: '5',
        opportunityTitle: 'ICT Trainer',
        organization: 'Golden Heart Foundation',
        applicantName: 'David Obi',
        applicantEmail: 'david@example.com',
        phone: '08099887766',
        message:
            'I am an IT professional with 8 years of experience. I want to share my knowledge.',
        status: 'completed',
        appliedAt: DateTime.now().subtract(const Duration(days: 30)),
        reviewedAt: DateTime.now().subtract(const Duration(days: 25)),
      ),
    ];
  }
}
