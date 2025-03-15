import "package:fl_utilities/fl_utilities.dart";
import "package:flutter/material.dart";

import "package:dicoding_story_fl/interfaces/libs/l10n.dart";
import "package:dicoding_story_fl/interfaces/modules.dart";
import "package:go_router/go_router.dart";

class RootShellRouteScreen extends StatefulWidget {
  const RootShellRouteScreen({super.key, this.child});

  final Widget? child;

  List<RootShellRouteScreenNavDelegate> get navigationDelegates {
    return [
      RootShellRouteScreenNavDelegate(
        icon: const Icon(Icons.home_outlined),
        label: "Home",
        activeIcon: const Icon(Icons.home),
        routePath: const StoriesRoute().location,
        floatingActionButton: Builder(builder: (context) {
          return FloatingActionButton.extended(
            onPressed: () => const PostStoryRoute().go(context),
            label: Text(AppL10n.of(context)!.postStory),
            icon: const Icon(Icons.add),
          );
        }),
      ),
      RootShellRouteScreenNavDelegate(
        icon: const Icon(Icons.person_outlined),
        label: "Profile",
        activeIcon: const Icon(Icons.person),
        routePath: const ProfileRoute().location,
      ),
    ];
  }

  @override
  State<RootShellRouteScreen> createState() => _RootShellRouteScreenState();
}

class _RootShellRouteScreenState extends State<RootShellRouteScreen> {
  bool isExtended = true;

  void _handlePostNavigation() {
    if (!isExtended) return;

    setState(() => isExtended = false);
  }

  @override
  Widget build(BuildContext context) {
    final navigationDelegates = widget.navigationDelegates;

    return Scaffold(
      body: _RootShellRouteScreenBody(
        navigationDelegates: navigationDelegates,
        isExtended: isExtended,
        onNavigationRailTrailingTap: () {
          setState(() => isExtended = !isExtended);
        },
        onPostNavigation: _handlePostNavigation,
        child: widget.child,
      ),
      bottomNavigationBar: _RootShellRouteScreenBottomNavBar(
        navigationDelegates: navigationDelegates,
        onPostNavigation: _handlePostNavigation,
      ),
      floatingActionButton: _RootShellRouteScreenFAB(
        navigationDelegates: navigationDelegates,
      ),
    );
  }
}

class RootShellRouteScreenNavDelegate {
  const RootShellRouteScreenNavDelegate({
    required this.icon,
    required this.label,
    this.activeIcon,
    required this.routePath,
    this.floatingActionButton,
  });

  final Icon icon;
  final String label;
  final Icon? activeIcon;
  final String routePath;

  /// Only be rendered when the current route matches the [routePath].
  final Widget? floatingActionButton;
}

mixin _RootShellRouteScreenNavHelperMixin on Widget {
  double get minWidthForNavigationRail => 800.0;

  /// Match [GoRouter] current route starts with the [navs] route path.
  int _getCurrentNavigationIndex(
    BuildContext context,
    List<RootShellRouteScreenNavDelegate> navs,
  ) {
    final currentRoute = GoRouterState.of(context).uri.path;

    return navs.indexWhere((e) => currentRoute.startsWith(e.routePath));
  }

  /// Instead of matching the route starts like [_getCurrentNavigationIndex]
  /// does, this method match the exact route path.
  ///
  /// If there is no matched route, it returns -1.
  int _getActualRouteMatchIndex(
    BuildContext context,
    List<RootShellRouteScreenNavDelegate> navs,
  ) {
    final currentRoute = GoRouterState.of(context).uri.path;

    return navs.indexWhere((e) => currentRoute == e.routePath);
  }
}

class _RootShellRouteScreenBody extends StatelessWidget
    with _RootShellRouteScreenNavHelperMixin {
  const _RootShellRouteScreenBody({
    required this.navigationDelegates,
    this.isExtended = false,
    this.onNavigationRailTrailingTap,
    this.onPostNavigation,
    this.child,
  });

  final List<RootShellRouteScreenNavDelegate> navigationDelegates;
  final bool isExtended;
  final VoidCallback? onNavigationRailTrailingTap;
  final VoidCallback? onPostNavigation;
  final Widget? child;

  Widget _buildNavigationRail(BuildContext context) {
    final currentNavIndex = _getCurrentNavigationIndex(
      context,
      navigationDelegates,
    );

    return SizedBox.expand(
      child: Row(
        children: [
          NavigationRail(
            extended: isExtended,
            selectedIndex: currentNavIndex,
            onDestinationSelected: (index) {
              final routePath = navigationDelegates[index].routePath;

              context.go(routePath);

              onPostNavigation?.call();
            },
            destinations: navigationDelegates.map((e) {
              return NavigationRailDestination(
                icon: e.icon,
                selectedIcon: e.activeIcon,
                label: Text(e.label),
              );
            }).toList(),
            trailing: Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    tooltip: isExtended ? "Shrink" : "Expand",
                    onPressed: onNavigationRailTrailingTap,
                    icon: Icon(
                      isExtended ? Icons.chevron_left : Icons.chevron_right,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const VerticalDivider(width: 2.0, thickness: 2.0),
          Expanded(child: child ?? const SizedBox.shrink()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = context.mediaQuery.size.width;
    final isRenderNavRail = deviceWidth >= minWidthForNavigationRail;

    return SafeArea(
      child: isRenderNavRail
          ? _buildNavigationRail(context)
          : child ?? const SizedBox.shrink(),
    );
  }
}

class _RootShellRouteScreenBottomNavBar extends StatelessWidget
    with _RootShellRouteScreenNavHelperMixin {
  const _RootShellRouteScreenBottomNavBar({
    required this.navigationDelegates,
    this.onPostNavigation,
  });

  final List<RootShellRouteScreenNavDelegate> navigationDelegates;
  final VoidCallback? onPostNavigation;

  Widget _buildBottomNavigationBar(BuildContext context) {
    final currentNavIndex = _getCurrentNavigationIndex(
      context,
      navigationDelegates,
    );

    return BottomNavigationBar(
      currentIndex: currentNavIndex,
      onTap: (index) {
        final routePath = navigationDelegates[index].routePath;

        context.go(routePath);

        onPostNavigation?.call();
      },
      items: navigationDelegates.map((e) {
        return BottomNavigationBarItem(
          icon: e.icon,
          label: e.label,
          activeIcon: e.activeIcon,
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceWidth = context.mediaQuery.size.width;
    final isRenderNavRail = deviceWidth >= minWidthForNavigationRail;

    return isRenderNavRail
        ? const SizedBox.shrink()
        : _buildBottomNavigationBar(context);
  }
}

class _RootShellRouteScreenFAB extends StatelessWidget
    with _RootShellRouteScreenNavHelperMixin {
  const _RootShellRouteScreenFAB({required this.navigationDelegates});

  final List<RootShellRouteScreenNavDelegate> navigationDelegates;

  @override
  Widget build(BuildContext context) {
    final currentNavIndex = _getActualRouteMatchIndex(
      context,
      navigationDelegates,
    );

    final isNegativeIndex = currentNavIndex < 0;

    return AnimatedSize(
      duration: Durations.medium1,
      child: isNegativeIndex
          ? const SizedBox.shrink()
          : navigationDelegates[currentNavIndex].floatingActionButton ??
              const SizedBox.shrink(),
    );
  }
}
