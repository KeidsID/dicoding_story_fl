import 'package:flutter/material.dart';

import 'package:dicoding_story_fl/interfaces/ux.dart';
import 'package:go_router/go_router.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      if (constraints.maxWidth < 600) {
        return _HomeLayoutS(child: child);
      }

      return _HomeLayoutL(child: child);
    });
  }
}

class _NavBarItemDelegate {
  const _NavBarItemDelegate({
    required this.icon,
    required this.label,
    this.activeIcon,
  });

  final Icon icon;
  final String label;
  final Icon? activeIcon;
}

const _navs = [
  _NavBarItemDelegate(
    icon: Icon(Icons.home_outlined),
    label: 'Home',
    activeIcon: Icon(Icons.home),
  ),
  _NavBarItemDelegate(
    icon: Icon(Icons.person_outlined),
    label: 'Profile',
    activeIcon: Icon(Icons.person),
  ),
];

int _currentNav(BuildContext context) {
  final currentRoute = GoRouterState.of(context).uri.path;

  if (currentRoute.startsWith(const StoriesRoute().location)) {
    return 0;
  }

  return 1;
}

ValueChanged<int> _onNavItemTap(BuildContext context) {
  return (index) {
    final currentRoute = GoRouterState.of(context).uri.path;

    index == 0
        ? currentRoute == const StoriesRoute().location
            ? null // prevent re-navigate
            : const StoriesRoute().go(context)
        : currentRoute == const ProfileRoute().location
            ? null
            : const ProfileRoute().go(context);
  };
}

bool _isStoriesRoute(BuildContext context) {
  final currentRoute = GoRouterState.of(context).uri.path;

  return currentRoute == const StoriesRoute().location;
}

class _HomeLayoutS extends HomeLayout {
  const _HomeLayoutS({super.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: child ?? const SizedBox.shrink()),
      bottomNavigationBar: BottomNavigationBar(
        items: _navs.map((e) {
          return BottomNavigationBarItem(
            icon: e.icon,
            activeIcon: e.activeIcon,
            label: e.label,
          );
        }).toList(),
        currentIndex: _currentNav(context),
        onTap: _onNavItemTap(context),
      ),
      floatingActionButton: !_isStoriesRoute(context)
          ? null
          : FloatingActionButton(
              onPressed: () => const PostStoryRoute().go(context),
              tooltip: 'Post Story',
              child: const Icon(Icons.add),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _HomeLayoutL extends HomeLayout {
  const _HomeLayoutL({super.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox.expand(
          child: Row(
            children: [
              NavigationRail(
                selectedIndex: _currentNav(context),
                destinations: _navs.map((e) {
                  return NavigationRailDestination(
                    icon: e.icon,
                    label: Text(e.label),
                    selectedIcon: e.activeIcon,
                  );
                }).toList(),
                onDestinationSelected: _onNavItemTap(context),
              ),
              const VerticalDivider(width: 2.0, thickness: 2.0),
              Expanded(child: child ?? const SizedBox()),
            ],
          ),
        ),
      ),
      floatingActionButton: !_isStoriesRoute(context)
          ? null
          : FloatingActionButton.extended(
              onPressed: () => const PostStoryRoute().go(context),
              icon: const Icon(Icons.add),
              label: const Text('Post Story'),
            ),
    );
  }
}
