import 'package:flutter_tindeq/src/features/testing/application/rfd_testing_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../repository/test_data.dart';

void main() {
  // _lineParameters
  test('lineParameters', () {
    expect(lineParameters((-2, 6), (5, 27)), (3, 12));
  });
  // rfdResult
  //TODO add tests for horizontal and vertical lines and create specific RFD test data
  test('rfdResult', () {
    expect(rfdWave.rfdResult, (
      peak: 169.561733525,
      peakPoint: (0.0, 10.0),
      peakLine: (
        (-0.04413592728183971, 1.931986301),
        (0.04041524981991993, 17.387876709)
      ),
      // Mean is actually steeper as the sample interval is smaller due to the test data size
      mean: 190.4592246,
      timeToPeak: 0.0
    ));
  });
}
