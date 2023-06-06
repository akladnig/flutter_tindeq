import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tindeq/src/constants/theme.dart';
import 'package:flutter_tindeq/src/features/testing/domain/testing_models.dart';

class TestChart extends StatefulWidget {
  final PointListClass dataLeft;
  final PointListClass? dataRight;
  final int duration;
  final List<Legend>? legends;
  final PointListClass? points;
  final List<(Line, Color)>? lines;
  const TestChart({
    super.key,
    required this.dataLeft,
    this.dataRight,
    required this.duration,
    this.legends,
    this.points,
    this.lines,
  });

  @override
  State<TestChart> createState() => _TestChartState();
}

class _TestChartState extends State<TestChart> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        if (widget.legends != null) lineLegend(widget.legends),
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
  /// TODO Legend position based on media query etc.
  Positioned lineLegend(List<Legend>? legends, {left = 80.0, top = 30.0}) {
    List<Row> legendRows = [];
    for (var legend in legends!) {
      legendRows.add(legendRow(legend));
    }
    return Positioned(
      left: left,
      top: top,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: ChartColours.lineLegendBorderColor)),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: legendRows,
        ),
      ),
    );
  }

  LineChartData mainData() {
    var dataLeft = widget.dataLeft.toFixed();
    List<FlSpot> spotListL =
        dataLeft.map((dataLeft) => FlSpot(dataLeft.$1, dataLeft.$2)).toList();

    List<FlSpot> spotListR = [];
    if (widget.dataRight != null) {
      var dataRight = widget.dataRight!.toFixed();
      spotListR.addAll(dataRight
          .map((dataRight) => FlSpot(dataRight.$1, dataRight.$2))
          .toList());
    }

    // This sets both the grid size and x axis label intervals - once the x axis becomes too large
    // the grid lines and labels run into each other
    double xAxisGridInterval = (widget.duration > 20) ? 10.0 : 1.0;
    double xAxisLabelInterval = (widget.duration > 20) ? 20.0 : 1.0;

    List<LineChartBarData> chartDataList = [];
    chartDataList.add(plotData(spotListL, ChartColours.gradientColorsL));
    if (widget.dataRight != null) {
      chartDataList.add(plotData(spotListR, ChartColours.gradientColorsR));
    }
    if (widget.points != null) chartDataList.add(plotPoints(widget.points));
    if (widget.lines != null) {
      chartDataList.addAll(plotLines(widget.lines));
    }
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
      maxX: widget.duration.toDouble(),
      minY: 0,
      maxY: 60,
      //TODO: Dot display - round to integer
      lineTouchData: LineTouchData(enabled: true),
      lineBarsData: chartDataList,
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
  List<LineChartBarData> plotLines(List<(Line, Color)>? lineTypes) {
    List<LineChartBarData> lineCharts = [];
    for (var lineType in lineTypes!) {
      Point start = (lineType.$1).$1;
      //TODO change this to a function
      start = (start.$1, ((start.$2) * 10).round() / 10);
      Point end = (lineType.$1).$2;
      end = (end.$1, ((end.$2) * 10).round() / 10);

      lineCharts.add(LineChartBarData(
        spots: [
          FlSpot(start.$1, start.$2),
          FlSpot(end.$1, end.$2),
        ],
        color: lineType.$2,
        dotData: FlDotData(
          show: false,
        ),
        barWidth: 1,
      ));
    }
    return lineCharts;
  }

  // TODO: dot styling

  LineChartBarData plotPoints(PointListClass? points,
      {colour = ChartColours.dotColor}) {
    List<FlSpot> spotList = [];
    for (var point in points!.toFixed()) {
      spotList.add(FlSpot(point.$1, point.$2));
    }
    return LineChartBarData(
      // Set barwidth to 0 so that only the spots are drawn
      barWidth: 0,
      spots: spotList,
      color: colour,
      dotData: FlDotData(
        show: true,
      ),
    );
  }

  Row legendRow(Legend legend) {
    return Row(
      children: [
        Icon(
          Icons.square,
          size: 10,
          color: legend.colour,
        ),
        Text("  ${legend.title}"),
      ],
    );
  }
}
