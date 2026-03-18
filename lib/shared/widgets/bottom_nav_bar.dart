import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../core/theme/app_colors.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  final String location;

  const MainShell({
    super.key,
    required this.child,
    required this.location,
  });

  static final _destinations = [
    _NavDest(
        label: 'Home',
        icon: PhosphorIconsRegular.house,
        route: '/home'),
    _NavDest(
        label: 'Search',
        icon: PhosphorIconsRegular.magnifyingGlass,
        route: '/search'),
    _NavDest(
        label: 'Scan',
        icon: PhosphorIconsRegular.qrCode,
        route: '/scan'),
    _NavDest(
        label: 'Progress',
        icon: PhosphorIconsRegular.chartBar,
        route: '/progress'),
    _NavDest(
        label: 'Profile',
        icon: PhosphorIconsRegular.user,
        route: '/profile'),
  ];

  int get _currentIndex {
    if (location == '/friends' || location == '/rewards') return 4;
    for (var i = 0; i < _destinations.length; i++) {
      if (location == _destinations[i].route) return i;
    }
    return -1;
  }

  @override
  Widget build(BuildContext context) {
    final isScan = location == '/scan';
    return Scaffold(
      body: child,
      bottomNavigationBar: isScan
          ? null
          : Container(
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(
                    top: BorderSide(color: AppColors.divider, width: 0.5)),
              ),
              child: SafeArea(
                child: SizedBox(
                  height: 64,
                  child: Row(
                    children: List.generate(_destinations.length, (i) {
                      final d = _destinations[i];
                      final selected = i == _currentIndex;
                      final color = selected ? AppColors.primary : AppColors.textSecondary;
                      return Expanded(
                        child: InkWell(
                          onTap: () => context.go(d.route),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(d.icon, color: color, size: 24),
                              const SizedBox(height: 4),
                              Text(
                                d.label,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: color,
                                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
    );
  }
}

class _NavDest {
  final String label;
  final IconData icon;
  final String route;
  const _NavDest(
      {required this.label, required this.icon, required this.route});
}
