import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lumisense/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:lumisense/features/history/presentation/pages/history_page.dart';
import 'package:lumisense/features/settings/presentation/pages/settings_page.dart';

/// Route names for the application
class AppRoutes {
  static const String dashboard = '/dashboard';
  static const String history = '/history';
  static const String settings = '/settings';
  
  // Named route constants
  static const String dashboardName = 'dashboard';
  static const String historyName = 'history';
  static const String settingsName = 'settings';
}

/// GoRouter configuration for the application
final router = GoRouter(
  initialLocation: AppRoutes.dashboard,
  routes: [
    GoRoute(
      path: AppRoutes.dashboard,
      name: AppRoutes.dashboardName,
      builder: (context, state) => const DashboardPage(),
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const DashboardPage(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.history,
      name: AppRoutes.historyName,
      builder: (context, state) => const HistoryPage(),
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const HistoryPage(),
        );
      },
    ),
    GoRoute(
      path: AppRoutes.settings,
      name: AppRoutes.settingsName,
      builder: (context, state) => const SettingsPage(),
      pageBuilder: (context, state) {
        return MaterialPage(
          key: state.pageKey,
          child: const SettingsPage(),
        );
      },
    ),
  ],
  redirect: (context, state) {
    // Add any redirect logic here if needed
    // For example: authentication checks
    return null;
  },
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Page not found',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'The page you are looking for does not exist.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.go(AppRoutes.dashboard),
            icon: const Icon(Icons.dashboard),
            label: const Text('Go to Dashboard'),
          ),
        ],
      ),
    ),
  ),
);

/// Extension for easier navigation
extension GoRouterExtension on GoRouter {
  void goToDashboard() => go(AppRoutes.dashboard);
  void goToHistory() => go(AppRoutes.history);
  void goToSettings() => go(AppRoutes.settings);
  
  void pushDashboard() => push(AppRoutes.dashboard);
  void pushHistory() => push(AppRoutes.history);
  void pushSettings() => push(AppRoutes.settings);
}

/// Navigation service for dependency injection
class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = 
      GlobalKey<NavigatorState>();
  
  static Future<T?>? pushNamed<T extends Object?>(
    String routeName, {
    Object? arguments,
  }) {
    return navigatorKey.currentState?.pushNamed(
      routeName,
      arguments: arguments,
    );
  }
  
  static void pop<T extends Object?>([T? result]) {
    return navigatorKey.currentState?.pop(result);
  }
  
  static void pushReplacementNamed(
    String routeName, {
    Object? arguments,
  }) {
    navigatorKey.currentState?.pushReplacementNamed(
      routeName,
      arguments: arguments,
    );
  }
  
  static void pushNamedAndRemoveUntil(
    String routeName, {
    Object? arguments,
  }) {
    navigatorKey.currentState?.pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }
}