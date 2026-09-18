import 'package:flutter/material.dart';
import '../models/campaign.dart';

class _Palette {
  static const navy = Color(0xFF0D1B2A);
  static const gold = Color(0xFFD4AF37);
}

class CampaignCard extends StatelessWidget {
  final Campaign campaign;
  final VoidCallback onTap;

  const CampaignCard({
    super.key,
    required this.campaign,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashColor: _Palette.gold.withValues(alpha: 0.08),
          highlightColor: _Palette.gold.withValues(alpha: 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImage(),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBadges(),
                    const SizedBox(height: 10),
                    Text(
                      campaign.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: _Palette.navy,
                        fontFamily: 'Georgia',
                        height: 1.25,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.corporate_fare_rounded,
                            size: 14, color: Colors.grey[500]),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            campaign.organizationName,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                              fontFamily: 'Georgia',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _buildProgress(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return Stack(
      children: [
        Image.network(
          campaign.imageUrl,
          height: 150,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 150,
              color: Colors.grey[200],
              child: const Icon(
                Icons.image_not_supported_outlined,
                size: 36,
                color: Colors.grey,
              ),
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              height: 150,
              color: Colors.grey[100],
              child: const Center(
                child: SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    color: _Palette.gold,
                  ),
                ),
              ),
            );
          },
        ),
        // Subtle bottom fade so any future overlay content stays legible.
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.12),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBadges() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: _Palette.gold.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            campaign.category,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: _Palette.gold,
              fontFamily: 'Georgia',
              letterSpacing: 0.2,
            ),
          ),
        ),
        const SizedBox(width: 8),
        if (campaign.status == 'funded')
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle_rounded, size: 12, color: Colors.green),
                SizedBox(width: 4),
                Text(
                  'Funded',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.green,
                    fontFamily: 'Georgia',
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildProgress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              campaign.formattedRaised,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: _Palette.navy,
                fontFamily: 'Georgia',
              ),
            ),
            Text(
              campaign.formattedProgress,
              style: const TextStyle(
                fontSize: 13.5,
                color: _Palette.gold,
                fontWeight: FontWeight.w700,
                fontFamily: 'Georgia',
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: campaign.progress,
            backgroundColor: Colors.grey[200],
            color: _Palette.gold,
            minHeight: 7,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Target: ${campaign.formattedTarget}',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[500],
            fontFamily: 'Georgia',
          ),
        ),
      ],
    );
  }
}
