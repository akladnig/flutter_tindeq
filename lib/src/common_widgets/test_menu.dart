import 'package:flutter/material.dart';
import 'package:flutter_tindeq/src/routing/app_router.dart';
import 'package:go_router/go_router.dart';

enum TestMenuItem { maxTest, rfdTest, cftTest }

class TestMenu extends StatefulWidget {
  const TestMenu({super.key});

  @override
  State<TestMenu> createState() => _TestMenuState();
}

class _TestMenuState extends State<TestMenu> {
  TestMenuItem? selectedMenu;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<TestMenuItem>(
      initialValue: selectedMenu,
      child: const Text("The Tests!"),
      // Callback that sets the selected popup menu item.
      onSelected: (TestMenuItem item) {
        switch (item) {
          case TestMenuItem.maxTest:
            context.goNamed(AppRoute.maxTest.name);
          case TestMenuItem.rfdTest:
            context.goNamed(AppRoute.rfdTest.name);
          case TestMenuItem.cftTest:
            context.goNamed(AppRoute.cftTest.name);
          default:
        }

        setState(() {
          selectedMenu = item;
        });
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<TestMenuItem>>[
        const PopupMenuItem<TestMenuItem>(
          value: TestMenuItem.maxTest,
          child: Text('Max Test'),
        ),
        const PopupMenuItem<TestMenuItem>(
          value: TestMenuItem.rfdTest,
          child: Text('RFD Test '),
        ),
        const PopupMenuItem<TestMenuItem>(
          value: TestMenuItem.cftTest,
          child: Text('CFT Test'),
        ),
      ],
    );
  }
}
