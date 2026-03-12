import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

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
        return Icons.local_cafe_outlined;
      case 'bar':
        return Icons.local_bar_outlined;
      case 'fastfood':
        return Icons.fastfood_outlined;
      default:
        return Icons.restaurant_outlined;
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
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_categoryIcon, color: AppColors.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name,
                        style: Theme.of(context).textTheme.titleMedium),
                    if (promotion.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.local_fire_department,
                              size: 14, color: AppColors.secondary),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(promotion,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: AppColors.secondary),
                                overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                    ],
                    if (distance.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined,
                              size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text(distance,
                              style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
