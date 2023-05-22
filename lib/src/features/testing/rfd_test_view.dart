import 'package:flutter/material.dart';
import 'package:flutter_tindeq/src/common_widgets/navigation_rail.dart';
import 'package:flutter_tindeq/src/constants/theme.dart';
import 'package:flutter_tindeq/src/features/testing/test_view.dart';
import 'package:flutter_tindeq/src/features/testing/test_widgets.dart';
import 'package:flutter_tindeq/src/features/testing/testing_service.dart';
import 'package:flutter_tindeq/src/repository/data.dart';

class RfdTestingView extends StatelessWidget {
  const RfdTestingView({super.key});
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
              child: RfdTestView(),
            ),
          ],
        ),
      ),
    );
  }
}

class RfdTestView extends StatelessWidget {
  RfdTestView({super.key});
  final dataLeft = pointListRfdL;
  final dataRight = pointListRfdR;
  final pointLeft = (rfdMinMax(pointListRfdL));
  final pointRight = (rfdMinMax(pointListRfdR));
  final startButtonLeft = const StartButton();
  final startButtonRight = const StartButton();
  final countdownTime = const CountDownTime(time: 10.0);
  final double duration = 12.0;

  @override
  Widget build(BuildContext context) {
    return TestView(
      "Rate of Force Development Test",
      dataLeft: dataLeft,
      dataRight: dataRight,
      pointLeft: (rfdMinMax(dataLeft).$3),
      pointRight: (rfdMinMax(dataRight).$3),
      valueLeft: (rfdMinMax(dataLeft).$1),
      valueRight: (rfdMinMax(dataRight).$1),
      lineLeft: rfdLine(dataLeft),
      lineRight: rfdLine(dataRight),
      startButtonLeft: startButtonLeft,
      startButtonRight: startButtonRight,
      countdownTime: countdownTime,
      duration: duration,
      units: "kg/s",
      results: Results(
          (rfdMinMax(dataLeft).$1, 0, 0, rfdMinMax(dataRight).$1, 0, 0)),
    );
  }
}

class Results extends StatelessWidget {
  const Results(this.values, {super.key});

  final (double, double, double, double, double, double) values;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TestResultsHeader("Left Hand"),
        ResultsBody((values.$1, values.$2, values.$3)),
        const TestResultsHeader("Right Hand"),
        ResultsBody((values.$4, values.$5, values.$6))
      ],
    );
  }
}

class ResultsBody extends StatelessWidget {
  const ResultsBody(this.values, {super.key});

  final (double, double, double) values;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          // mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("Max: ", style: TextStyles.h2),
            Text("${values.$1.toStringAsFixed(1)} ", style: TextStyles.h2),
            Text("kg/s", style: TextStyles.h2),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          // mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("Average: ", style: TextStyles.h2),
            Text("${values.$2.toStringAsFixed(1)} ", style: TextStyles.h2),
            Text("kg/s", style: TextStyles.h2),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          // mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("Time to Peak: ", style: TextStyles.h2),
            Text("${values.$3.toStringAsFixed(1)} ", style: TextStyles.h2),
            Text("kg/s", style: TextStyles.h2),
          ],
        ),
      ],
    );
  }
}
