import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tindeq/src/features/testing/repository/data.dart';

import '../repository/test_data.dart';

void main() {
//subList
  group('subList', () {
    test('subList(-1,5).length', () {
      expect(squareWave.sublist(-1, 5).length, 5);
    });

    test('subList(0).length', () {
      expect(squareWave.sublist(0).length, 100);
    });

    test('subList(99).length', () {
      expect(squareWave.sublist(99).length, 1);
    });

    test('subList(100).length', () {
      expect(squareWave.sublist(100).length, 0);
    });

    test('subList(101).length', () {
      expect(squareWave.sublist(101).length, 0);
    });

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
  });

  // length
  group('length', () {
    test('testPoints list length is 10', () {
      expect(testPoints.length, 10);
    });

    test('squareWave list length is 100', () {
      expect(squareWave.length, 100);
    });

    test('pointListCft list length is 100', () {
      expect(pointListCft.length, 20085);
    });

    // toFixed
    test(
        'tofixed correctly converts a list of doubles to a list of single decimal point',
        () {
      expect(testPoints.toFixed, fixedPoints);
    });
  });
}
