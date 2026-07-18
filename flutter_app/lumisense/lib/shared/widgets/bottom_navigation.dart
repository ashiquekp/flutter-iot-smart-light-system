import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LumiSenseBottomNavigation extends ConsumerWidget {
  final int currentIndex;

  const LumiSenseBottomNavigation({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedItemColor: theme.colorScheme.primary,
      unselectedItemColor: theme.colorScheme.onSurfaceVariant,
      selectedLabelStyle: theme.textTheme.labelMedium,
      unselectedLabelStyle: theme.textTheme.labelMedium,
      onTap: (index) {
        switch (index) {
          case 0:
            if (currentIndex != 0) {
              context.go('/dashboard');
            }
            break;
          case 1:
            if (currentIndex != 1) {
              context.go('/history');
            }
            break;
          case 2:
            if (currentIndex != 2) {
              context.go('/settings');
            }
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'History',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    );
  }
}