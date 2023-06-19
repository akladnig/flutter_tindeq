import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_tindeq/src/common_widgets/navigation_rail.dart';
import 'package:flutter_tindeq/src/common_widgets/text.dart';
import 'package:flutter_tindeq/src/constants/app_sizes.dart';
import 'package:flutter_tindeq/src/constants/test_constants.dart';
import 'package:flutter_tindeq/src/constants/theme.dart';
import 'package:flutter_tindeq/src/features/analysis/presentation/grade_gauge.dart';
import 'package:flutter_tindeq/src/features/analysis/presentation/weight_gauge.dart';
import 'package:flutter_tindeq/src/features/testing/application/countdown_controller.dart';
import 'package:flutter_tindeq/src/features/testing/domain/countdown_model.dart';
import 'package:flutter_tindeq/src/features/testing/domain/testing_models.dart';
import 'package:flutter_tindeq/src/features/tindeq/tindeq_provider.dart';
import 'package:flutter_tindeq/src/features/user_details/repository/user.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

//TODO this needs to have a better name
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

class StartButton extends HookConsumerWidget {
  const StartButton(this.testKey, {super.key});
  final Tests testKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //TODO combine/ rationalise
    final tindeqConnected = ref.watch(tindeqConnectedProvider);
    final currentTestState = ref.watch(currentTestProvider);
    final allTests = ref.watch(allTestsProvider);

    bool connected = tindeqConnected.when(
      loading: () => false,
      error: (_, err) => false,
      data: (_) => true,
    );
    var buttonText = useState(ButtonState.waiting);

    if (!connected) {
      buttonText.value = ButtonState.waiting;
    } else {
      // debugPrint(
      //     "StartButton: $allTests $testKey, ${currentTestState.$1} ${currentTestState.$2}");
      if (allTests[testKey] == TestState.notStarted) {
        buttonText.value = ButtonState.start;
        // If the [testKey] test is in progress and current test is complete update
        // the tests status and reset the crurent test
      } else if ((allTests[testKey] == TestState.inProgress) &
          (currentTestState.$1 == testKey) &
          (currentTestState.$2 == TestState.complete)) {
        buttonText.value = ButtonState.complete;
        // Reset the current test
        Future(() => ref
            .read(currentTestProvider.notifier)
            .setTest(Tests.none, TestState.notStarted));
        Future(() => ref
            .read(allTestsProvider.notifier)
            .setTest(testKey, TestState.complete));
      } else if (allTests[testKey] == TestState.complete) {
        buttonText.value = ButtonState.complete;
      }
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, Sizes.xSmall, 0, Sizes.xSmall),
      child: ElevatedButton(
        onPressed: () {
          // debugPrint("Start Button Pressed $testKey $currentTestState");
          if ((currentTestState.$2 == TestState.notStarted)) {
            buttonText.value = ButtonState.start;
            // When starting a new test:
            // Reset the Reps to 0
            ref.read(repProvider.notifier).reset();

            // Start the timer
            ref.read(startTimerProvider.notifier).start();
            // set the test status to In Progress
            ref
                .read(currentTestProvider.notifier)
                .setTest(testKey, TestState.inProgress);
            ref
                .read(allTestsProvider.notifier)
                .setTest(testKey, TestState.inProgress);
            // Start logging data
          }
        },
        style:
            ElevatedButton.styleFrom(backgroundColor: buttonText.value.colour),
        child: Text(buttonText.value.label),
      ),
    );
  }
}

class CountDownWidget extends HookConsumerWidget {
  const CountDownWidget(this.testTimes, {super.key});

  final TestTimes testTimes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool startTimer = ref.watch(startTimerProvider);
    final timerState = useState(TimerState.idle);

    // Used for the current countdown
    final countdown = useState(0);

    //TODO move out of here
    final currentCountdown = useState(testTimes.countdownTime);

    /// Determine the current TimerState based on:
    /// If the Tindeq Progressor has not connected via Bluetooth then we are [waiting] for a connection
    /// and so will not be able to start the timer until a connection is made.
    /// - startTimer == false, then timerState == waiting.
    //TODO Riverpod TindeqProvider

    getTimerState(timerState, countdown, currentCountdown, testTimes, ref);

    // debugPrint("${timerState.value} ${countdown.value} ${currentCountdown.value} ");
    useTimer(
      () {
        countdown.value++;
        currentCountdown.value--;
      },
      startTimer,
    );

    final timeInSeconds = currentCountdown.value;
    final timeDisplay = CountDownTime(
      time: timeInSeconds,
      timerState: timerState.value,
    );
    return Column(children: [
      timeDisplay,
    ]);
  }
}

/// Displays the Countdown [time] in Secs. The background colour is based on the [timerState]
class CountDownTime extends StatelessWidget {
  const CountDownTime(
      {super.key, required this.time, required this.timerState});

  final int time;
  final TimerState timerState;

  @override
  Widget build(BuildContext context) {
    String timeSecs = time.ceil().toString().padLeft(2, '0');

    return Container(
      // width: 400,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: timerState.colour),
      child: Text(
        timeSecs,
        textAlign: TextAlign.right,
        style: CountdownTimerStyle(timerState.colour).count,
      ),
    );
  }
}

class TestResultsHeader extends HookWidget {
  const TestResultsHeader(this.testKey, this.header, {super.key});
  final Tests testKey;
  final String header;

  @override
  Widget build(BuildContext context) {
    final startButton = StartButton(testKey);
    return Column(children: [
      TextPara(header, style: TextStyles.h1Colour, margin: Sizes.none),
      startButton,
    ]);
  }
}

class ResultsRow extends HookWidget {
  const ResultsRow(this.title, this.value, this.units,
      {this.digits = 1, super.key});

  final String title;
  final double value;
  final String units;
  final int digits;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(title, style: TextStyles.h3),
        Text(
          "${value.toStringAsFixed(digits)} $units",
          style: TextStyles.h3,
        ),
      ],
    );
  }
}

class GradeResultsGauge extends HookWidget {
  const GradeResultsGauge(this.title, this.gradeMin, this.gradeMax,
      {super.key});

  final String title;
  final int gradeMin;
  final int gradeMax;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyles.h2),
        gapHMED,
        SizedBox(
          width: gradeGaugeSizeWidth,
          height: mainBarHeight + legendOffset + Sizes.medium,
          child: CustomPaint(
            painter: GradeGaugePainter(gradeMin, gradeMax),
          ),
        ),
      ],
    );
  }
}

class WeightResultsGauge extends HookConsumerWidget {
  const WeightResultsGauge(this.title, this.strength,
      {this.max,
      this.showTicks = true,
      this.showPercentages = true,
      super.key});

  final String title;
  final double strength;
  final double? max;
  final bool showTicks;
  final bool showPercentages;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    User user = ref.watch(userProvider);

    double weight = max ?? user.weight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: weightGaugeSizeWidth,
          height: showPercentages
              ? mainBarHeight + labelOffset + Sizes.medium
              : mainBarHeight,
          child: CustomPaint(
            painter: WeightGaugePainter(title,
                strength: strength,
                weight: weight,
                showTicks: showTicks,
                showPercentages: showPercentages),
          ),
        ),
        gapHMED
      ],
    );
  }
}

class GradesResultsRow extends HookWidget {
  const GradesResultsRow(this.title, this.gradeMin, this.gradeMax, {super.key});

  final String title;
  final String gradeMin;
  final String gradeMax;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyles.h3),
        Text(gradeMin, style: TextStyles.h3),
        Text(" - ", style: TextStyles.h3),
        Text(gradeMax, style: TextStyles.h3),
      ],
    );
  }
}
