import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tindeq/src/common_widgets/navigation_rail.dart';
import 'package:flutter_tindeq/src/common_widgets/text.dart';
import 'package:flutter_tindeq/src/constants/app_sizes.dart';
import 'package:flutter_tindeq/src/constants/theme.dart';
import 'package:flutter_tindeq/src/features/analysis/application/analyse_results.dart';
import 'package:flutter_tindeq/src/features/testing/domain/testing_models.dart';
import 'package:flutter_tindeq/src/features/testing/presentation/test_widgets.dart';
import 'package:flutter_tindeq/src/features/testing/repository/test_results_provider.dart';
import 'package:flutter_tindeq/src/features/user_details/domain/user.dart';

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
    var maxTests = ref.watch(maxResultsProvider);
    var rfdTests = ref.watch(rfdResultsProvider);
    var cftTests = ref.watch(cftResultsProvider);

    int gradeMin;
    int gradeMax;
    int rfdGradeMin;
    int rfdGradeMax;
    int cftGradeMin;
    int cftGradeMax;
    (gradeMin, gradeMax) = analyseStrength(ref);
    (rfdGradeMin, rfdGradeMax) = analyseRfd(ref);
    (cftGradeMin, cftGradeMax) = analyseCft(ref);

    debugPrint(user.weight.toString());
    return Container(
      // width: mediaWidth,
      width: gradeGaugeSizeWidth + Sizes.medium,
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.all(Sizes.small),
      child: ListView(
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextPara("Analysis Results", style: TextStyles.h1Colour),
          TextPara(
              "Your maximum strength shown as a percentage of your body weight",
              style: TextStyles.body),
          WeightResultsGauge(
              "Max Strength Left (kg)", maxTests[Hand.left].maxStrength,
              showPercentages: false),
          WeightResultsGauge(
              "Max Strength Right (kg)", maxTests[Hand.right].maxStrength),
          TextPara(
              "The peak force and critical force shown as a percentage of your body weight",
              style: TextStyles.body),
          WeightResultsGauge("Peak Force (kg)", cftTests.peakForce,
              showPercentages: false),
          WeightResultsGauge("Critical Force (kg)", cftTests.criticalForce),
          TextPara("The peak force as a percentage of critical force",
              style: TextStyles.body),
          WeightResultsGauge("Critical Force % of Peak", cftTests.criticalForce,
              max: cftTests.peakForce),
          ResultsRow("RFD Left: ", rfdTests[Hand.left].peak, digits: 0, "kg/s"),
          ResultsRow(
              "RFD Right: ", rfdTests[Hand.right].peak, digits: 0, "kg/s"),
          TextPara("Predicted Redpoint Grades", style: TextStyles.h1Colour),
          GradeResultsGauge("Max Strength", gradeMin, gradeMax),
          GradeResultsGauge("Endurance", cftGradeMin, cftGradeMax),
          GradeResultsGauge("Contact Strength", rfdGradeMin, rfdGradeMax),
        ],
      ),
    );
  }
}
