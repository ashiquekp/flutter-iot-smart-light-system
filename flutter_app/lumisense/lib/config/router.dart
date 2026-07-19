import 'package:go_router/go_router.dart';
import 'package:lumisense/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:lumisense/features/history/presentation/pages/history_page.dart';
import 'package:lumisense/features/settings/presentation/pages/settings_page.dart';

final router = GoRouter(
  initialLocation: '/dashboard',
  routes: [
    GoRoute(
      path: '/dashboard',
      name: 'dashboard',
      builder: (context, state) => const DashboardPage(),
    ),
    GoRoute(
      path: '/history',
      name: 'history',
      builder: (context, state) => const HistoryPage(),
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsPage(),
    ),
  ],
);