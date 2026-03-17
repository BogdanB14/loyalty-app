import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

final _mockRewards = [
  {
    'name': 'Free Coffee',
    'venue': 'Caffe Bar Lav',
    'points': 100,
    'description': 'One espresso or filter coffee',
    'icon': PhosphorIconsRegular.coffee,
  },
  {
    'name': 'Free Dessert',
    'venue': 'Kafana Zlatni Bor',
    'points': 200,
    'description': 'Choose any dessert from the menu',
    'icon': PhosphorIconsRegular.cake,
  },
  {
    'name': 'Free Fries',
    'venue': 'McBurger Beograd',
    'points': 150,
    'description': 'Medium portion of fries',
    'icon': PhosphorIconsRegular.hamburger,
  },
  {
    'name': '10% Discount',
    'venue': 'Restoran Šaran',
    'points': 300,
    'description': 'On your total bill',
    'icon': PhosphorIconsRegular.tag,
  },
];

class RewardsScreen extends ConsumerWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPoints = ref.watch(authProvider).user?.totalPoints ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rewards'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Icon(PhosphorIconsRegular.star,
                    color: AppColors.secondary, size: 18),
                const SizedBox(width: 4),
                Text('$userPoints pts',
                    style: const TextStyle(
                        color: AppColors.secondary,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _mockRewards.length,
        itemBuilder: (_, i) {
          final r = _mockRewards[i];
          final pts = r['points'] as int;
          final canClaim = userPoints >= pts;
          return _RewardCard(
            name: r['name'] as String,
            venue: r['venue'] as String,
            description: r['description'] as String,
            points: pts,
            icon: r['icon'] as IconData,
            canClaim: canClaim,
          );
        },
      ),
    );
  }
}

class _RewardCard extends StatelessWidget {
  final String name;
  final String venue;
  final String description;
  final int points;
  final IconData icon;
  final bool canClaim;

  const _RewardCard({
    required this.name,
    required this.venue,
    required this.description,
    required this.points,
    required this.icon,
    required this.canClaim,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: canClaim
                    ? Color.fromRGBO(255, 215, 0, 0.15)
                    : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon,
                  color: canClaim
                      ? AppColors.secondary
                      : AppColors.textSecondary),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: Theme.of(context).textTheme.titleMedium),
                  Text(venue,
                      style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 4),
                  Text(description,
                      style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 4),
                  Text(
                    '$points pts required',
                    style: TextStyle(
                      color: canClaim
                          ? AppColors.secondary
                          : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: canClaim ? () {} : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(72, 36),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                backgroundColor:
                    canClaim ? AppColors.primary : AppColors.surfaceVariant,
                foregroundColor:
                    canClaim ? AppColors.onPrimary : AppColors.textSecondary,
              ),
              child: const Text('Claim'),
            ),
          ],
        ),
      ),
    );
  }
}
