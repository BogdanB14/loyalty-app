import 'package:flutter/material.dart';

class TierUtils {
  static Color tierColor(String tier) {
    switch (tier.toUpperCase()) {
      case 'BRONZE':
        return const Color(0xFFCD7F32);
      case 'SILVER':
        return const Color(0xFFC0C0C0);
      case 'GOLD':
        return const Color(0xFFC9A96E);
      case 'PLATINUM':
        return const Color(0xFFE5E4E2);
      default:
        return const Color(0xFFCD7F32);
    }
  }

  static String tierLabel(String tier) {
    switch (tier.toUpperCase()) {
      case 'BRONZE':
        return 'Bronze';
      case 'SILVER':
        return 'Silver';
      case 'GOLD':
        return 'Gold';
      case 'PLATINUM':
        return 'Platinum';
      default:
        return tier;
    }
  }

  static int pointsForNextTier(String tier) {
    switch (tier.toUpperCase()) {
      case 'BRONZE':
        return 500;
      case 'SILVER':
        return 1500;
      case 'GOLD':
        return 3000;
      case 'PLATINUM':
        return 0;
      default:
        return 500;
    }
  }

  static String? nextTier(String tier) {
    switch (tier.toUpperCase()) {
      case 'BRONZE':
        return 'SILVER';
      case 'SILVER':
        return 'GOLD';
      case 'GOLD':
        return 'PLATINUM';
      case 'PLATINUM':
        return null;
      default:
        return null;
    }
  }

  static double tierMultiplier(String tier) {
    switch (tier.toUpperCase()) {
      case 'BRONZE':
        return 1.0;
      case 'SILVER':
        return 1.25;
      case 'GOLD':
        return 1.5;
      case 'PLATINUM':
        return 2.0;
      default:
        return 1.0;
    }
  }
}
