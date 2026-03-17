Replace the entire content of lib/app.dart with exactly this:

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'shared/widgets/loading_widget.dart';
import 'features/venues/presentation/screens/home_screen.dart';
import 'features/venues/presentation/screens/search_screen.dart';
import 'features/venues/presentation/screens/venue_detail_screen.dart';
import 'features/scan/presentation/screens/scan_screen.dart';
import 'features/points/presentation/screens/progress_screen.dart';
import 'features/rewards/presentation/screens/rewards_screen.dart';
import 'features/profile/presentation/screens/profile_screen.dart';
import 'features/friends/presentation/screens/friends_screen.dart';
import 'shared/widgets/bottom_nav_bar.dart';

// A ChangeNotifier that listens to Riverpod AuthState changes
// and notifies GoRouter to re-evaluate redirects.
class _AuthNotifierListener extends ChangeNotifier {
AuthState _state;
_AuthNotifierListener(this._state);

void update(AuthState newState) {
if (newState.isLoading != _state.isLoading ||
newState.isAuthenticated != _state.isAuthenticated) {
_state = newState;
notifyListeners();
}
}

AuthState get state => _state;
}

final _authListenerProvider =
ChangeNotifierProvider<_AuthNotifierListener>((ref) {
final authState = ref.watch(authProvider);
final notifier =
_AuthNotifierListener(authState);
ref.listen<AuthState>(authProvider, (_, next) {
notifier.update(next);
});
return notifier;
});

final routerProvider = Provider<GoRouter>((ref) {
final authListener = ref.watch(_authListenerProvider);

final router = GoRouter(
initialLocation: '/login',
refreshListenable: authListener,
redirect: (context, state) {
final authState = authListener.state;
final isLoading = authState.isLoading;
final isLoggedIn = authState.isAuthenticated;
final location = state.matchedLocation;

      // While checking auth on startup, show splash
      if (isLoading) {
        return location == '/splash' ? null : '/splash';
      }

      // Not logged in — go to login
      if (!isLoggedIn) {
        return location == '/login' ? null : '/login';
      }

      // Logged in — leave splash or login, go home
      if (location == '/splash' || location == '/login') {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (_, __) => const Scaffold(body: LoadingWidget()),
      ),
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
          GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
          GoRoute(path: '/search', builder: (_, __) => const SearchScreen()),
          GoRoute(path: '/scan', builder: (_, __) => const ScanScreen()),
          GoRoute(path: '/progress', builder: (_, __) => const ProgressScreen()),
          GoRoute(path: '/rewards', builder: (_, __) => const RewardsScreen()),
          GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
          GoRoute(path: '/friends', builder: (_, __) => const FriendsScreen()),
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

return router;
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

After replacing, run: flutter analyze
Report the result and any errors.