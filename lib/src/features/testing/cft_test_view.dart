import 'package:flutter/material.dart';
import 'package:flutter_tindeq/src/common_widgets/navigation_rail.dart';
import 'package:flutter_tindeq/src/constants/theme.dart';
import 'package:flutter_tindeq/src/features/testing/test_view.dart';
import 'package:flutter_tindeq/src/features/testing/test_widgets.dart';
import 'package:flutter_tindeq/src/repository/data.dart';

class CftTestingView extends StatelessWidget {
  const CftTestingView({super.key});
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
              child: CftTestView(),
            ),
          ],
        ),
      ),
    );
  }
}

class CftTestView extends StatelessWidget {
  CftTestView({super.key});
  final dataLeft = pointListCft;
  final startButtonLeft = const StartButton();
  final countdownTime = const CountDownTime(time: 10.0);
  final double duration = 240.0;

  @override
  Widget build(BuildContext context) {
    return TestView(
      "Critical Force Test",
      dataLeft: pointListCft,
      startButtonLeft: startButtonLeft,
      countdownTime: countdownTime,
      duration: duration,
      results: const ResultsText(hand: "Left", value: 2, units: "kg"),
    );
  }
}

class ResultsText extends StatelessWidget {
  const ResultsText(
      {super.key,
      required this.hand,
      required this.value,
      required this.units});

  final String hand;
  final double value;
  final String units;

  @override
  Widget build(BuildContext context) {
    String valueString = value.toStringAsFixed(1);
    return Row(
      mainAxisSize: MainAxisSize.min,
      // mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text("$hand Hand: ", style: TextStyles.h2),
        Text("$valueString ", style: TextStyles.h2),
        Text(units, style: TextStyles.h2),
      ],
    );
  }
}