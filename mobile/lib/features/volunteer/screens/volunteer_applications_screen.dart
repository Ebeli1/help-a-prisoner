import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/volunteer_opportunity.dart';
import '../models/volunteer_application.dart';

class VolunteerApplicationsScreen extends ConsumerStatefulWidget {
  final VolunteerOpportunity? opportunity;

  const VolunteerApplicationsScreen({super.key, this.opportunity});

  @override
  ConsumerState<VolunteerApplicationsScreen> createState() =>
      _VolunteerApplicationsScreenState();
}

class _VolunteerApplicationsScreenState
    extends ConsumerState<VolunteerApplicationsScreen> {
  List<VolunteerApplication> _applications = [];

  @override
  void initState() {
    super.initState();
    _loadApplications();
  }

  void _loadApplications() {
    // In a real app, this would come from an API
    _applications = VolunteerApplication.getSampleApplications();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Volunteer Applications',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0D1B2A),
        elevation: 0,
      ),
      body: _applications.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _applications.length,
              itemBuilder: (context, index) {
                final application = _applications[index];
                return _buildApplicationCard(application);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
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
                Icons.volunteer_activism,
                size: 50,
                color: Color(0xFFD4AF37),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No Applications Yet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Georgia',
                color: Color(0xFF0D1B2A),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'You haven\'t applied to any volunteer opportunities yet.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontFamily: 'Georgia',
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/volunteer');
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
                'Browse Opportunities',
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplicationCard(VolunteerApplication application) {
    Color statusColor;
    IconData statusIcon;
    String statusText;

    switch (application.status) {
      case 'pending':
        statusColor = Colors.orange;
        statusIcon = Icons.pending;
        statusText = 'Pending Review';
        break;
      case 'under_review':
        statusColor = Colors.blue;
        statusIcon = Icons.visibility;
        statusText = 'Under Review';
        break;
      case 'approved':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        statusText = 'Approved';
        break;
      case 'rejected':
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        statusText = 'Not Selected';
        break;
      case 'completed':
        statusColor = Colors.purple;
        statusIcon = Icons.flag;
        statusText = 'Completed';
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.info;
        statusText = 'Unknown';
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    application.opportunityTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Georgia',
                      color: Color(0xFF0D1B2A),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 14, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        statusText,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: statusColor,
                          fontFamily: 'Georgia',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(
                  Icons.business_center,
                  size: 14,
                  color: Color(0xFF4A5A6A),
                ),
                const SizedBox(width: 4),
                Text(
                  application.organization,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF4A5A6A),
                    fontFamily: 'Georgia',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 14,
                  color: Color(0xFF4A5A6A),
                ),
                const SizedBox(width: 4),
                Text(
                  'Applied: ${_formatDate(application.appliedAt)}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF4A5A6A),
                    fontFamily: 'Georgia',
                  ),
                ),
                const SizedBox(width: 16),
                if (application.reviewedAt != null)
                  Row(
                    children: [
                      const Icon(
                        Icons.history,
                        size: 14,
                        color: Color(0xFF4A5A6A),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Reviewed: ${_formatDate(application.reviewedAt!)}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF4A5A6A),
                          fontFamily: 'Georgia',
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            if (application.message != null &&
                application.message!.isNotEmpty) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '"${application.message}"',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    fontFamily: 'Georgia',
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
