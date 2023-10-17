import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tindeq/src/features/testing/application/max_testing_service.dart';

import '../repository/test_data.dart';

void main() {
  // maxResult
  test('maxResult', () {
    expect(squareWave.maxResult, (
      maxStrength: 19.31986301,
      meanStrength: 17.966490519090907,
      meanLine: ((0.0, 17.966490519090907), (0.5, 17.966490519090907)),
    ));
  });

  // maxStrength
  group('maxStrength', () {
    test('maxStrength gets the maximum point from a list', () {
      expect(testPoints.maxStrength,
          ((time: 7.581200000000000438e-02, force: 2.505363864898681570e+02)));
    });
    test('maxStrength gets the maximum point from the squareWave', () {
      expect(squareWave.maxStrength, ((time: 0.08, force: 19.31986301)));
    });
  });
}
