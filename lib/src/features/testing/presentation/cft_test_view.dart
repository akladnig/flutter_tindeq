import 'package:flutter/material.dart';
import 'package:flutter_tindeq/src/common_widgets/navigation_rail.dart';
import 'package:flutter_tindeq/src/constants/test_constants.dart';
import 'package:flutter_tindeq/src/constants/theme.dart';
import 'package:flutter_tindeq/src/features/testing/application/test_actions.dart';
import 'package:flutter_tindeq/src/features/testing/presentation/test_view.dart';
import 'package:flutter_tindeq/src/features/testing/presentation/test_widgets.dart';
import 'package:flutter_tindeq/src/features/testing/domain/testing_models.dart';
import 'package:flutter_tindeq/src/features/testing/repository/test_results.dart';
import 'package:flutter_tindeq/src/features/testing/testing_service.dart';
import 'package:flutter_tindeq/src/features/testing/repository/data.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

//TODO put this into common widgets - pass as parameter from appRouter
class CftTestingView extends HookConsumerWidget {
  const CftTestingView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //TODO also called by CftAction
    PointListClass meansList = getCftEdges(pointListCft);
    var testResults = ref.watch(testResultsProvider);

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
                points: meansList,
                lines: [
                  // (
                  //   (
                  //     (0.0, testResults.criticalForce),
                  //     (240.0, testResults.criticalForce)
                  //   ),
                  //   ChartColours.contentColorRed
                  // )
                ],
                // startButton: const StartButton(),
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
    var testResults = ref.watch(testResultsProvider);
    var bs = ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          return null; // Use the component's default.
        },
      ),
    );
    return Column(
      children: [
        ElevatedButton(
            style: bs,
            onPressed: () {
              cftAction(ref);
              // setState(() {});
            },
            child: const ButtonText(text: "Start Test")),
        // ResultsRow("Peak Load:", testResults.peakForce, "kg"),
        // ResultsRow("Critical Load:", testResults.criticalForce, "kg"),
        //TODO
        const ResultsRow("Asymptotic Load:", 0, "kg"),
        const ResultsRow("W':", 0, "J"),
        const ResultsRow("Anaerobic Function Score:", 0, ""),
      ],
    );
  }
}
