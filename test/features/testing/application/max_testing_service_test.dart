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
}
