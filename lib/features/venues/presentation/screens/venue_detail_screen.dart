import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class VenueDetailScreen extends StatelessWidget {
  final String venueId;
  const VenueDetailScreen({super.key, required this.venueId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Venue Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Icon(Icons.restaurant_outlined,
                    size: 72, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 20),
            Text('Kafana Zlatni Bor',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text('Beograd, Srbija',
                    style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(width: 12),
                const Icon(Icons.directions_walk,
                    size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text('0.3 km',
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
            const SizedBox(height: 20),
            _sectionHeader('Active Promotion'),
            const SizedBox(height: 8),
            _promoCard(context),
            const SizedBox(height: 20),
            _sectionHeader('Rewards'),
            const SizedBox(height: 8),
            _rewardRow(context, 'Free Coffee', 100),
            _rewardRow(context, 'Free Dessert', 200),
            _rewardRow(context, '10% Discount', 300),
            const SizedBox(height: 20),
            _sectionHeader('Point Formula'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calculate_outlined,
                      color: AppColors.primary, size: 20),
                  const SizedBox(width: 12),
                  Text('points = bill × 0.1',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontFamily: 'monospace')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(title,
        style: const TextStyle(
            color: AppColors.onSurface,
            fontWeight: FontWeight.w600,
            fontSize: 15));
  }

  Widget _promoCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 107, 53, 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color.fromRGBO(255, 107, 53, 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_fire_department, color: AppColors.secondary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Double points this weekend!',
                    style: TextStyle(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w600)),
                Text('Valid Sat & Sun only',
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _rewardRow(BuildContext context, String name, int pts) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          const Icon(Icons.card_giftcard_outlined,
              size: 20, color: AppColors.secondary),
          const SizedBox(width: 12),
          Expanded(
              child: Text(name,
                  style: Theme.of(context).textTheme.bodyMedium)),
          Text('$pts pts',
              style: const TextStyle(
                  color: AppColors.secondary, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
