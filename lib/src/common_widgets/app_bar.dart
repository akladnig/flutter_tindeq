import 'package:flutter/material.dart';
import 'package:flutter_tindeq/src/common_widgets/test_menu.dart';
import 'package:flutter_tindeq/src/routing/app_router.dart';
import 'package:go_router/go_router.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            context.goNamed(AppRoute.user.name);
          },
          child: const Text('User Details'),
        ),
        // TextButton(
        //   onPressed: () {
        //     context.goNamed(AppRoute.testing.name);
        //   },
        //   child: const Text('The Tests!'),
        // ),
        const TestMenu(),
        TextButton(
          onPressed: () {
            context.goNamed(AppRoute.trendAnalysis.name);
          },
          child: const Text('Trend Analysis'),
        ),
        TextButton(
          onPressed: () {
            context.goNamed(AppRoute.settings.name);
          },
          child: const Text('Settings'),
        ),
      ],
    );
  }
}
