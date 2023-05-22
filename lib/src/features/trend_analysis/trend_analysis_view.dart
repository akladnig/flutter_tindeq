import 'package:flutter/material.dart';
import 'package:flutter_tindeq/src/common_widgets/app_bar.dart';

/// Displays detailed information about a SampleItem.
class TrendAnalysisView extends StatelessWidget {
  const TrendAnalysisView({super.key});

  static const routeName = '/sample_item';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child: AppBarWidget(title: "Trend Analysis")),
      body: Center(
        child: Text('Coming later'),
      ),
    );
  }
}
