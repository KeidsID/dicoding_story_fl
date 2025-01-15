import "package:dicoding_story_fl/interfaces/libs/l10n/modules.dart";
import "package:fl_utilities/fl_utilities.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

import "routes/auth.dart";
import "routes/root.dart";

export "routes/auth.dart";
export "routes/root.dart";

part "routes.g.dart";

@TypedShellRoute<AuthShellRoute>(routes: [
  signInRouteBuild,
  signUpRouteBuild,
])
final class AuthShellRoute extends ShellRouteData {
  const AuthShellRoute();

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    return _AuthShellRouteScreen(child: navigator);
  }
}

class _AuthShellRouteScreen extends StatelessWidget {
  const _AuthShellRouteScreen({this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}

@TypedShellRoute<RootShellRoute>(routes: [
  storiesRouteBuild,
  profileRouteBuild,
])
final class RootShellRoute extends ShellRouteData {
  const RootShellRoute();

  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    return _RootShellRouteScreen(child: navigator);
  }
}

class _RootShellRouteScreen extends StatefulWidget {
  const _RootShellRouteScreen({this.child});

  final Widget? child;

  List<_RootShellRouteScreenNavDelegate> get navigationDelegates {
    return [
      _RootShellRouteScreenNavDelegate(
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
      _RootShellRouteScreenNavDelegate(
        icon: const Icon(Icons.person_outlined),
        label: "Profile",
        activeIcon: const Icon(Icons.person),
        routePath: const ProfileRoute().location,
      ),
    ];
  }

  @override
  State<_RootShellRouteScreen> createState() => _RootShellRouteScreenState();
}

class _RootShellRouteScreenState extends State<_RootShellRouteScreen> {
  bool isExtended = true;

  @override
  Widget build(BuildContext context) {
    final navigationDelegates = widget.navigationDelegates;

    return Scaffold(
      body: _RootShellRouteScreenBody(
        isExtended: isExtended,
        onNavigationRailTrailingTap: () {
          setState(() => isExtended = !isExtended);
        },
        navigationDelegates: navigationDelegates,
        child: widget.child,
      ),
      bottomNavigationBar: _RootShellRouteScreenBottomNavBar(
        navigationDelegates: navigationDelegates,
      ),
      floatingActionButton: _RootShellRouteScreenFAB(
        navigationDelegates: navigationDelegates,
      ),
    );
  }
}

class _RootShellRouteScreenNavDelegate {
  const _RootShellRouteScreenNavDelegate({
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
    List<_RootShellRouteScreenNavDelegate> navs,
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
    List<_RootShellRouteScreenNavDelegate> navs,
  ) {
    final currentRoute = GoRouterState.of(context).uri.path;

    return navs.indexWhere((e) => currentRoute == e.routePath);
  }
}

class _RootShellRouteScreenBody extends StatelessWidget
    with _RootShellRouteScreenNavHelperMixin {
  const _RootShellRouteScreenBody({
    this.isExtended = false,
    this.onNavigationRailTrailingTap,
    required this.navigationDelegates,
    this.child,
  });

  final bool isExtended;
  final VoidCallback? onNavigationRailTrailingTap;

  final List<_RootShellRouteScreenNavDelegate> navigationDelegates;
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
    final deviceWidth = context.mediaQuery!.size.width;
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
  });

  final List<_RootShellRouteScreenNavDelegate> navigationDelegates;

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
    final deviceWidth = context.mediaQuery!.size.width;
    final isRenderNavRail = deviceWidth >= minWidthForNavigationRail;

    return isRenderNavRail
        ? const SizedBox.shrink()
        : _buildBottomNavigationBar(context);
  }
}

class _RootShellRouteScreenFAB extends StatelessWidget
    with _RootShellRouteScreenNavHelperMixin {
  const _RootShellRouteScreenFAB({required this.navigationDelegates});

  final List<_RootShellRouteScreenNavDelegate> navigationDelegates;

  @override
  Widget build(BuildContext context) {
    final currentNavIndex = _getActualRouteMatchIndex(
      context,
      navigationDelegates,
    );

    if (currentNavIndex == -1) return const SizedBox.shrink();

    return navigationDelegates[currentNavIndex].floatingActionButton ??
        const SizedBox.shrink();
  }
}
