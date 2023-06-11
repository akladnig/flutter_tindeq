import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_tindeq/src/common_widgets/navigation_rail.dart';
import 'package:flutter_tindeq/src/constants/app_sizes.dart';
import 'package:flutter_tindeq/src/constants/test_constants.dart';
import 'package:flutter_tindeq/src/constants/theme.dart';
import 'package:flutter_tindeq/src/features/testing/domain/testing_models.dart';
import 'package:flutter_tindeq/src/features/testing/presentation/test_view.dart';
import 'package:flutter_tindeq/src/features/testing/presentation/test_widgets.dart';
import 'package:flutter_tindeq/src/features/testing/repository/data.dart';
import 'package:flutter_tindeq/src/features/testing/repository/test_results_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

//TODO add ability to do mulitple tests for different grip types - maybe a separate grip tests menu item?
//TODO calculate max strength based on average of 3 reps of 10 seconds
class MaxTestingView extends HookWidget {
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
  final PointListClass dataLeft = pointListMaxL;
  final PointListClass dataRight = pointListMaxR;
  final legends = [
    (title: "Left", colour: ChartColours.contentColorBlue),
    (title: "Right", colour: ChartColours.contentColorRed)
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var maxTests = ref.watch(maxResultsProvider);

    const CountDownWidget countdownTime = CountDownWidget(maxTimes);
    return TestView(
      "Maximum Strength Test",
      dataLeft: dataLeft,
      dataRight: dataRight,
      legends: legends,
      lines: [
        (maxTests[Hand.left].meanLine, ChartColours.contentColorBlue),
        (maxTests[Hand.right].meanLine, ChartColours.contentColorRed)
      ],
      countdownTime: countdownTime,
      duration: maxTimes.totalDuration,
      results: const Results(),
    );
  }
}

class Results extends StatefulHookConsumerWidget {
  const Results({super.key});

  @override
  ConsumerState<Results> createState() => _ResultsState();
}

class _ResultsState extends ConsumerState<Results> {
  @override
  Widget build(BuildContext context) {
    var maxTests = ref.watch(maxResultsProvider);

    return Column(
      children: [
        const TestResultsHeader(Tests.maxTestLeft, "Left Hand"),
        ResultsBody((
          maxTests[Hand.left].maxStrength,
          maxTests[Hand.left].meanStrength
        )),
        gapHMED,
        const TestResultsHeader(Tests.maxTestRight, "Right Hand"),
        ResultsBody((
          maxTests[Hand.right].maxStrength,
          maxTests[Hand.right].meanStrength
        )),
      ],
    );
  }
}

class ResultsBody extends HookWidget {
  const ResultsBody(this.values, {super.key});

  final (double?, double?) values;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ResultsRow("Max: ", values.$1!, "kg"),
        ResultsRow("Average: ", values.$2!, "kg"),
      ],
    );
  }
}
