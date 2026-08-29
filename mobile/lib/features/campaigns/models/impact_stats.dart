class ImpactStats {
  final int peopleSupported;
  final int peopleTrained;
  final int projectsCompleted;
  final int facilitiesSupported;
  final int totalRaised;

  ImpactStats({
    required this.peopleSupported,
    required this.peopleTrained,
    required this.projectsCompleted,
    required this.facilitiesSupported,
    required this.totalRaised,
  });

  factory ImpactStats.fromJson(Map<String, dynamic> json) {
    return ImpactStats(
      peopleSupported: json['people_supported'] ?? 0,
      peopleTrained: json['people_trained'] ?? 0,
      projectsCompleted: json['projects_completed'] ?? 0,
      facilitiesSupported: json['facilities_supported'] ?? 0,
      totalRaised: json['total_raised'] ?? 0,
    );
  }

  // Sample data for development
  static ImpactStats getSample() {
    return ImpactStats(
      peopleSupported: 1250,
      peopleTrained: 380,
      projectsCompleted: 12,
      facilitiesSupported: 8,
      totalRaised: 12400000,
    );
  }
}
