import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:shimmer/shimmer.dart';
import '../core/theme/app_colors.dart';

class PromoImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const PromoImage({
    super.key,
    this.imageUrl,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(12);
    final url = imageUrl;

    if (url == null || url.isEmpty) {
      return _placeholder(radius);
    }

    return ClipRRect(
      borderRadius: radius,
      child: CachedNetworkImage(
        imageUrl: url,
        width: width,
        height: height,
        fit: BoxFit.cover,
        placeholder: (context, url) => _shimmer(radius),
        errorWidget: (context, url, error) => _error(radius),
      ),
    );
  }

  Widget _shimmer(BorderRadius radius) {
    return ClipRRect(
      borderRadius: radius,
      child: Shimmer.fromColors(
        baseColor: AppColors.surfaceVariant,
        highlightColor: const Color(0xFF3A3A3A),
        child: Container(
          width: width,
          height: height,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _placeholder(BorderRadius radius) {
    return ClipRRect(
      borderRadius: radius,
      child: Container(
        width: width,
        height: height,
        color: AppColors.surfaceVariant,
        child: Center(
          child: Icon(PhosphorIconsRegular.image,
              color: AppColors.textSecondary, size: 32),
        ),
      ),
    );
  }

  Widget _error(BorderRadius radius) {
    return ClipRRect(
      borderRadius: radius,
      child: Container(
        width: width,
        height: height,
        color: AppColors.surfaceVariant,
        child: Center(
          child: Icon(PhosphorIconsRegular.image,
              color: AppColors.textSecondary, size: 32),
        ),
      ),
    );
  }
}
