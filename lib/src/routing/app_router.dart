import 'package:flutter/material.dart';
import 'package:flutter_tindeq/src/features/testing/cft_test_view.dart';
import 'package:flutter_tindeq/src/features/testing/max_test_view.dart';
import 'package:flutter_tindeq/src/features/testing/rfd_test_view.dart';
import 'package:flutter_tindeq/src/features/trend_analysis/trend_analysis_view.dart';
import 'package:flutter_tindeq/src/features/user_details_view.dart';
import 'package:go_router/go_router.dart';

enum AppRoute {
  user,
  testing,
  maxTest,
  rfdTest,
  cftTest,
  trendAnalysis,
  settings
}

final goRouter = GoRouter(
  initialLocation: '/userdetials',
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: '/userdetials',
      name: AppRoute.user.name,
      pageBuilder: (context, state) {
        return FadeTransitionPage(
          key: state.pageKey,
          child: const UserDetailsView(),
        );
      },
    ),
    GoRoute(
      path: '/maxtest',
      name: AppRoute.maxTest.name,
      pageBuilder: (context, state) {
        return FadeTransitionPage(
          key: state.pageKey,
          child: const MaxTestingView(),
        );
      },
    ),
    GoRoute(
      path: '/rfdtest',
      name: AppRoute.rfdTest.name,
      pageBuilder: (context, state) {
        return FadeTransitionPage(
          key: state.pageKey,
          child: const RfdTestingView(),
        );
      },
    ),
    GoRoute(
      path: '/cfttest',
      name: AppRoute.cftTest.name,
      pageBuilder: (context, state) {
        return FadeTransitionPage(
          key: state.pageKey,
          child: const CftTestingView(),
        );
      },
    ),
    GoRoute(
      path: '/trend_analysis',
      name: AppRoute.trendAnalysis.name,
      pageBuilder: (context, state) {
        return FadeTransitionPage(
          key: state.pageKey,
          child: const TrendAnalysisView(),
        );
      },
    ),
    // GoRoute(
    //   path: 'settings',
    //   name: AppRoute.settings.name,
    //   pageBuilder: (context, state) {
    //     return FadeTransitionPage(
    //       key: state.pageKey,
    //       child: SettingsView(controller: settingsController),
    //     );
    //   },
    // ),
  ],
);

/// A page that fades in an out.
class FadeTransitionPage extends CustomTransitionPage<void> {
  /// Creates a [FadeTransitionPage].
  FadeTransitionPage({
    required LocalKey key,
    required Widget child,
  }) : super(
            key: key,
            transitionsBuilder: (BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child) =>
                FadeTransition(
                  opacity: animation.drive(_curveTween),
                  child: child,
                ),
            child: child);

  static final CurveTween _curveTween = CurveTween(curve: Curves.easeIn);
}
