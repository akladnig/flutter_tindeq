import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tindeq/src/common_widgets/navigation_rail.dart';
import 'package:flutter_tindeq/src/constants/theme.dart';
import 'package:flutter_tindeq/src/features/testing/application/test_actions.dart';
import 'package:flutter_tindeq/src/features/testing/presentation/test_view.dart';
import 'package:flutter_tindeq/src/features/testing/presentation/test_widgets.dart';
import 'package:flutter_tindeq/src/features/testing/domain/testing_models.dart';
import 'package:flutter_tindeq/src/features/testing/repository/test_results.dart';
import 'package:flutter_tindeq/src/features/testing/testing_service.dart';
import 'package:flutter_tindeq/src/features/testing/repository/data.dart';

//TODO put this into common widgets - pass as parameter from appRouter
class CftTestingView extends ConsumerStatefulWidget {
  const CftTestingView({super.key});

  @override
  ConsumerState<CftTestingView> createState() => _CftTestingViewState();
}

class _CftTestingViewState extends ConsumerState<CftTestingView> {
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

class CftTestView extends ConsumerStatefulWidget {
  CftTestView({super.key});
  final dataLeft = pointListCft;
  //TODO put these constants somewhere sensible
  final countdownTime = const CountDownTime(time: 10.0);
  final double duration = 240.0;

  @override
  ConsumerState<CftTestView> createState() => _CftTestViewState();
}

class _CftTestViewState extends ConsumerState<CftTestView> {
  @override
  Widget build(BuildContext context) {
    // final startButtonLeft = StartButton(cftAction(ref));
    PointListClass meansList = getCftEdges(pointListCft);
    //TODO move to controller so that these values are set once data capture is complete
    // ref.read(testResultsProvider).peakForce = meansList[0].$2;
    // ref.read(testResultsProvider).criticalForce = criticalLoad(meansList);

    TestResults testResults = ref.watch(testResultsProvider);

    return TestView(
      "Critical Force Test",
      dataLeft: pointListCft,
      points: meansList,
      lines: [
        (
          (
            (0.0, testResults.criticalForce),
            (240.0, testResults.criticalForce)
          ),
          ChartColours.contentColorRed
        )
      ],
      // startButtonLeft: startButtonLeft,
      countdownTime: widget.countdownTime,
      duration: widget.duration,
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
    TestResults testResults = ref.watch(testResultsProvider);
    var bs = ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          if (ref.watch(testStartedProvider).state) {
            // if (states.contains(MaterialState.pressed)) {
            return Theme.of(context).colorScheme.secondary;
          }
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
              setState(() {});
            },
            child: buttonState(ref)),
        ResultsRow("Peak Load:", testResults.peakForce, "kg"),
        ResultsRow("Critical Load:", testResults.criticalForce, "kg"),
        //TODO
        const ResultsRow("Asymptotic Load:", 0, "kg"),
        const ResultsRow("W':", 0, "J"),
        const ResultsRow("Anaerobic Function Score:", 0, ""),
      ],
    );
  }
}
