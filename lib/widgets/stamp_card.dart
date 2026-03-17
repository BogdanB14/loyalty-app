import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

class StampCard extends StatelessWidget {
  final String venueName;
  final int totalStamps;
  final int earnedStamps;

  const StampCard({
    super.key,
    required this.venueName,
    required this.totalStamps,
    required this.earnedStamps,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E1A13), Color(0xFF242424)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accentGoldMuted, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(venueName, style: AppTextStyles.titleMedium),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(totalStamps, (i) {
              final filled = i < earnedStamps;
              return _StampCircle(filled: filled);
            }),
          ),
          const SizedBox(height: 12),
          Text(
            '$earnedStamps / $totalStamps stamps',
            style: AppTextStyles.labelSmall
                .copyWith(color: AppColors.accentGold),
          ),
        ],
      ),
    );
  }
}

class _StampCircle extends StatelessWidget {
  final bool filled;
  const _StampCircle({required this.filled});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: filled ? AppColors.accentGold : AppColors.backgroundTertiary,
        border: filled
            ? null
            : Border.all(color: AppColors.accentGoldMuted, width: 1),
      ),
      child: filled
          ? const Icon(
              PhosphorIconsRegular.check,
              color: Colors.white,
              size: 20,
            )
          : null,
    );
  }
}
