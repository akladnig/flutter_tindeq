import 'package:flutter_tindeq/src/features/testing/application/max_testing_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../repository/test_data.dart';

void main() {
  // mean
  test('mean', () {
    expect(squareWave.mean, (force: 17.966490519090907, time: 17.55128099));
  });

  // meanLine
  test('meanLine', () {
    expect(squareWave.meanLine,
        ((0.0, 17.966490519090907), (0.5, 17.966490519090907)));
  });

  // maxResult
  test('maxResult', () {});
}
