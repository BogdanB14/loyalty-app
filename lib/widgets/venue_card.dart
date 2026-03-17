import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shimmer/shimmer.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

class VenueCard extends StatelessWidget {
  final String venueName;
  final String? imageUrl;
  final String category;
  final String distance;
  final String? rating;
  final VoidCallback? onTap;

  const VenueCard({
    super.key,
    required this.venueName,
    this.imageUrl,
    this.category = '',
    this.distance = '',
    this.rating,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider, width: 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _VenueImage(imageUrl: imageUrl),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(venueName, style: AppTextStyles.titleLarge),
                  const SizedBox(height: 8),
                  if (category.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundTertiary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        category,
                        style: AppTextStyles.labelSmall
                            .copyWith(color: AppColors.accentGold),
                      ),
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (distance.isNotEmpty) ...[
                        Icon(PhosphorIconsRegular.mapPin,
                            size: 14, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text(distance, style: AppTextStyles.bodyMedium),
                      ],
                      if (distance.isNotEmpty && rating != null)
                        const SizedBox(width: 12),
                      if (rating != null) ...[
                        Icon(PhosphorIconsRegular.star,
                            size: 14, color: AppColors.accentGold),
                        const SizedBox(width: 4),
                        Text(rating!, style: AppTextStyles.bodyMedium),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VenueImage extends StatelessWidget {
  final String? imageUrl;
  const _VenueImage({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
    if (url == null || url.isEmpty) {
      return _placeholder();
    }
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        placeholder: (context, url) => _shimmer(),
        errorWidget: (context, url, error) => _placeholder(),
      ),
    );
  }

  Widget _shimmer() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Shimmer.fromColors(
        baseColor: AppColors.backgroundTertiary,
        highlightColor: const Color(0xFF3A3A3A),
        child: Container(color: Colors.white),
      ),
    );
  }

  Widget _placeholder() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        color: AppColors.backgroundTertiary,
        child: const Center(
          child: Icon(PhosphorIconsRegular.image,
              size: 36, color: AppColors.textTertiary),
        ),
      ),
    );
  }
}
