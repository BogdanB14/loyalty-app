import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

const _mockProgress = [
  {'venue': 'Kafana Zlatni Bor', 'points': 420, 'max': 500, 'next': 'Free Coffee'},
  {'venue': 'Caffe Bar Lav', 'points': 180, 'max': 200, 'next': 'Free Dessert'},
  {'venue': 'McBurger Beograd', 'points': 75, 'max': 150, 'next': '10% Discount'},
];

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final totalPoints = user?.totalPoints ?? 0;

    return Scaffold(
      appBar: AppBar(title: const Text('My Progress')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _TotalPointsCard(points: totalPoints, context: context),
          const SizedBox(height: 24),
          Text('Venue Progress',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          for (final v in _mockProgress)
            _VenueProgressCard(
              venue: v['venue'] as String,
              points: v['points'] as int,
              max: v['max'] as int,
              nextReward: v['next'] as String,
              context: context,
            ),
        ],
      ),
    );
  }
}

class _TotalPointsCard extends StatelessWidget {
  final int points;
  final BuildContext context;
  const _TotalPointsCard({required this.points, required this.context});

  @override
  Widget build(BuildContext c) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromRGBO(255, 107, 53, 0.8),
            Color.fromRGBO(255, 107, 53, 0.4),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(PhosphorIconsRegular.star,
              size: 48, color: AppColors.secondary),
          const SizedBox(height: 8),
          Text(
            '$points',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 48,
                ),
          ),
          Text('Total Points',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.white70)),
        ],
      ),
    );
  }
}

class _VenueProgressCard extends StatelessWidget {
  final String venue;
  final int points;
  final int max;
  final String nextReward;
  final BuildContext context;

  const _VenueProgressCard({
    required this.venue,
    required this.points,
    required this.max,
    required this.nextReward,
    required this.context,
  });

  @override
  Widget build(BuildContext c) {
    final progress = (points / max).clamp(0.0, 1.0);
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
                Text(venue,
                    style: Theme.of(context).textTheme.titleMedium),
                Text(
                  '$points pts',
                  style: const TextStyle(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: AppColors.surfaceVariant,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$points / $max pts',
                    style: Theme.of(context).textTheme.bodySmall),
                Row(
                  children: [
                    Icon(PhosphorIconsRegular.gift,
                        size: 14, color: AppColors.secondary),
                    const SizedBox(width: 4),
                    Text(nextReward,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: AppColors.secondary)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
