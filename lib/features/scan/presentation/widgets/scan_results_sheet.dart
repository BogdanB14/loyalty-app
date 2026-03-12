import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class ScanResultsSheet extends StatelessWidget {
  final String qrUrl;
  final int points;
  final String venueName;

  const ScanResultsSheet({
    super.key,
    required this.qrUrl,
    required this.points,
    required this.venueName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Color.fromRGBO(255, 107, 53, 0.15),
              shape: BoxShape.circle,
            ),
            child:
                const Icon(Icons.check, size: 40, color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          Text(
            'Receipt Scanned!',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            '+$points pts',
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'at $venueName',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.people_outline, size: 18),
            label: const Text('Share points with friends'),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Done'),
            ),
          ),
        ],
      ),
    );
  }
}
