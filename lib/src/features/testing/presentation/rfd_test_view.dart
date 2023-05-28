import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tindeq/src/common_widgets/navigation_rail.dart';
import 'package:flutter_tindeq/src/constants/app_sizes.dart';
import 'package:flutter_tindeq/src/constants/theme.dart';
import 'package:flutter_tindeq/src/features/testing/application/test_actions.dart';
import 'package:flutter_tindeq/src/features/testing/presentation/test_view.dart';
import 'package:flutter_tindeq/src/features/testing/presentation/test_widgets.dart';
import 'package:flutter_tindeq/src/features/testing/domain/testing_models.dart';
import 'package:flutter_tindeq/src/features/testing/repository/data.dart';

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
  final PointListClass dataLeft = pointListRfdL;
  final PointListClass dataRight = pointListRfdR;
  final pointLeft = pointListRfdL.rfdMinMax;
  final pointRight = pointListRfdR.rfdMinMax;
  final legends = [
    (title: "Left", colour: ChartColours.contentColorBlue),
    (title: "Right", colour: ChartColours.contentColorRed)
  ];
  // final startButtonLeft = const StartButton();
  // final startButtonRight = const StartButton();
  final countdownTime = const CountDownTime(time: 10.0);
  final double duration = 12.0;

  @override
  Widget build(BuildContext context) {
    var points = PointListClass([(pointLeft.$2), (pointRight.$2)]);
    return TestView(
      "Rate of Force Development Test",
      dataLeft: dataLeft,
      dataRight: dataRight,
      points: points,
      legends: legends,
      lines: [
        (dataLeft.rfdLine, ChartColours.contentColorRed),
        (dataRight.rfdLine, ChartColours.contentColorRed)
      ],
      // startButtonLeft: startButtonLeft,
      // startButtonRight: startButtonRight,
      countdownTime: countdownTime,
      duration: duration,
      units: "kg/s",
      results:
          Results((dataLeft.rfdMinMax.$1, 0, 0, dataRight.rfdMinMax.$1, 0, 0)),
    );
  }
}

class Results extends ConsumerWidget {
  const Results(this.values, {super.key});

  final (double, double, double, double, double, double) values;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        TestResultsHeader("Left Hand", rfdAction(Hand.left, ref)),
        ResultsBody((values.$1, values.$2, values.$3)),
        gapHMED,
        TestResultsHeader("Left Hand", rfdAction(Hand.right, ref)),
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
        ResultsRow("Peak: ", values.$1, "kg/s"),
        ResultsRow("Average ", values.$2, "kg/s"),
        ResultsRow("Time to RFD: ", values.$3, "kg/s"),
      ],
    );
  }
}
