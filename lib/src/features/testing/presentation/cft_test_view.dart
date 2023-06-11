import 'package:flutter/material.dart';
import 'package:flutter_tindeq/src/common_widgets/navigation_rail.dart';
import 'package:flutter_tindeq/src/constants/test_constants.dart';
import 'package:flutter_tindeq/src/constants/theme.dart';
import 'package:flutter_tindeq/src/features/testing/presentation/test_view.dart';
import 'package:flutter_tindeq/src/features/testing/presentation/test_widgets.dart';
import 'package:flutter_tindeq/src/features/testing/domain/testing_models.dart';
import 'package:flutter_tindeq/src/features/testing/repository/test_results_provider.dart';
import 'package:flutter_tindeq/src/features/testing/repository/data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CftTestingView extends HookConsumerWidget {
  const CftTestingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var cftTests = ref.watch(cftResultsProvider);

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
              child: TestView(
                "Critical Force Test",
                dataLeft: pointListCft,
                points: cftTests.cftPoints,
                lines: [
                  (
                    (
                      (0.0, cftTests.criticalForce),
                      (240.0, cftTests.criticalForce)
                    ),
                    ChartColours.contentColorRed
                  )
                ],
                results: const Results(),
                countdownTime: const CountDownWidget(cftTimes),
                duration: cftTimes.totalDuration,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Results extends HookConsumerWidget {
  const Results({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var cftTests = ref.watch(cftResultsProvider);

    return Column(
      children: [
        const StartButton(Tests.cftTest),
        ResultsRow("Peak Load:", cftTests.peakForce, "kg"),
        ResultsRow("Critical Load:", cftTests.criticalForce, "kg"),
        ResultsRow("Asymptotic Load:", cftTests.asymptoticForce, "kg"),
        ResultsRow("W':", cftTests.wPrime, digits: 0, "J"),
        ResultsRow("Anaerobic Function Score:",
            cftTests.wPrime / cftTests.criticalForce, ""),
      ],
    );
  }
}
