import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/venues/presentation/screens/home_screen.dart';
import 'features/venues/presentation/screens/search_screen.dart';
import 'features/venues/presentation/screens/venue_detail_screen.dart';
import 'features/scan/presentation/screens/scan_screen.dart';
import 'features/points/presentation/screens/progress_screen.dart';
import 'features/rewards/presentation/screens/rewards_screen.dart';
import 'features/profile/presentation/screens/profile_screen.dart';
import 'features/friends/presentation/screens/friends_screen.dart';
import 'shared/widgets/bottom_nav_bar.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/home',
    redirect: (context, state) {
      final isLoggedIn = authState.isAuthenticated;
      final isLoginPage = state.matchedLocation == '/login';

      if (!isLoggedIn && !isLoginPage) return '/login';
      if (isLoggedIn && isLoginPage) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (ctx, _) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (ctx, state, child) => MainShell(
          location: state.matchedLocation,
          child: child,
        ),
        routes: [
          GoRoute(
            path: '/home',
            builder: (_, __) => const HomeScreen(),
          ),
          GoRoute(
            path: '/search',
            builder: (_, __) => const SearchScreen(),
          ),
          GoRoute(
            path: '/scan',
            builder: (_, __) => const ScanScreen(),
          ),
          GoRoute(
            path: '/progress',
            builder: (_, __) => const ProgressScreen(),
          ),
          GoRoute(
            path: '/rewards',
            builder: (_, __) => const RewardsScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (_, __) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/friends',
            builder: (_, __) => const FriendsScreen(),
          ),
          GoRoute(
            path: '/venue/:id',
            builder: (_, state) => VenueDetailScreen(
              venueId: state.pathParameters['id']!,
            ),
          ),
        ],
      ),
    ],
  );
});

class LoyApp extends ConsumerWidget {
  const LoyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'LoyApp',
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
