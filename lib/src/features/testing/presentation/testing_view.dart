import 'package:flutter/material.dart';
import 'package:flutter_tindeq/src/common_widgets/navigation_rail.dart';
import 'package:flutter_tindeq/src/features/testing/presentation/max_test_view.dart';

class TestingView2 extends StatefulWidget {
  const TestingView2({super.key});

  @override
  State<TestingView2> createState() => _TestingView2State();
}

class _TestingView2State extends State<TestingView2> {
  final value = "0.0";



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const PreferredSize(
      //     preferredSize: Size.fromHeight(80.0),
      //     child: AppBarWidget(title: "The Tests!")),
      body: SafeArea(
        child: Row(
          children: <Widget>[
            const NavigationRailWidget(),
            const VerticalDivider(thickness: 2, width: 1),
            Expanded(
              child: MaxTestView(),
            ),
          ],
        ),
      ),
    );
  }


}
