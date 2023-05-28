import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tindeq/src/common_widgets/navigation_rail.dart';
import 'package:flutter_tindeq/src/constants/app_sizes.dart';
import 'package:flutter_tindeq/src/constants/breakpoints.dart';
import 'package:flutter_tindeq/src/constants/theme.dart';
import 'package:flutter_tindeq/src/features/testing/presentation/test_widgets.dart';
import 'package:flutter_tindeq/src/features/testing/repository/test_results.dart';
import 'package:flutter_tindeq/src/features/user_details/repository/user.dart';

class AnalysisView extends StatefulWidget {
  const AnalysisView({super.key});

  @override
  State<AnalysisView> createState() => _AnalysisViewState();
}

class _AnalysisViewState extends State<AnalysisView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // appBar: PreferredSize(
      //     preferredSize: Size.fromHeight(80.0),
      //     child: AppBarWidget(title: "User Details")),
      body: SafeArea(
        child: Row(
          children: <Widget>[
            NavigationRailWidget(),
            VerticalDivider(thickness: 2, width: 1),
            AnalysisDetails(),
          ],
        ),
      ),
    );
  }
}

class AnalysisDetails extends ConsumerStatefulWidget {
  const AnalysisDetails({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AnalysisDetailsState();
}

class _AnalysisDetailsState extends ConsumerState<AnalysisDetails> {
  @override
  Widget build(BuildContext context) {
    // Watch for user and testing changes
    User user = ref.watch(userProvider);
    TestResults testResults = ref.watch(testResultsProvider);

    debugPrint(user.weight.toString());
    debugPrint(testResults.maxStrengthLeft.toString());
    return Container(
      width: Breakpoint.tablet,
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Analysis Results", style: TextStyles.h1Colour),
          gapHMED,
          ResultsRow("Body Weight: ", user.weight, "kg"),
          ResultsRow("Max Strength Left: ",
              testResults.maxStrengthLeft / user.weight * 100, "%BW"),
          ResultsRow("Max Strength Right: ",
              testResults.maxStrengthRight / user.weight * 100, "%BW"),
          ResultsRow(
              "Peak Force: ", testResults.peakForce / user.weight * 100, "%BW"),
          ResultsRow("Critical Force: ",
              testResults.criticalForce / user.weight * 100, "%BW"),
          ResultsRow(
              "Critical Force: ",
              testResults.criticalForce / testResults.peakForce * 100,
              "% of Peak Force"),
          ResultsRow("RFD Left: ", testResults.rfdfLeft, "kg/s"),
          ResultsRow("RFD Right: ", testResults.rfdRight, "kg/s"),
          const Text("Predicted Redpoint Grades", style: TextStyles.h1Colour),
          const ResultsRow("Max Strength: ", 0.0, ""),
          const ResultsRow("Endurance: ", 0.0, ""),
          const ResultsRow("Contact Strength: ", 0.0, ""),
        ],
      ),
    );
  }
}
