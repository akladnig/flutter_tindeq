import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tindeq/src/common_widgets/navigation_rail.dart';
import 'package:flutter_tindeq/src/constants/theme.dart';
import 'package:flutter_tindeq/src/features/testing/domain/testing_models.dart';
import 'package:flutter_tindeq/src/features/testing/repository/data.dart';
import 'package:flutter_tindeq/src/features/testing/repository/test_results.dart';
import 'package:flutter_tindeq/src/features/testing/testing_service.dart';

class TestingView extends StatelessWidget {
  const TestingView({
    super.key,
    required this.testView,
  });
  final Widget testView;
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
              child: testView,
            ),
          ],
        ),
      ),
    );
  }
}

class StartButton extends ConsumerStatefulWidget {
  const StartButton(this.action, {super.key});
  final void action;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StartButtonState();
}

class _StartButtonState extends ConsumerState<StartButton> {
  @override
  Widget build(BuildContext context) {
    ButtonStyle buttonStyle =
        ElevatedButton.styleFrom(backgroundColor: Colors.green);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ElevatedButton(
        style: buttonStyle,
        onPressed: () {
          PointListClass meansList = getCftEdges(pointListCft);
          ref.read(testResultsProvider).peakForce = meansList[0].$2;
          ref.read(testResultsProvider).criticalForce = criticalLoad(meansList);
        },
        child: const Text(
          'Start Test',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class CountDownTime extends StatelessWidget {
  const CountDownTime({super.key, required this.time});

  final double time;

  @override
  Widget build(BuildContext context) {
    String timeSecs = time.truncate().toString().padLeft(2, '0');
    String timeMs =
        ((time - time.truncate()) * 100).round().toString().padRight(2, '0');
    return Text("$timeSecs:$timeMs",
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 100,
            color: Colors.white,
            backgroundColor: Colors.deepOrange));
  }
}

class TestResultsHeader extends StatelessWidget {
  const TestResultsHeader(this.header, this.action, {super.key});

  final String header;
  final Function() action;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(header, style: TextStyles.h1Colour),
      StartButton(action),
    ]);
  }
}

class ResultsRow extends StatelessWidget {
  const ResultsRow(this.title, this.value, this.units, {super.key});

  final String title;
  final double value;
  final String units;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyles.h3),
        Text(
          "${value.toStringAsFixed(1)} $units",
          style: TextStyles.h3,
        ),
      ],
    );
  }
}

class ButtonText extends StatefulWidget {
  const ButtonText({
    this.text = 'Start Test',
    super.key,
  });
  final String text;

  @override
  State<ButtonText> createState() => _ButtonTextState();
}

class _ButtonTextState extends State<ButtonText> {
  @override
  Widget build(BuildContext context) {
    return Text(
      widget.text,
      style: const TextStyle(color: Colors.white),
    );
  }
}
