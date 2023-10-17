import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_tindeq/src/common_widgets/navigation_rail.dart';
import 'package:flutter_tindeq/src/constants/app_sizes.dart';
import 'package:flutter_tindeq/src/constants/test_constants.dart';
import 'package:flutter_tindeq/src/constants/theme.dart';
import 'package:flutter_tindeq/src/features/testing/application/rfd_testing_service.dart';
import 'package:flutter_tindeq/src/features/testing/presentation/test_view.dart';
import 'package:flutter_tindeq/src/features/testing/presentation/test_widgets.dart';
import 'package:flutter_tindeq/src/features/testing/domain/testing_models.dart';
import 'package:flutter_tindeq/src/features/testing/repository/data.dart';
import 'package:flutter_tindeq/src/features/testing/repository/test_results_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RfdTestingView extends HookWidget {
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

class RfdTestView extends HookConsumerWidget {
  RfdTestView({super.key});
  final PointListClass dataLeft = pointListRfdL;
  final PointListClass dataRight = pointListRfdR;
  final pointLeft = pointListRfdL.rfdPeak;
  final pointRight = pointListRfdR.rfdPeak;
  final legends = [
    (title: "Left", colour: ChartColours.contentColorBlue),
    (title: "Right", colour: ChartColours.contentColorRed)
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var rfdTests = ref.watch(rfdResultsProvider);

    var points = PointListClass(
        [rfdTests[Hand.left].peakPoint, rfdTests[Hand.right].peakPoint]);

    return TestView(
      "Rate of Force Development Test",
      dataLeft: dataLeft,
      dataRight: dataRight,
      points: points,
      legends: legends,
      lines: [
        (rfdTests[Hand.left].peakLine, ChartColours.contentColorBlue),
        (rfdTests[Hand.right].peakLine, ChartColours.contentColorRed)
      ],
      countdownTime: const CountDownWidget(rfdTimes),
      duration: rfdTimes.totalDuration,
      units: "kg/s",
      results: const Results(),
    );
  }
}

class Results extends ConsumerStatefulWidget {
  const Results({super.key});

  @override
  ConsumerState<Results> createState() => _ResultsState();
}

class _ResultsState extends ConsumerState<Results> {
  @override
  Widget build(BuildContext context) {
    var rfdTests = ref.watch(rfdResultsProvider);

    return SizedBox(
      width: resultsViewWidth,
      height: plotHeight,
      child: Column(
        children: [
          SizedBox(
            height: plotHeight / 2,
            child: Column(
              children: [
                const TestResultsHeader(Tests.rfdTestLeft, "Left Hand"),
                ResultsBody((
                  rfdTests[Hand.left].peak,
                  rfdTests[Hand.left].mean,
                  rfdTests[Hand.left].timeToPeak
                )),
              ],
            ),
          ),
          SizedBox(
            height: plotHeight / 2,
            child: Column(
              children: [
                const TestResultsHeader(Tests.rfdTestRight, "Right Hand"),
                ResultsBody((
                  rfdTests[Hand.right].peak,
                  rfdTests[Hand.right].mean,
                  rfdTests[Hand.right].timeToPeak
                )),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ResultsBody extends StatelessWidget {
  const ResultsBody(this.values, {super.key});

  final (double?, double?, double?) values;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ResultsRow("Peak: ", values.$1!, digits: 0, "kg/s"),
        ResultsRow("Average: ", values.$2!, digits: 0, "kg/s"),
        ResultsRow("Time to RFD: ", values.$3!, digits: 0, "ms"),
      ],
    );
  }
}
