import 'package:flutter/material.dart';
import 'package:flutter_tindeq/src/features/testing/test_chart_view.dart';
import 'package:flutter_tindeq/src/features/testing/test_widgets.dart';
import 'package:flutter_tindeq/src/features/testing/testing_models.dart';

class TestView extends StatelessWidget {
  const TestView(
    this.title, {
    super.key,
    required this.dataLeft,
    this.dataRight,
    this.valueLeft,
    this.valueRight,
    this.pointLeft,
    this.pointRight,
    this.lineLeft,
    this.lineRight,
    required this.startButtonLeft,
    this.startButtonRight,
    required this.countdownTime,
    required this.duration,
    this.units = "kg",
    required this.results,
  });
  final PointList dataLeft;
  final PointList? dataRight;
  final double? valueLeft;
  final double? valueRight;
  final Point? pointLeft;
  final Point? pointRight;
  final Line? lineLeft;
  final Line? lineRight;
  final String title;
  final StartButton startButtonLeft;
  final StartButton? startButtonRight;
  final CountDownTime countdownTime;
  final double duration;
  final String units;
  final Widget results;

  @override
  Widget build(BuildContext context) {
    String? legendLeft = (startButtonRight == null) ? null : "Left";
    String? legendRight = (startButtonRight == null) ? null : "Right";

    double mediaWidth = MediaQuery.of(context).size.width;
    debugPrint(mediaWidth.toString());
    // var resultsWidth = mediaWidth * 0.3;
    var plotWidth = mediaWidth * 0.6;
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      children: <Widget>[
        const SizedBox(height: 80.0),
        // [Name]
        Text(title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 32,
              color: Colors.blue,
            )),
        Container(
          constraints: const BoxConstraints.expand(height: 500),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [results],
                      ),
                      countdownTime,
                    ],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: plotWidth,
                height: 400,
                child: TestChart(
                  legendLeft: legendLeft,
                  legendRight: legendRight,
                  dataLeft: dataLeft,
                  dataRight: dataRight,
                  duration: duration,
                  pointLeft: pointLeft,
                  pointRight: pointRight,
                  lineLeft: lineLeft,
                  lineRight: lineRight,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
