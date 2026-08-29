import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/activity.dart';
import '../../give/models/donation.dart';
import '../../volunteer/models/volunteer_application.dart';

// Activity state notifier
class ActivityNotifier extends StateNotifier<List<Activity>> {
  ActivityNotifier() : super([]) {
    _loadSampleActivities();
  }

  void _loadSampleActivities() {
    // Load sample donations
    final donations = Donation.getSampleDonations();
    final donationActivities = donations.map((donation) {
      return Activity.fromDonation(
        id: donation.id,
        campaignTitle: donation.campaignTitle,
        amount: donation.amount,
        status: donation.status,
        createdAt: donation.createdAt,
      );
    }).toList();

    // Load sample volunteer applications
    final applications = VolunteerApplication.getSampleApplications();
    final volunteerActivities = applications.map((app) {
      return Activity.fromVolunteerApplication(
        id: app.id,
        opportunityTitle: app.opportunityTitle,
        status: app.status,
        createdAt: app.appliedAt,
      );
    }).toList();

    // Combine and sort by date (newest first)
    final allActivities = [...donationActivities, ...volunteerActivities];
    allActivities.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    state = allActivities;
  }

  void addActivity(Activity activity) {
    state = [activity, ...state];
  }

  void recordDonation({
    required String campaignTitle,
    required int amount,
    required String status,
  }) {
    final activity = Activity.fromDonation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      campaignTitle: campaignTitle,
      amount: amount,
      status: status,
      createdAt: DateTime.now(),
    );
    addActivity(activity);
  }

  void recordVolunteerApplication({
    required String opportunityTitle,
    required String status,
  }) {
    final activity = Activity.fromVolunteerApplication(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      opportunityTitle: opportunityTitle,
      status: status,
      createdAt: DateTime.now(),
    );
    addActivity(activity);
  }

  void recordCampaignFollow({
    required String campaignTitle,
  }) {
    final activity = Activity.fromCampaignFollow(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      campaignTitle: campaignTitle,
      createdAt: DateTime.now(),
    );
    addActivity(activity);
  }

  int getTotalDonated() {
    return state
        .where((a) => a.type == 'donation' && a.status == 'Completed')
        .fold(0, (sum, a) => sum + (a.amount ?? 0));
  }

  int getCampaignCount() {
    return state
        .where((a) => a.type == 'campaign_follow' || a.type == 'donation')
        .toSet()
        .length;
  }

  int getVolunteerCount() {
    return state.where((a) => a.type == 'volunteer_apply').length;
  }
}

// Activity provider
final activityProvider =
    StateNotifierProvider<ActivityNotifier, List<Activity>>((ref) {
  return ActivityNotifier();
});

// Activity stats provider
final activityStatsProvider = Provider<Map<String, dynamic>>((ref) {
  final activities = ref.watch(activityProvider);
  final notifier = ref.read(activityProvider.notifier);

  return {
    'totalDonated': notifier.getTotalDonated(),
    'campaignCount': notifier.getCampaignCount(),
    'volunteerCount': notifier.getVolunteerCount(),
    'totalActivities': activities.length,
  };
});
