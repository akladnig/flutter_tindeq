import 'package:flutter_test/flutter_test.dart';

import '../repository/test_data.dart';

void main() {
//subList
  test('subList', () {
    expect(squareWave.sublist(0, 5), [
      (-0.08, 1.206029211),
      (-0.06, 0.712331731),
      (-0.04, 3.105896908),
      (-0.02, 5.243282114),
      (0, 10),
    ]);
  });
  test('subList', () {
    expect(squareWave.sublist(1, 8 + 1), [
      (-0.06, 0.712331731),
      (-0.04, 3.105896908),
      (-0.02, 5.243282114),
      (0, 10),
      (0.02, 13.65598468),
      (0.04, 16.67083559),
      (0.06, 18.59944873),
      (0.08, 19.31986301),
    ]);
  });

  // length
  test('list length is 10', () {
    expect(testPoints.length, 10);
  });

  // toFixed
  test(
      'tofixed correctly converts a list of doubles to a list of single decimal point',
      () {
    expect(testPoints.toFixed, fixedPoints);
  });
}
