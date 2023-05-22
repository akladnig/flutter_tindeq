import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tindeq/src/constants/theme.dart';
import 'package:flutter_tindeq/src/features/testing/testing_models.dart';

class TestChart extends StatefulWidget {
  final PointList dataLeft;
  final PointList? dataRight;
  final double duration;
  final String? legendLeft;
  final String? legendRight;
  final Point? pointLeft;
  final Point? pointRight;
  final Line? lineLeft;
  final Line? lineRight;
  const TestChart(
      {super.key,
      required this.dataLeft,
      this.dataRight,
      required this.duration,
      this.legendLeft,
      this.legendRight,
      this.pointLeft,
      this.pointRight,
      this.lineLeft,
      this.lineRight});

  @override
  State<TestChart> createState() => _TestChartState();
}

class _TestChartState extends State<TestChart> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        if (widget.legendLeft != null)
          lineLegend(
            widget.legendLeft,
            widget.legendRight,
          ),
        AspectRatio(
          aspectRatio: 1.70,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 24,
              bottom: 12,
            ),
            child: LineChart(
              mainData(),
            ),
          ),
        ),
      ],
    );
  }

  /// Overlays a legend box for the line(s)
  /// TODO add a button to only show the line that is clicked on
  Positioned lineLegend(
    String? legendLeft,
    String? legendRight, {
    left = 80.0,
    top = 30.0,
  }) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: ChartColours.lineLegendBorderColor)),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.square,
                  size: 10,
                  color: ChartColours.lineColorL,
                ),
                Text("  ${legendLeft!}"),
              ],
            ),
            if (legendRight != null)
              Row(
                children: [
                  const Icon(
                    Icons.square,
                    size: 10,
                    color: ChartColours.lineColorR,
                  ),
                  Text("  $legendRight"),
                ],
              ),
          ],
        ),
      ),
    );
  }

  LineChartData mainData() {
    var dataLeft = widget.dataLeft;
    List<FlSpot> spotListL =
        dataLeft.map((dataLeft) => FlSpot(dataLeft.$1, dataLeft.$2)).toList();

    List<FlSpot> spotListR = [];
    if (widget.dataRight != null) {
      var dataRight = widget.dataRight!;
      spotListR.addAll(dataRight
          .map((dataRight) => FlSpot(dataRight.$1, dataRight.$2))
          .toList());
    }

    // This sets both the grid size and x axis label intervals - once the x axis becomes too large
    // the grid lines and labels run into each other
    double xAxisGridInterval = (widget.duration > 20) ? 10.0 : 1.0;
    double xAxisLabelInterval = (widget.duration > 20) ? 20.0 : 1.0;

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 10,
        verticalInterval: xAxisGridInterval,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: ChartColours.mainGridLineColor,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: ChartColours.mainGridLineColor,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          axisNameWidget: const Text("secs"),
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: xAxisLabelInterval,
          ),
        ),
        leftTitles: AxisTitles(
          axisNameWidget: const Text("kg"),
          sideTitles: SideTitles(
            showTitles: true,
            interval: 10,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: ChartColours.chartBorderColor),
      ),
      //TODO: chart ranges - autosize?
      minX: 0,
      maxX: widget.duration,
      minY: 0,
      maxY: 60,
      //TODO: Dot display - round to integer
      lineTouchData: LineTouchData(enabled: false),
      lineBarsData: [
        plotData(spotListL, ChartColours.gradientColorsL),
        if (widget.dataRight != null)
          plotData(spotListR, ChartColours.gradientColorsR),
        if (widget.pointLeft != null) plotPoint(widget.pointLeft),
        if (widget.pointRight != null) plotPoint(widget.pointRight),
        if (widget.lineLeft != null)
          plotLine(widget.lineLeft, colour: Colors.greenAccent),
        if (widget.lineRight != null) plotLine(widget.lineRight),
      ],
    );
  }

  LineChartBarData plotData(data, colours) {
    return LineChartBarData(
      spots: data,
      gradient: LinearGradient(
        colors: colours,
      ),
      barWidth: 1,
      dotData: FlDotData(
        show: false,
      ),
    );
  }

  /// Plots a single line - used to show maximum RFD
  LineChartBarData plotLine(Line? line, {colour = ChartColours.lineColor}) {
    Point start = line!.$1;
    Point end = line.$2;
    return LineChartBarData(
      spots: [
        FlSpot(start.$1, start.$2),
        FlSpot(end.$1, end.$2),
      ],
      color: colour,
      dotData: FlDotData(
        show: false,
      ),
      barWidth: 1,
    );
  }

// Plots a single point on the Chart - Used to show the maximum part of a plot
// TODO: dot styling
  LineChartBarData plotPoint(Point? point, {colour = ChartColours.dotColor}) {
    return LineChartBarData(
      spots: [FlSpot(point!.$1, point.$2)],
      color: colour,
      dotData: FlDotData(
        show: true,
      ),
    );
  }
}
