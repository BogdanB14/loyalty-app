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
    for (var i = 0; i < _destinations.length; i++) {
      if (location.startsWith(_destinations[i].route)) return i;
    }
    return 0;
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
              child: NavigationBar(
                backgroundColor: AppColors.surface,
                selectedIndex: _currentIndex,
                onDestinationSelected: (i) =>
                    context.go(_destinations[i].route),
                labelBehavior:
                    NavigationDestinationLabelBehavior.onlyShowSelected,
                destinations: _destinations
                    .map(
                      (d) => NavigationDestination(
                        icon: Icon(d.icon, color: AppColors.textSecondary),
                        selectedIcon: Icon(d.icon, color: AppColors.primary),
                        label: d.label,
                      ),
                    )
                    .toList(),
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
