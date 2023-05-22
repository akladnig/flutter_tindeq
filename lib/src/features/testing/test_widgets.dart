import 'package:flutter/material.dart';
import 'package:flutter_tindeq/src/constants/theme.dart';

class StartButton extends StatelessWidget {
  const StartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        child: const Text(
          'Start Test',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {},
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
  const TestResultsHeader(this.header, {super.key});

  final String header;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(header, style: TextStyles.h1),
      const StartButton(),
    ]);
  }
}
