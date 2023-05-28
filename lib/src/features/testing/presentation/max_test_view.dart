import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tindeq/src/common_widgets/navigation_rail.dart';
import 'package:flutter_tindeq/src/constants/app_sizes.dart';
import 'package:flutter_tindeq/src/constants/theme.dart';
import 'package:flutter_tindeq/src/features/testing/application/test_actions.dart';
import 'package:flutter_tindeq/src/features/testing/domain/testing_models.dart';
import 'package:flutter_tindeq/src/features/testing/presentation/test_view.dart';
import 'package:flutter_tindeq/src/features/testing/presentation/test_widgets.dart';
import 'package:flutter_tindeq/src/features/testing/repository/data.dart';

//TODO add ability to do mulitple tests for different grip types - maybe a separate grip tests menu item?
class MaxTestingView extends StatelessWidget {
  const MaxTestingView({super.key});

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

class MaxTestView extends ConsumerWidget {
  MaxTestView({super.key});
  final dataLeft = pointListMaxL;
  final dataRight = pointListMaxR;
  final points = [pointListMaxL.maxForce, pointListMaxR.maxForce];
  final legends = [
    (title: "Left", colour: ChartColours.contentColorBlue),
    (title: "Right", colour: ChartColours.contentColorRed)
  ];
  final countdownTime = const CountDownTime(time: 10.0);
  final double duration = 12.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final startButtonLeft =  StartButton(maxAction(Hand.left, ref));
    // final startButtonRight =  StartButton(maxAction(Hand.right, ref));
    return TestView(
      "Maximum Strength Test",
      dataLeft: dataLeft,
      dataRight: dataRight,
      legends: legends,
      lines: [
        (dataLeft.meanLine, ChartColours.contentColorBlue),
        (dataRight.meanLine, ChartColours.contentColorRed)
      ],
      // startButtonLeft: startButtonLeft,
      // startButtonRight: startButtonRight,
      countdownTime: countdownTime,
      duration: duration,
      results: Results((
        points[0].force,
        dataLeft.mean.force,
        points[0].force,
        dataRight.mean.force,
      )),
    );
  }
}

class Results extends ConsumerWidget {
  const Results(this.values, {super.key});
//TODO make this a class?
  final (double, double, double, double) values;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        TestResultsHeader("Left Hand", maxAction(Hand.left, ref)),
        ResultsBody((values.$1, values.$2)),
        gapHMED,
        TestResultsHeader("Right Hand", maxAction(Hand.right, ref)),
        ResultsBody((values.$3, values.$4))
      ],
    );
  }
}

class ResultsBody extends StatelessWidget {
  const ResultsBody(this.values, {super.key});

  final (double, double) values;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ResultsRow("Max: ", values.$1, "kg"),
        ResultsRow("Average: ", values.$2, "kg"),
      ],
    );
  }
}
