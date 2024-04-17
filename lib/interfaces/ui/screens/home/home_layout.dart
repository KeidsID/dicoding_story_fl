import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:dicoding_story_fl/interfaces/app_l10n.dart';
import 'package:dicoding_story_fl/interfaces/ux.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key, this.child});

  final Widget? child;

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  bool isExtended = true;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_, constraints) {
      if (constraints.maxWidth < 600) {
        return _HomeLayoutS(child: widget.child);
      }

      return _HomeLayoutL(
        isExtended: isExtended,
        onTrailingTap: () => setState(() => isExtended = !isExtended),
        child: widget.child,
      );
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

List<_NavBarItemDelegate> _navs(BuildContext context) {
  final appL10n = AppL10n.of(context)!;

  return [
    const _NavBarItemDelegate(
      icon: Icon(Icons.home_outlined),
      label: 'Home',
      activeIcon: Icon(Icons.home),
    ),
    _NavBarItemDelegate(
      icon: const Icon(Icons.person_outlined),
      label: appL10n.profile,
      activeIcon: const Icon(Icons.person),
    ),
  ];
}

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

class _HomeLayoutS extends StatelessWidget {
  const _HomeLayoutS({this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: child ?? const SizedBox.shrink()),
      bottomNavigationBar: BottomNavigationBar(
        items: _navs(context).map((e) {
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
              tooltip: AppL10n.of(context)!.postStory,
              child: const Icon(Icons.add),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _HomeLayoutL extends StatelessWidget {
  const _HomeLayoutL({
    this.isExtended = true,
    this.onTrailingTap,
    this.child,
  });

  final bool isExtended;

  final VoidCallback? onTrailingTap;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox.expand(
          child: Row(
            children: [
              NavigationRail(
                extended: isExtended,
                selectedIndex: _currentNav(context),
                destinations: _navs(context).map((e) {
                  return NavigationRailDestination(
                    icon: e.icon,
                    label: Text(e.label),
                    selectedIcon: e.activeIcon,
                  );
                }).toList(),
                onDestinationSelected: _onNavItemTap(context),
                trailing: Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        tooltip: isExtended ? 'Shrink' : 'Expand',
                        onPressed: onTrailingTap,
                        icon: Icon(
                          isExtended ? Icons.chevron_left : Icons.chevron_right,
                        ),
                      ),
                    ],
                  ),
                ),
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
              label: Text(AppL10n.of(context)!.postStory),
            ),
    );
  }
}
