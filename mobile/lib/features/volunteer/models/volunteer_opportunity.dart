class VolunteerOpportunity {
  final String id;
  final String title;
  final String description;
  final String organization;
  final String category;
  final String commitment;
  final String skills;
  final int spots;
  final int applicants;
  final String status; // open, filled, closed
  final String imageUrl;
  final DateTime createdAt;

  VolunteerOpportunity({
    required this.id,
    required this.title,
    required this.description,
    required this.organization,
    required this.category,
    required this.commitment,
    required this.skills,
    required this.spots,
    required this.applicants,
    required this.status,
    required this.imageUrl,
    required this.createdAt,
  });

  factory VolunteerOpportunity.fromJson(Map<String, dynamic> json) {
    return VolunteerOpportunity(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      organization: json['organization'] ?? 'Unknown Organization',
      category: json['category'] ?? 'General',
      commitment: json['commitment'] ?? 'Flexible',
      skills: json['skills'] ?? 'Various skills',
      spots: json['spots'] ?? 0,
      applicants: json['applicants'] ?? 0,
      status: json['status'] ?? 'open',
      imageUrl: json['image_url'] ?? 'https://via.placeholder.com/400x200',
      createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }

  // Sample data for development
  static List<VolunteerOpportunity> getSampleOpportunities() {
    return [
      VolunteerOpportunity(
        id: '1',
        title: 'Digital Skills Trainer',
        description:
            'Teach basic digital literacy skills to programme participants.',
        organization: 'Discipleship Leadership Institution',
        category: 'Teaching',
        commitment: '2 sessions/week, 4 weeks',
        skills: 'Digital literacy, patience, communication',
        spots: 5,
        applicants: 3,
        status: 'open',
        imageUrl:
            'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=400&h=200&fit=crop',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      VolunteerOpportunity(
        id: '2',
        title: 'Mentorship Programme Coordinator',
        description:
            'Coordinate mentorship sessions for participants in the rehabilitation programme.',
        organization: 'Dominion City Prisons Ministry',
        category: 'Mentoring',
        commitment: '1 session/week, 8 weeks',
        skills: 'Mentoring, communication, organisation',
        spots: 3,
        applicants: 2,
        status: 'open',
        imageUrl:
            'https://images.unsplash.com/photo-1511632765486-a01980e01a18?w=400&h=200&fit=crop',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      VolunteerOpportunity(
        id: '3',
        title: 'Vocational Skills Instructor',
        description:
            'Teach vocational skills including carpentry, tailoring, or crafts.',
        organization: 'Golden Heart Foundation',
        category: 'Vocational Training',
        commitment: '3 sessions/week, 6 weeks',
        skills: 'Vocational expertise, teaching experience',
        spots: 4,
        applicants: 1,
        status: 'open',
        imageUrl:
            'https://images.unsplash.com/photo-1523240795612-9a054b0db644?w=400&h=200&fit=crop',
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
      ),
      VolunteerOpportunity(
        id: '4',
        title: 'Admin Support Volunteer',
        description:
            'Provide administrative support to programme coordinators.',
        organization: 'Discipleship Leadership Institution',
        category: 'Administration',
        commitment: '2 sessions/week, flexible',
        skills: 'Administration, organisation, computer skills',
        spots: 2,
        applicants: 4,
        status: 'filled',
        imageUrl:
            'https://images.unsplash.com/photo-1554224155-6726b3ff858f?w=400&h=200&fit=crop',
        createdAt: DateTime.now().subtract(const Duration(days: 14)),
      ),
    ];
  }
}
