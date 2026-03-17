import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class VenueCard extends StatelessWidget {
  final String name;
  final String promotion;
  final String distance;
  final String category;
  final VoidCallback? onTap;

  const VenueCard({
    super.key,
    this.name = 'Venue',
    this.promotion = '',
    this.distance = '',
    this.category = 'restaurant',
    this.onTap,
  });

  IconData get _categoryIcon {
    switch (category) {
      case 'cafe':
        return PhosphorIconsRegular.coffee;
      case 'bar':
        return PhosphorIconsRegular.wine;
      case 'fastfood':
        return PhosphorIconsRegular.hamburger;
      default:
        return PhosphorIconsRegular.forkKnife;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.backgroundTertiary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_categoryIcon, color: AppColors.accentGold),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: AppTextStyles.titleMedium),
                    if (promotion.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(PhosphorIconsRegular.flame,
                              size: 14, color: AppColors.accentGoldLight),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              promotion,
                              style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.accentGoldLight),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (distance.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(PhosphorIconsRegular.mapPin,
                              size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(distance, style: AppTextStyles.bodyMedium),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
