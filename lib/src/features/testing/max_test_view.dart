import 'package:flutter/material.dart';
import 'package:flutter_tindeq/src/common_widgets/navigation_rail.dart';
import 'package:flutter_tindeq/src/constants/theme.dart';
import 'package:flutter_tindeq/src/features/testing/test_view.dart';
import 'package:flutter_tindeq/src/features/testing/test_widgets.dart';
import 'package:flutter_tindeq/src/features/testing/testing_service.dart';
import 'package:flutter_tindeq/src/repository/data.dart';

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

class MaxTestView extends StatelessWidget {
  MaxTestView({
    super.key,
    // required this.startButtonLeft,
    // required this.startButtonRight,
    // required this.countdownTime,
    // required this.duration,
  });
  final dataLeft = pointListMaxL;
  final dataRight = pointListMaxR;
  final pointLeft = (maxKg(pointListMaxL));
  final pointRight = (maxKg(pointListMaxR));
  final startButtonLeft = const StartButton();
  final startButtonRight = const StartButton();
  final countdownTime = const CountDownTime(time: 10.0);
  final double duration = 12.0;

  @override
  Widget build(BuildContext context) {
    return TestView(
      "Max Test",
      dataLeft: dataLeft,
      dataRight: dataRight,
      // pointLeft: pointLeft,
      // pointRight: pointRight,
      // pointLeft: (meanKg(dataLeft)),
      // pointRight: (meanKg(dataRight)),
      valueLeft: pointLeft.$2,
      valueRight: pointRight.$2,
      lineLeft: meanLine(dataLeft),
      lineRight: meanLine(dataRight),
      startButtonLeft: startButtonLeft,
      startButtonRight: startButtonRight,
      countdownTime: countdownTime,
      duration: duration,
      results: Results((
        pointLeft.$2,
        meanKg(dataLeft).$2,
        pointRight.$2,
        meanKg(dataRight).$2
      )),
    );
  }
}

class Results extends StatelessWidget {
  const Results(this.values, {super.key});
//TODO make this a class?
  final (double, double, double, double) values;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TestResultsHeader("Left Hand"),
        ResultsBody((values.$1, values.$2)),
        const TestResultsHeader("Right Hand"),
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
        Row(
          mainAxisSize: MainAxisSize.min,
          // mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("Max: ", style: TextStyles.h2),
            Text("${values.$1.toStringAsFixed(1)} ", style: TextStyles.h2),
            Text("kg", style: TextStyles.h2),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          // mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("Average: ", style: TextStyles.h2),
            Text("${values.$2.toStringAsFixed(1)} ", style: TextStyles.h2),
            Text("kg", style: TextStyles.h2),
          ],
        ),
      ],
    );
  }
}
